import 'package:flutter/material.dart';

/// Shared color tokens. Product features should use theme colors for UI.
abstract final class TurfBookingColors {
  static const brand = Color(0xFF1B6B45);
}

/// Shared layout-spacing tokens in logical pixels.
abstract final class TurfBookingSpacing {
  static const xSmall = 4.0;
  static const small = 8.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const xLarge = 32.0;
}

/// Shared shape tokens for cards, fields, and controls.
abstract final class TurfBookingRadii {
  static const small = 8.0;
  static const medium = 12.0;
  static const large = 16.0;
  static const pill = 999.0;
}

/// Material 3 themes shared by the independently deployed applications.
abstract final class TurfBookingTheme {
  static final light = _build(Brightness.light);
  static final dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: TurfBookingColors.brand,
      brightness: brightness,
    );
    final borderRadius = BorderRadius.circular(TurfBookingRadii.medium);
    final shape = RoundedRectangleBorder(borderRadius: borderRadius);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: shape,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(44, 44),
          shape: shape,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(44, 44),
          shape: shape,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: borderRadius),
        enabledBorder: OutlineInputBorder(borderRadius: borderRadius),
        focusedBorder: OutlineInputBorder(borderRadius: borderRadius),
      ),
    );
  }
}
