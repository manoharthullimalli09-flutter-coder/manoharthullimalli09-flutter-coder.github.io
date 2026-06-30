import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences prefs;
  static const _key = 'theme_mode';

  ThemeCubit({required this.prefs}) : super(_loadTheme(prefs));

  static ThemeMode _loadTheme(SharedPreferences prefs) {
    final saved = prefs.getString(_key);
    if (saved == 'light') return ThemeMode.light;
    return ThemeMode.dark;
  }

  void toggleTheme() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    prefs.setString(_key, next == ThemeMode.dark ? 'dark' : 'light');
    emit(next);
  }

  bool get isDark => state == ThemeMode.dark;
}
