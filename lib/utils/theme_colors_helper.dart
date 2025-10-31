import 'package:flutter/material.dart';

/// Helper class for quick access to theme colors
/// This makes it easier to migrate from hardcoded colors to theme colors
class ThemeColors {
  final BuildContext context;
  
  ThemeColors(this.context);
  
  // Quick access to color scheme
  ColorScheme get scheme => Theme.of(context).colorScheme;
  
  // Background colors
  Color get background => scheme.background;
  Color get surface => scheme.surface;
  Color get card => Theme.of(context).cardColor;
  
  // Primary colors
  Color get primary => scheme.primary;
  Color get primaryLight => scheme.primary.withOpacity(0.8);
  Color get primaryDark => scheme.primary.withOpacity(0.6);
  Color get primarySubtle => scheme.primary.withOpacity(0.3);
  Color get primaryFaint => scheme.primary.withOpacity(0.1);
  
  // Text colors
  Color get textPrimary => scheme.onBackground;
  Color get textSecondary => scheme.onBackground.withOpacity(0.7);
  Color get textTertiary => scheme.onBackground.withOpacity(0.5);
  Color get textDisabled => scheme.onBackground.withOpacity(0.3);
  
  // Surface text colors
  Color get surfaceText => scheme.onSurface;
  Color get surfaceTextSecondary => scheme.onSurface.withOpacity(0.7);
  Color get surfaceTextTertiary => scheme.onSurface.withOpacity(0.5);
  
  // Border colors
  Color get border => scheme.onSurface.withOpacity(0.2);
  Color get borderLight => scheme.onSurface.withOpacity(0.1);
  Color get borderPrimary => scheme.primary.withOpacity(0.3);
  
  // Divider colors
  Color get divider => scheme.onSurface.withOpacity(0.12);
  
  // Semantic colors
  Color get success => Colors.green.shade400;
  Color get error => Colors.red.shade400;
  Color get warning => Colors.orange.shade400;
  Color get info => scheme.primary;
  
  // Gradient colors
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Check if dark mode
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  
  // Common color combinations
  BoxDecoration cardDecoration({
    double borderRadius = 12,
    bool withBorder = true,
  }) {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: withBorder ? Border.all(color: border) : null,
    );
  }
  
  BoxDecoration primaryCardDecoration({
    double borderRadius = 12,
  }) {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderPrimary, width: 2),
    );
  }
  
  BoxDecoration gradientDecoration({
    double borderRadius = 12,
  }) {
    return BoxDecoration(
      gradient: primaryGradient,
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
  
  // Text styles
  TextStyle get heading1 => TextStyle(
    color: textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  TextStyle get heading2 => TextStyle(
    color: textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  
  TextStyle get heading3 => TextStyle(
    color: textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  
  TextStyle get bodyLarge => TextStyle(
    color: textPrimary,
    fontSize: 16,
  );
  
  TextStyle get bodyMedium => TextStyle(
    color: textPrimary,
    fontSize: 14,
  );
  
  TextStyle get bodySmall => TextStyle(
    color: textSecondary,
    fontSize: 12,
  );
  
  TextStyle get caption => TextStyle(
    color: textTertiary,
    fontSize: 12,
  );
  
  TextStyle get label => TextStyle(
    color: textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}

/// Extension for easy access to ThemeColors
extension ThemeColorsExtension on BuildContext {
  ThemeColors get colors => ThemeColors(this);
}

/// Common color migration mappings
/// Use this as a reference when converting hardcoded colors
class ColorMigrationGuide {
  // Dark theme colors -> Theme equivalents
  static const Map<String, String> darkColorMapping = {
    '0xFF0A1021': 'colorScheme.background',
    '0xFF1C2439': 'colorScheme.surface',
    '0xFF16243A': 'colorScheme.surface',
    '0xFF2C2C30': 'colorScheme.surface',
    '0xFF2D3548': 'colorScheme.onSurface.withOpacity(0.1)',
    '0xFFE3F2FD': 'colorScheme.onBackground',
    '0xFF90CAF9': 'colorScheme.onBackground.withOpacity(0.7)',
    '0xFF64748B': 'colorScheme.onSurface.withOpacity(0.5)',
    '0xFF2196F3': 'colorScheme.primary',
    '0xFF9C27B0': 'colorScheme.primary (purple)',
    '0xFF4CAF50': 'colorScheme.primary (green)',
    '0xFFFF9800': 'colorScheme.primary (orange)',
  };
  
  // Light theme colors -> Theme equivalents
  static const Map<String, String> lightColorMapping = {
    '0xFFF5F5F5': 'colorScheme.background',
    '0xFFFFFFFF': 'colorScheme.surface',
    '0xFFFAFAFA': 'colorScheme.surface',
    '0xFF212121': 'colorScheme.onBackground',
    '0xFF757575': 'colorScheme.onSurface.withOpacity(0.6)',
  };
  
  // Generic mappings
  static const Map<String, String> genericMapping = {
    'Colors.white (on dark bg)': 'colorScheme.onBackground',
    'Colors.black (on light bg)': 'colorScheme.onBackground',
    'Hardcoded blue': 'colorScheme.primary',
    'Hardcoded purple': 'colorScheme.primary',
    'Hardcoded green': 'colorScheme.primary',
    'Hardcoded orange': 'colorScheme.primary',
  };
}

/// Quick color replacement helper
/// Example usage:
/// ```dart
/// // Before:
/// color: const Color(0xFF0A1021)
/// 
/// // After:
/// color: context.colors.background
/// ```
class QuickColorReplacements {
  // Common replacements
  static Color background(BuildContext context) => 
      Theme.of(context).colorScheme.background;
  
  static Color surface(BuildContext context) => 
      Theme.of(context).colorScheme.surface;
  
  static Color primary(BuildContext context) => 
      Theme.of(context).colorScheme.primary;
  
  static Color text(BuildContext context) => 
      Theme.of(context).colorScheme.onBackground;
  
  static Color textSecondary(BuildContext context) => 
      Theme.of(context).colorScheme.onBackground.withOpacity(0.7);
  
  static Color border(BuildContext context) => 
      Theme.of(context).colorScheme.onSurface.withOpacity(0.2);
}
