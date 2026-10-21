import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:flutter/material.dart';

enum StationView {liste, carte }

class ViewSwitch extends StatelessWidget{
  const ViewSwitch({
   required this.selected,
   required this.onChanged,
   super.key,
});
  final StationView selected;
  final ValueChanged<StationView> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        children: [
          _Option(
            label: 'Liste',
            icon: Icons.list,
            isSelected: selected == StationView.liste,
            onTap: () => onChanged(StationView.liste),
          ),
          _Option(
            label: 'Carte',
            icon: Icons.map_outlined,
            isSelected: selected == StationView.carte,
            onTap: () => onChanged(StationView.carte),
          )
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.blanc : AppColors.neutral500;
    return Expanded(
      child: Material(
        color: isSelected ? AppColors.vert : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: color,),
                const SizedBox(width: 6),
                Text(
                  label.toUpperCase(),
                  style: AppTextStyle.label.copyWith(color: color),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}