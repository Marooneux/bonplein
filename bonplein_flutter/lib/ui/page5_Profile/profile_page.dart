import 'package:bonplein_flutter/data/repositories/http_auth_repository.dart';
import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:bonplein_flutter/ui/page5_Profile/view_models/profile_view_model.dart';
import 'package:bonplein_flutter/ui/page5_Profile/widgets/auth_form.dart';
import 'package:bonplein_flutter/ui/page5_Profile/widgets/profile_dashboard.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Le ViewModel gère l'état (connecté ou non, chargement, erreur).
  // Il utilise HttpAuthRepository, donc la vraie base de données.
  final _viewModel = ProfileViewModel(authRepository: HttpAuthRepository());

  // Libère le ViewModel quand la page est détruite
  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ListenableBuilder redessine la page à chaque changement du ViewModel
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          final utilisateur = _viewModel.utilisateur;

          // Utilisateur connecté : on affiche son profil
          if (utilisateur != null) {
            return ProfileDashboard(
              utilisateur: utilisateur,
              onDeconnexion: _viewModel.deconnecter,
            );
          }

          // Sinon : formulaire de connexion / inscription, centré et défilable
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: _buildFormulaire(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Le formulaire avec son titre, le message d'erreur et le bouton de bascule
  Widget _buildFormulaire() {
    final inscription = _viewModel.inscription; // true = créer un compte

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Titre qui change selon le mode
        Text(
          inscription ? 'Créer un compte' : 'Connexion',
          style: AppTextStyle.titreSection,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          inscription
              ? 'Enregistrez vos stations favorites et vos alertes.'
              : 'Content de vous revoir !',
          style: AppTextStyle.texteSecondaire,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Bandeau rouge, affiché seulement s'il y a une erreur
        if (_viewModel.erreur != null) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.rouge.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              _viewModel.erreur!,
              style: AppTextStyle.texteSecondaire.copyWith(
                color: AppColors.rouge,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],

        // Le formulaire. La key le recrée (champs vidés) à chaque changement de mode
        AuthForm(
          key: ValueKey(inscription),
          inscription: inscription,
          chargement: _viewModel.chargement,
          validerEmail: _viewModel.validerEmail,
          validerMotDePasse: _viewModel.validerMotDePasse,
          onSubmit: _viewModel.soumettre,
        ),
        const SizedBox(height: AppSpacing.sm),

        // Bouton pour passer de « connexion » à « inscription » et inversement
        TextButton(
          onPressed: _viewModel.basculerMode,
          child: Text(
            inscription
                ? 'Déjà un compte ? Se connecter'
                : "Pas de compte ? S'inscrire",
            style: AppTextStyle.bouton.copyWith(color: AppColors.vert),
          ),
        ),
      ],
    );
  }
}