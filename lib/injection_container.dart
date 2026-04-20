import 'package:dio/dio.dart';
import 'package:e_laundry/core/entities/json_serializer.dart';
import 'package:e_laundry/core/network/dio_network_call_executor.dart';
import 'package:e_laundry/features/service/data/repositories/service_repository_impl.dart';
import 'package:e_laundry/features/service/domain/repositories/service_repository.dart';
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
import 'package:e_laundry/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:e_laundry/features/auth/domain/usecases/login_usecase.dart';
import 'package:e_laundry/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:e_laundry/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:e_laundry/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:e_laundry/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:e_laundry/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:e_laundry/features/splash/data/datasources/mock_splash_datasource.dart';
import 'package:e_laundry/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:e_laundry/features/splash/domain/repositories/splash_repository.dart';
import 'package:e_laundry/features/splash/presentation/cubit/splash/splash_cubit.dart';
import 'package:e_laundry/features/onboarding/data/datasources/mock_onboarding_datasource.dart';
import 'package:e_laundry/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:e_laundry/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:e_laundry/features/onboarding/presentation/cubit/onboarding/onboarding_cubit.dart';
import 'package:e_laundry/features/home/domain/repositories/home_repository.dart';
import 'package:e_laundry/features/home/data/repositories/home_repository_impl.dart';
import 'package:e_laundry/features/home/data/datasources/home_local_data_source.dart';
import 'package:e_laundry/features/home/domain/usecases/get_home_data.dart';
import 'package:e_laundry/features/home/presentation/cubit/home_cubit.dart';
import 'package:e_laundry/features/service/data/datasources/service_local_data_source.dart';
import 'package:e_laundry/features/service/presentation/cubit/service_cubit.dart';
import 'package:e_laundry/features/order/domain/repositories/order_repository.dart';
import 'package:e_laundry/features/order/data/repositories/order_repository_impl.dart';
import 'package:e_laundry/features/order/data/datasources/order_local_data_source.dart';
import 'package:e_laundry/features/order/domain/usecases/get_active_orders.dart';
import 'package:e_laundry/features/order/domain/usecases/get_completed_orders.dart';
import 'package:e_laundry/features/order/domain/usecases/get_order_details.dart';
import 'package:e_laundry/features/order/presentation/cubit/order_cubit.dart';

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
    () => AuthLocalDataSourceImpl(),
  );

  di.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: di()),
  );

  // Auth UseCases
  di.registerLazySingleton(() => LoginUseCase(di()));
  di.registerLazySingleton(() => SignUpUseCase(di()));
  di.registerLazySingleton(() => VerifyOtpUseCase(di()));
  di.registerLazySingleton(() => ResetPasswordUseCase(di()));
  di.registerLazySingleton(() => SendOtpUseCase(di()));

  // Auth Cubit
  di.registerFactory(
    () => AuthCubit(
      loginUseCase: di(),
      signUpUseCase: di(),
      verifyOtpUseCase: di(),
      resetPasswordUseCase: di(),
      sendOtpUseCase: di(),
    ),
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
  di.registerFactory(() => OnboardingCubit(onboardingRepository: di()));

  // Home
  di.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(),
  );
  di.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(localDataSource: di()),
  );
  di.registerLazySingleton(() => GetHomeData(di()));
  di.registerFactory(() => HomeCubit(getHomeData: di()));

  // Service
  di.registerLazySingleton<ServiceLocalDataSource>(
    () => ServiceLocalDataSourceImpl(),
  );
  di.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(localDataSource: di()),
  );
  di.registerLazySingleton(() => ServiceCubit(repository: di()));

  // ── Order ───────────────────────────────────────────────────────────
  // 1. Data Sources
  di.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSourceImpl(),
  );

  // 2. Repository
  di.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(localDataSource: di()),
  );

  // 3. Use Cases
  di.registerLazySingleton(() => GetActiveOrders(di()));
  di.registerLazySingleton(() => GetCompletedOrders(di()));
  di.registerLazySingleton(() => GetOrderDetails(di()));

  // 4. Cubit
  di.registerFactory(
    () => OrderCubit(
      getActiveOrdersUseCase: di(),
      getCompletedOrdersUseCase: di(),
      getOrderDetailsUseCase: di(),
    ),
  );
}
