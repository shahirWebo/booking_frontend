import 'package:flutter/material.dart';

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Turf Booking',
      home: _CustomerFoundationScreen(),
    );
  }
}

class _CustomerFoundationScreen extends StatelessWidget {
  const _CustomerFoundationScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_soccer, size: 56),
            SizedBox(height: 16),
            Text('Turf Booking'),
            SizedBox(height: 8),
            Text('Customer app foundation'),
          ],
        ),
      ),
    );
  }
}
