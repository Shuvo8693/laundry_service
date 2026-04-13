import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌──────────────────────────────────────────────────────────');
      print('│ REQUEST');
      print('├──────────────────────────────────────────────────────────');
      print('│ Method: ${options.method}');
      print('│ URL: ${options.baseUrl}${options.path}');
      print('│ Headers: ${options.headers}');
      print('│ Query Parameters: ${options.queryParameters}');
      if (options.data != null) {
        print('│ Body: ${options.data}');
      }
      print('└──────────────────────────────────────────────────────────');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌──────────────────────────────────────────────────────────');
      print('│ RESPONSE');
      print('├──────────────────────────────────────────────────────────');
      print('│ Status Code: ${response.statusCode}');
      print('│ URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}');
      print('│ Headers: ${response.headers}');
      print('│ Data: ${response.data}');
      print('└──────────────────────────────────────────────────────────');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌──────────────────────────────────────────────────────────');
      print('│ ERROR');
      print('├──────────────────────────────────────────────────────────');
      print('│ Status Code: ${err.response?.statusCode}');
      print('│ URL: ${err.requestOptions.baseUrl}${err.requestOptions.path}');
      print('│ Type: ${err.type}');
      print('│ Message: ${err.message}');
      if (err.response?.data != null) {
        print('│ Error Data: ${err.response?.data}');
      }
      print('└──────────────────────────────────────────────────────────');
    }
    super.onError(err, handler);
  }
}
