import 'package:flutter/material.dart';

class AppTheme {
  static const _seed = Color(0xff116265);

  static final light = _build(Brightness.light);
  static final dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: brightness
      )
    );
  }

}