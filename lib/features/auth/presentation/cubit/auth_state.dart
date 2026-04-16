import 'package:equatable/equatable.dart';
import 'package:e_laundry/features/auth/domain/entities/auth_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final AuthEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

final class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class AuthOtpSent extends AuthState {
  final String phone;

  const AuthOtpSent({required this.phone});

  @override
  List<Object?> get props => [phone];
}

final class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}

final class AuthSignupSuccess extends AuthState {
  final AuthEntity user;

  const AuthSignupSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}
