import 'package:flutter/material.dart';
import 'station_card.dart';

class StationList extends StatelessWidget{
  final List<StationCard> stations;
  const StationList({super.key, required this.stations});

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) {
      return const Center(
        child: Padding(
            padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_gas_station, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'Aucune station disponible',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Essayez une autre adresse.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) => stations[index],
    );
  }

}