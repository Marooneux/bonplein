
import 'package:flutter/material.dart';
import 'widgets/widget_prix_carburants.dart';
import 'widgets/widget_nom_station.dart';
import 'widgets/widget_distance_trajet.dart';

// Page qui affiche les informations d'une station
// but de la page
// quand on clique sur un parking on veut ses infos
// pour le sprint 1 pour l'instant on veut surtout ses diff carburants et les prix
// et possiblement une zone qui calcule la distance
// je n'ai pas accès aux données donc je vais faire la page


// page statique, mais toutes ces variables changeront
// nom et adresse changeront selon ce qu'on récupèrera

// distance et trajet en voiture sera selon l'adresse que le client aura rentré

// et les carburants affichés changeront selon leur disponibilité ou non


class PageInfoStation extends StatefulWidget {

  //final Station station                             //la station sélectionnée préalablement, dépend de comment on récup l'API
  const PageInfoStation({super.key,});    // + required this.station

  @override
  State<PageInfoStation> createState() => _PageInfoStationState();
  
}

class _PageInfoStationState extends State<PageInfoStation>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text('Détail station'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? buildPortrait()
              : buildLandscape();
        },

      ),
    );
  }


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




  Widget buildLandscape() => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Partie gauche : fixe
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom et adresse
              buildNomParking(),

              const SizedBox(height: 24),

              // Distance et temps de trajet
              buildDistanceTrajet(),
            ],
          ),
        ),

        const SizedBox(width: 24),

        // Partie droite : les prix défilent
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
