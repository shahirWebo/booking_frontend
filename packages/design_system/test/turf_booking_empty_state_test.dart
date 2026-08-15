import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_design_system/turf_booking_design_system.dart';

void main() {
  Widget buildSubject({Widget? action}) {
    return MaterialApp(
      home: Scaffold(
        body: TurfBookingEmptyState(
          title: 'No bookings yet',
          description: 'Your upcoming bookings will appear here.',
          action: action,
        ),
      ),
    );
  }

  testWidgets('renders the title, description, and default icon', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    expect(find.text('No bookings yet'), findsOneWidget);
    expect(
      find.text('Your upcoming bookings will appear here.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });

  testWidgets('marks the localized title as a semantic heading', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(buildSubject());

    expect(
      tester.getSemantics(find.text('No bookings yet')),
      matchesSemantics(label: 'No bookings yet', isHeader: true),
    );

    semantics.dispose();
  });

  testWidgets('renders an optional discovery action', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        action: FilledButton(
          onPressed: () {},
          child: const Text('Explore turfs'),
        ),
      ),
    );

    expect(find.widgetWithText(FilledButton, 'Explore turfs'), findsOneWidget);
  });
}
