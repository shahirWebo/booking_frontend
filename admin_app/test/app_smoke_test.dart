import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_admin/app/app.dart';
import 'package:turf_booking_admin/app/dependencies/app_dependencies.dart';
import 'package:turf_booking_admin/app/routing/admin_app_router.dart';

void main() {
  testWidgets('renders the admin application shell', (tester) async {
    final configuration = ApiConfiguration.fromBaseUrl(
      environment: AppEnvironment.production,
      baseUrl: 'https://api.example.invalid/api/v1',
    );
    await tester.pumpWidget(_adminApp(configuration));

    expect(find.text('Turf Booking Admin'), findsOneWidget);
    expect(find.text('Admin portal foundation'), findsOneWidget);
  });

  testWidgets('renders the development display name', (tester) async {
    final configuration = ApiConfiguration.fromBaseUrl(
      environment: AppEnvironment.development,
      baseUrl: 'http://localhost:8000/api/v1',
    );
    await tester.pumpWidget(_adminApp(configuration));

    expect(find.text('Turf Booking Admin Dev'), findsOneWidget);
    expect(find.text('Development'), findsOneWidget);
  });

  testWidgets('renders an app-owned unknown-route screen', (tester) async {
    final appRouter = AdminAppRouter(environment: AppEnvironment.production);
    addTearDown(appRouter.router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
    appRouter.router.go('/customer');
    await tester.pumpAndSettle();

    expect(find.text('Admin route not found in Production.'), findsOneWidget);
  });
}

Widget _adminApp(ApiConfiguration configuration) {
  return ProviderScope(
    overrides: [adminApiConfigurationProvider.overrideWithValue(configuration)],
    child: AdminApp(configuration: configuration),
  );
}
