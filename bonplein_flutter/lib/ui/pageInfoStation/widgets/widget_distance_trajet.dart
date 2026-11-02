import 'package:flutter/material.dart';


Widget buildDistanceTrajet(double? distanceKm, int? tempsMin) => Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.black12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: Row(
    children: [
      // Distance
      Expanded(
        child: Column(
          children: [
            Text(
              distanceKm == null
                  ? '–'
                  : '${distanceKm.toStringAsFixed(1).replaceAll('.', ',')} km',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Distance',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),

      // Séparateur vertical
      Container(
        width: 1,
        height: 45,
        color: Colors.black12,
      ),

      // Temps de trajet
      Expanded(
        child: Column(
          children: [
            Text(
              tempsMin == null ? '–' : '$tempsMin min',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Trajet en voiture',
              style: TextStyle(
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