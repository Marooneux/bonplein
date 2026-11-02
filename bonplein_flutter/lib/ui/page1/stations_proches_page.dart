import 'dart:async';

import 'package:bonplein_flutter/domain/models/type_carburant.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/widgets/widget_filtres_carburant.dart';
import 'package:bonplein_flutter/ui/page1/view_models/page1_view_model.dart';
import 'package:bonplein_flutter/ui/page1/widgets/station_list.dart';
import 'package:bonplein_flutter/ui/page2/widgets/station_sort_bar.dart';
import 'package:flutter/material.dart';

/// Liste des stations les plus proches de l'adresse choisie dans la barre de
/// recherche. Les stations sont chargées par [Page1ViewModel.selectSuggestion].
class StationsProchesPage extends StatelessWidget {
  const StationsProchesPage({required this.viewModel, super.key});

  final Page1ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: Text(viewModel.positionLabel ?? 'Stations')),
          body: Column(
            children: [
              const SizedBox(height: AppSpacing.xs),
              FuelFilterWidget(
                carburantInitial: _boutonDe(viewModel.carburant),
                // Une carte n'affiche qu'un prix : il faut un carburant précis.
                afficherTous: false,
                onFuelSelected: (bouton) {
                  if (bouton != null) unawaited(viewModel.selectFuel(bouton));
                },
              ),
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StationSortBar(
                  triParPrix: viewModel.triParPrix,
                  onTriChanged: (v) =>
                      unawaited(viewModel.setTriParPrix(triParPrix: v)),
                  carburant: viewModel.carburant,
                  // Le carburant se choisit déjà avec les boutons au-dessus.
                  carburants: const [],
                  onCarburantChanged: (_) {},
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Expanded(child: _buildBody()),
            ],
          ),
        );
      },
    );
  }

  /// Libellé du bouton de [FuelFilterWidget] pour ce carburant.
  static String _boutonDe(TypeCarburant carburant) {
    return switch (carburant) {
      TypeCarburant.e10 => 'SP95-E10',
      TypeCarburant.gplc => 'GPL-c',
      _ => carburant.nom,
    };
  }

  Widget _buildBody() {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final erreur = viewModel.errorMessage;
    if (erreur != null) {
      return Center(child: Text(erreur));
    }
    return StationList(stations: viewModel.stations, viewModel: viewModel);
  }
}
