import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State notifier for theme state
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemePreference();
  }

  static const String _prefsKey = 'theme_mode';

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_prefsKey);
    
    if (themeIndex != null) {
      state = ThemeMode.values[themeIndex];
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newMode;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, newMode.index);
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, mode.index);
  }
}

// Provider for theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

// Provider to check if the current theme is dark
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  if (themeMode == ThemeMode.system) {
    // Get system brightness using the correct API
    return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }
  return themeMode == ThemeMode.dark;
}); 