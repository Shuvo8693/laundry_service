import 'package:e_laundry/features/order/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.serviceName,
    required super.status,
    required super.totalPrice,
    required super.subtotal,
    super.pickupCost = 0.0,
    super.deliveryCost = 0.0,
    required super.date,
    required super.pickupTime,
    required super.deliveryAddress,
    required super.items,
    required super.steps,
    super.itemSummary,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      serviceName: json['service_name'] as String,
      status: OrderStatus.values.byName(json['status'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      pickupCost: (json['pickup_cost'] as num? ?? 0.0).toDouble(),
      deliveryCost: (json['delivery_cost'] as num? ?? 0.0).toDouble(),
      date: DateTime.parse(json['date'] as String),
      pickupTime: json['pickup_time'] as String,
      deliveryAddress: json['delivery_address'] as String,
      itemSummary: json['item_summary'] as String?,
      items: (json['items'] as List)
          .map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>))
          .toList(),
      steps: (json['steps'] as List)
          .map((s) => OrderStepModel.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'service_name': serviceName,
        'status': status.name,
        'total_price': totalPrice,
        'subtotal': subtotal,
        'pickup_cost': pickupCost,
        'delivery_cost': deliveryCost,
        'date': date.toIso8601String(),
        'pickup_time': pickupTime,
        'delivery_address': deliveryAddress,
        'item_summary': itemSummary,
        'items': items.map((i) => (i as OrderItemModel).toJson()).toList(),
        'steps': steps.map((s) => (s as OrderStepModel).toJson()).toList(),
      };
}

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.name,
    required super.quantity,
    required super.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'price': price,
      };
}

class OrderStepModel extends OrderStep {
  const OrderStepModel({
    required super.title,
    required super.isCompleted,
    super.time,
  });

  factory OrderStepModel.fromJson(Map<String, dynamic> json) {
    return OrderStepModel(
      title: json['title'] as String,
      isCompleted: json['is_completed'] as bool,
      time: json['time'] != null ? DateTime.parse(json['time'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'is_completed': isCompleted,
        'time': time?.toIso8601String(),
      };
}
