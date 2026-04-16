import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.manrope(
      fontWeight: FontWeight.w800,
      fontSize: 48,
      color: AppColors.onSurface,
    ),
    headlineLarge: GoogleFonts.manrope(
      fontWeight: FontWeight.w700,
      fontSize: 32,
      color: AppColors.onSurface,
    ),
    headlineMedium: GoogleFonts.manrope(
      fontWeight: FontWeight.w700,
      fontSize: 28,
      color: AppColors.onSurface,
    ),
    headlineSmall: GoogleFonts.manrope(
      fontWeight: FontWeight.w600,
      fontSize: 24,
      color: AppColors.onSurface,
    ),
    titleLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 22,
      color: AppColors.onSurface,
    ),
    bodyLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: AppColors.onSurface,
    ),
    bodyMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: AppColors.onSurface,
    ),
    bodySmall: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: AppColors.onSurface,
    ),
    labelLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: AppColors.onSurface,
    ),
    labelSmall: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      fontSize: 11,
      color: AppColors.onSurface,
    ),
  );
}
