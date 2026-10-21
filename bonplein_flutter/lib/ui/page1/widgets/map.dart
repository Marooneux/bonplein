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

class _MapWidgetState extends State<MapWidget> {
  Position? position;
  // Chaque valeur envoyée recentre la carte sur l'utilisateur
  // avec ce zoom (null = garder le zoom actuel).
  final _recentrerController = StreamController<double?>();
  final _mapController = MapController();
  late final StreamSubscription<void> _reinitialisationSubscription;

  @override
  void initState() {
    super.initState();
    getPosition();
    _reinitialisationSubscription =
        widget.viewModel.reinitialisationCarte.listen((_) => _reinitialiser());
  }

  @override
  void dispose() {
    unawaited(_reinitialisationSubscription.cancel());
    unawaited(_recentrerController.close());
    _mapController.dispose();
    super.dispose();
  }

  /// Remet la carte comme à l'ouverture : nord en haut, centrée sur
  /// l'utilisateur au zoom par défaut.
  void _reinitialiser() {
    _mapController.rotate(0);
    _recentrerController.add(_zoomParDefaut);
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
            initialCenter: const LatLng(43.604, 1.444),
            initialZoom: _zoomParDefaut,
            // Toucher la carte à côté d'une pastille ferme la fiche.
            onTap: (_, _) => widget.viewModel.selectStation(null),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.bonplein.bonplein_flutter',
            ),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                final selected = widget.viewModel.selectedStation;
                return MarkerLayer(
                  // Pompes et fiche restent droites quand la carte tourne.
                  rotate: true,
                  markers: [
                    for (final station in widget.viewModel.stations)
                      Marker(
                        point: LatLng(station.latitude, station.longitude),
                        width: 36,
                        height: 36,
                        child: GestureDetector(
                          onTap: () => widget.viewModel.selectStation(station),
                          child: _StationMarker(
                            niveau: widget.viewModel.niveauPrix(station),
                          ),
                        ),
                      ),
                    // En dernier pour passer au-dessus des autres pastilles.
                    if (selected != null)
                      Marker(
                        point: LatLng(selected.latitude, selected.longitude),
                        width: _StationFiche.largeur,
                        height: _StationFiche.hauteur,
                        // La pointe de la fiche juste au-dessus de la pastille.
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
            const RichAttributionWidget(
              alignment: AttributionAlignment.bottomLeft,
              showFlutterMapAttribution: false,
              attributions: [TextSourceAttribution('OpenStreetMap contributors')],
            ),
            CurrentLocationLayer(
              alignPositionStream: _recentrerController.stream,
              alignPositionOnUpdate: AlignOnUpdate.once,
            ), // User location
            // En dernier pour rester au-dessus des marqueurs.
            const MapCompass(icon: _CompassIcon()),
            Align(
              alignment: Alignment.bottomRight,
              // Sous la boussole (10 de padding + 48 de bouton).
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

// Style commun aux boutons ronds posés sur la carte.
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

/// Petite fiche en bulle au-dessus de la pastille touchée.
/// La toucher ouvre la page de la station.
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
        // Moitié de la pastille (36 / 2) + un petit écart.
        const SizedBox(height: 20),
      ],
    );
  }
}

/// Petit triangle sous la fiche, qui pointe vers la pastille.
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

/// Pastille ronde avec une pompe, centrée sur la station, colorée
/// selon le prix par rapport aux autres stations.
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
