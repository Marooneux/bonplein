import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.icone,
    required this.couleur,
    required this.titre,
    required this.sousTitre,
    this.onTap,
  });

  final IconData icone;
  final Color couleur;
  final String titre;
  final String sousTitre;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 14,
        ),
        child: Row(
          children: [
            // Pastille colorée avec l'icône
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: couleur.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icone, color: couleur, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),

            // Titre + sous-titre
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titre,
                    style: AppTextStyle.titreCarte.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(sousTitre, style: AppTextStyle.texteSecondaire),
                ],
              ),
            ),

            // Flèche à droite
            const Icon(Icons.chevron_right, color: AppColors.neutral300),
          ],
        ),
      ),
    );
  }
}