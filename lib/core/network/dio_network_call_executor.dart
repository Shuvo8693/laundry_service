import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../entities/connection_error.dart';
import '../entities/json_serializer.dart';
import '../entities/network_error_converter.dart';
import '../error/failures.dart';
import 'network_caller.dart';

/// Dio-based implementation of NetworkCaller
///
/// This implementation uses Dio for HTTP requests and integrates with:
/// - JsonSerializer for JSON encoding/decoding
/// - NetworkErrorConverter for error handling
/// - ConnectivityResult for network status checking
class DioNetworkCallExecutor implements NetworkCaller {
  /// Dio HTTP client instance
  final Dio dio;

  /// JSON serializer for encoding/decoding
  final JsonSerializer dioSerializer;

  /// Error converter for transforming exceptions to failures
  final NetworkErrorConverter<Failure> errorConverter;

  /// Connectivity result from session data
  final ConnectivityResult connectivityResult;

  DioNetworkCallExecutor({
    required this.dio,
    required this.dioSerializer,
    required this.errorConverter,
    required this.connectivityResult,
  });

  /// Checks if network is available
  Future<bool> _isNetworkAvailable() async {
    // Check session connectivity result
    if (connectivityResult == ConnectivityResult.none) {
      // Try to refresh connectivity status
      try {
        final List<ConnectivityResult> results = await Connectivity()
            .checkConnectivity();
        return results.isNotEmpty && results.first != ConnectivityResult.none;
      } catch (e) {
        return false;
      }
    }
    return connectivityResult != ConnectivityResult.none;
  }

  /// Generic request executor
  Future<Either<Failure, NetworkResponse<T>>> _executeRequest<T>({
    required String url,
    required HttpMethod method,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  }) async {
    try {
      // Check network connectivity
      final isAvailable = await _isNetworkAvailable();
      if (!isAvailable) {
        final connectionError = const ConnectionError(
          type: ConnectionErrorType.noInternet,
        );
        return Left(
          errorConverter.convert(Exception(connectionError.toString())),
        );
      }

      // Prepare options
      Options? options;
      if (headers != null && headers.isNotEmpty) {
        options = Options(
          headers: headers.map((key, value) => MapEntry(key, value.toString())),
        );
      }

      // Execute request based on HTTP method
      Response<dynamic> response;
      switch (method) {
        case HttpMethod.get:
          response = await dio.get(
            url,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.post:
          response = await dio.post(
            url,
            data: body,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.put:
          response = await dio.put(
            url,
            data: body,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.delete:
          response = await dio.delete(
            url,
            data: body,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.patch:
          response = await dio.patch(
            url,
            data: body,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.head:
          response = await dio.head(
            url,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.options:
          response = dio.options as Response<dynamic>;
          break;
      }

      // Deserialize response data if deserializer provided
      T? deserializedData;
      if (responseDeserializer != null && response.data != null) {
        deserializedData = responseDeserializer(response.data);
      } else {
        deserializedData = response.data as T?;
      }

      // Extract headers as Map<String, String>
      final Map<String, String> responseHeaders = {};
      response.headers.map.forEach((key, values) {
        if (values.isNotEmpty) {
          responseHeaders[key] = values.first;
        }
      });

      return Right(
        NetworkResponse<T>(
          statusCode: response.statusCode ?? 0,
          data: deserializedData,
          headers: responseHeaders,
          rawResponse: response.data,
        ),
      );
    } catch (e) {
      // Convert exception to failure using error converter
      final Exception exception = e is Exception ? e : Exception(e.toString());
      return Left(errorConverter.convert(exception));
    }
  }

  @override
  Future<Either<Failure, NetworkResponse<T>>> get<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  }) {
    return _executeRequest<T>(
      url: url,
      method: HttpMethod.get,
      queryParameters: queryParameters,
      headers: headers,
      responseDeserializer: responseDeserializer,
    );
  }

  @override
  Future<Either<Failure, NetworkResponse<T>>> post<T>({
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  }) {
    return _executeRequest<T>(
      url: url,
      method: HttpMethod.post,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      responseDeserializer: responseDeserializer,
    );
  }

  @override
  Future<Either<Failure, NetworkResponse<T>>> put<T>({
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  }) {
    return _executeRequest<T>(
      url: url,
      method: HttpMethod.put,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      responseDeserializer: responseDeserializer,
    );
  }

  @override
  Future<Either<Failure, NetworkResponse<T>>> delete<T>({
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  }) {
    return _executeRequest<T>(
      url: url,
      method: HttpMethod.delete,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      responseDeserializer: responseDeserializer,
    );
  }

  @override
  Future<Either<Failure, NetworkResponse<T>>> patch<T>({
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  }) {
    return _executeRequest<T>(
      url: url,
      method: HttpMethod.patch,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      responseDeserializer: responseDeserializer,
    );
  }

  @override
  Future<Either<Failure, NetworkResponse<T>>> request<T>({
    required String url,
    required HttpMethod method,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? responseDeserializer,
  }) {
    return _executeRequest<T>(
      url: url,
      method: method,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      responseDeserializer: responseDeserializer,
    );
  }
}
