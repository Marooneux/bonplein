import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

// Style commun aux boutons ronds posés sur la carte
const boutonCarteDecoration = BoxDecoration(
  color: AppColors.blanc,
  shape: BoxShape.circle,
  border: Border.fromBorderSide(BorderSide(color: AppColors.neutral200)),
  boxShadow: [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ],
);

class BoutonRecentrer extends StatelessWidget {
  const BoutonRecentrer({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      // Sous la boussole avec 10 de marge et 48 de bouton
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 62, 10, 10),
        child: IconButton(
          padding: EdgeInsets.zero,
          tooltip: 'Recentrer',
          onPressed: onPressed,
          icon: Container(
            width: 44,
            height: 44,
            decoration: boutonCarteDecoration,
            child: const Icon(
              Icons.my_location,
              color: AppColors.blueFonce,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

class CompassIcon extends StatelessWidget {
  const CompassIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: boutonCarteDecoration,
      child: CustomPaint(painter: _CompassNeedlePainter()),
    );
  }
}

class _CompassNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final length = size.height * 0.34;
    final halfWidth = size.width * 0.12;

    final nord = Path()
      ..moveTo(center.dx, center.dy - length)
      ..lineTo(center.dx + halfWidth, center.dy)
      ..lineTo(center.dx - halfWidth, center.dy)
      ..close();
    final sud = Path()
      ..moveTo(center.dx, center.dy + length)
      ..lineTo(center.dx + halfWidth, center.dy)
      ..lineTo(center.dx - halfWidth, center.dy)
      ..close();

    canvas
      ..drawPath(nord, Paint()..color = AppColors.rouge)
      ..drawPath(sud, Paint()..color = AppColors.neutral400)
      ..drawCircle(center, 2.5, Paint()..color = AppColors.blueFonce);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
