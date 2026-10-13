import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import '../../core/themes/app_spacing.dart';
import 'station_card.dart';

class StationList extends StatelessWidget{
  final List<StationCard> stations;
  const StationList({super.key, required this.stations});

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) {
      return Center(
        child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_gas_station, size: 48, color: AppColors.slate300),
              const SizedBox(height: AppSpacing.sm),
              Text('Aucune station disponible', style: AppTextStyle.titrePrincipal),
              const SizedBox(height: 4),
              Text('Essayez une autre adresse.',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.body.copyWith(color: AppColors.slate500)),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      itemCount: stations.length,
      itemBuilder: (context, index) => stations[index],
    );
  }

}