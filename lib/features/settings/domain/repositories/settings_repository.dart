import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import '../entities/user_profile_entity.dart';

abstract class SettingsRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile();
  Future<Either<Failure, UserProfileEntity>> updateProfile(UserProfileEntity profile);
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<Either<Failure, void>> logout();
}
