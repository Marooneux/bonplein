import 'package:dio/dio.dart';

import 'package:bonplein_flutter/data/api_models/carburant_api_model.dart';
import 'package:bonplein_flutter/data/services/api/carburant_api_service.dart';
import 'package:bonplein_flutter/domain/models/carburant.dart';
import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:bonplein_flutter/domain/models/type_carburant.dart';

class StationServiceRepository {
  final CarburantsApi _api;

  StationServiceRepository({CarburantsApi? api})
    : _api =
          api ??
          CarburantsApi(
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            ),
          );

  /// Recherche les stations situées dans un rayon (en km) autour des coordonnées GPS fournies.
  /// Si un [carburant] est spécifié, seules les stations proposant ce carburant sont retournées,
  /// les résultats sont triés par prix croissant.
  Future<List<Station>> getStationsProches({
    required double latitude,
    required double longitude,
    double rayonKm = 25.0,
    TypeCarburant? carburant,
    int limit = 20,
    int offset = 0,
  }) async {
    final conditions = <String>[
      "within_distance(geom, geom'POINT($longitude $latitude)', ${rayonKm}km)",
    ];

    if (carburant != null) {
      conditions.add('is_defined(${carburant.champApi})');
    }

    final orderBy = carburant != null
        ? '${carburant.champApi} asc'
        : "distance(geom, geom'POINT($longitude $latitude)') asc";

    final reponse = await _api.getRecords(
      where: conditions.join(' and '),
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return reponse.results.map(_mapperVersStation).toList();
  }

  /// Recherche les stations d'un département (ex: "31", "75", "13").
  Future<List<Station>> getStationsParDepartement({
    required String codeDepartement,
    TypeCarburant? carburant,
    int limit = 20,
    int offset = 0,
  }) async {
    final conditions = <String>['code_departement = "$codeDepartement"'];

    if (carburant != null) {
      conditions.add('is_defined(${carburant.champApi})');
    }

    final reponse = await _api.getRecords(
      where: conditions.join(' and '),
      orderBy: carburant != null ? '${carburant.champApi} asc' : null,
      limit: limit,
      offset: offset,
    );

    return reponse.results.map(_mapperVersStation).toList();
  }

  /// Recherche les stations dans une ville donnée.
  Future<List<Station>> getStationsParVille({
    required String ville,
    TypeCarburant? carburant,
    int limit = 20,
    int offset = 0,
  }) async {
    final conditions = <String>['search(ville, "$ville")'];

    if (carburant != null) {
      conditions.add('is_defined(${carburant.champApi})');
    }

    final reponse = await _api.getRecords(
      where: conditions.join(' and '),
      orderBy: carburant != null ? '${carburant.champApi} asc' : null,
      limit: limit,
      offset: offset,
    );

    return reponse.results.map(_mapperVersStation).toList();
  }

  /// Convertit le modèle de l'API [StationService] vers le modèle domaine [Station].
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

  /// Renvoie les coordonnées de secours sous forme de chaîne entière (ex: "4818300" -> 48.183).
  double _parserCoordonnee(String? valeur) {
    if (valeur == null || valeur.isEmpty) return 0.0;
    final parsed = double.tryParse(valeur);
    if (parsed == null) return 0.0;

    if (parsed.abs() > 180) {
      return parsed / 100000.0;
    }
    return parsed;
  }
}
