import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/page1/view_models/carte_view_model.dart';
import 'package:flutter/material.dart';

Color couleurPrix(PriceLevel? niveau) => switch (niveau) {
  PriceLevel.bas => AppColors.vert,
  PriceLevel.moyen => AppColors.orange,
  PriceLevel.eleve => AppColors.rouge,
  null => AppColors.neutral400,
};

const _ombre = BoxShadow(
  color: Color(0x33000000),
  blurRadius: 4,
  offset: Offset(0, 2),
);

/// Pastille ronde avec une pompe centrée sur la station et colorée selon
/// son prix
class StationMarker extends StatelessWidget {
  const StationMarker({required this.niveau, super.key});

  final PriceLevel? niveau;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: couleurPrix(niveau),
        shape: BoxShape.circle,
        border: const Border.fromBorderSide(
          BorderSide(color: AppColors.blanc, width: 2),
        ),
        boxShadow: const [_ombre],
      ),
      child: const Icon(
        Icons.local_gas_station,
        color: AppColors.blanc,
        size: 20,
      ),
    );
  }
}

/// Regroupe des pastilles proches avec la couleur de la moins chère
class ClusterBulle extends StatelessWidget {
  const ClusterBulle({required this.nombre, required this.niveau, super.key});

  final int nombre;
  final PriceLevel? niveau;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: couleurPrix(niveau),
        shape: BoxShape.circle,
        border: const Border.fromBorderSide(
          BorderSide(color: AppColors.blanc, width: 2),
        ),
        boxShadow: const [_ombre],
      ),
      child: Text(
        '$nombre',
        style: const TextStyle(
          color: AppColors.blanc,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
