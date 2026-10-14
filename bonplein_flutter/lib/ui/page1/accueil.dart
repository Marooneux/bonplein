import 'package:flutter/material.dart';
import 'package:bonplein_flutter/ui/page1/widgets/map.dart';
import 'package:bonplein_flutter/ui/page1/widgets/search_bar.dart';
import 'package:bonplein_flutter/ui/core/widgets/widget_filtres_carburant.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';

class Accueil extends StatelessWidget {
  const Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          SizedBox(height: AppSpacing.xs),
          SearchBarWidget(hintText: 'Rechercher une station'),
          FuelFilterWidget(),
          SizedBox(height: AppSpacing.xs),
          Expanded(child: MapWidget()),
        ],
      ),
    );
  }
}
