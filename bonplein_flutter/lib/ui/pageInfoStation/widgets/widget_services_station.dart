import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:flutter/material.dart';

class ServicesStation extends StatefulWidget {
  const ServicesStation({
    super.key,
    required this.services,
    this.nombreVisible = 5,
  });

  final List<String> services;

  /// Nombre d'icônes affichées avant de déplier
  final int nombreVisible;

  @override
  State<ServicesStation> createState() => _ServicesStationState();
}

class _ServicesStationState extends State<ServicesStation> {
  bool _deplie = false;

  static const double _taille = 48;

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
    if (s.contains('réparation') ||
        s.contains('reparation') ||
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
            const SizedBox(height: AppSpacing.sm),
            if (services.isEmpty)
              Text(
                'Aucun service renseigné',
                style: AppTextStyle.texteSecondaire,
              )
            else
              _buildIcones(services),
          ],
        ),
      ),
    );
  }

  Widget _buildIcones(List<String> services) {
    final aDesAutres = services.length > widget.nombreVisible;
    final affiches = _deplie
        ? services
        : services.take(widget.nombreVisible).toList();

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...affiches.map(_pastille),
            if (aDesAutres) _pastilleFleche(services.length - widget.nombreVisible),
          ],
        ),
      ),
    );
  }

  /// Pastille ronde avec l'icône. Un appui affiche le nom du service.
  Widget _pastille(String service) {
    return Tooltip(
      message: service,
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 3),
      child: Container(
        width: _taille,
        height: _taille,
        decoration: BoxDecoration(
          color: AppColors.vert.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(_icone(service), size: 22, color: AppColors.vert),
      ),
    );
  }

  /// Pastille ronde avec la flèche pour voir / masquer les autres services.
  Widget _pastilleFleche(int nombreCaches) {
    return Tooltip(
      message: _deplie ? 'Voir moins' : 'Voir $nombreCaches autres services',
      child: InkWell(
        onTap: () => setState(() => _deplie = !_deplie),
        customBorder: const CircleBorder(),
        child: Container(
          width: _taille,
          height: _taille,
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.neutral200),
          ),
          child: AnimatedRotation(
            turns: _deplie ? 0.5 : 0,
            duration: const Duration(milliseconds: 250),
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.neutral700,
            ),
          ),
        ),
      ),
    );
  }
}