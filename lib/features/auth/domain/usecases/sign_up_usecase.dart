import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/auth/domain/entities/auth_entity.dart';
import 'package:e_laundry/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call({
    required String phone,
    required String password,
    required String name,
    required String gender,
  }) {
    return repository.signUp(phone, password, name, gender);
  }
}
