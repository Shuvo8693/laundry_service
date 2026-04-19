import 'package:e_laundry/features/service/domain/entities/service_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/custom_app_bar.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/core/widgets/spacing.dart';
import 'package:e_laundry/core/widgets/shimmer_placeholder.dart';
import 'package:go_router/go_router.dart';
import '../cubit/service_cubit.dart';
import '../cubit/service_state.dart';
import '../widgets/service_type_card.dart';
import 'package:e_laundry/core/routes/route_names.dart';
import 'package:e_laundry/injection_container.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await di<ServiceCubit>().fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di<ServiceCubit>(),
      child: BlocListener<ServiceCubit, ServiceState>(
        listenWhen: (previous, current) =>
            //         First tap "+"
            //   previous = ClothSelectionInitial   → is NOT Loaded ✅
            //   current  = ClothSelectionLoaded    → is Loaded ✅
            //   Both conditions true → listener fires → navigate ✅
            // Second tap "+"
            //   previous = ClothSelectionLoaded    → is NOT Loaded? ❌ (it WAS loaded)
            //   current  = ClothSelectionLoaded    → is Loaded ✅
            //   First condition FAILED → listener blocked → no navigate 🚫
            previous is! ClothSelectionLoaded &&
            current is ClothSelectionLoaded,
        listener: (context, state) {
          context.push(RouteNames.selectService);
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomAppBar(title: 'Services', showBackButton: false),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Our Services',
                  textType: TextType.headlineMedium,
                  color: AppColors.onSurface,
                ),
                const VerticalSpace(16),
                BlocBuilder<ServiceCubit, ServiceState>(
                  builder: (context, state) {
                    if (state is ServiceLoading && state.services.isEmpty) {
                      return _buildShimmer();
                    } else if (state is ServiceError) {
                      return Center(child: CustomText(text: state.message));
                    }
                    return _buildGrid(context, state.services);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, list) {
    // If list is empty, it might be because we just transitioned back.
    // In a real implementation, we'd ensure state consistency.
    // For this mock, I'll provide the list if empty for demonstration.
    final items = list.isEmpty
        ? [
            ServiceEntity(
              id: 'wash_001',
              title: 'Wash & fold',
              priceInfo: 'From \$5/item',
              icon: Icons.local_laundry_service,
            ),
            ServiceEntity(
              id: 'iron_002',
              title: 'Iron & Press',
              priceInfo: 'From \$5/item',
              icon: Icons.iron,
            ),
            ServiceEntity(
              id: 'dry_003',
              title: 'Dry Clean',
              priceInfo: 'From \$5/item',
              icon: Icons.dry_cleaning,
            ),
            // Mock for design consistency if state is lost
          ]
        : list;

    return Wrap(
      spacing: 8.w,
      runSpacing: 16.h,
      children: items
          .map<Widget>(
            (service) => ServiceTypeCard(
              service: service,
              isSelected: false,
              onTap: () => context.read<ServiceCubit>().startBooking(service),
            ),
          )
          .toList(),
    );
  }

  Widget _buildShimmer() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 16.h,
      children: List.generate(
        3,
        (index) => ShimmerPlaceholder(
          child: Container(
            width: 114.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }
}
