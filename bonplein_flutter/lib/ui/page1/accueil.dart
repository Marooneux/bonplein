import 'dart:async';

import 'package:bonplein_flutter/data/repositories/station_service_repository.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/widgets/widget_filtres_carburant.dart';
import 'package:bonplein_flutter/ui/page1/view_models/carte_view_model.dart';
import 'package:bonplein_flutter/ui/page1/view_models/page1_view_model.dart';
import 'package:bonplein_flutter/ui/page1/widgets/map.dart';
import 'package:bonplein_flutter/ui/page1/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final _repository = StationServiceRepository();
  late final _viewModel = Page1ViewModel(repository: _repository);
  late final _carte = CarteViewModel(repository: _repository);

  @override
  void initState() {
    super.initState();
    unawaited(_chargerPosition());
  }

  Future<void> _chargerPosition() async {
    final position = await _viewModel.loadUserPosition();
    if (mounted) _carte.positionUtilisateur = position;
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _carte.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xs),
          SearchBarWidget(
            viewModel: _viewModel,
            hintText: 'Rechercher une adresse',
            onRetour: () => unawaited(_carte.reinitialiser()),
          ),
          FuelFilterWidget(
            onFuelSelected: (bouton) {
              unawaited(_carte.selectFiltre(bouton));
              // La liste s'ouvrira avec le carburant choisi sur la carte
              if (bouton != null) unawaited(_viewModel.selectFuel(bouton));
            },
          ),
          const SizedBox(height: AppSpacing.xs),
          Expanded(child: MapWidget(viewModel: _carte)),
        ],
      ),
    );
  }
}
