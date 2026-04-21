import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile_entity.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

final class SettingsLoaded extends SettingsState {
  final UserProfileEntity user;
  const SettingsLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

final class SettingsUpdateSuccess extends SettingsState {
  final UserProfileEntity user;
  final String message;
  const SettingsUpdateSuccess({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

final class SettingsPasswordChangeSuccess extends SettingsState {
  final String message;
  const SettingsPasswordChangeSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class SettingsLogoutSuccess extends SettingsState {
  const SettingsLogoutSuccess();
}

final class SettingsError extends SettingsState {
  final String message;
  const SettingsError({required this.message});

  @override
  List<Object?> get props => [message];
}
