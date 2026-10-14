import 'package:bonplein_flutter/data/api_models/carburant_api_model.dart';

/// Crée une station « telle que l'API la renvoie » (StationService) avec des
/// valeurs par défaut.
///
/// Chaque test n'indique que ce qui le rend différent. Exemples :
///   fakeStation(gazolePrix: 1.72)   → station avec du gazole à 1,72
///   fakeStation(geom: null)         → station sans coordonnées « geom »
StationService fakeStation({
  int? id = 1,
  String? adresse = '118 route de narbonne',
  String? ville = 'Toulouse',
  String? cp = '31400',
  PointGeo? geom = const PointGeo(lat: 43.6047, lon: 1.4442),
  double? gazolePrix,
  double? sp95Prix,
  String? pop,
  String? latitude,
  String? longitude,
  List<String>? servicesService,
}) {
  return StationService(
    id: id,
    adresse: adresse,
    ville: ville,
    cp: cp,
    geom: geom,
    gazolePrix: gazolePrix,
    sp95Prix: sp95Prix,
    pop: pop,
    latitude: latitude,
    longitude: longitude,
    servicesService: servicesService,
  );
}