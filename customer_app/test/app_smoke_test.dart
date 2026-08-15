import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_customer/app/app.dart';
import 'package:turf_booking_customer/app/dependencies/app_dependencies.dart';
import 'package:turf_booking_customer/app/routing/customer_app_router.dart';

void main() {
  testWidgets('renders the customer application shell', (tester) async {
    final configuration = ApiConfiguration.fromBaseUrl(
      environment: AppEnvironment.production,
      baseUrl: 'https://api.example.invalid/api/v1',
    );
    await tester.pumpWidget(_customerApp(configuration));

    expect(find.text('Turf Booking'), findsOneWidget);
    expect(find.text('Customer app foundation'), findsOneWidget);
  });

  testWidgets('renders the staging display name', (tester) async {
    final configuration = ApiConfiguration.fromBaseUrl(
      environment: AppEnvironment.staging,
      baseUrl: 'https://staging-api.example.invalid/api/v1',
    );
    await tester.pumpWidget(_customerApp(configuration));

    expect(find.text('Turf Booking Staging'), findsOneWidget);
    expect(find.text('Staging'), findsOneWidget);
  });

  testWidgets('renders an app-owned unknown-route screen', (tester) async {
    final appRouter = CustomerAppRouter(
      environment: AppEnvironment.development,
    );
    addTearDown(appRouter.router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
    appRouter.router.go('/vendor');
    await tester.pumpAndSettle();

    expect(
      find.text('Customer route not found in Development.'),
      findsOneWidget,
    );
  });
}

Widget _customerApp(ApiConfiguration configuration) {
  return ProviderScope(
    overrides: [
      customerApiConfigurationProvider.overrideWithValue(configuration),
    ],
    child: CustomerApp(configuration: configuration),
  );
}
