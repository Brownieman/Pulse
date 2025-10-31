import 'package:flutter/material.dart';

/// Extension to easily access theme colors throughout the app
extension ThemeExtensions on BuildContext {
  // Color Scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  // Primary Colors
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => colorScheme.background;
  Color get surfaceColor => colorScheme.surface;
  
  // Text Colors
  Color get textColor => colorScheme.onBackground;
  Color get subtextColor => colorScheme.onSurface.withOpacity(0.7);
  
  // Card Color
  Color get cardColor => Theme.of(this).cardColor;
  
  // Specific App Colors (for backward compatibility)
  Color get appBackground => colorScheme.background;
  Color get appCard => colorScheme.surface;
  Color get appPrimary => colorScheme.primary;
  Color get appText => colorScheme.onBackground;
  Color get appSubtext => colorScheme.onSurface.withOpacity(0.6);
  
  // Semantic Colors
  Color get successColor => Colors.green;
  Color get errorColor => Colors.red;
  Color get warningColor => Colors.orange;
  Color get infoColor => colorScheme.primary;
  
  // Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  // Text Theme
  TextTheme get textTheme => Theme.of(this).textTheme;
}

/// Common color constants that work with both themes
class AppColors {
  // These colors adapt based on theme
  static Color getBackground(BuildContext context) => 
      Theme.of(context).colorScheme.background;
  
  static Color getCard(BuildContext context) => 
      Theme.of(context).colorScheme.surface;
  
  static Color getPrimary(BuildContext context) => 
      Theme.of(context).colorScheme.primary;
  
  static Color getText(BuildContext context) => 
      Theme.of(context).colorScheme.onBackground;
  
  static Color getSubtext(BuildContext context) => 
      Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
  
  // Semantic colors (same in both themes)
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
}
