import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/core/error/exceptions.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/cloth_item_entity.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/service_local_data_source.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceLocalDataSource localDataSource;

  ServiceRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServices() async {
    try {
      final result = await localDataSource.getServices();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ClothItemEntity>>> getClothItems() async {
    try {
      final result = await localDataSource.getClothItems();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
