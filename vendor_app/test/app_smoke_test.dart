import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_vendor/app/app.dart';
import 'package:turf_booking_vendor/app/dependencies/app_dependencies.dart';
import 'package:turf_booking_vendor/app/routing/vendor_app_router.dart';

void main() {
  testWidgets('renders the vendor application shell', (tester) async {
    final configuration = ApiConfiguration.fromBaseUrl(
      environment: AppEnvironment.production,
      baseUrl: 'https://api.example.invalid/api/v1',
    );
    await tester.pumpWidget(_vendorApp(configuration));

    expect(find.text('Turf Booking Vendor'), findsOneWidget);
    expect(find.text('Vendor and staff app foundation'), findsOneWidget);
  });

  testWidgets('renders the development display name', (tester) async {
    final configuration = ApiConfiguration.fromBaseUrl(
      environment: AppEnvironment.development,
      baseUrl: 'http://localhost:8000/api/v1',
    );
    await tester.pumpWidget(_vendorApp(configuration));

    expect(find.text('Turf Booking Vendor Dev'), findsOneWidget);
    expect(find.text('Development'), findsOneWidget);
  });

  testWidgets('renders an app-owned unknown-route screen', (tester) async {
    final appRouter = VendorAppRouter(environment: AppEnvironment.staging);
    addTearDown(appRouter.router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
    appRouter.router.go('/customer');
    await tester.pumpAndSettle();

    expect(find.text('Page not found (Staging).'), findsOneWidget);
  });
}

Widget _vendorApp(ApiConfiguration configuration) {
  return ProviderScope(
    overrides: [
      vendorApiConfigurationProvider.overrideWithValue(configuration),
    ],
    child: VendorApp(configuration: configuration),
  );
}
