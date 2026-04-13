import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/splash/data/datasources/mock_splash_datasource.dart';
import 'package:e_laundry/features/splash/domain/entities/splash_page_data.dart';
import 'package:e_laundry/features/splash/domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final MockSplashDataSource mockDataSource;

  SplashRepositoryImpl({required this.mockDataSource});

  @override
  Future<Either<Failure, SplashPageData>> getSplashPageData() async {
    try {
      final splashData = await mockDataSource.fetchSplashData();
      return Right(splashData);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
