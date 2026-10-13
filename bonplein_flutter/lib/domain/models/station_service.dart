import 'package:bonplein_flutter/domain/models/carburant.dart';
import 'package:bonplein_flutter/domain/models/type_carburant.dart';
import 'package:bonplein_flutter/utils/math_utils.dart';

class Station {
  const Station({
    required this.id,
    required this.nom,
    required this.adresse,
    required this.ville,
    required this.codePostal,
    required this.latitude,
    required this.longitude,
    required this.surAutoroute,
    required this.carburants,
    required this.services,
  });
  final int id;
  final String nom;
  final String adresse;
  final String ville;
  final String codePostal;
  final double latitude;
  final double longitude;
  final bool surAutoroute;
  final List<Carburant> carburants;
  final List<String> services;

  /// Renvoie le prix du carburant pour cette station
  double? prixPourCarburant(TypeCarburant type) {
    for (final carburant in carburants) {
      if (carburant.type == type) return carburant.prix;
    }
    return null;
  }

  /// Calcule la distance en kilomètres par rapport à la position fournie
  /// (latitude et longitude) avec la formule de Haversine.
  double distanceEnKmDepuis(double latitudeUser, double longitudeUser) {
    return calculerDistanceKm(
      lat1: latitudeUser,
      lon1: longitudeUser,
      lat2: latitude,
      lon2: longitude,
    );
  }

  /// Estime le temps de trajet en minutes pour aller d'une position (latitude,
  /// longitude) vers la station à une vitesse donnée
  int tempsEnMinutesDepuis(double lat, double lon, double vitesseKmH) {
    final distanceKm = distanceEnKmDepuis(lat, lon);
    return calculerTempsTrajetEnMinutes(distanceKm, vitesseKmH);
  }
}
