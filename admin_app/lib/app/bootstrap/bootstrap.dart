import 'package:flutter/widgets.dart';
import 'package:turf_booking_admin/app/app.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

void runAdminApp(ApiConfiguration configuration) {
  runApp(AdminApp(configuration: configuration));
}
