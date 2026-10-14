import 'package:bonplein_flutter/ui/page1/widgets/station_card.dart';
import 'package:flutter/material.dart';

class StationList extends StatelessWidget {
  const StationList({required this.stations, super.key});
  final List<StationCard> stations;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) => stations[index],
    );
  }
}
