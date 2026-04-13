import 'package:equatable/equatable.dart';
import '../error/failures.dart';
import 'error_code.dart';
import 'error_message_mapper.dart';

class ApiError extends Equatable implements Failure {
  final int statusCode;
  final String errorCode;
  final String _message;
  final dynamic exception;

  const ApiError({
    this.statusCode = 0,
    this.errorCode = '',
    String message = "",
    this.exception,
  }) : _message = message;

  String get parsedErrorCodeMessage {
    String errorMessage = ErrorMessageMapper.getErrorMessage(errorCode.trim());
    if (errorMessage == 'Unknown error') {
      errorMessage = _message;
    }

    return errorMessage;
  }

  String parseErrorCodeMessage({String? extra}) {
    return "${ErrorMessageMapper.getErrorMessage(errorCode)}${extra ??= _message}";
  }

  static ApiError get networkError => ApiError(
    statusCode: ErrorCode.connectionTimeOut,
    errorCode: 'no_internet_connection',
    message: 'You are offline. Check you internet connection.',
  );

  static ApiError connectionError({required int statusCode}) => ApiError(
    statusCode: statusCode,
    message:
    'Connection Timeout: Unable to establish a connection. Please try again.',
  );

  @override
  List<Object> get props => [statusCode, errorCode, _message];

  @override
  String get message => _message.isNotEmpty ? _message : parsedErrorCodeMessage;
}

class ApiErrors extends Equatable implements Failure {
  final List<ApiError> apiErrors;

  const ApiErrors(this.apiErrors);

  @override
  String get message => apiErrors.map((e) => e.message).join('; ');

  @override
  List<Object> get props => [apiErrors];
}
