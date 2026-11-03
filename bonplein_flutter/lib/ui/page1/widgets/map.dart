import 'dart:async';

import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:bonplein_flutter/ui/page1/view_models/carte_view_model.dart';
import 'package:bonplein_flutter/ui/page1/widgets/carte/boutons_carte.dart';
import 'package:bonplein_flutter/ui/page1/widgets/carte/legende_carte.dart';
import 'package:bonplein_flutter/ui/page1/widgets/carte/marqueurs_carte.dart';
import 'package:bonplein_flutter/ui/page1/widgets/carte/regroupement_stations.dart';
import 'package:bonplein_flutter/ui/page1/widgets/carte/station_fiche.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

const _zoomParDefaut = 13.0;
// Toulouse si pas de GPS
const _centreParDefaut = LatLng(43.604, 1.444);

class MapWidget extends StatefulWidget {
  const MapWidget({required this.viewModel, super.key});

  final CarteViewModel viewModel;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  // Chaque valeur envoyée recentre la carte sur l'utilisateur avec ce zoom
  // ou garde le zoom actuel avec null
  final _recentrerController = StreamController<double?>();
  final _mapController = MapController();
  final _regroupement = RegroupementStations();
  late final StreamSubscription<void> _reinitialisationSubscription;

  CarteViewModel get _viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _reinitialisationSubscription = _viewModel.reinitialisation.listen(
      (_) => _reinitialiser(),
    );
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
    if (_viewModel.positionUtilisateur == null) {
      _mapController.move(_centreParDefaut, _zoomParDefaut);
    } else {
      _recentrerController.add(_zoomParDefaut);
    }
  }

  void _envoyerZone(MapCamera camera) {
    final bounds = camera.visibleBounds;
    _viewModel.zoneChangee((
      sud: bounds.south,
      ouest: bounds.west,
      nord: bounds.north,
      est: bounds.east,
    ));
  }

  Marker _marqueurStation(Station station) => Marker(
    point: LatLng(station.latitude, station.longitude),
    width: 36,
    height: 36,
    child: GestureDetector(
      onTap: () => _viewModel.selectStation(station),
      child: StationMarker(niveau: _viewModel.niveauPrix(station)),
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
        child: ClusterBulle(
          nombre: groupe.length,
          niveau: _viewModel.niveauMoinsChere(groupe),
        ),
      ),
    );
  }

  Widget _coucheStations() {
    // Reconstruit quand la carte bouge
    return Builder(
      builder: (context) {
        final groupes = _regroupement.grouper(
          _viewModel.stations,
          MapCamera.of(context),
        );
        return MarkerLayer(
          // Restent droites quand la carte tourne
          rotate: true,
          markers: [
            for (final groupe in groupes)
              if (groupe.length >= RegroupementStations.stationsMinParBulle)
                _marqueurBulle(groupe)
              else
                for (final station in groupe) _marqueurStation(station),
          ],
        );
      },
    );
  }

  Widget _coucheFiche() {
    final selected = _viewModel.selectedStation;
    return MarkerLayer(
      rotate: true,
      markers: [
        if (selected != null)
          Marker(
            point: LatLng(selected.latitude, selected.longitude),
            width: StationFiche.largeur,
            height: StationFiche.hauteur,
            // La pointe de la fiche juste au-dessus de la pastille
            alignment: Alignment.topCenter,
            child: StationFiche(station: selected, viewModel: _viewModel),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _centreParDefaut,
            initialZoom: _zoomParDefaut,
            // Toucher la carte à côté d'une pastille ferme la fiche
            onTap: (_, _) => _viewModel.selectStation(null),
            onMapReady: () => _envoyerZone(_mapController.camera),
            onPositionChanged: (camera, _) => _envoyerZone(camera),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.bonplein.bonplein_flutter',
            ),
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) => _coucheStations(),
            ),
            // La fiche passe au-dessus des pastilles
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) => _coucheFiche(),
            ),
            CurrentLocationLayer(
              alignPositionStream: _recentrerController.stream,
              alignPositionOnUpdate: AlignOnUpdate.once,
            ),
            // En dernier pour rester au-dessus des marqueurs
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) => BoutonInfo(
                avecPrix: _viewModel.filtre != null,
                mediane: _viewModel.medianeDuJour,
              ),
            ),
            const MapCompass(icon: CompassIcon()),
            BoutonRecentrer(
              onPressed: () => _recentrerController.add(_zoomParDefaut),
            ),
          ],
        ),
      ),
    );
  }
}
