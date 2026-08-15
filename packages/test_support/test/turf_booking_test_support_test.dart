import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_test_support/turf_booking_test_support.dart';

final _labelProvider = Provider<String>((_) => 'default');

void main() {
  test('creates a deterministic staging configuration', () {
    expect(
      testApiConfiguration(environment: AppEnvironment.staging).baseUrl,
      Uri.parse('https://staging-api.example.invalid/api/v1'),
    );
  });

  testWidgets('pumps widgets with an isolated provider scope', (tester) async {
    await pumpTestWidget(
      tester,
      child: Consumer(
        builder: (context, ref, child) =>
            MaterialApp(home: Text(ref.watch(_labelProvider))),
      ),
    );
    expect(find.text('default'), findsOneWidget);
  });
}
