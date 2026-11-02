import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:flutter/material.dart';

class ServicesStation extends StatefulWidget {
  const ServicesStation({
    super.key,
    required this.services,
    this.nombreVisible = 3,
  });

  final List<String> services;

  /// Nombre de services affichés avant de déplier
  final int nombreVisible;

  @override
  State<ServicesStation> createState() => _ServicesStationState();
}

class _ServicesStationState extends State<ServicesStation> {
  bool _deplie = false;

  /// Choisit une icône selon des mots-clés du service
  static IconData _icone(String service) {
    final s = service.toLowerCase();
    if (s.contains('gaz domestique')) return Icons.propane_tank_outlined;
    if (s.contains('automate')) return Icons.credit_card;
    if (s.contains('gonflage')) return Icons.tire_repair;
    if (s.contains('boutique')) return Icons.storefront_outlined;
    if (s.contains('poids lourds')) return Icons.local_shipping_outlined;
    if (s.contains('dab') || s.contains('distributeur')) return Icons.atm;
    if (s.contains('additi')) return Icons.science_outlined;
    if (s.contains('lavage')) return Icons.local_car_wash_outlined;
    if (s.contains('toilette')) return Icons.wc;
    if (s.contains('colis')) return Icons.inventory_2_outlined;
    if (s.contains('emporter')) return Icons.takeout_dining_outlined;
    if (s.contains('laverie')) return Icons.local_laundry_service_outlined;
    if (s.contains('location')) return Icons.car_rental;
    if (s.contains('wifi')) return Icons.wifi;
    if (s.contains('restauration')) return Icons.restaurant_outlined;
    if (s.contains('réparation') || s.contains('reparation') ||
        s.contains('entretien')) {
      return Icons.build_outlined;
    }
    if (s.contains('borne')) return Icons.ev_station_outlined;
    if (s.contains('fioul') || s.contains('pétrole') || s.contains('petrole')) {
      return Icons.oil_barrel_outlined;
    }
    if (s.contains('bébé') || s.contains('bebe')) {
      return Icons.baby_changing_station_outlined;
    }
    if (s == 'bar') return Icons.local_bar_outlined;
    if (s.contains('douche')) return Icons.shower_outlined;
    if (s.contains('camping')) return Icons.rv_hookup;
    if (s.contains('gnv')) return Icons.local_gas_station_outlined;
    if (s.contains('carburant')) return Icons.local_gas_station_outlined;
    return Icons.check_circle_outline; // service inconnu
  }

  @override
  Widget build(BuildContext context) {
    final services = widget.services;

    return Card(
      color: AppColors.blanc,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Services proposés', style: AppTextStyle.titreCarte),
            const SizedBox(height: AppSpacing.xs),
            if (services.isEmpty)
              Text(
                'Aucun service renseigné',
                style: AppTextStyle.texteSecondaire,
              )
            else
              _buildListe(services),
          ],
        ),
      ),
    );
  }

  Widget _buildListe(List<String> services) {
    final visibles = services.take(widget.nombreVisible).toList();
    final autres = services.skip(widget.nombreVisible).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...visibles.map(_ligne),

        // Les services supplémentaires apparaissent avec une animation
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _deplie
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: autres.map(_ligne).toList(),
          )
              : const SizedBox(width: double.infinity),
        ),

        // Bouton flèche, seulement s'il y a des services en plus
        if (autres.isNotEmpty)
          InkWell(
            onTap: () => setState(() => _deplie = !_deplie),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _deplie ? 'Voir moins' : 'Voir ${autres.length} autres',
                    style: AppTextStyle.label.copyWith(
                      color: AppColors.vert,
                      letterSpacing: 0,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _deplie ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.vert,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _ligne(String service) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.vert.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm / 2),
            ),
            child: Icon(_icone(service), size: 18, color: AppColors.vert),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(service, style: AppTextStyle.body.copyWith(fontSize: 14))),
        ],
      ),
    );
  }
}