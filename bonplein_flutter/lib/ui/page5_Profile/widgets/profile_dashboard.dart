import 'package:bonplein_flutter/domain/models/utilisateur.dart';
import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:bonplein_flutter/ui/page5_Profile/widgets/profile_header.dart';
import 'package:bonplein_flutter/ui/page5_Profile/widgets/profile_menu_item.dart';
import 'package:bonplein_flutter/ui/page5_Profile/widgets/stat_card.dart';
import 'package:flutter/material.dart';

class ProfileDashboard extends StatelessWidget {
  const ProfileDashboard({
    super.key,
    required this.utilisateur,
    required this.onDeconnexion,
  });

  final Utilisateur utilisateur;
  final VoidCallback onDeconnexion;

  static const _bleu = Color(0xFF3B82F6);
  static const _violet = Color(0xFF8B5CF6);
  static const _rose = Color(0xFFEC4899);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.sm),
        children: [
          Text('Profil', style: AppTextStyle.titrePrincipal),
          const SizedBox(height: AppSpacing.md),

          ProfileHeader(
            nom: utilisateur.nom,
            membreDepuis: _formaterMembreDepuis(utilisateur.membreDepuis),
            badge:
            utilisateur.estContributeurActif ? 'Contributeur actif' : null,
          ),
          const SizedBox(height: AppSpacing.md),

          // Statistiques : 3 cartes de même largeur
          Row(
            children: [
              Expanded(
                child: StatCard(
                  valeur: '${utilisateur.signalements}',
                  label: 'Signalements',
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: StatCard(
                  valeur: '${utilisateur.kmEconomises.round()}',
                  label: 'Km économisés',
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: StatCard(
                  valeur: '${_formaterEuros(utilisateur.economies)}€',
                  label: 'Économisés',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Menu
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ProfileMenuItem(
                  icone: Icons.directions_car_outlined,
                  couleur: _bleu,
                  titre: 'Mon véhicule',
                  sousTitre: 'Renault Clio · SP95 · 6.8 L/100',
                  onTap: () {},
                ),
                const Divider(),
                ProfileMenuItem(
                  icone: Icons.notifications_none,
                  couleur: AppColors.orange,
                  titre: 'Préférences de notifications',
                  sousTitre: '3 alertes actives',
                  onTap: () {},
                ),
                const Divider(),
                ProfileMenuItem(
                  icone: Icons.shield_outlined,
                  couleur: _violet,
                  titre: 'Confidentialité',
                  sousTitre: 'Données et localisation',
                  onTap: () {},
                ),
                const Divider(),
                ProfileMenuItem(
                  icone: Icons.star_outline,
                  couleur: _rose,
                  titre: 'Contribuer à la communauté',
                  sousTitre: 'Signalements et avis',
                  onTap: () {},
                ),
                const Divider(),
                ProfileMenuItem(
                  icone: Icons.settings_outlined,
                  couleur: AppColors.neutral500,
                  titre: 'Paramètres',
                  sousTitre: 'Apparence, unités',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Déconnexion
          Material(
            color: AppColors.rouge.withValues(alpha: 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              side: BorderSide(color: AppColors.rouge.withValues(alpha: 0.2)),
            ),
            child: InkWell(
              onTap: onDeconnexion,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: AppColors.rouge, size: 20),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Se déconnecter',
                      style: AppTextStyle.bouton.copyWith(
                        color: AppColors.rouge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          Text(
            'BonPlein v2.4.1 · Données MAJ en temps réel',
            textAlign: TextAlign.center,
            style: AppTextStyle.metaPetite.copyWith(
              color: AppColors.neutral300,
            ),
          ),
        ],
      ),
    );
  }
}

String _formaterMembreDepuis(DateTime date) {
  const mois = [
    'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
    'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
  ];
  return 'Membre depuis ${mois[date.month - 1]} ${date.year}';
}

String _formaterEuros(double montant) =>
    montant.toStringAsFixed(2).replaceAll('.', ',');