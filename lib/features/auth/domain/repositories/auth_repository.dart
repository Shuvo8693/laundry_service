import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> login(String email, String password);
  Future<Either<Failure, bool>> signup(String email, String password);
  Future<bool> isLoggedIn();
  Future<void> logout();
}
