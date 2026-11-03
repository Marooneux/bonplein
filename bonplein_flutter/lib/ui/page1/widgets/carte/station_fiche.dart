import 'package:bonplein_flutter/domain/models/station_service.dart';
import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:bonplein_flutter/ui/page1/view_models/carte_view_model.dart';
import 'package:bonplein_flutter/ui/page1/widgets/carte/marqueurs_carte.dart';
import 'package:bonplein_flutter/ui/pageInfoStation/page_info_station.dart';
import 'package:bonplein_flutter/utils/format_utils.dart';
import 'package:flutter/material.dart';

/// Petite fiche en bulle au-dessus de la pastille touchée qui ouvre la page
/// de la station
class StationFiche extends StatelessWidget {
  const StationFiche({
    required this.station,
    required this.viewModel,
    super.key,
  });

  static const largeur = 240.0;
  static const hauteur = 140.0;

  final Station station;
  final CarteViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final prix = viewModel.prixDe(station);
    final distance = viewModel.distanceKm(station);
    final temps = viewModel.tempsTrajetMin(station);
    final nom = station.nom.isNotEmpty ? station.nom : station.adresse;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Material(
          color: AppColors.blanc,
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => PageInfoStation(
                  station: station,
                  distanceKm: distance,
                  tempsMin: temps,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          nom,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.titreCarte,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          station.ville,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.texteSecondaire,
                        ),
                        if (distance != null && temps != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '${formaterNombre(distance, 1)} km · $temps min',
                            style: AppTextStyle.metaPetite,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (prix != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formaterNombre(prix, 3),
                          style: AppTextStyle.prixCarte.copyWith(
                            color: couleurPrix(viewModel.niveauPrix(station)),
                          ),
                        ),
                        Text('€/L', style: AppTextStyle.metaPetite),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        CustomPaint(
          size: const Size(16, 8),
          painter: _PointeFichePainter(),
        ),
        // Moitié de la pastille plus un petit écart
        const SizedBox(height: 20),
      ],
    );
  }
}

/// Petit triangle sous la fiche qui pointe vers la pastille
class _PointeFichePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pointe = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(pointe, Paint()..color = AppColors.blanc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
