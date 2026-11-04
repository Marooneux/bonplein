import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:bonplein_flutter/ui/page1/view_models/page1_view_model.dart';
import 'package:flutter/material.dart';

class LocationProblemMessage extends StatelessWidget {
  const LocationProblemMessage({
    required this.problem,
    required this.onRetry,
    required this.onOpenSettings,
    super.key,
  });

  final LocationProblem problem;
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final (title, message) = switch (problem) {
      LocationProblem.servicesDisabled => (
      'Localisation désactivée',
      'Activez la localisation de votre téléphone pour voir '
          'les stations autour de vous.',
      ),
      LocationProblem.denied => (
      'Localisation refusée',
      "Autorisez l'accès à votre position pour voir "
          'les stations autour de vous.',
      ),
      LocationProblem.deniedForever => (
      'Localisation bloquée',
      "L'accès à votre position est bloqué. Autorisez-le dans les "
          "réglages de l'application.",
      ),
      LocationProblem.unavailable => (
      'Position introuvable',
      'Impossible de trouver votre position. Réessayez, '
          'ou cherchez une adresse.',
      ),
    };

    // Dans ces deux cas, il faut aller dans les réglages du téléphone.
    final needsSettings = problem == LocationProblem.servicesDisabled ||
        problem == LocationProblem.deniedForever;
    // Quand l'accès est bloqué, redemander ne sert à rien.
    final canRetry = problem != LocationProblem.deniedForever;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_off_outlined,
                size: 48,
                color: AppColors.neutral300,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyle.titrePrincipal,
              ),
              const SizedBox(height: 4),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyle.body.copyWith(color: AppColors.neutral500),
              ),
              const SizedBox(height: AppSpacing.md),
              if (needsSettings)
                ElevatedButton(
                  onPressed: onOpenSettings,
                  child: const Text('Ouvrir les réglages'),
                ),
              if (canRetry && needsSettings)
                TextButton(
                  onPressed: onRetry,
                  child: const Text('Réessayer'),
                ),
              if (canRetry && !needsSettings)
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Réessayer'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}