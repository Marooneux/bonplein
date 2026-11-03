import 'dart:async';
import 'dart:math' show ln10, log;

import 'package:bonplein_flutter/data/repositories/station_service_repository.dart';
import 'package:bonplein_flutter/domain/models/coordonnees.dart';
import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:bonplein_flutter/domain/models/type_carburant.dart';
import 'package:bonplein_flutter/utils/math_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

typedef AddressSuggestion = ({String label, double latitude, double longitude});

/// Recherche d'adresse et liste des stations autour de l'adresse choisie
class Page1ViewModel extends ChangeNotifier {
  Page1ViewModel({required StationServiceRepository repository})
    : _repository = repository;

  /// Nombre de stations affichées au minimum même si elles sont loin
  static const stationsMinimum = 5;

  final StationServiceRepository _repository;
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Coordonnees? _position;
  String? _positionLabel;
  TypeCarburant _carburant = TypeCarburant.sp95;
  List<Station> _stations = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _requestId = 0;
  bool _disposed = false;
  bool _triParPrix = false;

  List<AddressSuggestion> _suggestions = [];
  Coordonnees? _userPosition;
  Timer? _debounce;
  int _addressRequestId = 0;

  Coordonnees? get position => _position;
  String? get positionLabel => _positionLabel;
  TypeCarburant get carburant => _carburant;
  List<Station> get stations => _stations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasLocation => _position != null;
  bool get triParPrix => _triParPrix;
  List<AddressSuggestion> get suggestions => _suggestions;

  double? prixDe(Station station) => station.prixPourCarburant(_carburant);

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

  int? tempsTrajetMin(Station station) {
    final km = distanceKm(station);
    if (km == null) return null;
    return calculerTempsTrajetEnMinutes(km, 40);
  }

  /// Position choisie avec la barre de recherche ou le bouton de localisation
  Future<void> selectLocation(String label, Coordonnees position) {
    _positionLabel = label;
    _position = position;
    return loadStations();
  }

