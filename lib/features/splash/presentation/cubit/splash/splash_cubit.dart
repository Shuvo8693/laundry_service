import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/features/auth/domain/repositories/auth_repository.dart';
import 'package:e_laundry/features/splash/domain/repositories/splash_repository.dart';
import 'package:e_laundry/features/splash/presentation/cubit/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashRepository splashRepository;
  final AuthRepository authRepository;

  SplashCubit({required this.splashRepository, required this.authRepository})
    : super(SplashInitial());

  Future<void> initializeData() async {
    emit(SplashLoading());

    // 1. Fetch Splash Data from Repository
    final result = await splashRepository.getSplashPageData();

    result.fold((failure) => emit(SplashError(failure.message)), (data) {
      emit(SplashLoaded(data));
    });

    // 2. Initial Auth Check and Navigation Delay
    await Future.delayed(const Duration(seconds: 3)); // Minimum splash duration

    final isLoggedIn = await authRepository.isLoggedIn();
    if (!isLoggedIn) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToLogin());
    }
  }
}
