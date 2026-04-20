import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/exceptions.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/order/data/datasources/order_local_data_source.dart';
import 'package:e_laundry/features/order/domain/entities/order_entity.dart';
import 'package:e_laundry/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<OrderEntity>>> getActiveOrders() async {
    try {
      final result = await localDataSource.getActiveOrders();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getCompletedOrders() async {
    try {
      final result = await localDataSource.getCompletedOrders();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderDetails(String orderId) async {
    try {
      final result = await localDataSource.getOrderDetails(orderId);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
