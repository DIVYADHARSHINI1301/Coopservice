import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Defines Nunito Sans for headings & brand titles, and Inter for clean readable body text
class AppTypography {
  AppTypography._();

  // Headings (Nunito Sans)
  static TextStyle headlineLarge({Color color = AppColors.darkEmerald}) =>
      GoogleFonts.nunitoSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.33,
        letterSpacing: -0.3,
        color: color,
      );

  static TextStyle headlineMedium({Color color = AppColors.darkEmerald}) =>
      GoogleFonts.nunitoSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.4,
        letterSpacing: -0.2,
        color: color,
      );

  static TextStyle headlineSmall({Color color = AppColors.darkEmerald}) =>
      GoogleFonts.nunitoSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: color,
      );

  static TextStyle titleMedium({Color color = AppColors.evergreen}) =>
      GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.37,
        color: color,
      );

  // Body & Labels (Inter)
  static TextStyle bodyLarge({Color color = AppColors.evergreen}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: -0.15,
        color: color,
      );

  static TextStyle bodyMedium({Color color = AppColors.evergreen}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.42,
        letterSpacing: -0.1,
        color: color,
      );

  static TextStyle bodySmall({Color color = AppColors.textSecondary}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        color: color,
      );

  static TextStyle labelLarge({Color color = AppColors.evergreen}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.28,
        letterSpacing: 0.1,
        color: color,
      );

  static TextStyle labelMedium({Color color = AppColors.evergreen}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0.2,
        color: color,
      );

  static TextStyle labelSmall({Color color = AppColors.textSecondary}) =>
      GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.27,
        letterSpacing: 0.25,
        color: color,
      );
}
