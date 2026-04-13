import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_laundry/core/entities/connection_error.dart';
import 'package:e_laundry/core/entities/network_error_converter.dart';
import 'package:flutter/foundation.dart';
import '../error/failures.dart';
import 'api_error.dart';
import 'error_code.dart';

class ErrorConverter implements NetworkErrorConverter<Failure> {
  ErrorConverter();

  @override
  Failure convert(Exception exception) {
    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.cancel:
          return ApiError(statusCode: ErrorCode.cancel);
        case DioExceptionType.connectionTimeout:
          return ApiError.connectionError(
            statusCode: ErrorCode.connectionTimeOut,
          );
        case DioExceptionType.sendTimeout:
          return ApiError.connectionError(statusCode: ErrorCode.sendTimeout);
        case DioExceptionType.receiveTimeout:
          return ApiError.connectionError(statusCode: ErrorCode.receiveTimeout);
        case DioExceptionType.badResponse:
          if (exception.response != null && exception.response?.data != null) {
            dynamic responseError = {
              'error_code': 'something_went_wrong',
              'error_message': 'Something went wrong',
            };

            if (exception.response?.data is String) {
              final responseData = exception.response?.data as String;
              if (responseData.trim().startsWith('<!DOCTYPE html>') ||
                  responseData.trim().startsWith('<html>')) {
                return ApiError(
                  statusCode: exception.response!.statusCode!,
                  errorCode: 'redirect_error',
                  message: 'Server error. Please try again later.',
                );
              }
              try {
                responseError = jsonDecode(responseData);
              } catch (e) {
                if (kDebugMode) {
                  print('Failed to parse JSON response: $e');
                }
                return ApiError(
                  statusCode: exception.response!.statusCode!,
                  errorCode: 'invalid_response',
                  message: 'Invalid server response. Please try again.',
                );
              }
            } else {
              responseError = exception.response?.data;
            }

            if (responseError is List) {
              final List<ApiError> apiErrors = [];
              for (var error in responseError) {
                apiErrors.add(
                  _deserialize(error, exception.response!.statusCode!),
                );
              }
              return ApiErrors(apiErrors);
            }

            return _deserialize(responseError, exception.response!.statusCode!);
          } else {
            return ApiError(
              statusCode: ErrorCode.unexpected,
              exception:
                  '''error: ${exception.error}\nresponse: ${exception.response?.data}''',
            );
          }
        case DioExceptionType.unknown:
          // Check connectivity if possible
          return ApiError(
            statusCode: ErrorCode.defaultError,
            message: "Something went wrong",
            exception: exception.error,
          );

        default:
          return ApiError(
            statusCode: ErrorCode.unexpected,
            exception:
                '''error: ${exception.error}\nresponse: ${exception.response?.data}''',
          );
      }
    } else if (exception is ConnectionError) {
      switch (exception.type) {
        case ConnectionErrorType.noInternet:
          return ApiError.networkError;
      }
    } else {
      return ApiError(
        statusCode: ErrorCode.unexpected,
        exception: '''error: ${exception.toString()}''',
      );
    }
  }

  ApiError _deserialize(dynamic error, int statusCode) {
    if (error is! Map<String, dynamic>) {
      return ApiError(
        statusCode: statusCode,
        errorCode: 'error',
        message: error?.toString() ?? 'Something went wrong',
      );
    }

    final errors = error['errors'];
    if (errors is Map && errors.keys.isNotEmpty) {
      return ApiError(
        statusCode: statusCode,
        errorCode: 'error',
        message: (errors[errors.keys.first] is List)
            ? (errors[errors.keys.first] as List).first
            : errors[errors.keys.first],
      );
    }
    final errorNode = error['error'];
    final errorMap = errorNode is Map<String, dynamic> ? errorNode : null;
    return ApiError(
      statusCode: statusCode,
      errorCode: errorMap?['error_code'] ?? error['error_code'] ?? 'error',
      message:
          errorMap?['error_message'] ??
          error['message'] ??
          error['error_data'] ??
          (errorMap?.values.isNotEmpty == true
              ? errorMap!.values.first.toString()
              : '') ??
          '',
    );
  }
}
