import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/update_profile.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetUserProfile getUserProfile;
  final UpdateProfile updateProfile;
  final ChangePassword changePassword;
  final Logout logoutUseCase;

  SettingsCubit({
    required this.getUserProfile,
    required this.updateProfile,
    required this.changePassword,
    required this.logoutUseCase,
  }) : super(const SettingsInitial());

  Future<void> fetchProfile() async {
    emit(const SettingsLoading());
    final result = await getUserProfile();
    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (user) => emit(SettingsLoaded(user: user)),
    );
  }

  Future<void> updateProfileDetails({
    required String name,
    required String phone,
    required String gender,
  }) async {
    final currentState = state;
    if (currentState is! SettingsLoaded && currentState is! SettingsUpdateSuccess) return;
    
    final user = currentState is SettingsLoaded ? currentState.user : (currentState as SettingsUpdateSuccess).user;
    
    emit(const SettingsLoading());
    final result = await updateProfile(user.copyWith(
      name: name,
      phone: phone,
      gender: gender,
    ));

    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (updatedUser) => emit(SettingsUpdateSuccess(
        user: updatedUser,
        message: 'Profile updated successfully',
      )),
    );
  }

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(const SettingsLoading());
    final result = await changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (_) => emit(const SettingsPasswordChangeSuccess(
        message: 'Password changed successfully',
      )),
    );
  }

  Future<void> logout() async {
    emit(const SettingsLoading());
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (_) => emit(const SettingsLogoutSuccess()),
    );
  }
}
