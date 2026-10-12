import 'package:flutter/material.dart';

class StationCard extends StatelessWidget{
  final String nom;
  final String adresse;
  final double prix;
  final double distance;
  final int temps;

  const StationCard ({
    super.key,
    required this.nom,
    required this.adresse,
    required this.prix,
    required this.distance,
    required this.temps
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
          padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  const SizedBox(height: 4),
                  Text(adresse),
                  const SizedBox(height: 8),
                  Text('${distance.toStringAsFixed(1)} km . $temps min'),
                ],
              ),
            ),
            Text('${prix.toStringAsFixed(3) } €/L',
              style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20
              ),
            )
          ],
        ),
      ),
    );
  }
}