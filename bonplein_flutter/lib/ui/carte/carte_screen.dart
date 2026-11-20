import 'dart:async';

import 'package:bonplein_flutter/data/repositories/station_service_repository.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/widgets/widget_filtres_carburant.dart';
import 'package:bonplein_flutter/ui/carte/view_models/carte_view_model.dart';
import 'package:bonplein_flutter/ui/carte/widgets/map.dart';
import 'package:flutter/material.dart';
import 'package:bonplein_flutter/ui/core/widgets/app_search_bar.dart';

class CarteScreen extends StatefulWidget {
  const CarteScreen({super.key});

  @override
  State<CarteScreen> createState() => _CarteScreenState();
}

class _CarteScreenState extends State<CarteScreen> {
  late final Page1ViewModel _viewModel = Page1ViewModel(
    repository: StationServiceRepository(),
  );

  @override
  void initState() {
    super.initState();
    unawaited(_viewModel.loadUserPosition());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xs),
          AppSearchBar(
            hintText: 'Chercher une station',
            onChanged: _viewModel.searchAddress,
            suggestionsListenable: _viewModel,
            suggestionsProvider: () =>
                _viewModel.suggestions.map((s) => s.label).toList(),
            onSuggestionSelected: (i) =>
                _viewModel.selectSuggestion(_viewModel.suggestions[i]),
          ),
          const FuelFilterWidget(),
          const SizedBox(height: AppSpacing.xs),
          const Expanded(child: MapWidget()),
        ],
      ),
    );
  }
}
