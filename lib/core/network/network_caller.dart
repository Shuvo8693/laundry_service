import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// HTTP method enumeration
enum HttpMethod { get, post, put, delete, patch, head, options }

/// Response wrapper for network calls
class NetworkResponse<T> {
  /// HTTP status code
  final int statusCode;

  /// Response data
  final T? data;

  /// Response headers
  final Map<String, String> headers;

  /// Raw response
  final dynamic rawResponse;

  const NetworkResponse({
    required this.statusCode,
    this.data,
    this.headers = const {},
    this.rawResponse,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

/// Abstract base class for network callers
///
/// This class defines the contract for making HTTP requests.
/// Implementations should handle the actual network communication.
abstract class NetworkCaller {
  /// Performs a GET request
  Future<Either<Failure, NetworkResponse<T>>> get<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  });

  /// Performs a POST request
  Future<Either<Failure, NetworkResponse<T>>> post<T>({
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  });

  /// Performs a PUT request
  Future<Either<Failure, NetworkResponse<T>>> put<T>({
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  });

  /// Performs a DELETE request
  Future<Either<Failure, NetworkResponse<T>>> delete<T>({
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  });

  /// Performs a PATCH request
  Future<Either<Failure, NetworkResponse<T>>> patch<T>({
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  });

  /// Performs a request with custom HTTP method
  Future<Either<Failure, NetworkResponse<T>>> request<T>({
    required String url,
    required HttpMethod method,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  });
}
