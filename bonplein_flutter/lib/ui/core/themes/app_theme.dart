import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_spacing.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get light {
    // Inter everywhere by default, named styles on top
    final textTheme = TextTheme(
      headlineLarge: AppTextStyle.hero,
      headlineMedium: AppTextStyle.titreSection,
      titleLarge: AppTextStyle.titrePrincipal,
      bodyLarge: AppTextStyle.body,
      bodyMedium: AppTextStyle.body,
      bodySmall: AppTextStyle.metaDonnee,
      labelLarge: AppTextStyle.label,
    );

    // Button text: bold, normal case like "Rechercher"
    final buttonText = AppTextStyle.label.copyWith(
      fontSize: 15,
      letterSpacing: 0,
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
    );

    // Search bar and text fields: light gray, rounded, no border
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide.none,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.slate50,
      textTheme: textTheme,
      iconTheme: const IconThemeData(color: AppColors.navigation),

      colorScheme: const ColorScheme.light(
        primary: AppColors.economie,
        secondary: AppColors.vigilance,
        onSecondary: AppColors.blanc,
        error: AppColors.prixEleve,
        onSurface: AppColors.navigation,
        outline: AppColors.slate200,
        outlineVariant: AppColors.slate200,
      ),

      // Top bar
      appBarTheme: AppBarThemeData(
        backgroundColor: AppColors.slate50,
        foregroundColor: AppColors.navigation,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyle.titrePrincipal.copyWith(fontSize: 18),
      ),

      // Cards (design system: radius 16, 1px  border)
      cardTheme: CardThemeData(
        color: AppColors.blanc,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.slate200),
        ),
      ),

      // Green button: "Démarrer l'itinéraire", "Créer"
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.economie,
          foregroundColor: AppColors.blanc,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),

      // Dark button: "Rechercher", "Voir le meilleur prix"
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navigation,
          foregroundColor: AppColors.blanc,
          minimumSize: const Size.fromHeight(48),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),

      // Fuel chips: SP95, SP98, Gazole etc (selected = green)
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.blanc,
        selectedColor: AppColors.economie,
        side: const BorderSide(color: AppColors.slate200),
        shape: const StadiumBorder(),
        showCheckmark: false,
        labelStyle: AppTextStyle.label.copyWith(fontSize: 13, letterSpacing: 0),
        secondaryLabelStyle: AppTextStyle.label.copyWith(
          fontSize: 13,
          letterSpacing: 0,
          color: AppColors.blanc,
        ),
      ),

      // Search bar and address fields
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.slate100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 14,
        ),
        hintStyle: AppTextStyle.body.copyWith(
          color: AppColors.slate400,
          fontSize: 15,
        ),
        prefixIconColor: AppColors.slate400,
        border: fieldBorder,
        enabledBorder: fieldBorder,
        focusedBorder: fieldBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.economie, width: 1.5),
        ),
      ),

      // Bottom bar: Carte, Trajet, Alertes, Historique, Profil
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.blanc,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 68,
        indicatorColor: AppColors.economie.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? AppColors.economie
                : AppColors.slate400,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppTextStyle.label.copyWith(
            fontSize: 11,
            letterSpacing: 0,
            color: states.contains(WidgetState.selected)
                ? AppColors.economie
                : AppColors.slate400,
          ),
        ),
      ),

      // station details
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.blanc,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.slate200,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
