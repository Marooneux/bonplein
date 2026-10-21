import 'dart:async';

import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/page1/view_models/page1_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({required this.viewModel, super.key});

  final Page1ViewModel viewModel;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

const _zoomParDefaut = 13.0;

class _MapWidgetState extends State<MapWidget> {
  Position? position;
  // Chaque valeur envoyée recentre la carte sur l'utilisateur
  // avec ce zoom (null = garder le zoom actuel).
  final _recentrerController = StreamController<double?>();
  final _mapController = MapController();
  late final StreamSubscription<void> _reinitialisationSubscription;

  @override
  void initState() {
    super.initState();
    getPosition();
    _reinitialisationSubscription =
        widget.viewModel.reinitialisationCarte.listen((_) => _reinitialiser());
  }

  @override
  void dispose() {
    unawaited(_reinitialisationSubscription.cancel());
    unawaited(_recentrerController.close());
    _mapController.dispose();
    super.dispose();
  }

  /// Remet la carte comme à l'ouverture : nord en haut, centrée sur
  /// l'utilisateur au zoom par défaut.
  void _reinitialiser() {
    _mapController.rotate(0);
    _recentrerController.add(_zoomParDefaut);
  }

  Future<void> getPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    position = await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FlutterMap(
          mapController: _mapController,
          options: const MapOptions(
            initialCenter: LatLng(43.604, 1.444),
            initialZoom: _zoomParDefaut,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.bonplein.bonplein_flutter',
            ),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) => MarkerLayer(
                markers: [
                  for (final station in widget.viewModel.stations)
                    Marker(
                      point: LatLng(station.latitude, station.longitude),
                      width: 32,
                      height: 32,
                      // La pointe de l'icône sur la station.
                      alignment: Alignment.topCenter,
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.vert,
                        size: 32,
                      ),
                    ),
                ],
              ),
            ),
            const RichAttributionWidget(
              alignment: AttributionAlignment.bottomLeft,
              showFlutterMapAttribution: false,
              attributions: [TextSourceAttribution('OpenStreetMap contributors')],
            ),
            CurrentLocationLayer(
              alignPositionStream: _recentrerController.stream,
              alignPositionOnUpdate: AlignOnUpdate.once,
            ), // User location
            // En dernier pour rester au-dessus des marqueurs.
            const MapCompass(icon: _CompassIcon()),
            Align(
              alignment: Alignment.bottomRight,
              // Sous la boussole (10 de padding + 48 de bouton).
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 62, 10, 10),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: 'Recentrer',
                  onPressed: () => _recentrerController.add(_zoomParDefaut),
                  icon: Container(
                    width: 44,
                    height: 44,
                    decoration: _boutonCarteDecoration,
                    child: const Icon(
                      Icons.my_location,
                      color: AppColors.blueFonce,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Style commun aux boutons ronds posés sur la carte.
const _boutonCarteDecoration = BoxDecoration(
  color: AppColors.blanc,
  shape: BoxShape.circle,
  border: Border.fromBorderSide(BorderSide(color: AppColors.neutral200)),
  boxShadow: [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ],
);

class _CompassIcon extends StatelessWidget {
  const _CompassIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: _boutonCarteDecoration,
      child: CustomPaint(painter: _CompassNeedlePainter()),
    );
  }
}

class _CompassNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final length = size.height * 0.34;
    final halfWidth = size.width * 0.12;

    final nord = Path()
      ..moveTo(center.dx, center.dy - length)
      ..lineTo(center.dx + halfWidth, center.dy)
      ..lineTo(center.dx - halfWidth, center.dy)
      ..close();
    final sud = Path()
      ..moveTo(center.dx, center.dy + length)
      ..lineTo(center.dx + halfWidth, center.dy)
      ..lineTo(center.dx - halfWidth, center.dy)
      ..close();

    canvas
      ..drawPath(nord, Paint()..color = AppColors.rouge)
      ..drawPath(sud, Paint()..color = AppColors.neutral400)
      ..drawCircle(center, 2.5, Paint()..color = AppColors.blueFonce);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
