import 'dart:async';

import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:bonplein_flutter/ui/page1/view_models/page1_view_model.dart';
import 'package:bonplein_flutter/ui/pageInfoStation/page_info_station.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({required this.viewModel, super.key});

  final Page1ViewModel viewModel;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

const _zoomParDefaut = 13.0;
// Toulouse si pas de GPS
const _centreParDefaut = LatLng(43.604, 1.444);

// Une bulle à partir de 5 stations dans une case de 60 px
const _stationsMinParBulle = 5;
const _tailleCase = 60.0;
const _zoomSansBulle = 15;

class _MapWidgetState extends State<MapWidget> {
  Position? position;
  // Chaque valeur envoyée recentre la carte sur l'utilisateur avec ce zoom
  // ou garde le zoom actuel avec null
  final _recentrerController = StreamController<double?>();
  final _mapController = MapController();
  late final StreamSubscription<void> _reinitialisationSubscription;

  // Recalculé seulement quand le zoom ou les stations changent
  List<Station>? _stationsGroupees;
  int? _zoomGroupes;
  List<List<Station>> _groupes = [];

  @override
  void initState() {
    super.initState();
    getPosition();
    _reinitialisationSubscription = widget.viewModel.reinitialisationCarte
        .listen((_) => _reinitialiser());
  }

  @override
  void dispose() {
    unawaited(_reinitialisationSubscription.cancel());
    unawaited(_recentrerController.close());
    _mapController.dispose();
    super.dispose();
  }

  /// Remet la carte comme à l'ouverture avec le nord en haut et centrée
  /// sur l'utilisateur au zoom par défaut
  void _reinitialiser() {
    _mapController.rotate(0);
    if (position == null) {
      _mapController.move(_centreParDefaut, _zoomParDefaut);
    } else {
      _recentrerController.add(_zoomParDefaut);
    }
  }

  /// Regroupe les stations par case à l'écran
  List<List<Station>> _grouper(List<Station> stations, MapCamera camera) {
    final zoom = camera.zoom.floor();
    if (identical(stations, _stationsGroupees) && zoom == _zoomGroupes) {
      return _groupes;
    }
    _stationsGroupees = stations;
    _zoomGroupes = zoom;
    if (zoom >= _zoomSansBulle) {
      return _groupes = [
        for (final s in stations) [s],
      ];
    }
    // Au zoom entier les cases ne bougent pas quand on déplace la carte
    final cases = <(int, int), List<Station>>{};
    for (final s in stations) {
      final p = camera.projectAtZoom(
        LatLng(s.latitude, s.longitude),
        zoom.toDouble(),
      );
      final cle = ((p.dx / _tailleCase).floor(), (p.dy / _tailleCase).floor());
      (cases[cle] ??= []).add(s);
    }
    return _groupes = cases.values.toList();
  }

  Marker _marqueurStation(Station station) => Marker(
    point: LatLng(station.latitude, station.longitude),
    width: 36,
    height: 36,
    child: GestureDetector(
      onTap: () => widget.viewModel.selectStation(station),
      child: _StationMarker(niveau: widget.viewModel.niveauPrix(station)),
    ),
  );

  Marker _marqueurBulle(List<Station> groupe) {
    final points = [for (final s in groupe) LatLng(s.latitude, s.longitude)];
    final centre = LatLng(
      points.map((p) => p.latitude).reduce((a, b) => a + b) / points.length,
      points.map((p) => p.longitude).reduce((a, b) => a + b) / points.length,
    );
    return Marker(
      point: centre,
      width: 40,
      height: 40,
      child: GestureDetector(
        // Zoome sur les stations de la bulle
        onTap: () => _mapController.fitCamera(
          CameraFit.coordinates(
            coordinates: points,
            padding: const EdgeInsets.all(48),
          ),
        ),
        child: _ClusterBulle(
          nombre: groupe.length,
          niveau: _niveauMoinsChere(groupe),
        ),
      ),
    );
  }

  PriceLevel? _niveauMoinsChere(List<Station> groupe) {
    Station? moinsChere;
    double? prixMin;
    for (final s in groupe) {
      final prix = widget.viewModel.prixDe(s);
      if (prix != null && (prixMin == null || prix < prixMin)) {
        prixMin = prix;
        moinsChere = s;
      }
    }
    return moinsChere == null ? null : widget.viewModel.niveauPrix(moinsChere);
  }

  void _envoyerZone(MapCamera camera) {
    final bounds = camera.visibleBounds;
    widget.viewModel.zoneCarteChangee((
      sud: bounds.south,
      ouest: bounds.west,
      nord: bounds.north,
      est: bounds.east,
    ));
  }

