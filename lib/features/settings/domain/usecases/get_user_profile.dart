import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/settings_repository.dart';

class GetUserProfile {
  final SettingsRepository repository;

  GetUserProfile(this.repository);

  Future<Either<Failure, UserProfileEntity>> call() {
    return repository.getUserProfile();
  }
}
