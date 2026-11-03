import 'package:bonplein_flutter/domain/models/type_carburant.dart';
import 'package:bonplein_flutter/ui/page1/view_models/carte_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_station_repository.dart';

const ZoneCarte _zone = (sud: 43.5, ouest: 1.3, nord: 43.7, est: 1.6);
const TypeCarburant _sp95 = TypeCarburant.sp95;

/// Laisse finir les chargements lancés sans attendre comme les médianes
Future<void> _attendre() => Future<void>.delayed(Duration.zero);

void main() {
  late FakeStationRepository repository;
  late CarteViewModel viewModel;

  final dansZone = station(id: 1, prix: {_sp95: 1.95});
  final sansSp95 = station(id: 2, prix: {TypeCarburant.gazole: 2.20});
  final horsZone = station(id: 3, latitude: 48.85, prix: {_sp95: 1.90});

  setUp(() {
    repository = FakeStationRepository(
      stations: [dansZone, sansSp95, horsZone],
      medianes: {_sp95: 2.00},
    );
    viewModel = CarteViewModel(repository: repository)..zoneChangee(_zone);
  });

  tearDown(() => viewModel.dispose());

  group('stations affichées', () {
    test('seulement celles de la zone qui ont le carburant choisi', () async {
      await viewModel.selectFiltre('SP95');

      expect(viewModel.stations, [dansZone]);
    });

    test('avec Tous celles de la zone même sans prix', () async {
      await viewModel.selectFiltre(null);

      expect(viewModel.stations, [dansZone, sansSp95]);
    });

    test('toutes les stations sont téléchargées une seule fois', () async {
      await viewModel.selectFiltre('SP95');
      await viewModel.selectFiltre('Gazole');
      await viewModel.selectFiltre(null);

      expect(repository.appelsToutes, 1);
    });
  });

  group('couleurs', () {
    test("selon l'écart de 2 % à la médiane nationale", () async {
      await viewModel.selectFiltre('SP95');
      await _attendre();

      PriceLevel? niveau(double prix) =>
          viewModel.niveauPrix(station(id: 10, prix: {_sp95: prix}));

      expect(niveau(1.95), PriceLevel.bas);
      expect(niveau(1.97), PriceLevel.moyen);
      expect(niveau(2), PriceLevel.moyen);
      expect(niveau(2.03), PriceLevel.moyen);
      expect(niveau(2.05), PriceLevel.eleve);
    });

    test('pas de couleur avec Tous', () async {
      await viewModel.selectFiltre(null);
      await _attendre();

      expect(viewModel.niveauPrix(dansZone), isNull);
    });

    test('pas de couleur sans médiane', () async {
      repository.medianes = {};
      await viewModel.selectFiltre('SP95');
      await _attendre();

      expect(viewModel.niveauPrix(dansZone), isNull);
    });

    test('une bulle prend la couleur de sa station la moins chère', () async {
      await viewModel.selectFiltre('SP95');
      await _attendre();

      final groupe = [
        station(id: 10, prix: {_sp95: 2.10}),
        station(id: 11, prix: {_sp95: 1.90}),
        station(id: 12, prix: {_sp95: 2.00}),
      ];

      expect(viewModel.niveauMoinsChere(groupe), PriceLevel.bas);
    });

    test('les médianes sont demandées une seule fois par jour', () async {
      await viewModel.selectFiltre('SP95');
      await _attendre();
      await viewModel.selectFiltre('Gazole');
      await viewModel.reinitialiser();
      await _attendre();

      expect(repository.appelsMedianes, 1);
    });
  });

  group('fiche', () {
    test('reste ouverte si la station est encore dans la zone', () async {
      await viewModel.selectFiltre('SP95');
      viewModel.selectStation(dansZone);

      await viewModel.selectFiltre('SP95');

      expect(viewModel.selectedStation, dansZone);
    });

    test('se ferme si la station sort de la zone', () async {
      await viewModel.selectFiltre('SP95');
      viewModel
        ..selectStation(dansZone)
        ..zoneChangee((sud: 48.8, ouest: 2.3, nord: 48.9, est: 2.4));

      await viewModel.selectFiltre('SP95');

      expect(viewModel.selectedStation, isNull);
    });
  });

  test("la distance vient de la position de l'utilisateur", () {
    expect(viewModel.distanceKm(dansZone), isNull);

    viewModel.positionUtilisateur = (latitude: 43.604, longitude: 1.444);

    expect(viewModel.distanceKm(dansZone), closeTo(0, 0.01));
  });
}
