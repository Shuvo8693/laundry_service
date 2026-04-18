import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/features/home/domain/usecases/get_home_data.dart';
import 'package:e_laundry/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeData getHomeData;

  HomeCubit({required this.getHomeData}) : super(const HomeInitial());

  Future<void> fetchHomeData() async {
    emit(const HomeLoading());

    final result = await getHomeData();

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (homeData) => emit(HomeLoaded(homeData: homeData)),
    );
  }
}
