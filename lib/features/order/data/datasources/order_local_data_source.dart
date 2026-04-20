import 'package:e_laundry/core/error/exceptions.dart';
import 'package:e_laundry/features/order/data/models/order_model.dart';
import 'package:e_laundry/features/order/domain/entities/order_entity.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getActiveOrders();
  Future<List<OrderModel>> getCompletedOrders();
  Future<OrderModel> getOrderDetails(String orderId);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  static final List<Map<String, dynamic>> _mockOrders = [
    {
      'id': '319775',
      'service_name': 'Wash',
      'status': 'pending',
      'total_price': 100.0,
      'subtotal': 98.0,
      'pickup_cost': 1.0,
      'delivery_cost': 1.0,
      'date': '2026-12-31T10:00:00.000Z',
      'pickup_time': '10:00',
      'delivery_address': 'dhaka',
      'item_summary': 'shirts',
      'items': [
        {'name': 'Wash & Fold', 'quantity': 6, 'price': 30.0},
        {'name': 'Iron & Press', 'quantity': 6, 'price': 30.0},
        {'name': 'Wash & Fold', 'quantity': 6, 'price': 30.0},
      ],
      'steps': [
        {'title': 'Order Placed', 'is_completed': true, 'time': '2026-04-20T11:00:00.000Z'},
        {'title': 'Picked Up', 'is_completed': true, 'time': null},
        {'title': 'Processing', 'is_completed': true, 'time': null},
        {'title': 'Completed', 'is_completed': true, 'time': null},
        {'title': 'Out for Delivery', 'is_completed': true, 'time': null},
        {'title': 'Delivered', 'is_completed': true, 'time': null},
      ],
    },
  ];

  @override
  Future<List<OrderModel>> getActiveOrders() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockOrders
        .where((json) {
          final status = OrderStatus.values.byName(json['status'] as String);
          return status != OrderStatus.delivered &&
              status != OrderStatus.cancelled &&
              status != OrderStatus.completed;
        })
        .map((json) => OrderModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<OrderModel>> getCompletedOrders() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockOrders
        .where((json) {
          final status = OrderStatus.values.byName(json['status'] as String);
          return status == OrderStatus.delivered || status == OrderStatus.completed;
        })
        .map((json) => OrderModel.fromJson(json))
        .toList();
  }

  @override
  Future<OrderModel> getOrderDetails(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final json = _mockOrders.firstWhere((o) => o['id'] == orderId);
      return OrderModel.fromJson(json);
    } catch (e) {
      throw CacheException(message: 'Order $orderId not found');
    }
  }
}
