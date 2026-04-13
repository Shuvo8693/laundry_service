import 'package:dio/dio.dart';
import 'package:e_laundry/core/entities/session_data.dart';

class NetworkInterceptor extends Interceptor {
  static const List<String> authEndpoints = [
    '/login',
    '/register',
    '/forgot-password',
    '/reset-password',
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add language header
    final languageCode = SessionData.currentLanguage ?? 'en';
    options.headers['Accept-Language'] = languageCode;

    // Add authorization token for non-auth endpoints
    final isAuthEndpoint = authEndpoints.any(
      (endpoint) => options.path.contains(endpoint),
    );

    if (!isAuthEndpoint &&
        !options.headers.containsKey('Authorization') &&
        SessionData.getUserData?.token.isNotEmpty == true) {
      options.headers.addAll({
        'Authorization': 'Bearer ${SessionData.getUserData?.token}',
      });
    }

    super.onRequest(options, handler);
  }
}
