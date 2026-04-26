import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import '../repositories/settings_repository.dart';

class ChangePassword {
  final SettingsRepository repository;

  ChangePassword(this.repository);

  Future<Either<Failure, void>> call({
    required String oldPassword,
    required String newPassword,
  }) {
    return repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}
