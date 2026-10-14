import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bonplein_flutter/data/repositories/station_service_repository.dart';
import 'package:bonplein_flutter/domain/models/type_carburant.dart';

import '../testing/fake_carburants_api.dart';
import '../testing/fake_stations.dart';

void main() {
  late FakeCarburantsApi api;
  late StationServiceRepository repository;

  setUp(() {
    api = FakeCarburantsApi();
    repository = StationServiceRepository(api: api);
  });

  group('getStationsProches - requête envoyée', () {
    test('utilise within_distance avec les coordonnées et le rayon', () async {
      await repository.getStationsProches(
        latitude: 43.6047,
        longitude: 1.4442,
        rayonKm: 10,
      );

      expect(api.givenWhereParam, contains('within_distance'));
      expect(api.givenWhereParam, contains('POINT(1.4442 43.6047)'));
      expect(api.givenWhereParam, contains('10.0km'));
    });

    test('sans carburant: trie par distance, sans filtre de prix', () async {
      await repository.getStationsProches(latitude: 43.6, longitude: 1.4);

      expect(api.givenOrderByParam, startsWith('distance('));
      expect(api.givenWhereParam, isNot(contains('is_defined')));
    });

    test('avec carburant: filtre et trie par prix', () async {
      await repository.getStationsProches(
        latitude: 43.6,
        longitude: 1.4,
        carburant: TypeCarburant.gazole,
      );

      final champ = TypeCarburant.gazole.champApi;
      expect(api.givenWhereParam, contains('is_defined($champ)'));
      expect(api.givenOrderByParam, '$champ asc');
    });

    test('transmet limit et offset à l\'API', () async {
      await repository.getStationsProches(
        latitude: 43.6,
        longitude: 1.4,
        limit: 5,
        offset: 10,
      );

      expect(api.givenLimitParam, 5);
      expect(api.givenOffsetParam, 10);
    });

    test('fait exactement un appel à l\'API', () async {
      await repository.getStationsProches(latitude: 43.6, longitude: 1.4);

      expect(api.callCount, 1);
    });
  });

  group('getStationsParDepartement / getStationsParVille', () {
    test('filtre par code département', () async {
      await repository.getStationsParDepartement(codeDepartement: '31');

      expect(api.givenWhereParam, 'code_departement = "31"');
    });

    test('filtre par ville avec search()', () async {
      await repository.getStationsParVille(ville: 'Toulouse');

      expect(api.givenWhereParam, 'search(ville, "Toulouse")');
    });

    test('combine ville et carburant avec "and"', () async {
      await repository.getStationsParVille(
        ville: 'Toulouse',
        carburant: TypeCarburant.sp95,
      );

      expect(api.givenWhereParam, contains(' and is_defined('));
    });
  });


  group('conversion API -> Station', () {
    test('ne crée un Carburant que pour les prix présents', () async {
      api.stations = [fakeStation(gazolePrix: 1.72, sp95Prix: 1.85)];

      final stations = await repository.getStationsParDepartement(
        codeDepartement: '31',
      );

      final types = stations.first.carburants.map((c) => c.type).toList();
      expect(types, [TypeCarburant.gazole, TypeCarburant.sp95]);
      expect(stations.first.carburants.first.prix, 1.72);
    });

    test('station sans aucun prix → liste de carburants vide', () async {
      api.stations = [fakeStation()];

      final stations = await repository.getStationsParDepartement(
        codeDepartement: '31',
      );

      expect(stations.first.carburants, isEmpty);
    });

    test('nom = adresse; sinon ville; sinon "Station-service"', () async {
      api.stations = [
        fakeStation(adresse: '  1 rue A  '),
        fakeStation(adresse: '   ', ville: 'Albi'),
        fakeStation(adresse: null, ville: null),
      ];

      final s = await repository.getStationsParDepartement(
        codeDepartement: '31',
      );

      expect(s[0].nom, '1 rue A');
      expect(s[1].nom, 'Albi');
      expect(s[2].nom, 'Station-service');
    });

    test('pop == "A" → surAutoroute', () async {
      api.stations = [fakeStation(pop: 'A'), fakeStation(pop: 'R')];

      final s = await repository.getStationsParDepartement(
        codeDepartement: '31',
      );

      expect(s[0].surAutoroute, isTrue);
      expect(s[1].surAutoroute, isFalse);
    });

    test('sans geom: coordonnées de secours divisées par 100000', () async {
      api.stations = [
        fakeStation(geom: null, latitude: '4818300', longitude: '236000'),
      ];

      final s = await repository.getStationsParDepartement(
        codeDepartement: '31',
      );

      expect(s.first.latitude, closeTo(48.183, 0.0001));
      expect(s.first.longitude, closeTo(2.36, 0.0001));
    });

    test('coordonnées de secours invalides ou absentes -> 0.0', () async {
      api.stations = [fakeStation(geom: null, latitude: 'abc', longitude: null)];

      final s = await repository.getStationsParDepartement(
        codeDepartement: '31',
      );

      expect(s.first.latitude, 0.0);
      expect(s.first.longitude, 0.0);
    });

    test('id manquant → 0', () async {
      api.stations = [fakeStation(id: null)];

      final s = await repository.getStationsParDepartement(
        codeDepartement: '31',
      );

      expect(s.first.id, 0);
    });
  });

  // ── 3. Pagination (possible grâce au faux service enrichi) ────────────────
  group('pagination', () {
    test('renvoie seulement la page demandée', () async {
      api.stations = List.generate(30, (i) => fakeStation(id: i));

      final page = await repository.getStationsParDepartement(
        codeDepartement: '31',
        limit: 10,
        offset: 20,
      );

      expect(page.map((s) => s.id), [for (var i = 20; i < 30; i++) i]);
    });
  });


  group('erreurs', () {
    test('propage la DioException si l\'API échoue', () async {
      api.errorToThrow = DioException(
        requestOptions: RequestOptions(path: '/records'),
        type: DioExceptionType.connectionTimeout,
      );

      await expectLater(
        repository.getStationsParDepartement(codeDepartement: '31'),
        throwsA(isA<DioException>()),
      );
    });

    test('même en cas d\'erreur, la requête envoyée était la bonne', () async {
      api.errorToThrow = DioException(
        requestOptions: RequestOptions(path: '/records'),
        type: DioExceptionType.connectionTimeout,
      );

      await expectLater(
        repository.getStationsParDepartement(codeDepartement: '31'),
        throwsA(isA<DioException>()),
      );
      expect(api.lastCall.where, 'code_departement = "31"');
    });
  });
}