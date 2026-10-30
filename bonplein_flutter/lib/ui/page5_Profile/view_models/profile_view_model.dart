import 'package:bonplein_flutter/data/repositories/auth_repository.dart';
import 'package:bonplein_flutter/domain/models/utilisateur.dart';
import 'package:flutter/foundation.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  bool _inscription = false;
  bool _chargement = false;
  String? _erreur;
  Utilisateur? _utilisateur;

  /// true = création de compte, false = connexion
  bool get inscription => _inscription;
  bool get chargement => _chargement;
  String? get erreur => _erreur;
  Utilisateur? get utilisateur => _utilisateur;
  bool get estConnecte => _utilisateur != null;

  void basculerMode() {
    _inscription = !_inscription;
    _erreur = null;
    notifyListeners();
  }

  Future<void> soumettre(
      String email,
      String motDePasse,
      String nom,
      String prenom,
      ) async {
    if (_chargement) return;

    _chargement = true;
    _erreur = null;
    notifyListeners();

    try {
      _utilisateur = _inscription
          ? await _authRepository.inscription(email, motDePasse, nom, prenom)
          : await _authRepository.connexion(email, motDePasse);
    } on AuthException catch (e) {
      _erreur = e.message;
    } catch (_) {
      _erreur = 'Une erreur est survenue, réessayez.';
    } finally {
      _chargement = false;
      notifyListeners();
    }
  }

  Future<void> deconnecter() async {
    await _authRepository.deconnexion();
    _utilisateur = null;
    _erreur = null;
    notifyListeners();
  }

  // Validation : logique pure, facile à tester sans widgets.

  String? validerEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Entrez votre adresse e-mail';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Adresse e-mail invalide';
    }
    return null;
  }

  String? validerMotDePasse(String? value) {
    if (value == null || value.isEmpty) return 'Entrez un mot de passe';
    if (_inscription && value.length < 8) return '8 caractères minimum';
    return null;
  }
}