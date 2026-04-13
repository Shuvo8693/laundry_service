import 'package:equatable/equatable.dart';
import 'package:e_laundry/features/splash/domain/entities/splash_page_data.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final SplashPageData splashData;

  const SplashLoaded(this.splashData);

  @override
  List<Object?> get props => [splashData];
}

class SplashError extends SplashState {
  final String message;

  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}

class SplashNavigateToLogin extends SplashState {}

class SplashNavigateToHome extends SplashState {}
