import 'package:e_laundry/core/entities/session_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_laundry/core/localization/cubit/language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final SharedPreferences sharedPreferences;
  static const String _languageKey = 'language_code';

  LanguageCubit({required this.sharedPreferences})
    : super(const LanguageState(Locale('en'))) {
    _loadLanguage();
  }

  void _loadLanguage() {
    final String? languageCode = sharedPreferences.getString(_languageKey);
    if (languageCode != null) {
      SessionData.currentLanguage = languageCode;
      emit(LanguageState(Locale(languageCode)));
    } else {
      SessionData.currentLanguage = 'en';
      emit(const LanguageState(Locale('en')));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    await sharedPreferences.setString(_languageKey, languageCode);
    SessionData.currentLanguage = languageCode;
    emit(LanguageState(Locale(languageCode)));
  }
}
