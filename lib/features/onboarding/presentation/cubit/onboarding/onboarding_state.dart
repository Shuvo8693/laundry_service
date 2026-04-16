import 'package:equatable/equatable.dart';
import 'package:e_laundry/features/onboarding/domain/entities/onboarding_page_entity.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final List<OnboardingPageEntity> pages;

  const OnboardingLoaded(this.pages);

  @override
  List<Object?> get props => [pages];
}

class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object?> get props => [message];
}

class OnboardingNavigateToSignUp extends OnboardingState {}
