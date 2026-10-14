import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTextStyle {
  static TextStyle get hero => GoogleFonts.outfit(
    fontSize: 38,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.33,
    color: AppColors.navigation,
  );

  static TextStyle get titreSection => GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.7,
    color: AppColors.navigation,
  );

  static TextStyle get titrePrincipal => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.48,
    color: AppColors.navigation,
  );

  static TextStyle get body => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.navigation,
  );

  static TextStyle get valeur => GoogleFonts.dmMono(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.64,
    color: AppColors.navigation,
  );

  static TextStyle get label => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.56,
    color: AppColors.navigation,
  );

  static TextStyle get metaDonnee => GoogleFonts.dmMono(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.28,
    color: AppColors.slate500,
  );

  // Other sizes
  static TextStyle get titreBarre => GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.36,
    color: AppColors.navigation,
  );

  static TextStyle get titreCarte => GoogleFonts.outfit(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.34,
    color: AppColors.navigation,
  );

  static TextStyle get texteSecondaire => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.slate500,
  );

  static TextStyle get prixCarte => GoogleFonts.dmMono(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.44,
    color: AppColors.navigation,
  );

  static TextStyle get metaPetite => GoogleFonts.dmMono(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.24,
    color: AppColors.slate500,
  );

  static TextStyle get bouton => GoogleFonts.outfit(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.navigation,
  );

  static TextStyle get chip => GoogleFonts.outfit(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.navigation,
  );

  static TextStyle get navLabel => GoogleFonts.outfit(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.slate400,
  );
}
