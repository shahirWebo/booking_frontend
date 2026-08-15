import 'package:flutter/widgets.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_vendor/app/app.dart';

void runVendorApp(ApiConfiguration configuration) {
  runApp(VendorApp(configuration: configuration));
}
