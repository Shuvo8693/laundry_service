import 'package:connectivity_plus/connectivity_plus.dart';

class UserData {
  final String token;
  UserData({required this.token});
}

class SessionData {
  static UserData? _userData;
  static SessionData? _instance;
  static ConnectivityResult connectivityResult = ConnectivityResult.none;
  static String? currentLanguage;

  static SessionData get getInstance => _instance ??= SessionData();

  static Future<void> start() async {
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    connectivityResult = results.isNotEmpty ? results.first: ConnectivityResult.none;
  }

  static void setNewSession(UserData userData) {
    _userData = userData;
  }

  static void clearSession() {
    _instance = null;
    _userData = null;
    currentLanguage = null;
  }

  static UserData? get getUserData => _userData;
}
