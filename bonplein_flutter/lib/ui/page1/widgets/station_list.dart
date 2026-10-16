import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:bonplein_flutter/ui/page1/view_models/page1_view_model.dart';
import 'package:bonplein_flutter/ui/page1/widgets/station_card.dart';
import 'package:bonplein_flutter/ui/page_info_station/page_info_station.dart';
import 'package:flutter/material.dart';

class StationList extends StatelessWidget {
  const StationList({
    required this.stations,
    required this.viewModel,
    super.key,
    this.emptyMessage = 'Essayez une autre adresse.',
  });
  final List<Station> stations;
  final Page1ViewModel viewModel;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_gas_station,
                size: 48,
                color: AppColors.neutral300,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Aucune station disponible',
                style: AppTextStyle.titrePrincipal,
              ),
              const SizedBox(height: 4),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: AppTextStyle.body.copyWith(color: AppColors.neutral500),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final s = stations[index];
        return StationCard(
          ville: s.ville,
          adresse: s.adresse,
          prix: viewModel.prixDe(s)!,
          distance: viewModel.distanceKm(s)!,
          temps: viewModel.tempsTrajetMin(s)!,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PageInfoStation(
                station: s,
                distanceKm: viewModel.distanceKm(s),
                tempsMin: viewModel.tempsTrajetMin(s),
              ),
            ),
          ),
        );
      },
    );
  }
}