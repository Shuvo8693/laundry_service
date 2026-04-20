import 'package:equatable/equatable.dart';
import 'package:e_laundry/features/order/domain/entities/order_entity.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

final class OrderInitial extends OrderState {
  const OrderInitial();
}

final class OrderLoading extends OrderState {
  const OrderLoading();
}

final class OrderLoaded extends OrderState {
  final List<OrderEntity> activeOrders;
  final List<OrderEntity> completedOrders;

  const OrderLoaded({
    required this.activeOrders,
    required this.completedOrders,
  });

  @override
  List<Object?> get props => [activeOrders, completedOrders];
}

final class OrderDetailsLoaded extends OrderState {
  final OrderEntity order;

  const OrderDetailsLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

final class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object?> get props => [message];
}
