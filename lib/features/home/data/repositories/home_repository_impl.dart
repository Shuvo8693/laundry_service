import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/exceptions.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/home/domain/entities/home_entity.dart';
import 'package:e_laundry/features/home/domain/repositories/home_repository.dart';
import 'package:e_laundry/features/home/data/datasources/home_local_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, HomeEntity>> getHomeData() async {
    try {
      final result = await localDataSource.getHomeData();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
