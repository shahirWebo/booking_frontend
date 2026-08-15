import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_customer/app/app.dart';

void main() {
  testWidgets('renders the customer application shell', (tester) async {
    await tester.pumpWidget(
      const CustomerApp(environment: AppEnvironment.production),
    );

    expect(find.text('Turf Booking'), findsOneWidget);
    expect(find.text('Customer app foundation'), findsOneWidget);
  });

  testWidgets('renders the staging display name', (tester) async {
    await tester.pumpWidget(
      const CustomerApp(environment: AppEnvironment.staging),
    );

    expect(find.text('Turf Booking Staging'), findsOneWidget);
    expect(find.text('Staging'), findsOneWidget);
  });
}
