import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.nom,
    required this.membreDepuis,
    this.badge,
  });

  final String nom;
  final String membreDepuis;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.vert, Color(0xFF16A34A)],
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: const Icon(
            Icons.person_outline,
            color: AppColors.blanc,
            size: 32,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nom,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.titrePrincipal.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 2),
              Text(
                membreDepuis,
                style: AppTextStyle.texteSecondaire.copyWith(fontSize: 14),
              ),
              if (badge != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.vert.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '✦ $badge',
                    style: AppTextStyle.label.copyWith(
                      fontSize: 12,
                      letterSpacing: 0,
                      color: AppColors.vert,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}