  Future<void> getPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    position = await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _centreParDefaut,
            initialZoom: _zoomParDefaut,
            // Toucher la carte à côté d'une pastille ferme la fiche
            onTap: (_, _) => widget.viewModel.selectStation(null),
            onMapReady: () => _envoyerZone(_mapController.camera),
            onPositionChanged: (camera, _) => _envoyerZone(camera),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.bonplein.bonplein_flutter',
            ),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                // Reconstruit quand la carte bouge
                return Builder(
                  builder: (context) {
                    final groupes = _grouper(
                      widget.viewModel.stations,
                      MapCamera.of(context),
                    );
                    return MarkerLayer(
                      // Restent droites quand la carte tourne
                      rotate: true,
                      markers: [
                        for (final groupe in groupes)
                          if (groupe.length >= _stationsMinParBulle)
                            _marqueurBulle(groupe)
                          else
                            for (final station in groupe)
                              _marqueurStation(station),
                      ],
                    );
                  },
                );
              },
            ),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                final selected = widget.viewModel.selectedStation;
                return MarkerLayer(
                  rotate: true,
                  markers: [
                    // La fiche passe au-dessus des pastilles
                    if (selected != null)
                      Marker(
                        point: LatLng(selected.latitude, selected.longitude),
                        width: _StationFiche.largeur,
                        height: _StationFiche.hauteur,
                        // La pointe de la fiche juste au-dessus de la pastille
                        alignment: Alignment.topCenter,
                        child: _StationFiche(
                          station: selected,
                          viewModel: widget.viewModel,
                        ),
                      ),
                  ],
                );
              },
            ),
            CurrentLocationLayer(
              alignPositionStream: _recentrerController.stream,
              alignPositionOnUpdate: AlignOnUpdate.once,
            ),
            // En dernier pour rester au-dessus des marqueurs
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) => _BoutonInfo(
                avecPrix: widget.viewModel.filtreCarte != null,
                mediane: widget.viewModel.medianeDuJour,
              ),
            ),
            const MapCompass(icon: _CompassIcon()),
            Align(
              alignment: Alignment.bottomRight,
              // Sous la boussole avec 10 de marge et 48 de bouton
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 62, 10, 10),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: 'Recentrer',
                  onPressed: () => _recentrerController.add(_zoomParDefaut),
                  icon: Container(
                    width: 44,
                    height: 44,
                    decoration: _boutonCarteDecoration,
                    child: const Icon(
                      Icons.my_location,
                      color: AppColors.blueFonce,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Style commun aux boutons ronds posés sur la carte
const _boutonCarteDecoration = BoxDecoration(
  color: AppColors.blanc,
  shape: BoxShape.circle,
  border: Border.fromBorderSide(BorderSide(color: AppColors.neutral200)),
  boxShadow: [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ],
);

Color _couleurPrix(PriceLevel? niveau) => switch (niveau) {
  PriceLevel.bas => AppColors.vert,
  PriceLevel.moyen => AppColors.orange,
  PriceLevel.eleve => AppColors.rouge,
  null => AppColors.neutral400,
};

String _formatNombre(double valeur, int decimales) =>
    valeur.toStringAsFixed(decimales).replaceAll('.', ',');

/// Petite fiche en bulle au-dessus de la pastille touchée qui ouvre la page
/// de la station
class _StationFiche extends StatelessWidget {
  const _StationFiche({required this.station, required this.viewModel});

  static const largeur = 240.0;
  static const hauteur = 140.0;

  final Station station;
  final Page1ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final prix = viewModel.prixDe(station);
    final distance = viewModel.distanceKm(station);
    final temps = viewModel.tempsTrajetMin(station);
    final nom = station.nom.isNotEmpty ? station.nom : station.adresse;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Material(
          color: AppColors.blanc,
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => PageInfoStation(
                  station: station,
                  distanceKm: distance,
                  tempsMin: temps,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          nom,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.titreCarte,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          station.ville,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.texteSecondaire,
                        ),
                        if (distance != null && temps != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '${_formatNombre(distance, 1)} km · $temps min',
                            style: AppTextStyle.metaPetite,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (prix != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatNombre(prix, 3),
                          style: AppTextStyle.prixCarte.copyWith(
                            color: _couleurPrix(viewModel.niveauPrix(station)),
                          ),
                        ),
                        Text('€/L', style: AppTextStyle.metaPetite),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        CustomPaint(
          size: const Size(16, 8),
          painter: _PointeFichePainter(),
        ),
        // Moitié de la pastille plus un petit écart
        const SizedBox(height: 20),
      ],
    );
  }
}

/// Petit triangle sous la fiche qui pointe vers la pastille
class _PointeFichePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pointe = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(pointe, Paint()..color = AppColors.blanc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Pastille ronde avec une pompe centrée sur la station et colorée selon
/// son prix
class _StationMarker extends StatelessWidget {
  const _StationMarker({required this.niveau});

  final PriceLevel? niveau;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _couleurPrix(niveau),
        shape: BoxShape.circle,
        border: const Border.fromBorderSide(
          BorderSide(color: AppColors.blanc, width: 2),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.local_gas_station,
        color: AppColors.blanc,
        size: 20,
      ),
    );
  }
}

