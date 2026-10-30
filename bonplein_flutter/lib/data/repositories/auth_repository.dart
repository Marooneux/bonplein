import 'package:bonplein_flutter/domain/models/utilisateur.dart';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}

abstract class AuthRepository {
  Future<Utilisateur> connexion(String email, String motDePasse);
  Future<Utilisateur> inscription(
      String email,
      String motDePasse,
      String nom,
      String prenom,
      );
  Future<void> deconnexion();
}

/// Version factice pour tester l'interface, à remplacer par la vraie.
class FakeAuthRepository implements AuthRepository {
  @override
  Future<Utilisateur> connexion(String email, String motDePasse) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (motDePasse != 'password123') {
      throw const AuthException('E-mail ou mot de passe incorrect');
    }
    return Utilisateur(
      email: email,
      nom: 'Thomas Martin',
      membreDepuis: DateTime(2024, 3),
      signalements: 47,
      kmEconomises: 156,
      economies: 23.6,
      estContributeurActif: true,
    );
  }

  @override
  Future<Utilisateur> inscription(
      String email,
      String motDePasse,
      String nom,
      String prenom,
      ) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (email == 'deja@pris.com') {
      throw const AuthException('Cette adresse e-mail est déjà utilisée');
    }
    return Utilisateur(
      email: email,
      nom: '$prenom $nom',
      membreDepuis: DateTime.now(),
    );
  }

  @override
  Future<void> deconnexion() async {}
}