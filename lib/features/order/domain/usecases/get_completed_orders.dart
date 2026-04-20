import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/order/domain/entities/order_entity.dart';
import 'package:e_laundry/features/order/domain/repositories/order_repository.dart';

class GetCompletedOrders {
  final OrderRepository repository;

  GetCompletedOrders(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call() {
    return repository.getCompletedOrders();
  }
}
