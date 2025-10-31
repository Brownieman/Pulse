import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkzy_beta1/utils/app_theme.dart';

class ThemeController extends GetxController {
  static const String _themeKey = 'theme_mode';
  static const String _accentColorKey = 'accent_color';
  
  final Rx<ThemeMode> _themeMode = ThemeMode.dark.obs;
  final RxString _accentColor = 'blue'.obs;
  
  ThemeMode get themeMode => _themeMode.value;
  String get accentColor => _accentColor.value;
  
  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }
  
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      final savedAccent = prefs.getString(_accentColorKey);
      
      if (savedTheme != null) {
        _themeMode.value = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedTheme,
          orElse: () => ThemeMode.dark,
        );
      }
      
      if (savedAccent != null) {
        _accentColor.value = savedAccent;
      }
      
      // Apply the loaded theme
      _applyTheme();
    } catch (e) {
      print('Error loading theme mode: $e');
    }
  }
  
  void _applyTheme() {
    final accent = AppTheme.getAccentColor(_accentColor.value);
    
    // Determine which theme to apply based on mode
    ThemeData themeToApply;
    if (_themeMode.value == ThemeMode.system) {
      // For system mode, apply the appropriate theme based on platform brightness
      themeToApply = Get.isPlatformDarkMode 
          ? AppTheme.darkTheme(accentColor: accent)
          : AppTheme.lightTheme(accentColor: accent);
    } else if (_themeMode.value == ThemeMode.dark) {
      themeToApply = AppTheme.darkTheme(accentColor: accent);
    } else {
      themeToApply = AppTheme.lightTheme(accentColor: accent);
    }
    
    Get.changeTheme(themeToApply);
    Get.changeThemeMode(_themeMode.value);
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      _themeMode.value = mode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.toString());
      
      _applyTheme();
      
      Get.snackbar(
        'Theme Updated',
        'Theme mode changed to ${_getThemeModeName(mode)}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error saving theme mode: $e');
    }
  }
  
  Future<void> setAccentColor(String colorName) async {
    try {
      _accentColor.value = colorName;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accentColorKey, colorName);
      
      _applyTheme();
      
      Get.snackbar(
        'Accent Color Updated',
        'Accent color changed to ${colorName.capitalize}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error saving accent color: $e');
    }
  }
  
  void toggleTheme() {
    if (_themeMode.value == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
  
  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.dark;
  }
  
  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }
}
