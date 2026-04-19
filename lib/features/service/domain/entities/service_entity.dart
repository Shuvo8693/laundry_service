import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ServiceEntity extends Equatable {
  final String id;
  final String title;
  final String priceInfo;
  final IconData icon;

  const ServiceEntity({
    required this.id,
    required this.title,
    required this.priceInfo,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, title, priceInfo, icon];
}
