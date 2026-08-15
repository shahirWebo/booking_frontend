import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:turf_booking_api_client/turf_booking_api_client.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

void main() {
  ApiClient createClient(http.Client httpClient, {Duration? timeout}) {
    return ApiClient(
      configuration: ApiConfiguration.fromBaseUrl(
        environment: AppEnvironment.staging,
        baseUrl: 'https://staging-api.example.invalid/api/v1',
      ),
      httpClient: httpClient,
      requestTimeout: timeout ?? const Duration(seconds: 1),
    );
  }

  test('sends a relative request to the configured API base URL', () async {
    late http.Request capturedRequest;
    final client = createClient(
      MockClient((request) async {
        capturedRequest = request;
        return http.Response('{"success":true}', 200);
      }),
    );

    final response = await client.get(
      'health',
      headers: const {'Accept': 'application/json'},
      queryParameters: const {'verbose': '1'},
    );

    expect(capturedRequest.method, 'GET');
    expect(
      capturedRequest.url,
      Uri.parse('https://staging-api.example.invalid/api/v1/health?verbose=1'),
    );
    expect(capturedRequest.headers['Accept'], 'application/json');
    expect(response.statusCode, 200);
    expect(response.isSuccess, isTrue);
  });

  test('returns non-success responses for common API error decoding', () async {
    final client = createClient(
      MockClient((_) async => http.Response('{"success":false}', 422)),
    );

    final response = await client.send(
      ApiRequest(method: ApiHttpMethod.post, path: 'customer/bookings'),
    );

    expect(response.statusCode, 422);
    expect(response.isSuccess, isFalse);
    expect(response.bodyBytes, utf8.encode('{"success":false}'));
  });

  test('does not permit paths that bypass the configured API version', () {
    expect(
      () => ApiRequest(method: ApiHttpMethod.get, path: '/health'),
      throwsArgumentError,
    );
    expect(
      () => ApiRequest(
        method: ApiHttpMethod.get,
        path: 'https://other.example.invalid/api/v1/health',
      ),
      throwsArgumentError,
    );
    expect(
      () => ApiRequest(method: ApiHttpMethod.get, path: '../health'),
      throwsArgumentError,
    );
  });

  test('maps request timeouts to a safe transport exception', () async {
    final client = createClient(
      MockClient((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return http.Response('', 200);
      }),
      timeout: const Duration(milliseconds: 1),
    );

    await expectLater(
      client.get('health'),
      throwsA(isA<ApiTransportException>()),
    );
  });
}
