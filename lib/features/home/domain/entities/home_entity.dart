import 'package:equatable/equatable.dart';

class HomeServiceEntity extends Equatable {
  final String id;
  final String title;
  final String priceStartingFrom;

  const HomeServiceEntity({
    required this.id,
    required this.title,
    required this.priceStartingFrom,
  });

  @override
  List<Object?> get props => [id, title, priceStartingFrom];
}

class HomeActiveOrderEntity extends Equatable {
  final String orderId;
  final String services;
  final String date;
  final String status;
  final double price;

  const HomeActiveOrderEntity({
    required this.orderId,
    required this.services,
    required this.date,
    required this.status,
    required this.price,
  });

  @override
  List<Object?> get props => [orderId, services, date, status, price];
}

class HomeOfferEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String discountBadge;

  const HomeOfferEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.discountBadge,
  });

  @override
  List<Object?> get props => [id, title, description, discountBadge];
}

class HomeEntity extends Equatable {
  final String userName;
  final String location;
  final List<HomeServiceEntity> services;
  final List<HomeActiveOrderEntity> activeOrders;
  final List<HomeOfferEntity> offers;

  const HomeEntity({
    required this.userName,
    required this.location,
    required this.services,
    required this.activeOrders,
    required this.offers,
  });

  @override
  List<Object?> get props => [
        userName,
        location,
        services,
        activeOrders,
        offers,
      ];
}
