import 'package:equatable/equatable.dart';
import 'service_entity.dart';
import 'cloth_item_entity.dart';

class BookingDetails extends Equatable {
  final ServiceEntity? selectedService;
  final List<ClothItemEntity> selectedItems;
  final DateTime? pickupDate;
  final String? pickupTime;
  final String? address;

  const BookingDetails({
    this.selectedService,
    this.selectedItems = const [],
    this.pickupDate,
    this.pickupTime,
    this.address,
  });

  BookingDetails copyWith({
    ServiceEntity? selectedService,
    List<ClothItemEntity>? selectedItems,
    DateTime? pickupDate,
    String? pickupTime,
    String? address,
  }) {
    return BookingDetails(
      selectedService: selectedService ?? this.selectedService,
      selectedItems: selectedItems ?? this.selectedItems,
      pickupDate: pickupDate ?? this.pickupDate,
      pickupTime: pickupTime ?? this.pickupTime,
      address: address ?? this.address,
    );
  }

  double get totalCost {
    if (selectedItems.isEmpty) return 0;
    // Follow design $5/item
    double itemCost = selectedItems.fold(0, (sum, item) => sum + (item.count * 5.0));
    double pickupCost = 1.0;
    double deliveryCost = 1.0;
    return itemCost + pickupCost + deliveryCost;
  }

  @override
  List<Object?> get props => [
        selectedService,
        selectedItems,
        pickupDate,
        pickupTime,
        address,
      ];
}
