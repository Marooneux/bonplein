import 'package:flutter/material.dart';
import 'station_card.dart';

class StationList extends StatelessWidget{
  final List<StationCard> stations;
  const StationList({super.key, required this.stations});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) => stations[index],
    );
  }

}