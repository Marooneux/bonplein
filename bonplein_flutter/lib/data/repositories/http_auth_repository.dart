import 'dart:convert';

import 'package:bonplein_flutter/data/repositories/auth_repository.dart';
import 'package:bonplein_flutter/domain/models/utilisateur.dart';
import 'package:http/http.dart' as http;

/// Vraie version du repository : parle à l'API PHP sur alwaysdata
class HttpAuthRepository implements AuthRepository {
  // Adresse de l'API (dossier bonplein_api sur le serveur)
  static const _base = 'https://bonplein.alwaysdata.net/bonplein_api';

  // Envoie une requête POST à une page PHP et renvoie l'utilisateur reçu
  Future<Utilisateur> _post(String page, Map<String, String> corps) async {
    // 1. Envoi de la requête (10 secondes maximum)
    final http.Response reponse;
    try {
      reponse = await http
          .post(
        Uri.parse('$_base/$page'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(corps), // les données en JSON
      )
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      // Pas de réseau, serveur éteint, délai dépassé...
      throw const AuthException('Serveur injoignable, réessayez.');
    }

    // 2. Lecture de la réponse JSON
    final Map<String, dynamic> data;
    try {
      data = jsonDecode(reponse.body) as Map<String, dynamic>;
    } catch (_) {
      // Le serveur a renvoyé autre chose que du JSON (page d'erreur HTML par exemple)
      throw const AuthException('Réponse invalide du serveur.');
    }

    // 3. Code 2xx = succès : on construit l'Utilisateur
    if (reponse.statusCode >= 200 && reponse.statusCode < 300) {
      return Utilisateur.fromJson(data);
    }
    // Sinon, on affiche le message d'erreur envoyé par l'API
    throw AuthException(data['message'] as String? ?? 'Erreur inconnue');
  }

  // Connexion : appelle connexion.php
  @override
  Future<Utilisateur> connexion(String email, String motDePasse) =>
      _post('connexion.php', {'email': email, 'mot_de_passe': motDePasse});

  // Inscription : appelle inscription.php
  @override
  Future<Utilisateur> inscription(
      String email,
      String motDePasse,
      String nom,
      String prenom,
      ) =>
      _post('inscription.php', {
        'email': email,
        'mot_de_passe': motDePasse,
        'nom': nom,
        'prenom': prenom,
      });

  // Pas de session côté serveur pour l'instant : rien à faire
  @override
  Future<void> deconnexion() async {}
}