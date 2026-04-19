import 'package:flutter/material.dart';
import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.title,
    required super.priceInfo,
    required super.icon,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      priceInfo: json['price_info'] as String,
      icon: _getIconData(json['icon_name'] as String),
    );
  }

  static IconData _getIconData(String name) {
    switch (name) {
      case 'wash': return Icons.local_laundry_service;
      case 'iron': return Icons.iron;
      case 'dry_clean': return Icons.dry_cleaning;
      default: return Icons.help_outline;
    }
  }
}
