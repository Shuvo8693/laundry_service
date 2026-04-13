import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/features/auth/domain/repositories/auth_repository.dart';
import 'package:e_laundry/features/auth/presentation/cubit/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository repository;

  LoginCubit(this.repository) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    final result = await repository.login(email, password);

    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (success) => emit(LoginSuccess()),
    );
  }
}
