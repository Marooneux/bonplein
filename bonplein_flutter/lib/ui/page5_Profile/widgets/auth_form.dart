import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/page5_Profile/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.inscription,
    required this.chargement,
    required this.validerEmail,
    required this.validerMotDePasse,
    required this.onSubmit,
  });

  /// true = création de compte (nom, prénom, confirmation), false = connexion
  final bool inscription;

  /// true pendant l'appel au backend : bouton désactivé + spinner
  final bool chargement;

  final String? Function(String?) validerEmail;
  final String? Function(String?) validerMotDePasse;
  final void Function(
      String email,
      String motDePasse,
      String nom,
      String prenom,
      ) onSubmit;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _motDePasseController = TextEditingController();
  final _confirmationController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _motDePasseController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  String? _validerObligatoire(String? value) {
    if (value == null || value.trim().isEmpty) return 'Champ obligatoire';
    return null;
  }

  String? _validerConfirmation(String? value) {
    if (value != _motDePasseController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  void _envoyer() {
    if (widget.chargement) return;
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      _emailController.text.trim(),
      _motDePasseController.text,
      _nomController.text.trim(),
      _prenomController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.inscription) ...[
            AuthTextField(
              controller: _prenomController,
              label: 'Prénom',
              hint: 'Jean',
              icon: Icons.person_outline,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.givenName],
              validator: _validerObligatoire,
            ),
            const SizedBox(height: AppSpacing.sm),
            AuthTextField(
              controller: _nomController,
              label: 'Nom',
              hint: 'Dupont',
              icon: Icons.person_outline,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.familyName],
              validator: _validerObligatoire,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          AuthTextField(
            controller: _emailController,
            label: 'E-mail',
            hint: 'exemple@mail.com',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            validator: widget.validerEmail,
          ),
          const SizedBox(height: AppSpacing.sm),
          AuthTextField(
            controller: _motDePasseController,
            label: 'Mot de passe',
            hint: widget.inscription
                ? '8 caractères minimum'
                : 'Votre mot de passe',
            icon: Icons.lock_outline,
            motDePasse: true,
            textInputAction: widget.inscription
                ? TextInputAction.next
                : TextInputAction.done,
            autofillHints: [
              widget.inscription
                  ? AutofillHints.newPassword
                  : AutofillHints.password,
            ],
            validator: widget.validerMotDePasse,
            onFieldSubmitted: widget.inscription ? null : (_) => _envoyer(),
          ),
          if (widget.inscription) ...[
            const SizedBox(height: AppSpacing.sm),
            AuthTextField(
              controller: _confirmationController,
              label: 'Confirmer le mot de passe',
              hint: 'Répétez le mot de passe',
              icon: Icons.lock_outline,
              motDePasse: true,
              textInputAction: TextInputAction.done,
              validator: _validerConfirmation,
              onFieldSubmitted: (_) => _envoyer(),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: widget.chargement ? null : _envoyer,
            child: widget.chargement
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
                : Text(
              widget.inscription ? 'Créer mon compte' : 'Se connecter',
            ),
          ),
        ],
      ),
    );
  }
}