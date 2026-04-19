import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ClothItemEntity extends Equatable {
  final String id;
  final String name;
  final IconData icon;
  final int count;

  const ClothItemEntity({
    required this.id,
    required this.name,
    required this.icon,
    this.count = 0,
  });

  ClothItemEntity copyWith({int? count}) {
    return ClothItemEntity(
      id: id,
      name: name,
      icon: icon,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [id, name, icon, count];
}
