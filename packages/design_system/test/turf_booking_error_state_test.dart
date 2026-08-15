import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_design_system/turf_booking_design_system.dart';

void main() {
  Widget buildSubject({VoidCallback? onRetry, String? retryLabel}) {
    return MaterialApp(
      home: Scaffold(
        body: TurfBookingErrorState(
          title: 'Unable to load bookings',
          description: 'Check your connection and try again.',
          onRetry: onRetry,
          retryLabel: retryLabel,
        ),
      ),
    );
  }

  testWidgets('renders the localized failure copy and error icon', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    expect(find.text('Unable to load bookings'), findsOneWidget);
    expect(find.text('Check your connection and try again.'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('marks the localized title as a semantic heading', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(buildSubject());

    expect(
      tester.getSemantics(find.text('Unable to load bookings')),
      matchesSemantics(label: 'Unable to load bookings', isHeader: true),
    );

    semantics.dispose();
  });

  testWidgets('runs the retry callback from its labeled action', (
    tester,
  ) async {
    var retryCount = 0;

    await tester.pumpWidget(
      buildSubject(onRetry: () => retryCount++, retryLabel: 'Try again'),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Try again'));

    expect(retryCount, 1);
  });
}
