import 'dart:async';

import 'package:bonplein_flutter/data/repositories/station_service_repository.dart';
import 'package:bonplein_flutter/domain/models/coordonnees.dart';
import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:bonplein_flutter/domain/models/type_carburant.dart';
import 'package:bonplein_flutter/utils/math_utils.dart';
import 'package:flutter/foundation.dart';

typedef ZoneCarte = ({double sud, double ouest, double nord, double est});

enum PriceLevel { bas, moyen, eleve }

/// Stations, filtre et couleurs de la carte de l'accueil
class CarteViewModel extends ChangeNotifier {
  CarteViewModel({required StationServiceRepository repository})
    : _repository = repository;

  /// Durée avant de retélécharger les stations
  static const _dureeCache = Duration(minutes: 10);

  /// Écart à la médiane nationale pour passer au vert ou au rouge
  static const ecartMediane = 0.02;

  final StationServiceRepository _repository;

  Coordonnees? _positionUtilisateur;
  // null pour Tous
  TypeCarburant? _filtre;
  ZoneCarte? _zone;
  Timer? _debounceZone;
  // Toutes les stations de France
  ({List<Station> stations, DateTime chargeLe})? _toutesLesStations;
  Future<List<Station>>? _telechargement;
  // Médianes nationales récupérées une fois par jour
  ({DateTime jour, Map<TypeCarburant, double> medianes})? _medianes;
  Future<Map<TypeCarburant, double>>? _telechargementMedianes;
  List<Station> _stations = [];
  Station? _selected;
  int _requestId = 0;
  bool _disposed = false;
  final _reinitialisation = StreamController<void>.broadcast();

  Coordonnees? get positionUtilisateur => _positionUtilisateur;
  TypeCarburant? get filtre => _filtre;
  List<Station> get stations => _stations;
  Station? get selectedStation => _selected;

  /// Émet quand la carte doit revenir à sa position d'origine
  Stream<void> get reinitialisation => _reinitialisation.stream;

  set positionUtilisateur(Coordonnees? position) {
    _positionUtilisateur = position;
    _notify();
  }

  /// Médiane du jour pour le carburant choisi
  double? get medianeDuJour {
    final carburant = _filtre;
    if (carburant == null) return null;
    return _medianes?.medianes[carburant];
  }

  double? prixDe(Station station) {
    final carburant = _filtre;
    if (carburant == null) return null;
    return station.prixPourCarburant(carburant);
  }

  double? distanceKm(Station station) {
    final depart = _positionUtilisateur;
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

  /// Couleur selon l'écart à la médiane nationale ou null sans médiane
  PriceLevel? niveauPrix(Station station) {
    final prix = prixDe(station);
    final mediane = medianeDuJour;
    if (prix == null || mediane == null) return null;
    final ecart = (prix - mediane) / mediane;
    if (ecart <= -ecartMediane) return PriceLevel.bas;
    if (ecart >= ecartMediane) return PriceLevel.eleve;
    return PriceLevel.moyen;
  }

  /// Couleur de la station la moins chère du groupe
  PriceLevel? niveauMoinsChere(List<Station> groupe) {
    Station? moinsChere;
    double? prixMin;
    for (final s in groupe) {
      final prix = prixDe(s);
      if (prix != null && (prixMin == null || prix < prixMin)) {
        prixMin = prix;
        moinsChere = s;
      }
    }
    return moinsChere == null ? null : niveauPrix(moinsChere);
  }

  /// Boutons de carburant avec null pour Tous
  Future<void> selectFiltre(String? bouton) {
    _filtre = bouton == null ? null : TypeCarburant.depuisBouton(bouton);
    return _charger();
  }

  /// Appelée quand la carte bouge ou zoome
  void zoneChangee(ZoneCarte zone) {
    _zone = zone;
    // On attend que la carte s'arrête
    _debounceZone?.cancel();
    _debounceZone = Timer(const Duration(milliseconds: 150), _charger);
  }

  /// Ouvre la fiche de la pastille touchée ou la ferme avec null
  void selectStation(Station? station) {
    _selected = station;
    _notify();
  }

  /// Retour sur l'accueil après une recherche
  Future<void> reinitialiser() {
    _selected = null;
    _reinitialisation.add(null);
    return _charger();
  }

  /// Stations de la zone visible
  Future<void> _charger() async {
    unawaited(_chargerMedianes());
    final zone = _zone;
    if (zone == null) return;
    final requestId = ++_requestId;

    final toutes = _toutesLesStations;
    if (toutes != null) {
      // Déjà téléchargées donc affichées tout de suite même un peu anciennes
      _applyResult(_dansZone(toutes.stations, zone));
      _notify();
      if (DateTime.now().difference(toutes.chargeLe) < _dureeCache) return;
    } else {
      // On affiche les plus proches en attendant le téléchargement complet
      unawaited(_chargerApercu(zone, requestId));
    }

    try {
      final stations = await (_telechargement ??= _repository
          .getToutesLesStations()
          .whenComplete(() => _telechargement = null));
      _toutesLesStations = (stations: stations, chargeLe: DateTime.now());
      if (requestId != _requestId) return;
      // La carte a pu bouger entre-temps
      _applyResult(_dansZone(stations, _zone ?? zone));
      _notify();
    } on Object {
      // On garde les pastilles affichées
    }
  }

  /// Stations proches du centre en attendant le téléchargement complet
  Future<void> _chargerApercu(ZoneCarte zone, int requestId) async {
    try {
      final result = await _repository.getStationsDansZone(
        sud: zone.sud,
        ouest: zone.ouest,
        nord: zone.nord,
        est: zone.est,
        carburant: _filtre,
      );
      // Trop tard si la carte a bougé ou si tout est arrivé
      if (requestId != _requestId || _toutesLesStations != null) return;
      _applyResult(result);
      _notify();
    } on Object {
      // Le téléchargement complet prendra le relais
    }
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

  List<Station> _dansZone(List<Station> stations, ZoneCarte zone) {
    final carburant = _filtre;
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

  void _applyResult(List<Station> result) {
    // Avec Tous on garde aussi les stations sans prix
    _stations = _filtre == null
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
    _debounceZone?.cancel();
    unawaited(_reinitialisation.close());
    super.dispose();
  }
}
