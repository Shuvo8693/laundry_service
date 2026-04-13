import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:e_laundry/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> login(String email, String password) async {
    // Mock login for now
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'admin@example.com' && password == 'password123') {
      await localDataSource.saveToken('mock_token');
      return const Right(true);
    }
    return Left(ServerFailure('Invalid email or password'));
  }

  @override
  Future<Either<Failure, bool>> signup(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(true);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearToken();
  }
}
