import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_vendor/app/app.dart';

void main() {
  testWidgets('renders the vendor application shell', (tester) async {
    await tester.pumpWidget(const VendorApp());

    expect(find.text('Turf Booking Vendor'), findsOneWidget);
    expect(find.text('Vendor and staff app foundation'), findsOneWidget);
  });
}
