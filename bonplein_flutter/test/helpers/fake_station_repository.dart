import 'package:bonplein_flutter/data/repositories/station_service_repository.dart';
import 'package:bonplein_flutter/domain/models/carburant.dart';
import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:bonplein_flutter/domain/models/type_carburant.dart';

/// Station de test avec seulement ce qui compte pour la carte et la liste
Station station({
  required int id,
  double latitude = 43.604,
  double longitude = 1.444,
  Map<TypeCarburant, double> prix = const {},
}) {
  return Station(
    id: id,
    nom: 'Station $id',
    adresse: '$id rue du Test',
    ville: 'Toulouse',
    codePostal: '31000',
    latitude: latitude,
    longitude: longitude,
    surAutoroute: false,
    carburants: [
      for (final MapEntry(:key, :value) in prix.entries)
        Carburant(type: key, prix: value),
    ],
    services: const [],
  );
}

/// Repository qui renvoie des données fixes sans appeler l'API et compte
/// les appels
class FakeStationRepository extends StationServiceRepository {
  FakeStationRepository({
    this.stations = const [],
    this.medianes = const {},
  });

  List<Station> stations;
  Map<TypeCarburant, double> medianes;

  int appelsToutes = 0;
  int appelsZone = 0;
  int appelsMedianes = 0;
  int appelsProches = 0;

  @override
  Future<List<Station>> getToutesLesStations() async {
    appelsToutes++;
    return stations;
  }

  @override
  Future<List<Station>> getStationsDansZone({
    required double sud,
    required double ouest,
    required double nord,
    required double est,
    TypeCarburant? carburant,
    int limit = 100,
  }) async {
    appelsZone++;
    return stations.take(limit).toList();
  }

  @override
  Future<Map<TypeCarburant, double>> getMedianesNationales() async {
    appelsMedianes++;
    return medianes;
  }

  @override
  Future<List<Station>> getStationsProches({
    required double latitude,
    required double longitude,
    double? rayonKm = 25.0,
    TypeCarburant? carburant,
    bool triParPrix = true,
    int limit = 20,
    int offset = 0,
  }) async {
    appelsProches++;
    return stations;
  }
}
