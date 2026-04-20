import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/widgets/custom_app_bar.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/features/order/presentation/cubit/order_cubit.dart';
import 'package:e_laundry/features/order/presentation/cubit/order_state.dart';
import 'package:e_laundry/features/order/presentation/widgets/order_card.dart';
import 'package:go_router/go_router.dart';
import 'package:e_laundry/core/routes/route_names.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'My Order', showBackButton: false),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.onSurfaceVariant,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: [
                  BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, state) {
                      int activeCount = 0;
                      if (state is OrderLoaded) {
                        activeCount = state.activeOrders.length;
                      }
                      return Tab(text: 'Active ($activeCount)');
                    },
                  ),
                  BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, state) {
                      int completedCount = 0;
                      if (state is OrderLoaded) {
                        completedCount = state.completedOrders.length;
                      }
                      return Tab(text: 'Completed ($completedCount)');
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoading) {
                    return Center(child: CustomCircularProgressIndicator());
                  } else if (state is OrderLoaded) {
                    return TabBarView(
                      children: [
                        _OrderList(
                          orders: state.activeOrders,
                          emptyMessage: 'No active orders',
                        ),
                        _OrderList(
                          orders: state.completedOrders,
                          emptyMessage: 'No completed orders',
                        ),
                      ],
                    );
                  } else if (state is OrderError) {
                    return Center(child: CustomText.bodyMedium(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<dynamic> orders;
  final String emptyMessage;

  const _OrderList({required this.orders, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: CustomText.bodyMedium(
          emptyMessage,
          color: AppColors.onSurfaceVariant,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20.r),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onTap: () =>
              context.push('${RouteNames.dashboard}/order_details/${order.id}'),
        );
      },
    );
  }
}
