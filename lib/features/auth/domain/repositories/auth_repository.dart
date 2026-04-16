import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login(String phone, String password);
  
  Future<Either<Failure, AuthEntity>> signUp(
    String phone,
    String password,
    String name,
    String gender,
  );

  Future<Either<Failure, bool>> sendOtp(String phone);
  
  Future<Either<Failure, AuthEntity>> verifyOtp(String phone, String otp);
  
  Future<Either<Failure, bool>> resetPassword(String phone, String newPassword);
  
  Future<bool> isLoggedIn();
}
