import '../models/user_profile_model.dart';

abstract class SettingsLocalDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateProfile(UserProfileModel profile);
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<void> logout();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  UserProfileModel _mockUser = const UserProfileModel(
    id: 'USER-123',
    name: 'Mohammod Talha',
    phone: '+880 189* ****',
    gender: 'Male',
  );

  @override
  Future<UserProfileModel> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockUser;
  }

  @override
  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockUser = profile;
    return _mockUser;
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, verify old password here
    return;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return;
  }
}
