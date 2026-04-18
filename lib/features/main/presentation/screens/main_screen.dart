import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:e_laundry/core/navigation/cubit/navigation_cubit.dart';
import 'package:e_laundry/core/navigation/cubit/navigation_state.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/core/widgets/language_switcher.dart';
import 'package:e_laundry/features/home/presentation/screens/home_screen.dart';

/// Represents a nav item that can use either an SVG asset or an IconData.
class NavItemConfig {
  final String label;
  final String? svgAsset; // e.g. 'assets/icons/nav_home.svg'
  final IconData? iconData; // e.g. Icons.home

  const NavItemConfig({required this.label, this.svgAsset, this.iconData})
    : assert(
        svgAsset != null || iconData != null,
        'Provide either svgAsset or iconData',
      );
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final List<Widget> _screens;

  // Swap svgAsset ↔ iconData per item as needed
  final List<NavItemConfig> _navItems = const [
    NavItemConfig(label: 'Home', svgAsset: 'assets/app_icon/laundry_home.svg'),
    NavItemConfig(
      label: 'Service',
      svgAsset: 'assets/app_icon/laundry_service.svg',
    ),
    NavItemConfig(
      label: 'Orders',
      svgAsset: 'assets/app_icon/laundry_order.svg',
    ),
    NavItemConfig(
      label: 'Profile',
      svgAsset: 'assets/app_icon/laundry_profile.svg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const Center(child: CustomText.bodyLarge('Service')),
      const Center(child: CustomText.bodyLarge('Orders')),
      const Center(child: CustomText.bodyLarge('Profile')),
    ];
  }

  void _onNavTap(int index) {
    context.read<NavigationCubit>().navigateToIndex(index);
  }

  BottomNavigationBarItem _buildNavItem({
    required NavItemConfig config,
    required bool isSelected,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    Widget buildIcon(bool active) {
      final color = active ? activeColor : inactiveColor;

      if (config.svgAsset != null) {
        return SvgPicture.asset(
          config.svgAsset!,
          width: 24.w,
          height: 24.h,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        );
      }

      return Icon(config.iconData, color: color);
    }

    return BottomNavigationBarItem(
      icon: buildIcon(false),
      activeIcon: buildIcon(true),
      label: config.label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, navState) {
          return Stack(
            children: [
              IndexedStack(index: navState.selectedIndex, children: _screens),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BottomNavigationBar(
                  currentIndex: navState.selectedIndex,
                  onTap: _onNavTap,
                  type: BottomNavigationBarType.fixed,
                  items: List.generate(
                    _navItems.length,
                    (i) => _buildNavItem(
                      config: _navItems[i],
                      isSelected: navState.selectedIndex == i,
                      activeColor: colorScheme.primary,
                      inactiveColor: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),

      ///========== This is language switcher at all nav screen top right position ==================
      // floatingActionButton: const LanguageSwitcherDropdown(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
