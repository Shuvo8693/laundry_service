import 'package:dio/dio.dart';
import 'package:e_laundry/core/entities/session_data.dart';

class LanguageInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add language code header from session data or default to 'en'
    final languageCode = SessionData.currentLanguage ?? 'en';
    options.headers['Accept-Language'] = languageCode;
    options.queryParameters['lang'] = languageCode;

    super.onRequest(options, handler);
  }
}
