import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_customer/app/foundation_screen.dart';

abstract final class CustomerRoutePaths {
  static const home = '/';
}

/// Customer-owned route table. Feature routes are added here by their owners.
class CustomerAppRouter {
  CustomerAppRouter({required AppEnvironment environment})
    : router = GoRouter(
        initialLocation: CustomerRoutePaths.home,
        routes: [
          GoRoute(
            path: CustomerRoutePaths.home,
            name: 'customer-home',
            builder: (context, state) =>
                CustomerFoundationScreen(environment: environment),
          ),
        ],
        errorBuilder: (context, state) =>
            _UnknownCustomerRoute(environment: environment),
      );

  final GoRouter router;
}

class _UnknownCustomerRoute extends StatelessWidget {
  const _UnknownCustomerRoute({required this.environment});

  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Customer route not found in ${environment.label}.'),
      ),
    );
  }
}
