import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/settings_repository.dart';

class UpdateProfile {
  final SettingsRepository repository;

  UpdateProfile(this.repository);

  Future<Either<Failure, UserProfileEntity>> call(UserProfileEntity profile) {
    return repository.updateProfile(profile);
  }
}
