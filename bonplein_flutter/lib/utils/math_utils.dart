import 'dart:math';

/// Convertit un angle de degrés en radians.
double deg2rad(double degres) => degres * (pi / 180.0);

/// Calcule la distance en kilomètres entre deux positions (latitude et
/// longitude) avec la formule de Haversine.
double calculerDistanceKm({
  required double lat1,
  required double lon1,
  required double lat2,
  required double lon2,
}) {
  const rayonTerreKm = 6371.0;
  final dLat = deg2rad(lat2 - lat1);
  final dLon = deg2rad(lon2 - lon1);

  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return rayonTerreKm * c;
}

/// Calcule le temps de trajet (en minutes) en fonction de la distance (en km)
/// et d'une vitesse moyenne.
int calculerTempsTrajetEnMinutes(double distanceKm, double vitesseKmH) {
  if (vitesseKmH <= 0 || distanceKm <= 0) return 0;
  return ((distanceKm / vitesseKmH) * 60).round();
}
