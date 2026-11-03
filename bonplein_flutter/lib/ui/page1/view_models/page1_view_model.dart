import 'dart:async';
import 'dart:math' show ln10, log;

import 'package:bonplein_flutter/data/repositories/station_service_repository.dart';
import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:bonplein_flutter/domain/models/type_carburant.dart';
import 'package:bonplein_flutter/utils/math_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

typedef Coordonnees = ({double latitude, double longitude});
typedef AddressSuggestion = ({String label, double latitude, double longitude});
typedef ZoneCarte = ({double sud, double ouest, double nord, double est});

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

  /// Nombre de stations affichées au minimum même si elles sont loin
  static const stationsMinimum = 5;

  /// Durée avant de retélécharger les stations de la carte
  static const _dureeCache = Duration(minutes: 10);

  /// Écart à la médiane nationale pour passer au vert ou au rouge
  static const ecartMediane = 0.02;

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
  // null pour Tous
  TypeCarburant? _filtreCarte;
  // false sur la page de liste
  bool _surCarte = true;
  ZoneCarte? _zoneCarte;
  Timer? _debounceZone;
  // Toutes les stations de France pour la carte
  ({List<Station> stations, DateTime chargeLe})? _toutesLesStations;
  Future<List<Station>>? _telechargement;
  List<Station> _stations = [];
  Station? _selected;
  // Médianes nationales récupérées une fois par jour
  ({DateTime jour, Map<TypeCarburant, double> medianes})? _medianes;
  Future<Map<TypeCarburant, double>>? _telechargementMedianes;
  bool _isLoading = false;
  String? _errorMessage;
  int _requestId = 0;
  bool _disposed = false;
  bool _triParPrix = false;

  List<AddressSuggestion> _suggestions = [];
  Coordonnees? _userPosition;
  Timer? _debounce;
  int _addressRequestId = 0;
  final _reinitialisationCarte = StreamController<void>.broadcast();

  Coordonnees? get position => _position;
  String? get positionLabel => _positionLabel;
  TypeCarburant get carburant => _carburant;
  TypeCarburant? get filtreCarte => _filtreCarte;
  List<Station> get stations => _stations;
  Station? get selectedStation => _selected;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasLocation => _position != null;
  bool get triParPrix => _triParPrix;
  List<AddressSuggestion> get suggestions => _suggestions;

  /// Émet quand la carte de l'accueil doit revenir à sa position d'origine
  Stream<void> get reinitialisationCarte => _reinitialisationCarte.stream;

  /// La carte peut afficher tous les carburants mais pas la liste
  TypeCarburant? get _carburantCharge => _surCarte ? _filtreCarte : _carburant;

  double? prixDe(Station station) {
    final carburant = _carburantCharge;
    if (carburant == null) return null;
    return station.prixPourCarburant(carburant);
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

  int? tempsTrajetMin(Station station) {
    final km = distanceKm(station);
    if (km == null) return null;
    return calculerTempsTrajetEnMinutes(km, 40);
  }

  /// Médiane du jour pour le carburant de la carte
  double? get medianeDuJour {
    final carburant = _filtreCarte;
    if (carburant == null) return null;
    return _medianes?.medianes[carburant];
  }

  /// Couleur selon l'écart à la médiane nationale ou null sans médiane
  PriceLevel? niveauPrix(Station station) {
    final carburant = _carburantCharge;
    if (carburant == null) return null;
    final prix = station.prixPourCarburant(carburant);
    final mediane = _medianes?.medianes[carburant];
    if (prix == null || mediane == null) return null;
    final ecart = (prix - mediane) / mediane;
    if (ecart <= -ecartMediane) return PriceLevel.bas;
    if (ecart >= ecartMediane) return PriceLevel.eleve;
    return PriceLevel.moyen;
  }

  Future<void> _chargerMedianes() async {
    final maintenant = DateTime.now();
    final aujourdhui = DateTime(
      maintenant.year,
      maintenant.month,
      maintenant.day,
    );
    if (_medianes?.jour == aujourdhui) return;
    try {
      final medianes = await (_telechargementMedianes ??= _repository
          .getMedianesNationales()
          .whenComplete(() => _telechargementMedianes = null));
      _medianes = (jour: aujourdhui, medianes: medianes);
      _notify();
    } on Object {
      // Pastilles grises jusqu'au prochain essai
    }
  }

  /// Position choisie avec la barre de recherche ou le bouton de localisation
  Future<void> selectLocation(String label, Coordonnees position) {
    _positionLabel = label;
    _position = position;
    return loadStations();
  }

  /// Récupère la position GPS de l'utilisateur pour proposer en premier
  /// les adresses proches de lui, ne fait rien sans permission
  Future<void> loadUserPosition() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final p = await Geolocator.getCurrentPosition();
      final userPosition = (latitude: p.latitude, longitude: p.longitude);
      _userPosition = userPosition;
      // Stations autour de l'utilisateur pour la carte de l'accueil sauf
      // s'il a déjà choisi une adresse pendant que le GPS cherchait
      if (_position == null) {
        await selectLocation('Autour de moi', userPosition);
      }
    } on Exception {
      // Sans GPS la recherche marche quand même mais sans priorité
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
    _surCarte = false;
    // On garde le carburant choisi sur la carte
    _carburant = _filtreCarte ?? _carburant;
    return selectLocation(
      s.label,
      (latitude: s.latitude, longitude: s.longitude),
    );
  }

  /// Au retour sur l'accueil après une recherche on revient autour de
  /// l'utilisateur comme à l'ouverture de l'app
  Future<void> reinitialiserPosition() async {
    _reinitialisationCarte.add(null);
    _surCarte = true;
    final userPosition = _userPosition;
    if (userPosition != null) {
      return selectLocation('Autour de moi', userPosition);
    }
    // Sans GPS on recharge la zone par défaut de la carte
    _position = null;
    _positionLabel = null;
    _selected = null;
    return loadStations();
  }

  /// Trie la liste par distance ou par prix si triParPrix vaut true
  Future<void> setTriParPrix({required bool triParPrix}) async {
    if (_triParPrix == triParPrix) return;
    _triParPrix = triParPrix;
    await loadStations();
  }

  /// Boutons de carburant de la page de liste
  Future<void> selectFuel(String bouton) async {
    final carburant = _carburantDepuisBouton(bouton);
    if (carburant == null) return;
    _carburant = carburant;
    await loadStations();
  }

  /// Boutons de carburant de la carte avec null pour Tous
  Future<void> selectFiltreCarte(String? bouton) async {
    _filtreCarte = bouton == null ? null : _carburantDepuisBouton(bouton);
    await loadStations();
  }

  /// Appelée quand la carte bouge ou zoome
  void zoneCarteChangee(ZoneCarte zone) {
    _zoneCarte = zone;
    if (!_surCarte) return;
    // On attend que la carte s'arrête
    _debounceZone?.cancel();
    _debounceZone = Timer(const Duration(milliseconds: 150), loadStations);
  }

  /// Ouvre la fiche de la pastille touchée ou la ferme avec null
  void selectStation(Station? station) {
    _selected = station;
    _notify();
  }

  /// Cherche les stations autour de la position pour le carburant choisi
  Future<void> loadStations() async {
    unawaited(_chargerMedianes());
    final position = _position;
    final zone = _zoneCarte;
    if (_surCarte && zone != null) return _loadStationsZone(zone);
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
        carburant: _carburantCharge,
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
      _applyResult(result);
    } on Object {
      // Object et pas Exception car une réponse mal formée lève une
      // TypeError et le chargement ne s'arrêterait jamais
      if (requestId != _requestId) return;
      _stations = [];
      _selected = null;
      _errorMessage = 'Impossible de charger les stations.';
    }

    _isLoading = false;
    _notify();
  }

  /// Stations de la zone visible de la carte
  Future<void> _loadStationsZone(ZoneCarte zone) async {
    final requestId = ++_requestId;
    _errorMessage = null;

    final toutes = _toutesLesStations;
    if (toutes != null) {
      // Déjà téléchargées donc affichées tout de suite même un peu anciennes
      _isLoading = false;
      _applyResult(_dansZone(toutes.stations, zone));
      _notify();
      if (DateTime.now().difference(toutes.chargeLe) < _dureeCache) return;
    } else {
      _isLoading = true;
      _notify();
      // On affiche les plus proches en attendant le téléchargement complet
      unawaited(_loadApercuZone(zone, requestId));
    }

    try {
      final stations = await (_telechargement ??= _repository
          .getToutesLesStations()
          .whenComplete(() => _telechargement = null));
      _toutesLesStations = (stations: stations, chargeLe: DateTime.now());
      if (requestId != _requestId) return;
      // La carte a pu bouger entre-temps
      _applyResult(_dansZone(stations, _zoneCarte ?? zone));
    } on Object {
      // On garde les pastilles affichées
      if (requestId != _requestId) return;
      if (toutes == null) _errorMessage = 'Impossible de charger les stations.';
    }

    _isLoading = false;
    _notify();
  }

  /// Stations proches du centre en attendant le téléchargement complet
  Future<void> _loadApercuZone(ZoneCarte zone, int requestId) async {
    try {
      final result = await _repository.getStationsDansZone(
        sud: zone.sud,
        ouest: zone.ouest,
        nord: zone.nord,
        est: zone.est,
        carburant: _carburantCharge,
      );
      // Trop tard si la carte a bougé ou si tout est arrivé
      if (requestId != _requestId || _toutesLesStations != null) return;
      _applyResult(result);
      _notify();
    } on Object {
      // Le téléchargement complet prendra le relais
    }
  }

  List<Station> _dansZone(List<Station> stations, ZoneCarte zone) {
    final carburant = _carburantCharge;
    return [
      for (final s in stations)
        if (s.latitude >= zone.sud &&
            s.latitude <= zone.nord &&
            s.longitude >= zone.ouest &&
            s.longitude <= zone.est &&
            (carburant == null || s.prixPourCarburant(carburant) != null))
          s,
    ];
  }

  /// Les [stationsMinimum] stations les plus proches sans limite de distance
  Future<List<Station>> _stationsLesPlusProches(Coordonnees position) async {
    final result = await _repository.getStationsProches(
      latitude: position.latitude,
      longitude: position.longitude,
      rayonKm: null,
      carburant: _carburantCharge,
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

  void _applyResult(List<Station> result) {
    // Avec Tous on garde aussi les stations sans prix
    _stations = _carburantCharge == null
        ? result
        : result.where((s) => prixDe(s) != null).toList();

    // La fiche reste ouverte si la station est encore là
    final selected = _selected;
    _selected = selected == null
        ? null
        : _stations.where((s) => s.id == selected.id).firstOrNull;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    _debounceZone?.cancel();
    unawaited(_reinitialisationCarte.close());
    super.dispose();
  }
}
