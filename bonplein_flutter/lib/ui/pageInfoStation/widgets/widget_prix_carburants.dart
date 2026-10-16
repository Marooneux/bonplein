import 'package:bonplein_flutter/domain/models/carburant.dart';
import 'package:bonplein_flutter/domain/models/type_carburant.dart';
import 'package:flutter/material.dart';

// Affiche les prix et la disponibilité des carburants d'une station.
Widget buildPrixCarburants(List<Carburant> disponibles) {
  // Renvoie le prix formaté du carburant, ou null s'il est indisponible.
  String? prixDe(TypeCarburant type) {
    for (final c in disponibles) {
      if (c.type == type) {
        return '${c.prix.toStringAsFixed(3).replaceAll('.', ',')} €/L';
      }
    }
    return null;
  }

  // Un prix à null signifie que le carburant est indisponible.
  final carburants = [
    {'nom': 'SP95', 'prix': prixDe(TypeCarburant.sp95)},
    {'nom': 'SP95-E10', 'prix': prixDe(TypeCarburant.e10)},
    {'nom': 'SP98', 'prix': prixDe(TypeCarburant.sp98)},
    {'nom': 'Gazole', 'prix': prixDe(TypeCarburant.gazole)},
    {'nom': 'E85', 'prix': prixDe(TypeCarburant.e85)},
    {'nom': 'GPL-c', 'prix': prixDe(TypeCarburant.gplc)},
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