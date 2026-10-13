import 'package:flutter/material.dart';

Widget buildPrixCarburants() => Container(
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
      // Titre
      const Text(
        'Prix des carburants',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),

      const SizedBox(height: 12),

      // Ligne de séparation
      const Divider(color: Colors.black12),

      const SizedBox(height: 8),

      // SP95-E10
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('SP95'),
          const Text(
            '1,719 €/L',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),

      const SizedBox(height: 16),

      // SP98
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('SP98'),
          const Text(
            '1,829 €/L',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),

      const SizedBox(height: 16),

      // Gazole
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Gazole'),
          const Text(
            '1,659 €/L',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ],
  ),
);

