import 'package:e_laundry/features/home/domain/entities/home_entity.dart';

class HomeServiceModel extends HomeServiceEntity {
  const HomeServiceModel({
    required super.id,
    required super.title,
    required super.priceStartingFrom,
  });

  factory HomeServiceModel.fromJson(Map<String, dynamic> json) {
    return HomeServiceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      priceStartingFrom: json['price_starting_from'] as String,
    );
  }
}

class HomeActiveOrderModel extends HomeActiveOrderEntity {
  const HomeActiveOrderModel({
    required super.orderId,
    required super.services,
    required super.date,
    required super.status,
    required super.price,
  });

  factory HomeActiveOrderModel.fromJson(Map<String, dynamic> json) {
    return HomeActiveOrderModel(
      orderId: json['order_id'] as String,
      services: json['services'] as String,
      date: json['date'] as String,
      status: json['status'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}

class HomeOfferModel extends HomeOfferEntity {
  const HomeOfferModel({
    required super.id,
    required super.title,
    required super.description,
    required super.discountBadge,
  });

  factory HomeOfferModel.fromJson(Map<String, dynamic> json) {
    return HomeOfferModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      discountBadge: json['discount_badge'] as String,
    );
  }
}

class HomeModel extends HomeEntity {
  const HomeModel({
    required super.userName,
    required super.location,
    required super.services,
    required super.activeOrders,
    required super.offers,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      userName: json['user_name'] as String,
      location: json['location'] as String,
      services: (json['services'] as List<dynamic>)
          .map((e) => HomeServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeOrders: (json['active_orders'] as List<dynamic>)
          .map((e) => HomeActiveOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      offers: (json['offers'] as List<dynamic>)
          .map((e) => HomeOfferModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
