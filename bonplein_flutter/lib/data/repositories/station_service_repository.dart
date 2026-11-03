import 'package:bonplein_flutter/data/api_models/station_service_api_model.dart';
import 'package:bonplein_flutter/data/services/api/station_service_api_service.dart';
import 'package:bonplein_flutter/domain/models/carburant.dart';
import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:bonplein_flutter/domain/models/type_carburant.dart';
import 'package:dio/dio.dart';

class StationServiceRepository {
  StationServiceRepository({StationServiceApi? api})
    : _api =
          api ??
          StationServiceApi(
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            ),
          );
  final StationServiceApi _api;

  /// Seulement les champs utiles pour une réponse 4 fois plus légère
  static const _champsStation =
      'id,latitude,longitude,cp,pop,adresse,ville,geom,'
      'gazole_prix,gazole_maj,sp95_prix,sp95_maj,sp98_prix,sp98_maj,'
      'e10_prix,e10_maj,e85_prix,e85_maj,gplc_prix,gplc_maj,services_service';

  /// Stations dans un rayon en km autour des coordonnées GPS
  ///
  /// Avec un [carburant] seules les stations qui le proposent sont renvoyées
  /// et triées par prix croissant, ou de la plus proche à la plus éloignée
  /// si [triParPrix] vaut false. Sans [rayonKm] la distance n'est pas limitée
  Future<List<Station>> getStationsProches({
    required double latitude,
    required double longitude,
    double? rayonKm = 25.0,
    TypeCarburant? carburant,
    bool triParPrix = true,
    int limit = 20,
    int offset = 0,
  }) async {
    final point = "geom'POINT($longitude $latitude)'";
    final conditions = <String>[
      if (rayonKm != null) 'within_distance(geom, $point, ${rayonKm}km)',
    ];

    if (carburant != null) {
      conditions.add('${carburant.champApi} is not null');
    }

    final orderBy = carburant != null && triParPrix
        ? '${carburant.champApi} asc'
        : "distance(geom, geom'POINT($longitude $latitude)') asc";

    final reponse = await _api.getRecords(
      where: conditions.isEmpty ? null : conditions.join(' and '),
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return reponse.results.map(_mapperVersStation).toList();
  }

  /// Prix médian de chaque carburant en France calculé par l'API
  Future<Map<TypeCarburant, double>> getMedianesNationales() async {
    final reponse = await _api.getRecords(
      select: [
        for (final t in TypeCarburant.values)
          'median(${t.champApi}) as ${t.champApi}',
      ].join(', '),
      limit: 1,
    );
    if (reponse.results.isEmpty) return {};
    // L'API renvoie les médianes dans les champs de prix
    final medianes = _mapperVersStation(reponse.results.first);
    return {for (final c in medianes.carburants) c.type: c.prix};
  }

  /// Les 10 000 stations de France en une seule requête
  Future<List<Station>> getToutesLesStations() async {
    final reponse = await _api.exportRecords(select: _champsStation);
    return reponse.map(_mapperVersStation).toList();
  }

  /// Les [limit] stations les plus proches du centre de la zone pour
  /// afficher vite quelque chose
  Future<List<Station>> getStationsDansZone({
    required double sud,
    required double ouest,
    required double nord,
    required double est,
    TypeCarburant? carburant,
    int limit = 100,
  }) async {
    final conditions = <String>[
      'in_bbox(geom, $sud, $ouest, $nord, $est)',
      if (carburant != null) '${carburant.champApi} is not null',
    ];
    final centre = "geom'POINT(${(ouest + est) / 2} ${(sud + nord) / 2})'";

    final reponse = await _api.getRecords(
      select: _champsStation,
      where: conditions.join(' and '),
      orderBy: 'distance(geom, $centre) asc',
      limit: limit,
    );

    return reponse.results.map(_mapperVersStation).toList();
  }

  /// Stations d'un département comme "31", "75" ou "13"
  Future<List<Station>> getStationsParDepartement({
    required String codeDepartement,
    TypeCarburant? carburant,
    int limit = 20,
    int offset = 0,
  }) async {
    final conditions = <String>['code_departement = "$codeDepartement"'];

    if (carburant != null) {
      conditions.add('${carburant.champApi} is not null');
    }

    final reponse = await _api.getRecords(
      where: conditions.join(' and '),
      orderBy: carburant != null ? '${carburant.champApi} asc' : null,
      limit: limit,
      offset: offset,
    );

    return reponse.results.map(_mapperVersStation).toList();
  }

  /// Stations d'une ville
  Future<List<Station>> getStationsParVille({
    required String ville,
    TypeCarburant? carburant,
    int limit = 20,
    int offset = 0,
  }) async {
    final conditions = <String>['search(ville, "$ville")'];

    if (carburant != null) {
      conditions.add('${carburant.champApi} is not null');
    }

    final reponse = await _api.getRecords(
      where: conditions.join(' and '),
      orderBy: carburant != null ? '${carburant.champApi} asc' : null,
      limit: limit,
      offset: offset,
    );

    return reponse.results.map(_mapperVersStation).toList();
  }

  /// Convertit le modèle de l'API [StationService] vers le modèle domaine
  /// [Station]
  Station _mapperVersStation(StationService dto) {
    final carburants = <Carburant>[];

    if (dto.gazolePrix != null) {
      carburants.add(
        Carburant(
          type: TypeCarburant.gazole,
          prix: dto.gazolePrix!,
          maj: dto.gazoleMaj,
        ),
      );
    }
    if (dto.sp95Prix != null) {
      carburants.add(
        Carburant(
          type: TypeCarburant.sp95,
          prix: dto.sp95Prix!,
          maj: dto.sp95Maj,
        ),
      );
    }
    if (dto.sp98Prix != null) {
      carburants.add(
        Carburant(
          type: TypeCarburant.sp98,
          prix: dto.sp98Prix!,
          maj: dto.sp98Maj,
        ),
      );
    }
    if (dto.e10Prix != null) {
      carburants.add(
        Carburant(type: TypeCarburant.e10, prix: dto.e10Prix!, maj: dto.e10Maj),
      );
    }
    if (dto.e85Prix != null) {
      carburants.add(
        Carburant(type: TypeCarburant.e85, prix: dto.e85Prix!, maj: dto.e85Maj),
      );
    }
    if (dto.gplcPrix != null) {
      carburants.add(
        Carburant(
          type: TypeCarburant.gplc,
          prix: dto.gplcPrix!,
          maj: dto.gplcMaj,
        ),
      );
    }

    final nom = (dto.adresse != null && dto.adresse!.trim().isNotEmpty)
        ? dto.adresse!.trim()
        : (dto.ville ?? 'Station-service');

    return Station(
      id: dto.id ?? 0,
      nom: nom,
      adresse: dto.adresse ?? '',
      ville: dto.ville ?? '',
      codePostal: dto.cp ?? '',
      latitude: dto.geom?.lat ?? _parserCoordonnee(dto.latitude),
      longitude: dto.geom?.lon ?? _parserCoordonnee(dto.longitude),
      surAutoroute: dto.pop == 'A',
      carburants: carburants,
      services: dto.servicesService ?? const [],
    );
  }

  /// Convertit les coordonnées de secours écrites en entier comme "4818300"
  /// qui donne 48.183
  double _parserCoordonnee(String? valeur) {
    if (valeur == null || valeur.isEmpty) return 0;
    final parsed = double.tryParse(valeur);
    if (parsed == null) return 0;

    if (parsed.abs() > 180) {
      return parsed / 100000.0;
    }
    return parsed;
  }
}
