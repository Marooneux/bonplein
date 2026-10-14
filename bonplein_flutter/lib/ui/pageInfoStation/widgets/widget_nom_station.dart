import 'package:flutter/material.dart';


final String nomParking = 'Station TotalEnergies';
final String adresseParking = '12 rue de Metz, Toulouse';

Widget buildNomParking() => Container(
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
              nomParking,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              adresseParking,
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

