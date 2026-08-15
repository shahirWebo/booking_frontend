/// Test helpers shared by Turf Booking applications and packages.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

Widget withTestProviders({required Widget child}) =>
    ProviderScope(child: child);

Future<void> pumpTestWidget(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(withTestProviders(child: child));

ApiConfiguration testApiConfiguration({
  AppEnvironment environment = AppEnvironment.development,
}) {
  final baseUrl = switch (environment) {
    AppEnvironment.development => 'http://localhost:8000/api/v1',
    AppEnvironment.staging => 'https://staging-api.example.invalid/api/v1',
    AppEnvironment.production => 'https://api.example.invalid/api/v1',
  };
  return ApiConfiguration.fromBaseUrl(
    environment: environment,
    baseUrl: baseUrl,
  );
}
