import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_localization/turf_booking_localization.dart';

void main() {
  testWidgets('loads the Hindi shared message for a supported locale', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('hi'),
        localizationsDelegates: TurfBookingLocalizations.localizationsDelegates,
        supportedLocales: TurfBookingLocalizations.supportedLocales,
        home: Builder(
          builder: (context) =>
              Text(TurfBookingLocalizations.of(context)!.pageNotFound),
        ),
      ),
    );

    expect(find.text('पृष्ठ नहीं मिला'), findsOneWidget);
  });
}
