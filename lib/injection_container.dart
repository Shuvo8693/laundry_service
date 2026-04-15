import 'package:dio/dio.dart';
import 'package:e_laundry/core/entities/json_serializer.dart';
import 'package:e_laundry/core/network/dio_network_call_executor.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_laundry/core/config/app_config.dart';
import 'package:e_laundry/core/entities/error_converter.dart';
import 'package:e_laundry/core/entities/session_data.dart';
import 'package:e_laundry/core/logger/logging_interceptors.dart';
import 'package:e_laundry/core/logger/app_logger.dart';
import 'package:e_laundry/core/services/interceptors/language_interceptor.dart';
import 'package:e_laundry/core/services/interceptors/network_interceptor.dart';
import 'package:e_laundry/core/navigation/cubit/navigation_cubit.dart';
import 'package:e_laundry/core/localization/cubit/language_cubit.dart';
import 'package:e_laundry/features/auth/domain/repositories/auth_repository.dart';
import 'package:e_laundry/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:e_laundry/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:e_laundry/features/splash/data/datasources/mock_splash_datasource.dart';
import 'package:e_laundry/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:e_laundry/features/splash/domain/repositories/splash_repository.dart';
import 'package:e_laundry/features/splash/presentation/cubit/splash/splash_cubit.dart';
import 'package:e_laundry/features/onboarding/data/datasources/mock_onboarding_datasource.dart';
import 'package:e_laundry/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:e_laundry/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:e_laundry/features/onboarding/presentation/cubit/onboarding/onboarding_cubit.dart';

final di = GetIt.instance;

Future<void> setUpNetworkExecutor() async {
  // Register Dio instance
  di.registerSingleton(
    Dio(
      BaseOptions(
        baseUrl: di<AppConfig>().baseUrl,
        headers: {"accept": "application/json"},
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
        sendTimeout: const Duration(milliseconds: 30000),
      ),
    ),
  );

  // Add interceptors
  di<Dio>().interceptors.addAll([
    LanguageInterceptor(),
    NetworkInterceptor(),
    LoggingInterceptors(),
  ]);

  // Register JSON Serializer
  di.registerSingleton(JsonSerializer());

  // Register Error Converter
  di.registerFactory(() => ErrorConverter());

  // Register DioNetworkCallExecutor
  di.registerLazySingleton(
    () => DioNetworkCallExecutor(
      errorConverter: di<ErrorConverter>(),
      dio: di<Dio>(),
      dioSerializer: di<JsonSerializer>(),
      connectivityResult: SessionData.connectivityResult,
    ),
  );
}

Future<void> setUpPreference() async {
  di.registerSingleton(await SharedPreferences.getInstance());
}

Future<void> _initializeLanguage() async {
  final sharedPreferences = di<SharedPreferences>();
  const languageKey = 'language_code';

  final String? languageCode = sharedPreferences.getString(languageKey);
  SessionData.currentLanguage = languageCode ?? 'en';
}

Future<void> initDI(AppConfig config) async {
  await SessionData.start();

  di.registerSingleton(config);

  // Logger
  logger.init(enableLogging: config.isLoggerEnabled);

  // Preference
  await setUpPreference();

  // Initialize language early before any network calls
  await _initializeLanguage();

  // Network executor
  await setUpNetworkExecutor();

  // Navigation
  di.registerLazySingleton(() => NavigationCubit());

  // Localization
  di.registerFactory(() => LanguageCubit(sharedPreferences: di()));

  // Repositories & Data Sources (Blueprint examples)
  di.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(sharedPreferences: di()),
  );

  di.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: di()),
  );

  // Splash
  di.registerLazySingleton(() => MockSplashDataSource());
  di.registerLazySingleton<SplashRepository>(
    () => SplashRepositoryImpl(mockDataSource: di()),
  );
  di.registerFactory(
    () => SplashCubit(splashRepository: di(), authRepository: di()),
  );

  // Onboarding
  di.registerLazySingleton(() => MockOnboardingDataSource());
  di.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(mockDataSource: di()),
  );
  di.registerFactory(
    () => OnboardingCubit(onboardingRepository: di()),
  );

  // Home
  // di.registerLazySingleton(() => MockHomeDataSource());
  // di.registerLazySingleton<HomeRepository>(
  //   () => HomeRepositoryImpl(mockDataSource: di()),
  // );
  // di.registerFactory(
  //   () => HomeCubit(homeRepository: di()),
  // );
}