/// Ouvre la légende et laisse la mention OpenStreetMap visible
class _BoutonInfo extends StatefulWidget {
  const _BoutonInfo({required this.avecPrix, required this.mediane});

  final bool avecPrix;
  final double? mediane;

  @override
  State<_BoutonInfo> createState() => _BoutonInfoState();
}

class _BoutonInfoState extends State<_BoutonInfo> {
  bool _ouvert = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_ouvert) ...[
              _Legende(avecPrix: widget.avecPrix, mediane: widget.mediane),
              const SizedBox(height: AppSpacing.xs),
            ],
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _ouvert = !_ouvert),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: _boutonCarteDecoration,
                    child: Icon(
                      _ouvert ? Icons.close : Icons.info_outline,
                      color: AppColors.blueFonce,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  color: AppColors.blanc.withValues(alpha: 0.7),
                  child: Text(
                    '© OpenStreetMap',
                    style: AppTextStyle.texteSecondaire.copyWith(
                      fontSize: 10,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Legende extends StatelessWidget {
  const _Legende({required this.avecPrix, required this.mediane});

  // false avec Tous
  final bool avecPrix;
  final double? mediane;

  static final pourcentage = '${(Page1ViewModel.ecartMediane * 100).round()} %';

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyle.texteSecondaire.copyWith(
      fontSize: 12,
      height: 1.3,
      color: AppColors.neutral700,
    );
    final note = AppTextStyle.texteSecondaire.copyWith(
      fontSize: 11,
      height: 1.3,
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      constraints: const BoxConstraints(maxWidth: 230),
      decoration: BoxDecoration(
        color: AppColors.blanc.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (avecPrix) ...[
            _LigneLegende(
              PriceLevel.bas,
              'Au moins $pourcentage moins cher',
              style,
            ),
            _LigneLegende(PriceLevel.moyen, 'Proche de la médiane', style),
            _LigneLegende(
              PriceLevel.eleve,
              'Au moins $pourcentage plus cher',
              style,
            ),
            const SizedBox(height: 2),
            // Rétrécit plutôt que de passer à la ligne
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                mediane == null
                    ? 'Comparé à la médiane nationale du jour'
                    : 'Médiane nationale du jour : '
                          '${_formatNombre(mediane!, 3)} €/L',
                style: note,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ] else
            _LigneLegende(
              null,
              'Choisissez un carburant pour comparer les prix',
              style,
            ),
        ],
      ),
    );
  }
}

class _LigneLegende extends StatelessWidget {
  const _LigneLegende(this.niveau, this.texte, this.style);

  final PriceLevel? niveau;
  final String texte;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: _couleurPrix(niveau),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(child: Text(texte, style: style)),
        ],
      ),
    );
  }
}

/// Regroupe des pastilles proches avec la couleur de la moins chère
class _ClusterBulle extends StatelessWidget {
  const _ClusterBulle({required this.nombre, required this.niveau});

  final int nombre;
  final PriceLevel? niveau;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _couleurPrix(niveau),
        shape: BoxShape.circle,
        border: const Border.fromBorderSide(
          BorderSide(color: AppColors.blanc, width: 2),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$nombre',
        style: const TextStyle(
          color: AppColors.blanc,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _CompassIcon extends StatelessWidget {
  const _CompassIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: _boutonCarteDecoration,
      child: CustomPaint(painter: _CompassNeedlePainter()),
    );
  }
}

class _CompassNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final length = size.height * 0.34;
    final halfWidth = size.width * 0.12;

    final nord = Path()
      ..moveTo(center.dx, center.dy - length)
      ..lineTo(center.dx + halfWidth, center.dy)
      ..lineTo(center.dx - halfWidth, center.dy)
      ..close();
    final sud = Path()
      ..moveTo(center.dx, center.dy + length)
      ..lineTo(center.dx + halfWidth, center.dy)
      ..lineTo(center.dx - halfWidth, center.dy)
      ..close();

    canvas
      ..drawPath(nord, Paint()..color = AppColors.rouge)
      ..drawPath(sud, Paint()..color = AppColors.neutral400)
      ..drawCircle(center, 2.5, Paint()..color = AppColors.blueFonce);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
