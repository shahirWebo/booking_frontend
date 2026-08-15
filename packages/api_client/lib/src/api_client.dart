import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:turf_booking_core/turf_booking_core.dart';

import 'interceptors.dart';

/// HTTP methods supported by the shared API transport.
enum ApiHttpMethod {
  get,
  post,
  put,
  patch,
  delete,
}

/// An immutable request relative to the configured versioned API base URL.
class ApiRequest {
  ApiRequest({
    required this.method,
    required this.path,
    Map<String, String> headers = const {},
    Map<String, String> queryParameters = const {},
    List<int>? bodyBytes,
  })  : headers = Map.unmodifiable(headers),
        queryParameters = Map.unmodifiable(queryParameters),
        bodyBytes = bodyBytes == null ? null : Uint8List.fromList(bodyBytes) {
    _validatePath(path);
  }

  final ApiHttpMethod method;
  final String path;
  final Map<String, String> headers;
  final Map<String, String> queryParameters;
  final Uint8List? bodyBytes;

  /// Returns a request with replacement headers while preserving its payload.
  ApiRequest copyWith({Map<String, String>? headers}) {
    return ApiRequest(
      method: method,
      path: path,
      headers: headers ?? this.headers,
      queryParameters: queryParameters,
      bodyBytes: bodyBytes,
    );
  }

  static void _validatePath(String value) {
    final uri = Uri.tryParse(value);
    if (value.startsWith('/') ||
        uri == null ||
        uri.hasScheme ||
        uri.hasAuthority ||
        uri.hasQuery ||
        uri.hasFragment ||
        value.split('/').contains('..')) {
      throw ArgumentError.value(
        value,
        'path',
        'API request paths must be relative and cannot leave the API base URL.',
      );
    }
  }
}

/// The un-decoded HTTP response returned by [ApiClient].
class ApiResponse {
  ApiResponse({
    required this.statusCode,
    required Map<String, String> headers,
    required List<int> bodyBytes,
  })  : headers = Map.unmodifiable(headers),
        bodyBytes = Uint8List.fromList(bodyBytes);

  final int statusCode;
  final Map<String, String> headers;
  final Uint8List bodyBytes;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  /// The server-accepted correlation identifier, if it was returned.
  String? get requestID {
    for (final header in headers.entries) {
      if (header.key.toLowerCase() == 'x-request-id') {
        return header.value;
      }
    }

    return null;
  }
}

/// A safe transport failure that contains no request body or credential data.
class ApiTransportException implements Exception {
  const ApiTransportException(this.message);

  final String message;

  @override
  String toString() => 'ApiTransportException: $message';
}

/// Shared HTTP transport constructed explicitly by each application's bootstrap.
///
/// It deliberately performs no authentication, request-ID, retry, or API
/// envelope work. Those cross-cutting policies are added by later tasks.
class ApiClient {
  ApiClient({
    required ApiConfiguration configuration,
    http.Client? httpClient,
    List<ApiInterceptor>? interceptors,
    this.requestTimeout = const Duration(seconds: 15),
  })  : _baseUrl = configuration.baseUrl,
        _httpClient = httpClient ?? http.Client(),
        _interceptors = List.unmodifiable(
          interceptors ?? [RequestIDInterceptor()],
        );

  final Uri _baseUrl;
  final http.Client _httpClient;
  final List<ApiInterceptor> _interceptors;
  final Duration requestTimeout;

  Future<ApiResponse> get(
    String path, {
    Map<String, String> headers = const {},
    Map<String, String> queryParameters = const {},
  }) {
    return send(
      ApiRequest(
        method: ApiHttpMethod.get,
        path: path,
        headers: headers,
        queryParameters: queryParameters,
      ),
    );
  }

  Future<ApiResponse> send(ApiRequest apiRequest) async {
    var interceptedRequest = apiRequest;

    try {
      for (final interceptor in _interceptors) {
        interceptedRequest = await interceptor.onRequest(interceptedRequest);
      }

      var response = await _send(interceptedRequest);
      for (final interceptor in _interceptors.reversed) {
        response = await interceptor.onResponse(interceptedRequest, response);
      }

      return response;
    } on ApiTransportException catch (exception) {
      var interceptedException = exception;
      for (final interceptor in _interceptors.reversed) {
        interceptedException = await interceptor.onError(
          interceptedRequest,
          interceptedException,
        );
      }

      throw interceptedException;
    }
  }

  Future<ApiResponse> _send(ApiRequest apiRequest) async {
    final request = http.Request(
      apiRequest.method.name.toUpperCase(),
      _resolveUri(apiRequest),
    )
      ..headers.addAll(apiRequest.headers);

    if (apiRequest.bodyBytes != null) {
      request.bodyBytes = apiRequest.bodyBytes!;
    }

    try {
      final streamedResponse = await _httpClient
          .send(request)
          .timeout(requestTimeout);
      final response = await http.Response.fromStream(streamedResponse);

      return ApiResponse(
        statusCode: response.statusCode,
        headers: response.headers,
        bodyBytes: response.bodyBytes,
      );
    } on TimeoutException {
      throw ApiTransportException('The API request timed out.');
    } on http.ClientException {
      throw ApiTransportException('The API request could not be completed.');
    }
  }

  /// Releases the underlying reusable HTTP connections when an app shuts down.
  void close() => _httpClient.close();

  Uri _resolveUri(ApiRequest request) {
    final basePath = _baseUrl.path.endsWith('/')
        ? _baseUrl.path
        : '${_baseUrl.path}/';

    return _baseUrl
        .replace(path: basePath)
        .resolve(request.path)
        .replace(queryParameters: request.queryParameters);
  }
}
