import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_dreamers/core/navigation/cubit/navigation_cubit.dart';
import 'package:medi_dreamers/core/navigation/cubit/navigation_state.dart';
import 'package:medi_dreamers/core/widgets/custom_text.dart';
import 'package:medi_dreamers/core/widgets/language_switcher.dart';
import 'package:medi_dreamers/features/home/presentation/cubit/home_cubit.dart';
import 'package:medi_dreamers/features/home/presentation/screens/home_content.dart';
import 'package:medi_dreamers/injection_container.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const Center(child: CustomText.bodyLarge('Subject')),
      const Center(child: CustomText.bodyLarge('Test')),
      BlocProvider(
        create: (context) => di<HomeCubit>()..loadHomeData(),
        child: const HomeContent(),
      ),
      const Center(child: CustomText.bodyLarge('Study')),
      const Center(child: CustomText.bodyLarge('Settings')),
    ];
  }

  void _onNavTap(int index) {
    context.read<NavigationCubit>().navigateToIndex(index);
  }

  @override
  Widget build(BuildContext context) {
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
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.subject),
                      label: 'Subject',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.note_alt),
                      label: 'Test',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.book),
                      label: 'Study',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      // Add language switcher in the top-right corner
      floatingActionButton: const LanguageSwitcherDropdown(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
