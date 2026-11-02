import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:flutter/material.dart';

Widget buildNomParking(Station station) => Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  ),
  child: Row(
    children: [
      // Logo à gauche
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.local_gas_station,
          size: 36,
          color: Colors.green,
        ),
      ),

      const SizedBox(width: 16),

      // Nom et adresse à droite
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              station.nom,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${station.adresse}, ${station.codePostal} ${station.ville}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);