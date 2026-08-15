import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_admin/app/app.dart';
import 'package:turf_booking_admin/app/dependencies/app_dependencies.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

void runAdminApp(ApiConfiguration configuration) {
  runApp(
    ProviderScope(
      overrides: [
        adminApiConfigurationProvider.overrideWithValue(configuration),
      ],
      child: AdminApp(configuration: configuration),
    ),
  );
}
