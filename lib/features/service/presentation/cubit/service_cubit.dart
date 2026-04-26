import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/service_repository.dart';
import '../../domain/entities/service_entity.dart';
import 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final ServiceRepository repository;

  ServiceCubit({required this.repository}) : super(const ServiceInitial());

  Future<void> fetchServices() async {
    if (state.services.isNotEmpty) return;
    emit(
      ServiceLoading(
        bookingDetails: state.bookingDetails,
        services: state.services,
      ),
    );
    final result = await repository.getServices();
    result.fold(
      (failure) => emit(
        ServiceError(
          message: failure.message,
          bookingDetails: state.bookingDetails,
          services: state.services,
        ),
      ),
      (services) => emit(
        ServicesListLoaded(
          services: services,
          bookingDetails: state.bookingDetails,
        ),
      ),
    );
  }

  Future<void> startBooking(ServiceEntity service) async {
    emit(
      ServiceLoading(
        bookingDetails: state.bookingDetails.copyWith(selectedService: service),
      ),
    );
    final result = await repository.getClothItems();
    result.fold(
      (failure) => emit(
        ServiceError(
          message: failure.message,
          bookingDetails: state.bookingDetails,
          services: state.services,
        ),
      ),
      (items) => emit(
        ClothSelectionLoaded(
          items: items,
          services: state.services,
          bookingDetails: state.bookingDetails.copyWith(
            selectedService: service,
          ),
        ),
      ),
    );
  }

  void updateClothItemCount(String id, int count) {
    if (state is ClothSelectionLoaded) {
      final currentState = state as ClothSelectionLoaded;
      final updatedItems = currentState.items.map((item) {
        if (item.id == id) return item.copyWith(count: count);
        return item;
      }).toList();

      final selectedItems = updatedItems
          .where((item) => item.count > 0)
          .toList();

      emit(
        ClothSelectionLoaded(
          items: updatedItems,
          services: state.services,
          bookingDetails: state.bookingDetails.copyWith(
            selectedItems: selectedItems,
          ),
        ),
      );
    }
  }

  void proceedToBookingInfo() {
    emit(
      BookingInfoInProgress(
        bookingDetails: state.bookingDetails,
        services: state.services,
      ),
    );
  }

  void updateBookingInfo({DateTime? date, String? time, String? address}) {
    emit(
      BookingInfoInProgress(
        bookingDetails: state.bookingDetails.copyWith(
          pickupDate: date,
          pickupTime: time,
          address: address,
        ),
        services: state.services,
      ),
    );
  }

  void proceedToSummary() {
    emit(
      SummaryInProgress(
        bookingDetails: state.bookingDetails,
        services: state.services,
      ),
    );
  }

  void confirmOrder() {
    // Simulate API call
    emit(
      ServiceLoading(
        bookingDetails: state.bookingDetails,
        services: state.services,
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      emit(
        OrderConfirmed(
          bookingDetails: state.bookingDetails,
          services: state.services,
        ),
      );
    });
  }
}
