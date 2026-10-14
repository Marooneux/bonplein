import 'package:flutter/material.dart';
import 'package:bonplein_flutter/domain/models/station_service.dart';

// Affiche les prix et la disponibilité des carburants d'une station.
Widget buildPrixCarburants(Station station) {
  return Container(
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prix des carburants',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 12),
        const Divider(color: Colors.black12),
        const SizedBox(height: 8),
        // Affiche les carburants présents dans le modèle Station.
        ...station.carburants.map((carburant) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nom du carburant.
                Text(
                  carburant.type.nom,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
                // Prix au litre.
                Text(
                  '${carburant.prix.toStringAsFixed(3).replaceAll('.', ',')} €/L',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    ),
  );
}
