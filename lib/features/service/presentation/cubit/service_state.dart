import 'package:equatable/equatable.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/cloth_item_entity.dart';
import '../../domain/entities/booking_details.dart';

sealed class ServiceState extends Equatable {
  final BookingDetails bookingDetails;
  final List<ServiceEntity> services;

  const ServiceState({required this.bookingDetails, this.services = const []});

  @override
  List<Object?> get props => [bookingDetails, services];
}

final class ServiceInitial extends ServiceState {
  const ServiceInitial() : super(bookingDetails: const BookingDetails());
}

final class ServiceLoading extends ServiceState {
  const ServiceLoading({required super.bookingDetails, super.services});
}

final class ServicesListLoaded extends ServiceState {
  @override
  final List<ServiceEntity> services;
  const ServicesListLoaded({
    required super.bookingDetails,
    required this.services,
  });

  @override
  List<Object?> get props => [super.props, services];
}

final class ClothSelectionLoaded extends ServiceState {
  final List<ClothItemEntity> items;
  const ClothSelectionLoaded({
    required super.bookingDetails,
    required super.services,
    required this.items,
  });

  @override
  List<Object?> get props => [super.props, items];
}

final class BookingInfoInProgress extends ServiceState {
  const BookingInfoInProgress({
    required super.bookingDetails,
    required super.services,
  });
}

final class SummaryInProgress extends ServiceState {
  const SummaryInProgress({
    required super.bookingDetails,
    required super.services,
  });
}

final class OrderConfirmed extends ServiceState {
  const OrderConfirmed({
    required super.bookingDetails,
    required super.services,
  });
}

final class ServiceError extends ServiceState {
  final String message;
  const ServiceError({
    required super.bookingDetails,
    super.services,
    required this.message,
  });

  @override
  List<Object?> get props => [super.props, message];
}
