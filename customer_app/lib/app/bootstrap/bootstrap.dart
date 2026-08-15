import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_customer/app/app.dart';
import 'package:turf_booking_customer/app/dependencies/app_dependencies.dart';

void runCustomerApp(ApiConfiguration configuration) {
  runApp(
    ProviderScope(
      overrides: [
        customerApiConfigurationProvider.overrideWithValue(configuration),
      ],
      child: CustomerApp(configuration: configuration),
    ),
  );
}
