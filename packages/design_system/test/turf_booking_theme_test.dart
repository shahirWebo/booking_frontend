import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_design_system/turf_booking_design_system.dart';

void main() {
  test('provides Material 3 light and dark themes from one brand token', () {
    expect(TurfBookingTheme.light.useMaterial3, isTrue);
    expect(TurfBookingTheme.dark.useMaterial3, isTrue);
    expect(TurfBookingTheme.light.colorScheme.brightness, Brightness.light);
    expect(TurfBookingTheme.dark.colorScheme.brightness, Brightness.dark);
    expect(TurfBookingTheme.light.colorScheme.primary, isNotNull);
  });

  test('provides consistent accessible control and layout tokens', () {
    expect(TurfBookingSpacing.medium, 16);
    expect(TurfBookingRadii.medium, 12);
    expect(
      TurfBookingTheme.light.elevatedButtonTheme.style?.minimumSize?.resolve(
        <WidgetState>{},
      ),
      const Size(44, 44),
    );
  });
}
