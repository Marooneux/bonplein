
import 'package:flutter/material.dart';

// Affiche les prix et la disponibilité des carburants d'une station.
Widget buildPrixCarburants() {
// Données temporaires en attendant de connecter l'API.
// Un prix à null signifie que le carburant est indisponible.
  final carburants = [
    {'nom': 'SP95', 'prix': '1,719 €/L'},
    {'nom': 'SP95-E10', 'prix': '1,689 €/L'},
    {'nom': 'SP98', 'prix': '1,829 €/L'},
    {'nom': 'Gazole', 'prix': '1,659 €/L'},
    {'nom': 'E85', 'prix': null},
    {'nom': 'GPL-c', 'prix': null},
  ];

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
        // Titre de la section.
        const Text(
          'Prix des carburants',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 12),
        // Séparation entre le titre et la liste.
        const Divider(color: Colors.black12),
        const SizedBox(height: 8),

        // Affiche chaque carburant avec son prix ou son statut.
        ...carburants.map((carburant) {
          final prix = carburant['prix'];
          final disponible = prix != null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nom du carburant.
                Text(
                  carburant['nom']!,
                  style: TextStyle(
                    color: disponible ? Colors.black87 : Colors.grey,
                  ),
                ),

                // Prix si disponible, statut sinon.
              Text(
                prix ?? 'Indisponible',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: disponible ? Colors.black87 : Colors.grey,
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

