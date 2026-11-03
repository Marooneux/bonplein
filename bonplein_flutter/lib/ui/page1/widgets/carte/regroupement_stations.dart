import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Regroupe les stations proches à l'écran pour en faire des bulles
class RegroupementStations {
  // Une bulle à partir de 5 stations dans une case de 60 px
  static const stationsMinParBulle = 5;
  static const _tailleCase = 60.0;
  static const _zoomSansBulle = 15;

  // Recalculé seulement quand le zoom ou les stations changent
  List<Station>? _stations;
  int? _zoom;
  List<List<Station>> _groupes = [];

  List<List<Station>> grouper(List<Station> stations, MapCamera camera) {
    final zoom = camera.zoom.floor();
    if (identical(stations, _stations) && zoom == _zoom) return _groupes;
    _stations = stations;
    _zoom = zoom;
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
}
