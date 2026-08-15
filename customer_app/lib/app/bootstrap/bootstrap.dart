import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_customer/app/app.dart';
import 'package:turf_booking_customer/app/state/app_environment.dart';

void runCustomerApp(ApiConfiguration configuration) {
  runApp(
    ProviderScope(
      overrides: [
        customerAppEnvironmentProvider.overrideWithValue(
          configuration.environment,
        ),
      ],
      child: CustomerApp(configuration: configuration),
    ),
  );
}
