import 'package:bonplein_flutter/ui/page1/widgets/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Fausse implémentation de Geolocator : simule la réponse de l'utilisateur
/// à la demande d'autorisation et enregistre les appels effectués.
class FakeGeolocatorPlatform extends GeolocatorPlatform
    with MockPlatformInterfaceMixin {
  FakeGeolocatorPlatform({required this.permissionAfterRequest});

  final LocationPermission permissionAfterRequest;
  LocationPermission _permission = LocationPermission.denied;

  int requestPermissionCalls = 0;
  int getCurrentPositionCalls = 0;

  static final Position fakePosition = Position(
    latitude: 43.6,
    longitude: 1.44,
    timestamp: DateTime(2026),
    accuracy: 5,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  @override
  Future<LocationPermission> checkPermission() async => _permission;

  @override
  Future<LocationPermission> requestPermission() async {
    requestPermissionCalls++;
    _permission = permissionAfterRequest;
    return _permission;
  }

  @override
  Future<bool> isLocationServiceEnabled() async => true;

  @override
  Future<Position?> getLastKnownPosition({
    bool forceLocationManager = false,
  }) async => null;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    getCurrentPositionCalls++;
    return fakePosition;
  }

  @override
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) =>
      const Stream.empty();

  @override
  Stream<ServiceStatus> getServiceStatusStream() => const Stream.empty();
}

Future<void> pumpMap(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(home: Scaffold(body: MapWidget())),
  );
  // Laisse les futures de géolocalisation se résoudre.
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  testWidgets('géolocalisation acceptée : la position est récupérée et affichée',
      (tester) async {
    final fake = FakeGeolocatorPlatform(
      permissionAfterRequest: LocationPermission.whileInUse,
    );
    GeolocatorPlatform.instance = fake;

    await pumpMap(tester);

    expect(fake.requestPermissionCalls, greaterThan(0));
    expect(fake.getCurrentPositionCalls, greaterThan(0));
    expect(find.byType(DefaultLocationMarker), findsOneWidget);
  });

  testWidgets('géolocalisation refusée : aucune position récupérée ni affichée',
      (tester) async {
    final fake = FakeGeolocatorPlatform(
      permissionAfterRequest: LocationPermission.denied,
    );
    GeolocatorPlatform.instance = fake;

    await pumpMap(tester);

    expect(fake.requestPermissionCalls, greaterThan(0));
    expect(fake.getCurrentPositionCalls, 0);
    expect(find.byType(DefaultLocationMarker), findsNothing);
  });
}
