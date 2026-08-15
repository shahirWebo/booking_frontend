import 'package:flutter/material.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Turf Booking Admin',
      home: _AdminFoundationScreen(),
    );
  }
}

class _AdminFoundationScreen extends StatelessWidget {
  const _AdminFoundationScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.admin_panel_settings, size: 56),
            SizedBox(height: 16),
            Text('Turf Booking Admin'),
            SizedBox(height: 8),
            Text('Admin portal foundation'),
          ],
        ),
      ),
    );
  }
}
