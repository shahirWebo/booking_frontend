import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_customer/app/bootstrap/bootstrap.dart';

void main() {
  runCustomerApp(ApiConfiguration.fromCompileTime(AppEnvironment.development));
}