  /// Récupère la position GPS de l'utilisateur pour proposer en premier
  /// les adresses proches de lui, renvoie null sans permission
  Future<Coordonnees?> loadUserPosition() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      final p = await Geolocator.getCurrentPosition();
      return _userPosition = (latitude: p.latitude, longitude: p.longitude);
    } on Exception {
      // Sans GPS la recherche marche quand même mais sans priorité
      return null;
    }
  }

  /// Appelée à chaque lettre tapée dans la barre de recherche
  void searchAddress(String text) {
    _debounce?.cancel();
    final query = text.trim();
    if (query.length < 3) {
      _addressRequestId++;
      _suggestions = [];
      _notify();
      return;
    }
    // On attend 400 ms sans frappe avant d'appeler l'API
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final requestId = ++_addressRequestId;
      try {
        final result = await _fetchAddresses(query);
        if (requestId != _addressRequestId) return;
        _suggestions = result;
      } on Exception {
        if (requestId != _addressRequestId) return;
        _suggestions = [];
      }
      _notify();
    });
  }

  Future<List<AddressSuggestion>> _fetchAddresses(String query) async {
    final position = _userPosition;
    final response = await _dio.get<Map<String, dynamic>>(
      'https://data.geopf.fr/geocodage/search',
      queryParameters: {
        'q': query,
        // On en demande plus pour pouvoir retrier selon la distance
        'limit': position == null ? 5 : 20,
        if (position != null) ...{
          'lat': position.latitude,
          'lon': position.longitude,
        },
      },
    );
    final features = (response.data?['features'] as List<dynamic>?) ?? [];
    final results = [
      for (final f in features.cast<Map<String, dynamic>>()) _parseFeature(f),
    ];
    if (position == null) return [for (final r in results) r.suggestion];

    // L'API trie surtout sur le texte donc on enlève un peu de score aux
    // adresses lointaines sans que la distance écrase la pertinence
    double rang(({AddressSuggestion suggestion, double score}) r) {
      final km = calculerDistanceKm(
        lat1: position.latitude,
        lon1: position.longitude,
        lat2: r.suggestion.latitude,
        lon2: r.suggestion.longitude,
      );
      return r.score - 0.05 * log(1 + km) / ln10;
    }

    results.sort((a, b) => rang(b).compareTo(rang(a)));
    return [for (final r in results.take(5)) r.suggestion];
  }

  ({AddressSuggestion suggestion, double score}) _parseFeature(
    Map<String, dynamic> f,
  ) {
    final properties = f['properties'] as Map<String, dynamic>;
    final geometry = f['geometry'] as Map<String, dynamic>;
    final coordinates = geometry['coordinates'] as List<dynamic>;
    return (
      suggestion: (
        label: _formatLabel(properties),
        longitude: (coordinates[0] as num).toDouble(),
        latitude: (coordinates[1] as num).toDouble(),
      ),
      score: (properties['score'] as num?)?.toDouble() ?? 0,
    );
  }

  /// "8 Boulevard du Port, 80000, Amiens" au lieu de
  /// "8 Boulevard du Port 80000 Amiens"
  String _formatLabel(Map<String, dynamic> properties) {
    final name = properties['name'] as String?;
    final postcode = properties['postcode'] as String?;
    final city = properties['city'] as String?;
    // Un Set pour éviter "Amiens, 80000, Amiens" quand on cherche une ville
    final parts = <String?>{
      name,
      postcode,
      city,
    }.whereType<String>().where((p) => p.isNotEmpty);
    if (parts.isEmpty) return properties['label'] as String? ?? '';
    return parts.join(', ');
  }

  /// L'utilisateur choisit une adresse dans la liste
  Future<void> selectSuggestion(AddressSuggestion s) {
    _suggestions = [];
    return selectLocation(
      s.label,
      (latitude: s.latitude, longitude: s.longitude),
    );
  }

  /// Au retour sur l'accueil la liste est vidée jusqu'à la prochaine recherche
  void reinitialiserPosition() {
    _requestId++;
    _position = null;
    _positionLabel = null;
    _stations = [];
    _isLoading = false;
    _errorMessage = null;
    _notify();
  }

  /// Trie la liste par distance ou par prix si triParPrix vaut true
  Future<void> setTriParPrix({required bool triParPrix}) async {
    if (_triParPrix == triParPrix) return;
    _triParPrix = triParPrix;
    await loadStations();
  }

  /// Boutons de carburant de la page de liste
  Future<void> selectFuel(String bouton) async {
    final carburant = TypeCarburant.depuisBouton(bouton);
    if (carburant == null) return;
    _carburant = carburant;
    await loadStations();
  }

  /// Cherche les stations autour de la position pour le carburant choisi
  Future<void> loadStations() async {
    final position = _position;
    if (position == null) {
      _notify();
      return;
    }

    // Si on change vite de choix seule la dernière réponse compte
    final requestId = ++_requestId;
    _isLoading = true;
    _errorMessage = null;
    _notify();

    try {
      var result = await _repository.getStationsProches(
        latitude: position.latitude,
        longitude: position.longitude,
        carburant: _carburant,
        triParPrix: _triParPrix,
      );
      // Peu de stations autour donc on prend les plus proches même loin
      if (result.length < stationsMinimum) {
        try {
          result = await _stationsLesPlusProches(position);
        } on Object {
          // On garde les quelques stations déjà trouvées
          if (result.isEmpty) rethrow;
        }
      }
      if (requestId != _requestId) return;
      _stations = result.where((s) => prixDe(s) != null).toList();
    } on Object {
      // Object et pas Exception car une réponse mal formée lève une
      // TypeError et le chargement ne s'arrêterait jamais
      if (requestId != _requestId) return;
      _stations = [];
      _errorMessage = 'Impossible de charger les stations.';
    }

    _isLoading = false;
    _notify();
  }

  /// Les [stationsMinimum] stations les plus proches sans limite de distance
  Future<List<Station>> _stationsLesPlusProches(Coordonnees position) async {
    final result = await _repository.getStationsProches(
      latitude: position.latitude,
      longitude: position.longitude,
      rayonKm: null,
      carburant: _carburant,
      triParPrix: false,
      limit: stationsMinimum,
    );
    if (_triParPrix) {
      result.sort(
        (a, b) => (prixDe(a) ?? double.infinity).compareTo(
          prixDe(b) ?? double.infinity,
        ),
      );
    }
    return result;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    super.dispose();
  }
}
