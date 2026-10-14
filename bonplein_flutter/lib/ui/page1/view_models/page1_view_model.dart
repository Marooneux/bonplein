import 'package:dio/dio.dart';
import 'dart:math' show max, min;
import 'package:bonplein_flutter/data/repositories/station_service_repository.dart';
import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:bonplein_flutter/domain/models/type_carburant.dart';
import 'package:bonplein_flutter/utils/math_utils.dart';
import 'package:flutter/foundation.dart';

typedef Coordonnees = ({double latitude, double longitude});

enum PriceLevel { bas, moyen, eleve }

TypeCarburant? _carburantDepuisBouton(String bouton) {
  return switch (bouton) {
    'SP95' => TypeCarburant.sp95,
    'SP95-E10' || 'E10' => TypeCarburant.e10,
    'SP98' => TypeCarburant.sp98,
    'Gazole' => TypeCarburant.gazole,
    'E85' => TypeCarburant.e85,
    'GPL' || 'GPL-c' => TypeCarburant.gplc,
    _ => null,
  };
}

class Page1ViewModel extends ChangeNotifier {
  Page1ViewModel({required StationServiceRepository repository})
      : _repository = repository;

  final StationServiceRepository _repository;

  Coordonnees? _position;
  String? _positionLabel;
  TypeCarburant _carburant = TypeCarburant.sp95;
  List<Station> _stations = [];
  Station? _selected;
  double _prixMin = 0;
  double _prixMax = 0;
  bool _isLoading = false;
  String? _errorMessage;
  int _requestId = 0;
  bool _disposed = false;

  Coordonnees? get position => _position;
  String? get positionLabel => _positionLabel;
  TypeCarburant get carburant => _carburant;
  List<Station> get stations => _stations;
  Station? get selectedStation => _selected;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasLocation => _position != null;

  double? prixDe(Station station) {
    for (final c in station.carburants) {
      if (c.type == _carburant) return c.prix;
    }
    return null;
  }

  double? distanceKm(Station station) {
    final depart = _position;
    if (depart == null) return null;
    return calculerDistanceKm(
      lat1: depart.latitude,
      lon1: depart.longitude,
      lat2: station.latitude,
      lon2: station.longitude,
    );
  }

  /// Vert, orange ou rouge, selon le prix par rapport aux autres stations.
  PriceLevel? niveauPrix(Station station) {
    final prix = prixDe(station);
    if (prix == null) return null;
    final ecart = _prixMax - _prixMin;
    if (ecart <= 0) return PriceLevel.bas;
    final ratio = (prix - _prixMin) / ecart;
    if (ratio < 1 / 3) return PriceLevel.bas;
    if (ratio < 2 / 3) return PriceLevel.moyen;
    return PriceLevel.eleve;
  }

  /// Barre de recherche ou bouton de localisation, on choisit une position.
  Future<void> selectLocation(String label, Coordonnees position) {
    _positionLabel = label;
    _position = position;
    return loadStations();
  }

  /// Bouton de carburant (SP95, SP98, Gazole, E85, GPL).
  Future<void> selectFuel(String bouton) async {
    final carburant = _carburantDepuisBouton(bouton);
    if (carburant == null) return;
    _carburant = carburant;
    await loadStations();
  }

  /// On touche une pastille sur la carte : la carte du bas change.
  void selectStation(Station station) {
    _selected = station;
    _notify();
  }

  /// Cherche les stations autour de la position, pour le carburant choisi.
  Future<void> loadStations() async {
    final position = _position;
    if (position == null) {
      _notify(); // pas encore de position : rien à chercher
      return;
    }

    // Si on change vite de choix, seule la dernière réponse compte.
    final requestId = ++_requestId;
    _isLoading = true;
    _errorMessage = null;
    _notify();

    try {
      final result = await _repository.getStationsProches(
        latitude: position.latitude,
        longitude: position.longitude,
        carburant: _carburant,
      );
      if (requestId != _requestId) return;
      _applyResult(result);
    } on Exception catch (e) {
      // TEMPORAIRE : pour voir la vraie cause de l'erreur
      if (e is DioException) {
        debugPrint('API ${e.response?.statusCode} : ${e.response?.data}');
      }
      debugPrint('ERREUR API : $e');
    }

    _isLoading = false;
    _notify();
  }

  void _applyResult(List<Station> result) {
    _stations = result.where((s) => prixDe(s) != null).toList();

    final prix = _stations.map(prixDe).whereType<double>();
    _prixMin = prix.isEmpty ? 0 : prix.reduce(min);
    _prixMax = prix.isEmpty ? 0 : prix.reduce(max);

    // l'ancienne sélection n'est plus valable.
    _selected = null;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}