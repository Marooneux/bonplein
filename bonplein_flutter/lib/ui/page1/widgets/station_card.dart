import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:flutter/material.dart';

class StationCard extends StatelessWidget {

  const StationCard({
    required this.ville, required this.adresse, required this.prix, required this.distance, required this.temps, super.key,
    this.onTap,
  });
  final String ville;
  final String adresse;
  final double prix;
  final double distance;
  final int temps;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      adresse,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.titreCarte,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ville,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.texteSecondaire,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${distance.toStringAsFixed(1).replaceAll('.', ',')} km · $temps min',
                      style: AppTextStyle.metaPetite,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    prix.toStringAsFixed(3).replaceAll('.', ','),
                    style: AppTextStyle.prixCarte.copyWith(
                      color: AppColors.vert,
                    ),
                  ),
                  Text('€/L', style: AppTextStyle.metaPetite),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}