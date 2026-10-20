import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/page1/view_models/page1_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({required this.viewModel, super.key});

  final Page1ViewModel viewModel;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Position? position;

  @override
  void initState() {
    super.initState();
    getPosition();
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
          options: const MapOptions(
            initialCenter: LatLng(43.604, 1.444),
            initialZoom: 15,
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
              attributions: [TextSourceAttribution('OpenStreetMap contributors')],
            ),
            CurrentLocationLayer(
              alignPositionOnUpdate: AlignOnUpdate.always,
            ), // User location
          ],
        ),
      ),
    );
  }
}
