import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_design_system/turf_booking_design_system.dart';

void main() {
  Widget buildSubject({String? message}) {
    return MaterialApp(
      home: Scaffold(
        body: TurfBookingLoadingIndicator(
          semanticLabel: 'Loading bookings',
          message: message,
        ),
      ),
    );
  }

  testWidgets('renders a Material progress indicator', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('announces its localized semantic label once', (tester) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(buildSubject(message: 'Loading bookings'));

    expect(
      tester.getSemantics(find.byType(TurfBookingLoadingIndicator)),
      matchesSemantics(label: 'Loading bookings', isLiveRegion: true),
    );

    semantics.dispose();
  });

  testWidgets('shows optional visual status copy', (tester) async {
    await tester.pumpWidget(buildSubject(message: 'Loading bookings'));

    expect(find.text('Loading bookings'), findsOneWidget);
  });
}
