import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../models/cloth_item_model.dart';

abstract class ServiceLocalDataSource {
  Future<List<ServiceModel>> getServices();
  Future<List<ClothItemModel>> getClothItems();
}

class ServiceLocalDataSourceImpl implements ServiceLocalDataSource {
  @override
  Future<List<ServiceModel>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      ServiceModel(
        id: 'wash_001',
        title: 'Wash & fold',
        priceInfo: 'From \$5/item',
        icon: Icons.local_laundry_service,
      ),
      ServiceModel(
        id: 'iron_002',
        title: 'Iron & Press',
        priceInfo: 'From \$5/item',
        icon: Icons.iron,
      ),
      ServiceModel(
        id: 'dry_003',
        title: 'Dry Clean',
        priceInfo: 'From \$5/item',
        icon: Icons.dry_cleaning,
      ),
    ];
  }

  @override
  Future<List<ClothItemModel>> getClothItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      ClothItemModel(id: 'c1', name: 'Shirt', icon: Icons.checkroom),
      ClothItemModel(id: 'c2', name: 'Pants', icon: Icons.dry_cleaning),
      ClothItemModel(id: 'c3', name: 'Bedsheet', icon: Icons.bed),
      ClothItemModel(id: 'c4', name: 'Duvet', icon: Icons.bedroom_parent),
      ClothItemModel(id: 'c5', name: 'Others', icon: Icons.category),
    ];
  }
}
