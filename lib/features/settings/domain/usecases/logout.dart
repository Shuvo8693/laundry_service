import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import '../repositories/settings_repository.dart';

class Logout {
  final SettingsRepository repository;

  Logout(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
