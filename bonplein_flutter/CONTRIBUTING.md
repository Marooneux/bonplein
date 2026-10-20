# Guide développeur

L'objectif de cette application mobile est d'aider les automobilistes à trouver les meilleures
stations les moins chères. Ce document décrit les différentes parties du code et les procédures
mises en œuvre pour maintenir et continuer le développement de l'application.

## Prérequis

Flutter doit être installé sur son ordinateur. Si ce n'est pas fait, voir le guide d'installation
officiel :
https://docs.flutter.dev/install/quick

```bash
flutter pub get
dart run build_runner build
flutter run # compiler et lancer l'app
```

> [!WARNING]
> Les fichiers `*.g.dart` et `*.freezed.dart` sont **générés** par `build_runner` et doivent être
recompilés après tout changement.

## Architecture

```
lib/
├── data/
│   ├── api_models/          # Modèles représentant les données dans l'API
│   ├── repositories/        # Source unique de vérité : l'application prend les données d'ici
│   └── services/api/        # APIs et services utilisées pour fournir les donnéees 
├── domain/
│   └── models/              # Modèles représentant les données dans l'application
├── ui/
│   ├── core/                # Thème et widgets réutilisables (localisation dans le futur)
│   ├── page1/               # Page principale (Page1ViewModel + widgets)
│   └── ...                  # Autres pages de l'app
└── utils/                   # Fonctions (calcul de distance, temps de trajet, etc...)
```

**Flux de données** :

1. `services/` : données externes récupérées depuis des APIs
2. `data/repositories/` : données mises à disposition
3. `ui/<page>/viewmodels/` : Gestion de l'état des données
4. `ui/<page>/widgets/` : Données affichées dans les widgets, avec un widget servant de page

### Couche data

Le dossier `data/services/` contient le code pour envoyer les requêtes aux APIs et recevoir les
réponses. La réponse de l'API est mise sous forme de modèle dans `data/api_models/`. Le seul endroit
que le reste de l'application utilise pour obtenir des données sont les repositories, situées dans
`data/repositories/`. Ainsi, l'interface ne change pas si l'API change. De plus, il devient facile
de faire des tests isolés en créant de fausses repositories.

### Modèles API et domaine

Le modèle API copie les objets JSON renvoyés par l'API et reste dans `data/`. Le modèle domaine
décrit les données utiles à l'application et contient la logique métier. La traduction de l'un à
l'autre se fait dans la repository : un renommage côté API ne casse pas les widgets.

### Pattern MVVM

La Vue affiche l'état et déclenche les actions de l'utilisateur. Le Vue-Modèle garde l'état et
appelle la repository. Le Modèle désigne le domaine et la repository. Ainsi, l'application se divise
en plusieurs parties maintenables : les données, le fonctionnement, les widgets et la gestion des
états.

## Code généré

Régénérer les fichiers `*.g.dart` et `*.freezed.dart` après changement

```bash
dart run build_runner build
```

## Linter

Le projet utilise `very_good_analysis`. Avant tout commit, si ce n'est pas déjà fait :

```bash
flutter analyze
dart fix --apply # corrige automatiquement les avertissements
```

## Tests

Les tests sont dans `test/` avec le même découpage que `lib/`. Pour exécuter la suite de tests :

```bash
flutter test
```

Tout nouveau ViewModel ou Repository doit avoir des tests unitaires. Utiliser mocktail pour isoler
les tests et ne pas avoir à dépendre de la connexion aux API.

## APIs

| API                                                                                                                                                                        | Usage                             |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| [data.economie.gouv.fr - prix-des-carburants-en-france-flux-instantane-v2](https://data.economie.gouv.fr/explore/assets/prix-des-carburants-en-france-flux-instantane-v2/) | Prix des carburants en temps réel |
| [data.geopf.fr/geocodage/search](https://data.geopf.fr/geocodage/search)                                                                                                   | Autocomplétion d'adresses         |
