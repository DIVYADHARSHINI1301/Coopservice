import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.seaGreen,
      scaffoldBackgroundColor: AppColors.frostedMint.withOpacity(0.45),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.seaGreen,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.darkEmerald,
        onPrimaryContainer: AppColors.frostedMint,
        secondary: AppColors.mintLeaf2,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.celadon,
        onSecondaryContainer: AppColors.pineTeal,
        tertiary: AppColors.mintLeaf,
        onTertiary: AppColors.evergreen,
        error: AppColors.redDestructive,
        onError: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.evergreen,
        surfaceContainerLowest: AppColors.white,
        surfaceContainerLow: AppColors.frostedMint,
        surfaceContainer: AppColors.celadon,
        surfaceContainerHigh: AppColors.celadon2,
        outline: AppColors.subtleBorder,
        outlineVariant: AppColors.frostedMint,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.nunitoSans(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.darkEmerald,
        ),
        headlineLarge: GoogleFonts.nunitoSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.darkEmerald,
        ),
        headlineMedium: GoogleFonts.nunitoSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.darkEmerald,
        ),
        headlineSmall: GoogleFonts.nunitoSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkEmerald,
        ),
        titleMedium: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.evergreen,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.evergreen,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.evergreen,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.evergreen,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.evergreen,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkEmerald,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Nunito Sans',
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.celadon, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.55),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.celadon),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.celadon.withValues(alpha: 0.8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.seaGreen, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.redDestructive),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.seaGreen,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.mintLeaf2,
          side: const BorderSide(color: AppColors.mintLeaf2, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.seaGreen,
        unselectedItemColor: AppColors.textSecondary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.mintLeaf2,
      scaffoldBackgroundColor: AppColors.evergreen,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.mintLeaf2,
        onPrimary: AppColors.evergreen,
        primaryContainer: AppColors.pineTeal,
        onPrimaryContainer: AppColors.frostedMint,
        secondary: AppColors.seaGreen,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.pineTeal,
        onSecondaryContainer: AppColors.celadon,
        tertiary: AppColors.mintLeaf,
        onTertiary: AppColors.evergreen,
        error: AppColors.redDestructive,
        onError: AppColors.white,
        surface: AppColors.pineTeal,
        onSurface: AppColors.frostedMint,
        surfaceContainerLowest: AppColors.evergreen,
        surfaceContainerLow: AppColors.pineTeal,
        surfaceContainer: AppColors.pineTeal,
        surfaceContainerHigh: AppColors.darkEmerald,
        outline: AppColors.darkEmerald,
        outlineVariant: AppColors.pineTeal,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.pineTeal,
        foregroundColor: AppColors.frostedMint,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.pineTeal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkEmerald, width: 1),
        ),
      ),
    );
  }
}
