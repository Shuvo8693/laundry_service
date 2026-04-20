import 'package:dartz/dartz.dart';
import 'package:e_laundry/core/error/failures.dart';
import 'package:e_laundry/features/order/domain/entities/order_entity.dart';
import 'package:e_laundry/features/order/domain/repositories/order_repository.dart';

class GetActiveOrders {
  final OrderRepository repository;

  GetActiveOrders(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call() {
    return repository.getActiveOrders();
  }
}
