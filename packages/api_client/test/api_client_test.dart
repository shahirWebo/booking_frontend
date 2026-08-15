import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:turf_booking_api_client/turf_booking_api_client.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

void main() {
  ApiClient createClient(
    http.Client httpClient, {
    Duration? timeout,
    List<ApiInterceptor>? interceptors,
  }) {
    return ApiClient(
      configuration: ApiConfiguration.fromBaseUrl(
        environment: AppEnvironment.staging,
        baseUrl: 'https://staging-api.example.invalid/api/v1',
      ),
      httpClient: httpClient,
      interceptors: interceptors,
      requestTimeout: timeout ?? const Duration(seconds: 1),
    );
  }

  test('applies request hooks forward and response hooks in reverse', () async {
    final calls = <String>[];
    final client = createClient(
      MockClient((request) async {
        expect(request.headers['First'], 'request');
        expect(request.headers['Second'], 'request');
        return http.Response('', 204);
      }),
      interceptors: [
        _RecordingInterceptor('First', calls),
        _RecordingInterceptor('Second', calls),
      ],
    );

    await client.get('health');

    expect(calls, [
      'First request',
      'Second request',
      'Second response',
      'First response',
    ]);
  });

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

  test(
    'maps documented validation errors to a typed response exception',
    () async {
      final client = createClient(
        MockClient(
          (_) async => http.Response(
            '{"success":false,"code":"VALIDATION_ERROR","message":"The request contains invalid fields.","errors":{"mobile":["Enter a valid mobile number."]},"meta":{"request_id":"01ARZ3NDEKTSV4RRFFQ69G5FAV"}}',
            422,
          ),
        ),
      );

      await expectLater(
        client.send(
          ApiRequest(method: ApiHttpMethod.post, path: 'customer/bookings'),
        ),
        throwsA(
          isA<ApiResponseException>()
              .having((error) => error.statusCode, 'status code', 422)
              .having((error) => error.kind, 'kind', ApiErrorKind.validation)
              .having((error) => error.code, 'code', 'VALIDATION_ERROR')
              .having((error) => error.fieldErrors, 'field errors', {
                'mobile': ['Enter a valid mobile number.'],
              })
              .having(
                (error) => error.requestID,
                'request ID',
                '01ARZ3NDEKTSV4RRFFQ69G5FAV',
              ),
        ),
      );
    },
  );

  test('uses safe fallbacks for malformed API error responses', () async {
    final client = createClient(
      MockClient((_) async => http.Response('<html>Unavailable</html>', 503)),
    );

    await expectLater(
      client.get('health'),
      throwsA(
        isA<ApiResponseException>()
            .having((error) => error.kind, 'kind', ApiErrorKind.server)
            .having((error) => error.code, 'code', 'UNEXPECTED_RESPONSE')
            .having(
              (error) => error.message,
              'message',
              'The request could not be completed.',
            ),
      ),
    );
  });

  test(
    'adds a valid request ID and exposes the server-accepted response ID',
    () async {
      late http.Request capturedRequest;
      final client = createClient(
        MockClient((request) async {
          capturedRequest = request;
          return http.Response(
            '',
            204,
            headers: const {'x-request-id': '01ARZ3NDEKTSV4RRFFQ69G5FAV'},
          );
        }),
      );

      final response = await client.get('health');

      expect(
        capturedRequest.headers['X-Request-ID'],
        matches(RegExp(r'^[0-7][0-9A-HJKMNP-TV-Z]{25}$')),
      );
      expect(response.requestID, '01ARZ3NDEKTSV4RRFFQ69G5FAV');
    },
  );

  test('preserves an explicit request ID supplied by a caller', () async {
    late http.Request capturedRequest;
    final client = createClient(
      MockClient((request) async {
        capturedRequest = request;
        return http.Response('', 204);
      }),
    );

    await client.get(
      'health',
      headers: const {'x-request-id': '01ARZ3NDEKTSV4RRFFQ69G5FAV'},
    );

    expect(
      capturedRequest.headers['x-request-id'],
      '01ARZ3NDEKTSV4RRFFQ69G5FAV',
    );
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

  test(
    'allows error interceptors to replace safe transport failures',
    () async {
      final client = createClient(
        MockClient((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 20));
          return http.Response('', 200);
        }),
        timeout: const Duration(milliseconds: 1),
        interceptors: const [_ErrorMappingInterceptor()],
      );

      await expectLater(
        client.get('health'),
        throwsA(
          isA<ApiTransportException>().having(
            (exception) => exception.message,
            'message',
            'A replacement safe failure.',
          ),
        ),
      );
    },
  );
}

class _RecordingInterceptor extends ApiInterceptor {
  const _RecordingInterceptor(this.name, this.calls);

  final String name;
  final List<String> calls;

  @override
  ApiRequest onRequest(ApiRequest request) {
    calls.add('$name request');
    return request.copyWith(headers: {...request.headers, name: 'request'});
  }

  @override
  ApiResponse onResponse(ApiRequest request, ApiResponse response) {
    calls.add('$name response');
    return response;
  }
}

class _ErrorMappingInterceptor extends ApiInterceptor {
  const _ErrorMappingInterceptor();

  @override
  ApiTransportException onError(
    ApiRequest request,
    ApiTransportException exception,
  ) {
    return const ApiTransportException('A replacement safe failure.');
  }
}
