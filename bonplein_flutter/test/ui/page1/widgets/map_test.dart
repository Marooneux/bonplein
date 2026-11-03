import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:bonplein_flutter/domain/models/type_carburant.dart';
import 'package:bonplein_flutter/ui/page1/view_models/carte_view_model.dart';
import 'package:bonplein_flutter/ui/page1/widgets/carte/marqueurs_carte.dart';
import 'package:bonplein_flutter/ui/page1/widgets/carte/station_fiche.dart';
import 'package:bonplein_flutter/ui/page1/widgets/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import '../../../helpers/fake_geolocator.dart';
import '../../../helpers/fake_station_repository.dart';

const TypeCarburant _sp95 = TypeCarburant.sp95;

/// Affiche la carte puis attend la fin du chargement des stations
Future<CarteViewModel> pumpMap(
  WidgetTester tester,
  List<Station> stations,
) async {
  final viewModel = CarteViewModel(
    repository: FakeStationRepository(
      stations: stations,
      medianes: {_sp95: 2.25},
    ),
  );
  addTearDown(viewModel.dispose);
  await viewModel.selectFiltre('SP95');

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: MapWidget(viewModel: viewModel)),
    ),
  );
  // La carte attend 150 ms sans mouvement avant de charger
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pump();
  return viewModel;
}

/// Stations écartées de 0,02° pour ne jamais tomber dans la même case
List<Station> _eloignees(int nombre) => [
  for (var i = 0; i < nombre; i++)
    station(id: i, longitude: 1.40 + i * 0.02, prix: {_sp95: 2.00}),
];

/// Stations au même endroit donc dans la même case
List<Station> _groupees(int nombre) => [
  for (var i = 0; i < nombre; i++) station(id: i, prix: {_sp95: 2.00}),
];

void main() {
  setUp(() {
    GeolocatorPlatform.instance = FakeGeolocatorPlatform(
      permissionAfterRequest: LocationPermission.denied,
    );
  });

  testWidgets('une pastille par station éloignée', (tester) async {
    await pumpMap(tester, _eloignees(3));

    expect(find.byType(StationMarker), findsNWidgets(3));
    expect(find.byType(ClusterBulle), findsNothing);
  });

  testWidgets('5 stations proches forment une bulle', (tester) async {
    await pumpMap(tester, _groupees(5));

    expect(find.byType(ClusterBulle), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.byType(StationMarker), findsNothing);
  });

  testWidgets('4 stations proches restent des pastilles', (tester) async {
    await pumpMap(tester, _groupees(4));

    expect(find.byType(StationMarker), findsNWidgets(4));
    expect(find.byType(ClusterBulle), findsNothing);
  });

  testWidgets('la pastille prend la couleur de son prix', (tester) async {
    await pumpMap(tester, [
      station(id: 1, prix: {_sp95: 2.10}),
    ]);

    final marqueur = tester.widget<StationMarker>(find.byType(StationMarker));
    expect(marqueur.niveau, PriceLevel.bas);
  });

  testWidgets('toucher une pastille ouvre sa fiche', (tester) async {
    final viewModel = await pumpMap(tester, _eloignees(1));

    await tester.tap(find.byType(StationMarker));
    await tester.pump();

    expect(viewModel.selectedStation?.id, 0);
    expect(find.byType(StationFiche), findsOneWidget);
  });

  testWidgets('le bouton i affiche la médiane du jour', (tester) async {
    await pumpMap(tester, _eloignees(1));

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pump();

    expect(find.text('Médiane nationale du jour : 2,250 €/L'), findsOneWidget);
  });
}
