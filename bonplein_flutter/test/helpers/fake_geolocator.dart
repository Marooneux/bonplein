import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Faux Geolocator qui simule la réponse de l'utilisateur à la demande
/// d'autorisation et compte les appels
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
