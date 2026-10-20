import 'package:bonplein_flutter/domain/models/carburant.dart';
import 'package:flutter/material.dart';

// Affiche la date et l'heure de la dernière mise à jour des prix.
// L'API donne une date par carburant : on garde la plus récente.
Widget buildMajStation(List<Carburant> carburants) {
  DateTime? derniere;
  for (final c in carburants) {
    final maj = c.maj;
    if (maj != null && (derniere == null || maj.isAfter(derniere))) {
      derniere = maj;
    }
  }

  String deuxChiffres(int n) => n.toString().padLeft(2, '0');

  String texte = 'Date de mise à jour inconnue';
  if (derniere != null) {
    final d = derniere.toLocal();
    texte = 'Mis à jour le ${deuxChiffres(d.day)}/${deuxChiffres(d.month)}/${d.year}'
        ' à ${deuxChiffres(d.hour)}h${deuxChiffres(d.minute)}';
  }

  return Row(
    children: [
      const Icon(Icons.update, size: 18, color: Colors.black54),
      const SizedBox(width: 8),
      Text(
        texte,
        style: const TextStyle(fontSize: 14, color: Colors.black54),
      ),
    ],
  );
}