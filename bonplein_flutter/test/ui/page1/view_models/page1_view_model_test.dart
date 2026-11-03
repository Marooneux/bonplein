import 'package:bonplein_flutter/domain/models/type_carburant.dart';
import 'package:bonplein_flutter/ui/page1/view_models/page1_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import '../../../helpers/fake_geolocator.dart';
import '../../../helpers/fake_station_repository.dart';

const AddressSuggestion _adresse = (
  label: 'Capitole',
  latitude: 43.604,
  longitude: 1.444,
);

void main() {
  late FakeStationRepository repository;
  late Page1ViewModel viewModel;

  final avecSp95 = station(id: 1, prix: {TypeCarburant.sp95: 1.95});
  final sansSp95 = station(id: 2, prix: {TypeCarburant.gazole: 2.20});

  setUp(() {
    repository = FakeStationRepository(stations: [avecSp95, sansSp95]);
    viewModel = Page1ViewModel(repository: repository);
  });

  tearDown(() => viewModel.dispose());

  group('géolocalisation', () {
    test('acceptée la position est récupérée', () async {
      final fake = FakeGeolocatorPlatform(
        permissionAfterRequest: LocationPermission.whileInUse,
      );
      GeolocatorPlatform.instance = fake;

      final position = await viewModel.loadUserPosition();

      expect(fake.requestPermissionCalls, 1);
      expect(fake.getCurrentPositionCalls, 1);
      expect(position, (latitude: 43.6, longitude: 1.44));
    });

    test('refusée aucune position récupérée', () async {
      final fake = FakeGeolocatorPlatform(
        permissionAfterRequest: LocationPermission.denied,
      );
      GeolocatorPlatform.instance = fake;

      final position = await viewModel.loadUserPosition();

      expect(fake.requestPermissionCalls, 1);
      expect(fake.getCurrentPositionCalls, 0);
      expect(position, isNull);
    });
  });

  group('liste', () {
    test('une adresse choisie charge les stations avec un prix', () async {
      await viewModel.selectSuggestion(_adresse);

      expect(viewModel.positionLabel, 'Capitole');
      expect(viewModel.stations, [avecSp95]);
      expect(viewModel.isLoading, isFalse);
    });

    test("le retour sur l'accueil vide la liste", () async {
      await viewModel.selectSuggestion(_adresse);

      viewModel.reinitialiserPosition();

      expect(viewModel.position, isNull);
      expect(viewModel.stations, isEmpty);
    });
  });

  group('carburant', () {
    test('choisi sans adresse il est gardé sans rien charger', () async {
      await viewModel.selectFuel('GPL-c');

      expect(viewModel.carburant, TypeCarburant.gplc);
      expect(repository.appelsProches, 0);
    });

    test('un bouton inconnu ne change rien', () async {
      await viewModel.selectFuel('Kérosène');

      expect(viewModel.carburant, TypeCarburant.sp95);
    });
  });
}
