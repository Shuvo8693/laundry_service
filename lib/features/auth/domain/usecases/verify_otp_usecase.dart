import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/auth/domain/entities/auth_entity.dart';
import 'package:e_laundry/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call(String phone, String otp) {
    return repository.verifyOtp(phone, otp);
  }
}
