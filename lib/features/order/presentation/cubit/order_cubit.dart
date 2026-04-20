import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/features/order/domain/usecases/get_active_orders.dart';
import 'package:e_laundry/features/order/domain/usecases/get_completed_orders.dart';
import 'package:e_laundry/features/order/domain/usecases/get_order_details.dart';
import 'package:e_laundry/features/order/presentation/cubit/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final GetActiveOrders getActiveOrdersUseCase;
  final GetCompletedOrders getCompletedOrdersUseCase;
  final GetOrderDetails getOrderDetailsUseCase;

  OrderCubit({
    required this.getActiveOrdersUseCase,
    required this.getCompletedOrdersUseCase,
    required this.getOrderDetailsUseCase,
  }) : super(const OrderInitial());

  Future<void> fetchOrders() async {
    emit(const OrderLoading());

    final activeResult = await getActiveOrdersUseCase();
    final completedResult = await getCompletedOrdersUseCase();

    activeResult.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (activeOrders) {
        completedResult.fold(
          (failure) => emit(OrderError(message: failure.message)),
          (completedOrders) => emit(OrderLoaded(
            activeOrders: activeOrders,
            completedOrders: completedOrders,
          )),
        );
      },
    );
  }

  Future<void> fetchOrderDetails(String orderId) async {
    emit(const OrderLoading());
    final result = await getOrderDetailsUseCase(orderId);
    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (order) => emit(OrderDetailsLoaded(order)),
    );
  }
}
