import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFFF06292);
  static const Color accentColor = Color(0xFF00BFA5);
  
  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: false,
      iconTheme: IconThemeData(color: Color(0xFF424242)),
      titleTextStyle: TextStyle(
        color: Color(0xFF424242),
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: primaryColor, width: 1.5),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: primaryColor.withOpacity(0.1),
      labelStyle: const TextStyle(color: primaryColor),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF212121)),
      displayMedium: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF212121)),
      displaySmall: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF212121)),
      headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF212121)),
      titleLarge: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF212121)),
      bodyLarge: TextStyle(color: Color(0xFF424242)),
      bodyMedium: TextStyle(color: Color(0xFF616161)),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFF616161),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Color(0xFF9E9E9E),
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1,
      color: Color(0xFFEEEEEE),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: false,
      iconTheme: IconThemeData(color: Color(0xFFE0E0E0)),
      titleTextStyle: TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: primaryColor, width: 1.5),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: primaryColor.withOpacity(0.2),
      labelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF5F5F5)),
      displayMedium: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF5F5F5)),
      displaySmall: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF5F5F5)),
      headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF5F5F5)),
      titleLarge: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFF5F5F5)),
      bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
      bodyMedium: TextStyle(color: Color(0xFFBDBDBD)),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFBDBDBD),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: primaryColor,
      unselectedItemColor: Color(0xFF9E9E9E),
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1,
      color: Color(0xFF424242),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
    ),
  );
} 