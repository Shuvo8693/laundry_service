import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _tokenKey = 'auth_token';

  AuthLocalDataSource({required this.sharedPreferences});

  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    await sharedPreferences.remove(_tokenKey);
  }
}
