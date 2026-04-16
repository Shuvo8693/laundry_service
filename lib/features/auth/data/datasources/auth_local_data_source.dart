import 'package:e_laundry/core/error/exceptions.dart';
import 'package:e_laundry/features/auth/data/models/auth_model.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  Future<AuthModel> login(String phone, String password);
  Future<AuthModel> signUp(
    String phone,
    String password,
    String name,
    String gender,
  );
  Future<bool> sendOtp(String phone);
  Future<AuthModel> verifyOtp(String phone, String otp);
  Future<bool> resetPassword(String phone, String newPassword);
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  // MOCK DATA STORES
  //== user===
  final Map<String, AuthModel> _users = {
    '1234567': const AuthModel(
      id: 'USR-001',
      name: 'Tamim',
      phone: '1234567',
      token: 'mock-jwt-token-12345',
    ),
  };
  //== password===
  final Map<String, String> _passwords = {'1234567': '123456'};
  //== otp===
  final Map<String, String> _sentOtps = {};
  //== Login==

  @override
  Future<AuthModel> login(String phone, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (!_users.containsKey(phone)) {
      throw const CacheException(message: 'User does not exist');
    }
    if (_passwords[phone] != password) {
      throw const CacheException(message: 'Invalid password');
    }
    return _users[phone]!;
  }

  @override
  Future<AuthModel> signUp(
    String phone,
    String password,
    String name,
    String gender,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (_users.containsKey(phone)) {
      throw const CacheException(message: 'User already exists');
    }

    final newUser = AuthModel(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phone: phone,
      token: 'mock-jwt-token-new',
    );

    _users[phone] = newUser;
    _passwords[phone] = password;

    return newUser;
  }

  @override
  Future<bool> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Check if phone format is basic valid
    if (phone.isEmpty) {
      throw const CacheException(message: 'Invalid phone number');
    }

    // Hardcoded mock OTP for testing
    _sentOtps[phone] = '1111';

    return true;
  }

  @override
  Future<AuthModel> verifyOtp(String phone, String otp) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // if (_sentOtps[phone] != otp) {
    //   throw const CacheException(message: 'Invalid OTP');
    // }

    // Clear OTP after success
    _sentOtps.remove(phone);

    // If it's a login verification, return user
    if (_users.containsKey(phone)) {
      return _users[phone]!;
    } else {
      // Just return a temporary model for sign up flow to hold the token
      return AuthModel(id: 'temp', name: '', phone: phone, token: 'verified');
    }
  }

  @override
  Future<bool> resetPassword(String phone, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // if (!_users.containsKey(phone)) {
    //   throw const CacheException(message: 'User does not exist');
    // }

    // _passwords[phone] = newPassword;
    return true;
  }

  @override
  Future<bool> isLoggedIn() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // For mock, we'll say we're logged in if our mock users list is not empty
    // In a real app, this would check SharedPreferences for a stored token.
    return _users.isNotEmpty;
  }
}
