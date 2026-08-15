import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_admin/app/app.dart';

void main() {
  testWidgets('renders the admin application shell', (tester) async {
    await tester.pumpWidget(const AdminApp());

    expect(find.text('Turf Booking Admin'), findsOneWidget);
    expect(find.text('Admin portal foundation'), findsOneWidget);
  });
}
