import 'dart:async';
import 'dart:math';

import 'api_client.dart';

/// Hooks applied around a shared API request.
///
/// Request hooks run in registration order. Response and transport-error hooks
/// run in reverse order, allowing an interceptor to reliably wrap its own work.
abstract class ApiInterceptor {
  const ApiInterceptor();

  FutureOr<ApiRequest> onRequest(ApiRequest request) => request;

  FutureOr<ApiResponse> onResponse(ApiRequest request, ApiResponse response) =>
      response;

  FutureOr<ApiTransportException> onError(
    ApiRequest request,
    ApiTransportException exception,
  ) => exception;
}

/// Creates an API-compatible uppercase ULID for request correlation.
class ULIDRequestIDGenerator {
  ULIDRequestIDGenerator({Random? random})
    : _random = random ?? Random.secure();

  static const _alphabet = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

  final Random _random;

  String call() {
    var timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    final characters = List<String>.filled(26, '0');

    for (var index = 9; index >= 0; index--) {
      characters[index] = _alphabet[timestamp & 31];
      timestamp >>= 5;
    }

    for (var index = 10; index < characters.length; index++) {
      characters[index] = _alphabet[_random.nextInt(_alphabet.length)];
    }

    return characters.join();
  }
}

/// Adds an opaque request correlation ID unless a caller already supplied one.
class RequestIDInterceptor extends ApiInterceptor {
  RequestIDInterceptor({String Function()? requestIDGenerator})
    : _requestIDGenerator = requestIDGenerator ?? _generateRequestID;

  static final _defaultGenerator = ULIDRequestIDGenerator();
  final String Function() _requestIDGenerator;

  static String _generateRequestID() => _defaultGenerator();

  @override
  ApiRequest onRequest(ApiRequest request) {
    if (request.headers.keys.any(
      (header) => header.toLowerCase() == 'x-request-id',
    )) {
      return request;
    }

    return request.copyWith(
      headers: {...request.headers, 'X-Request-ID': _requestIDGenerator()},
    );
  }
}
