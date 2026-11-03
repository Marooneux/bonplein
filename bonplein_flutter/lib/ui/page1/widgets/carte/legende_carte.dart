import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:bonplein_flutter/ui/page1/view_models/carte_view_model.dart';
import 'package:bonplein_flutter/ui/page1/widgets/carte/boutons_carte.dart';
import 'package:bonplein_flutter/ui/page1/widgets/carte/marqueurs_carte.dart';
import 'package:bonplein_flutter/utils/format_utils.dart';
import 'package:flutter/material.dart';

/// Ouvre la légende et laisse la mention OpenStreetMap visible
class BoutonInfo extends StatefulWidget {
  const BoutonInfo({required this.avecPrix, required this.mediane, super.key});

  final bool avecPrix;
  final double? mediane;

  @override
  State<BoutonInfo> createState() => _BoutonInfoState();
}

class _BoutonInfoState extends State<BoutonInfo> {
  bool _ouvert = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_ouvert) ...[
              _Legende(avecPrix: widget.avecPrix, mediane: widget.mediane),
              const SizedBox(height: AppSpacing.xs),
            ],
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _ouvert = !_ouvert),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: boutonCarteDecoration,
                    child: Icon(
                      _ouvert ? Icons.close : Icons.info_outline,
                      color: AppColors.blueFonce,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  color: AppColors.blanc.withValues(alpha: 0.7),
                  child: Text(
                    '© OpenStreetMap',
                    style: AppTextStyle.texteSecondaire.copyWith(
                      fontSize: 10,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Legende extends StatelessWidget {
  const _Legende({required this.avecPrix, required this.mediane});

  // false avec Tous
  final bool avecPrix;
  final double? mediane;

  static final pourcentage = '${(CarteViewModel.ecartMediane * 100).round()} %';

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyle.texteSecondaire.copyWith(
      fontSize: 12,
      height: 1.3,
      color: AppColors.neutral700,
    );
    final note = AppTextStyle.texteSecondaire.copyWith(
      fontSize: 11,
      height: 1.3,
    );
    final mediane = this.mediane;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      constraints: const BoxConstraints(maxWidth: 230),
      decoration: BoxDecoration(
        color: AppColors.blanc.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (avecPrix) ...[
            _LigneLegende(
              PriceLevel.bas,
              'Au moins $pourcentage moins cher',
              style,
            ),
            _LigneLegende(PriceLevel.moyen, 'Proche de la médiane', style),
            _LigneLegende(
              PriceLevel.eleve,
              'Au moins $pourcentage plus cher',
              style,
            ),
            const SizedBox(height: 2),
            // Rétrécit plutôt que de passer à la ligne
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                mediane == null
                    ? 'Comparé à la médiane nationale du jour'
                    : 'Médiane nationale du jour : '
                          '${formaterNombre(mediane, 3)} €/L',
                style: note,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ] else
            _LigneLegende(
              null,
              'Choisissez un carburant pour comparer les prix',
              style,
            ),
        ],
      ),
    );
  }
}

class _LigneLegende extends StatelessWidget {
  const _LigneLegende(this.niveau, this.texte, this.style);

  final PriceLevel? niveau;
  final String texte;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: couleurPrix(niveau),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(child: Text(texte, style: style)),
        ],
      ),
    );
  }
}
