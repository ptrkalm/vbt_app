import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryColor = Color.fromRGBO(253, 120, 25, 1.0);
  static const Color secondaryColor = Color.fromRGBO(148, 147, 181, 1.0);
  static const Color tertiaryColor = Color.fromRGBO(237, 240, 218, 1.0);
  static const Color backgroundColor = Color.fromRGBO(29, 29, 29, 1.0);
  static const Color backgroundColorAccent = Color.fromRGBO(14, 14, 14, 1.0);
  static const Color titleColor = Color.fromRGBO(236, 236, 236, 1.0);
  static const Color textColor = Color.fromRGBO(211, 211, 211, 1.0);
}

ThemeData primaryTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
    ),

    scaffoldBackgroundColor: AppColors.backgroundColorAccent,

    appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.textColor,
        centerTitle: true),

    fontFamily: GoogleFonts.kanit().fontFamily,
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        fontFeatures: <FontFeature>[
          FontFeature.fractions()
        ],
        color: AppColors.textColor,
        fontSize: 14,
        letterSpacing: 0.8,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textColor,
        fontSize: 16,
        letterSpacing: 1,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textColor,
        fontSize: 24,
        letterSpacing: 1,
      ),
      headlineSmall: TextStyle(
          color: AppColors.titleColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1),
      headlineMedium: TextStyle(
          color: AppColors.titleColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1),
      headlineLarge: TextStyle(
          color: AppColors.titleColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1),
      titleMedium: TextStyle(
          color: AppColors.titleColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1),
      titleLarge: TextStyle(
          color: AppColors.titleColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.titleColor,
            foregroundColor: AppColors.backgroundColor)),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.backgroundColorAccent,
          foregroundColor: AppColors.primaryColor,
          disabledForegroundColor: AppColors.textColor.withOpacity(0.3)
      ).copyWith(
          side: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(color: AppColors.textColor.withOpacity(0.3));
            }
            return const BorderSide(color: AppColors.primaryColor);
          })
        ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundColor,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.secondaryColor),

    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.primaryColor,
      inactiveTrackColor: Colors.white12,
      thumbColor: AppColors.primaryColor,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: AppColors.textColor)
    ),

    splashFactory: NoSplash.splashFactory
);
