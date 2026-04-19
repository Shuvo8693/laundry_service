import 'package:e_laundry/core/navigation/cubit/navigation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void navigateToIndex(int index) {
    if (state.selectedIndex == index) return;
    emit(state.copyWith(selectedIndex: index));
  }

  void navigateToHome() => navigateToIndex(0);
  void navigateToNutrition() => navigateToIndex(1);
  void navigateToFitness() => navigateToIndex(2);
  void navigateToDoctors() => navigateToIndex(3);
}
