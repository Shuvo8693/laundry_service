import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/order/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getActiveOrders();
  Future<Either<Failure, List<OrderEntity>>> getCompletedOrders();
  Future<Either<Failure, OrderEntity>> getOrderDetails(String orderId);
}
