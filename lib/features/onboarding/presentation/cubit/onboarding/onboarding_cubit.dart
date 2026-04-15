import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:e_laundry/features/onboarding/presentation/cubit/onboarding/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepository onboardingRepository;

  OnboardingCubit({required this.onboardingRepository})
      : super(OnboardingInitial());

  Future<void> loadOnboardingPages() async {
    emit(OnboardingLoading());

    final result = await onboardingRepository.getOnboardingPages();

    result.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (pages) => emit(OnboardingLoaded(pages)),
    );
  }

  void navigateToLogin() {
    emit(OnboardingNavigateToLogin());
  }
}
