import 'package:flutter/material.dart';

class VendorApp extends StatelessWidget {
  const VendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Turf Booking Vendor',
      home: _VendorFoundationScreen(),
    );
  }
}

class _VendorFoundationScreen extends StatelessWidget {
  const _VendorFoundationScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront, size: 56),
            SizedBox(height: 16),
            Text('Turf Booking Vendor'),
            SizedBox(height: 8),
            Text('Vendor and staff app foundation'),
          ],
        ),
      ),
    );
  }
}
