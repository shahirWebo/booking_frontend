import 'package:flutter/widgets.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_customer/app/app.dart';

void runCustomerApp(ApiConfiguration configuration) {
  runApp(CustomerApp(configuration: configuration));
}
