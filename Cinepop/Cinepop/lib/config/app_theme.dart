import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../themes/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.popRed,
      onPrimary: AppColors.white,
      secondary: AppColors.butterYellow,
      onSecondary: AppColors.midnightBlue,
      surface: AppColors.surface,
      onSurface: AppColors.white,
      error: AppColors.popRed,
      onError: AppColors.white,
    );

    final baseTextTheme = GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: AppColors.white, displayColor: AppColors.white);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.midnightBlue,
      colorScheme: colorScheme,
      textTheme: baseTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.midnightBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: const TextStyle(color: AppColors.muted),
        prefixIconColor: AppColors.muted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.popRed, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.popRed,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.popRed,
      ),
    );
  }
}
