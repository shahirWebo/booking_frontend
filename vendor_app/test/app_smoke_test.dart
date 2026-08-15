import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_vendor/app/app.dart';

void main() {
  testWidgets('renders the vendor application shell', (tester) async {
    await tester.pumpWidget(
      const VendorApp(environment: AppEnvironment.production),
    );

    expect(find.text('Turf Booking Vendor'), findsOneWidget);
    expect(find.text('Vendor and staff app foundation'), findsOneWidget);
  });

  testWidgets('renders the development display name', (tester) async {
    await tester.pumpWidget(
      const VendorApp(environment: AppEnvironment.development),
    );

    expect(find.text('Turf Booking Vendor Dev'), findsOneWidget);
    expect(find.text('Development'), findsOneWidget);
  });
}
