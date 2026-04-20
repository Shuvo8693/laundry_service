import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/order/domain/entities/order_entity.dart';
import 'package:e_laundry/features/order/domain/repositories/order_repository.dart';

class GetOrderDetails {
  final OrderRepository repository;

  GetOrderDetails(this.repository);

  Future<Either<Failure, OrderEntity>> call(String orderId) {
    return repository.getOrderDetails(orderId);
  }
}
