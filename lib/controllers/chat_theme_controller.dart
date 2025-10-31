import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatThemeBackground {
  final Color? color;
  final Gradient? gradient;
  final Color bottomBorderColor;

  ChatThemeBackground({
    this.color,
    this.gradient,
    required this.bottomBorderColor,
  });
}

class ChatThemeController extends GetxController {
  static const String _chatThemeKey = 'chat_theme';
  
  final RxString _selectedTheme = 'default'.obs;
  
  String get selectedTheme => _selectedTheme.value;
  
  @override
  void onInit() {
    super.onInit();
    _loadChatTheme();
  }
  
  Future<void> _loadChatTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_chatThemeKey);
      
      if (savedTheme != null) {
        _selectedTheme.value = savedTheme;
      }
    } catch (e) {
      print('Error loading chat theme: $e');
    }
  }
  
  Future<void> setChatTheme(String theme) async {
    try {
      _selectedTheme.value = theme;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_chatThemeKey, theme);
    } catch (e) {
      print('Error saving chat theme: $e');
    }
  }
  
  // Get app bar background based on theme
  ChatThemeBackground appBarBackgroundFor({required bool isDark}) {
    switch (_selectedTheme.value) {
      case 'blue':
        return ChatThemeBackground(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          bottomBorderColor: Color(0xFF1976D2).withOpacity(0.3),
        );
      case 'purple':
        return ChatThemeBackground(
          gradient: LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          bottomBorderColor: Color(0xFF7B1FA2).withOpacity(0.3),
        );
      case 'green':
        return ChatThemeBackground(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          bottomBorderColor: Color(0xFF388E3C).withOpacity(0.3),
        );
      default:
        return ChatThemeBackground(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
          bottomBorderColor: isDark 
              ? Colors.white.withOpacity(0.1) 
              : Colors.black.withOpacity(0.1),
        );
    }
  }
  
  // Get page background based on theme
  ChatThemeBackground pageBackgroundFor({required bool isDark}) {
    switch (_selectedTheme.value) {
      case 'blue':
        return ChatThemeBackground(
          color: isDark ? Color(0xFF0D1B2A) : Color(0xFFE3F2FD),
          bottomBorderColor: Colors.transparent,
        );
      case 'purple':
        return ChatThemeBackground(
          color: isDark ? Color(0xFF1A0D2E) : Color(0xFFF3E5F5),
          bottomBorderColor: Colors.transparent,
        );
      case 'green':
        return ChatThemeBackground(
          color: isDark ? Color(0xFF0D1F0D) : Color(0xFFE8F5E9),
          bottomBorderColor: Colors.transparent,
        );
      default:
        return ChatThemeBackground(
          color: isDark ? Color(0xFF121212) : Color(0xFFF5F5F5),
          bottomBorderColor: Colors.transparent,
        );
    }
  }
  
  // Get accent color for send button, etc.
  Color accentColorFor({required bool isDark}) {
    switch (_selectedTheme.value) {
      case 'blue':
        return Color(0xFF2196F3);
      case 'purple':
        return Color(0xFF9C27B0);
      case 'green':
        return Color(0xFF4CAF50);
      default:
        return Color(0xFF2B5BFF);
    }
  }
}
