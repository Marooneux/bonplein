import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:bonplein_flutter/data/api_models/carburant_api_model.dart';
import 'package:bonplein_flutter/data/services/api/carburant_api_service.dart';

import 'recorded_ call_carburant.dart';


class FakeCarburantsApi extends Fake implements CarburantsApi {
  List<StationService> stations;

  FakeCarburantsApi({List<StationService>? stations})
      : stations = stations ?? [];


  /// Si défini, tous les appels lancent cette erreur (ex. DioException de timeout).
  Object? errorToThrow;

  /// Délai simulé avant de répondre (utile pour tester les états de chargement).
  Duration? delay;

  final List<RecordedCall> _calls = [];

  /// Historique de toutes les requêtes, de la plus ancienne à la plus récente.
  List<RecordedCall> get calls => List.unmodifiable(_calls);

  /// Nombre de fois où l'API a été appelée.
  int get callCount => _calls.length;

  /// La dernière requête reçue.
  RecordedCall get lastCall => _calls.last;

  // Raccourcis vers la dernière requête
  String? get givenWhereParam => _calls.isEmpty ? null : lastCall.where;
  String? get givenOrderByParam => _calls.isEmpty ? null : lastCall.orderBy;
  int? get givenLimitParam => _calls.isEmpty ? null : lastCall.limit;
  int? get givenOffsetParam => _calls.isEmpty ? null : lastCall.offset;

  /// Remet le faux service à zéro (pour le réutiliser entre plusieurs tests).
  void reset() {
    stations = [];
    errorToThrow = null;
    delay = null;
    _calls.clear();
  }


  @override
  Future<ReponseStations> getRecords({
    String? select,
    String? where,
    String? orderBy,
    int? limit,
    int? offset,
    String? refine,
    String? exclude,
    String? timezone,
  }) async {
    // On enregistre AVANT de lancer l'erreur : on peut ainsi vérifier la
    // requête envoyée même quand l'appel échoue.
    _calls.add(
      RecordedCall(
        select: select,
        where: where,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
        refine: refine,
        exclude: exclude,
        timezone: timezone,
      ),
    );

    if (delay != null) await Future<void>.delayed(delay!);
    if (errorToThrow != null) throw errorToThrow!;

    // Pagination comme la vraie API : totalCount = total,
    // results = uniquement la page demandée.
    final start = min(max(offset ?? 0, 0), stations.length);
    final end = limit == null
        ? stations.length
        : min(start + limit, stations.length);

    return ReponseStations(
      totalCount: stations.length,
      results: stations.sublist(start, end),
    );
  }
}