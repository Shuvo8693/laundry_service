import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/features/auth/domain/usecases/login_usecase.dart';
import 'package:e_laundry/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:e_laundry/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:e_laundry/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:e_laundry/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final SendOtpUseCase sendOtpUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
    required this.sendOtpUseCase,
  }) : super(const AuthInitial());

  String? _pendingPhone;
  String? _pendingPassword;
  String? _pendingName;
  String? _pendingGender;
  bool _isSignUpFlow = false;

  void cacheSignUpData({
    required String phone,
    required String password,
    required String name,
    required String gender,
  }) {
    _pendingPhone = phone;
    _pendingPassword = password;
    _pendingName = name;
    _pendingGender = gender;
  }

  void setIsSignUpFlow(bool isSignUp) {
    _isSignUpFlow = isSignUp;
  }
  
  String? get pendingPhone => _pendingPhone;

  Future<void> login(String phone, String password) async {
    emit(const AuthLoading());
    final result = await loginUseCase(phone, password);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> sendOtp(String phone) async {
    _pendingPhone = phone;
    emit(const AuthLoading());
    final result = await sendOtpUseCase(phone);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (success) => emit(AuthOtpSent(phone: phone)),
    );
  }

  Future<void> verifyOtp(String phone, String otp) async {
    emit(const AuthLoading());
    final result = await verifyOtpUseCase(phone, otp);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) {
        if (_isSignUpFlow) {
           _proceedToSignUp();
        } else {
           // Provide a temporary success state to trigger navigation to reset password
           emit(const AuthPasswordResetSuccess());
        }
      },
    );
  }

  Future<void> _proceedToSignUp() async {
    if (_pendingPhone == null || _pendingPassword == null || _pendingName == null || _pendingGender == null) {
      emit(const AuthError(message: 'Missing sign up data, please try again'));
      return;
    }

    final result = await signUpUseCase(
      phone: _pendingPhone!,
      password: _pendingPassword!,
      name: _pendingName!,
      gender: _pendingGender!,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthSignupSuccess(user: user)),
    );
  }

  Future<void> resetPassword(String phone, String newPassword) async {
    emit(const AuthLoading());
    final result = await resetPasswordUseCase(phone, newPassword);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) {
        // Log in automatically after password reset
        login(phone, newPassword);
      },
    );
  }

  void resetState() {
    emit(const AuthInitial());
  }
}
