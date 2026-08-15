import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_customer/app/app.dart';

void main() {
  testWidgets('renders the customer application shell', (tester) async {
    await tester.pumpWidget(const CustomerApp());

    expect(find.text('Turf Booking'), findsOneWidget);
    expect(find.text('Customer app foundation'), findsOneWidget);
  });
}
