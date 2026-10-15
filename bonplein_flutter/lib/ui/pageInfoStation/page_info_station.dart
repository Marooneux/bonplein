
import 'package:flutter/material.dart';
import 'widgets/widget_prix_carburants.dart';
import 'widgets/widget_nom_station.dart';
import 'widgets/widget_distance_trajet.dart';

// ============================================================
// PAGE : Informations détaillées d'une station
// ============================================================
// Cette page affiche les informations de la station sélectionnée.
// Pour le sprint 1, elle présente principalement :
// - Le nom et l'adresse de la station
// - Les carburants disponibles et leurs prix
// - La distance et le temps de trajet depuis l'adresse du client
//
// Pour le moment, les données sont statiques.
// Elles seront ensuite remplacées par les données récupérées
// depuis l'API.
//
// Les informations affichées dépendront donc de la station
// sélectionnée, des carburants disponibles et de l'adresse du client.
// ============================================================

class PageInfoStation extends StatefulWidget {

  // TODO : récupérer la station sélectionnée depuis la page précédente.
  // Exemple : final Station station;
  // La station sera transmise au constructeur avec un paramètre requis.

  const PageInfoStation({super.key,});

  @override
  State<PageInfoStation> createState() => _PageInfoStationState();

}

class _PageInfoStationState extends State<PageInfoStation>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Barre supérieure de la page avec le titre et le bouton retour.
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text('Détail station'),

        // Permet de revenir à la page précédente.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),


      // Adapte la disposition des informations à l'orientation
      // de l'écran : portrait ou paysage.
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? buildPortrait()
              : buildLandscape();
        },

      ),
    );
  }

// ============================================================
// AFFICHAGE EN PORTRAIT
// ============================================================
// Les informations sont disposées verticalement.
// L'utilisateur peut faire défiler la page pour consulter
// toutes les informations de la station.
// ============================================================

  Widget buildPortrait() => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Section 1 : Nom et adresse de la station
        buildNomParking(),
        const SizedBox(height: 24),

        // Section 2 : Distance et temps de trajet
        buildDistanceTrajet(),
        const SizedBox(height: 24),

        // Section 3 : Prix des carburants
        buildPrixCarburants()
      ],
    ),
  );

// ============================================================
// AFFICHAGE EN PAYSAGE
// ============================================================
// Les informations sont réparties sur deux colonnes :
// - À gauche : nom, adresse, distance et temps de trajet.
// - À droite : prix des carburants, avec défilement vertical.
// Cette disposition utilise davantage la largeur disponible.
// ============================================================


  Widget buildLandscape() => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Colonne de gauche : informations générales de la station.
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom et adresse
              buildNomParking(),

              const SizedBox(height: 24),

              // Distance et temps de trajet en voiture.
              buildDistanceTrajet(),
            ],
          ),
        ),

        const SizedBox(width: 24),

        // Colonne de droite : prix des carburants.
        // Le contenu peut défiler verticalement si nécessaire.
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: buildPrixCarburants(),
          ),
        ),
      ],
    ),
  );

}
