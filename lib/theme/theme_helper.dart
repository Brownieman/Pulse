import 'package:flutter/material.dart';
import 'package:talkzy_beta1/theme/app_theme.dart';

class ThemeHelper {
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color backgroundColor(BuildContext context) =>
      isDark(context) ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

  static Color cardColor(BuildContext context) =>
      isDark(context) ? const Color(0xFF1E1E1E) : Colors.white;

  static Color borderColor(BuildContext context) =>
      isDark(context) ? const Color(0xFF2C2C2C) : AppTheme.borderColor;

  static Color textPrimaryColor(BuildContext context) =>
      isDark(context) ? Colors.white : AppTheme.textPrimaryColor;

  static Color textSecondaryColor(BuildContext context) =>
      isDark(context) ? const Color(0xFFB0B0B0) : AppTheme.textSecoundaryColor;

  static Color primaryColor(BuildContext context) => AppTheme.primaryColor;
}
