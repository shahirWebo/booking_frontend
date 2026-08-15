import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_admin/app/app.dart';

void main() {
  testWidgets('renders the admin application shell', (tester) async {
    await tester.pumpWidget(
      AdminApp(
        configuration: ApiConfiguration.fromBaseUrl(
          environment: AppEnvironment.production,
          baseUrl: 'https://api.example.invalid/api/v1',
        ),
      ),
    );

    expect(find.text('Turf Booking Admin'), findsOneWidget);
    expect(find.text('Admin portal foundation'), findsOneWidget);
  });

  testWidgets('renders the development display name', (tester) async {
    await tester.pumpWidget(
      AdminApp(
        configuration: ApiConfiguration.fromBaseUrl(
          environment: AppEnvironment.development,
          baseUrl: 'http://localhost:8000/api/v1',
        ),
      ),
    );

    expect(find.text('Turf Booking Admin Dev'), findsOneWidget);
    expect(find.text('Development'), findsOneWidget);
  });
}
