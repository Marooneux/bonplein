/// Représente un utilisateur de l'application (les données de son profil).
class Utilisateur {
  // Constructeur normal : crée un Utilisateur à partir de valeurs déjà prêtes.
  // "const" = l'objet ne changera jamais après sa création.
  const Utilisateur({
    required this.email,          // obligatoire
    required this.nom,            // obligatoire
    required this.membreDepuis,   // obligatoire
    this.signalements = 0,        // facultatif, 0 par défaut
    this.kmEconomises = 0,
    this.economies = 0,
    this.estContributeurActif = false,
  });

  // Les champs de l'utilisateur ("final" = non modifiables)
  final String email;
  final String nom;                // ex. "Jean Dupont"
  final DateTime membreDepuis;     // date d'inscription
  final int signalements;          // nombre de signalements faits
  final double kmEconomises;
  final double economies;          // en euros
  final bool estContributeurActif; // true = affiche le badge "Contributeur actif"

  // Constructeur "factory" : fabrique un Utilisateur à partir du JSON
  // reçu de l'API PHP (un Map : clé -> valeur).
  // Utilisation : Utilisateur.fromJson(data)
  // "fromJson" n'a rien de spécial, c'est juste un nom de convention.
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      // "as String" : on dit à Dart que cette valeur est un texte
      email: json['email'] as String,
      nom: json['nom'] as String,

      // L'API envoie la date en texte ("2026-10-30 08:24:20"),
      // DateTime.parse la transforme en vrai DateTime
      membreDepuis: DateTime.parse(json['membre_depuis'] as String),

      signalements: json['signalements'] as int,

      // Le JSON peut donner 156 (entier) ou 156.5 (décimal) :
      // on lit un "num" (nombre quelconque) puis on convertit en double
      kmEconomises: (json['km_economises'] as num).toDouble(),
      economies: (json['economies'] as num).toDouble(),

      estContributeurActif: json['est_contributeur_actif'] as bool,
    );
  }
}