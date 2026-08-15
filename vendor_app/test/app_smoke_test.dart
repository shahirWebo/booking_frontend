import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_vendor/app/app.dart';
import 'package:turf_booking_vendor/app/routing/vendor_app_router.dart';

void main() {
  testWidgets('renders the vendor application shell', (tester) async {
    await tester.pumpWidget(
      VendorApp(
        configuration: ApiConfiguration.fromBaseUrl(
          environment: AppEnvironment.production,
          baseUrl: 'https://api.example.invalid/api/v1',
        ),
      ),
    );

    expect(find.text('Turf Booking Vendor'), findsOneWidget);
    expect(find.text('Vendor and staff app foundation'), findsOneWidget);
  });

  testWidgets('renders the development display name', (tester) async {
    await tester.pumpWidget(
      VendorApp(
        configuration: ApiConfiguration.fromBaseUrl(
          environment: AppEnvironment.development,
          baseUrl: 'http://localhost:8000/api/v1',
        ),
      ),
    );

    expect(find.text('Turf Booking Vendor Dev'), findsOneWidget);
    expect(find.text('Development'), findsOneWidget);
  });

  testWidgets('renders an app-owned unknown-route screen', (tester) async {
    final appRouter = VendorAppRouter(environment: AppEnvironment.staging);
    addTearDown(appRouter.router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
    appRouter.router.go('/customer');
    await tester.pumpAndSettle();

    expect(find.text('Vendor route not found in Staging.'), findsOneWidget);
  });
}
