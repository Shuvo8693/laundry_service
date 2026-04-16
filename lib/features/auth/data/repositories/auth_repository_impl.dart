import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/exceptions.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:e_laundry/features/auth/domain/entities/auth_entity.dart';
import 'package:e_laundry/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, AuthEntity>> login(
    String phone,
    String password,
  ) async {
    try {
      final result = await localDataSource.login(phone, password);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> signUp(
    String phone,
    String password,
    String name,
    String gender,
  ) async {
    try {
      final result = await localDataSource.signUp(
        phone,
        password,
        name,
        gender,
      );
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, bool>> sendOtp(String phone) async {
    try {
      final result = await localDataSource.sendOtp(phone);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> verifyOtp(
    String phone,
    String otp,
  ) async {
    try {
      final result = await localDataSource.verifyOtp(phone, otp);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(
    String phone,
    String newPassword,
  ) async {
    try {
      final result = await localDataSource.resetPassword(phone, newPassword);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unknown error occurred'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }
}
