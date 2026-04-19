import 'package:flutter/material.dart';
import '../../domain/entities/cloth_item_entity.dart';

class ClothItemModel extends ClothItemEntity {
  const ClothItemModel({
    required super.id,
    required super.name,
    required super.icon,
    super.count,
  });

  factory ClothItemModel.fromJson(Map<String, dynamic> json) {
    return ClothItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: _getIconData(json['icon_name'] as String),
      count: json['count'] as int? ?? 0,
    );
  }

  static IconData _getIconData(String name) {
    switch (name) {
      case 'shirt': return Icons.checkroom;
      case 'pants': return Icons.dry_cleaning;
      case 'bedsheet': return Icons.bed;
      case 'duvet': return Icons.bedroom_parent;
      default: return Icons.category;
    }
  }
}
