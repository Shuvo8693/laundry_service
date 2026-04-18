import 'package:e_laundry/core/error/exceptions.dart';
import 'package:e_laundry/features/home/data/models/home_model.dart';

abstract class HomeLocalDataSource {
  Future<HomeModel> getHomeData();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  static final Map<String, dynamic> _mockHomeData = {
    'user_name': 'Rakib',
    'location': 'Ghana',
    'services': [
      {
        'id': 'SRV-001',
        'title': 'Wash & fold',
        'price_starting_from': 'From \$5/item'
      },
      {
        'id': 'SRV-002',
        'title': 'Iron & Press',
        'price_starting_from': 'From \$5/item'
      },
      {
        'id': 'SRV-003',
        'title': 'Dry Clean',
        'price_starting_from': 'From \$5/item'
      }
    ],
    'active_orders': [
      {
        'order_id': 'ORD-001',
        'services': 'Wash & Fold, Iron & Press',
        'date': '2026-04-03',
        'status': 'Processing',
        'price': 34.0
      }
    ],
    'offers': [
      {
        'id': 'OFF-001',
        'title': 'First Booking',
        'description': 'You can get 5% Discount',
        'discount_badge': '5% OFF'
      }
    ]
  };

  @override
  Future<HomeModel> getHomeData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      return HomeModel.fromJson(_mockHomeData);
    } catch (e) {
      throw CacheException(message: 'Error fetching mock home data');
    }
  }
}
