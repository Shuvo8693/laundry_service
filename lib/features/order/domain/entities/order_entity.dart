import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  pickingUp,
  processing,
  completed,
  outForDelivery,
  delivered,
  cancelled,
}

class OrderStep extends Equatable {
  final String title;
  final bool isCompleted;
  final DateTime? time;

  const OrderStep({
    required this.title,
    required this.isCompleted,
    this.time,
  });

  @override
  List<Object?> get props => [title, isCompleted, time];
}

class OrderItem extends Equatable {
  final String name;
  final int quantity;
  final double price;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [name, quantity, price];
}

class OrderEntity extends Equatable {
  final String id;
  final String serviceName;
  final OrderStatus status;
  final double totalPrice;
  final double subtotal;
  final double pickupCost;
  final double deliveryCost;
  final DateTime date;
  final String pickupTime;
  final String deliveryAddress;
  final List<OrderItem> items;
  final List<OrderStep> steps;
  final String? itemSummary; // e.g. "shirts"

  const OrderEntity({
    required this.id,
    required this.serviceName,
    required this.status,
    required this.totalPrice,
    required this.subtotal,
    this.pickupCost = 0.0,
    this.deliveryCost = 0.0,
    required this.date,
    required this.pickupTime,
    required this.deliveryAddress,
    required this.items,
    required this.steps,
    this.itemSummary,
  });

  bool get isActive => status != OrderStatus.delivered && status != OrderStatus.cancelled && status != OrderStatus.completed;
  bool get isCompleted => status == OrderStatus.delivered || status == OrderStatus.completed;

  @override
  List<Object?> get props => [
        id,
        serviceName,
        status,
        totalPrice,
        subtotal,
        pickupCost,
        deliveryCost,
        date,
        pickupTime,
        deliveryAddress,
        items,
        steps,
        itemSummary,
      ];
}
