import 'package:flutter/material.dart';

class AppTheme {
  // Accent Colors
  static const Color blueAccent = Color(0xFF2196F3);
  static const Color purpleAccent = Color(0xFF9C27B0);
  static const Color greenAccent = Color(0xFF4CAF50);
  static const Color orangeAccent = Color(0xFFFF9800);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0A1021);
  static const Color darkCard = Color(0xFF1C2439);
  static const Color darkSurface = Color(0xFF16243A);
  static const Color darkText = Color(0xFFE3F2FD);
  static const Color darkSubtext = Color(0xFF90CAF9);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFAFAFA);
  static const Color lightText = Color(0xFF212121);
  static const Color lightSubtext = Color(0xFF757575);

  // Get accent color by name
  static Color getAccentColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return blueAccent;
      case 'purple':
        return purpleAccent;
      case 'green':
        return greenAccent;
      case 'orange':
        return orangeAccent;
      default:
        return blueAccent;
    }
  }

  // Dark Theme
  static ThemeData darkTheme({Color? accentColor}) {
    final accent = accentColor ?? blueAccent;
    final base = ThemeData.dark();

    return base.copyWith(
      scaffoldBackgroundColor: darkBackground,
      primaryColor: accent,
      colorScheme: base.colorScheme.copyWith(
        primary: accent,
        secondary: accent.withOpacity(0.8),
        surface: darkCard,
        background: darkBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkText,
        onBackground: darkText,
        brightness: Brightness.dark,
      ),
      cardColor: darkCard,
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: accent),
        titleTextStyle: const TextStyle(
          color: darkText,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkCard,
        selectedItemColor: accent,
        unselectedItemColor: darkSubtext,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: accent.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: darkSubtext.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: accent, width: 2),
        ),
        hintStyle: TextStyle(color: darkSubtext),
        labelStyle: TextStyle(color: darkSubtext),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: darkText,
        displayColor: darkText,
      ),
      iconTheme: IconThemeData(color: accent),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accent;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accent.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
      dividerColor: accent.withOpacity(0.2),
      dialogTheme: DialogThemeData(
        backgroundColor: darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCard,
        contentTextStyle: const TextStyle(color: darkText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: darkCard,
        textColor: darkText,
        iconColor: accent,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkCard,
        labelStyle: const TextStyle(color: darkText),
        selectedColor: accent.withOpacity(0.3),
        secondarySelectedColor: accent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: accent,
        unselectedLabelColor: darkSubtext,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: accent, width: 2),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accent;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accent;
          }
          return darkSubtext;
        }),
      ),
    );
  }

  // Light Theme
  static ThemeData lightTheme({Color? accentColor}) {
    final accent = accentColor ?? blueAccent;
    final base = ThemeData.light();

    return base.copyWith(
      scaffoldBackgroundColor: lightBackground,
      primaryColor: accent,
      colorScheme: base.colorScheme.copyWith(
        primary: accent,
        secondary: accent.withOpacity(0.8),
        surface: lightCard,
        background: lightBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightText,
        onBackground: lightText,
        brightness: Brightness.light,
      ),
      cardColor: lightCard,
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightCard,
        foregroundColor: lightText,
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: accent),
        titleTextStyle: TextStyle(
          color: lightText,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightCard,
        selectedItemColor: accent,
        unselectedItemColor: lightSubtext,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: accent.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: lightSubtext.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: accent, width: 2),
        ),
        hintStyle: TextStyle(color: lightSubtext),
        labelStyle: TextStyle(color: lightSubtext),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: lightText,
        displayColor: lightText,
      ),
      iconTheme: IconThemeData(color: accent),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accent;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accent.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
      dividerColor: accent.withOpacity(0.2),
      dialogTheme: DialogThemeData(
        backgroundColor: lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightCard,
        contentTextStyle: TextStyle(color: lightText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: lightCard,
        textColor: lightText,
        iconColor: accent,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightSurface,
        labelStyle: TextStyle(color: lightText),
        selectedColor: accent.withOpacity(0.3),
        secondarySelectedColor: accent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: accent,
        unselectedLabelColor: lightSubtext,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: accent, width: 2),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accent;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accent;
          }
          return lightSubtext;
        }),
      ),
    );
  }
}
