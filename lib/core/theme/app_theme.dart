import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_iconography.dart';
import 'app_radii.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimary,
    secondary: AppColors.primaryContainer,
    onSecondary: AppColors.onPrimary,
    secondaryContainer: AppColors.surfaceContainer,
    onSecondaryContainer: AppColors.onSurface,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onPrimary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onPrimary,
    error: AppColors.error,
    onError: AppColors.onPrimary,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: Color(0xFF410002),
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: Colors.black26,
    scrim: Colors.black54,
    inverseSurface: Color(0xFF2E3133),
    onInverseSurface: Color(0xFFF0F1F3),
    inversePrimary: Color(0xFF9CCAFF),
    surfaceTint: AppColors.primary,
    surfaceContainerLowest: AppColors.surfaceContainerLowest,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
  );

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _lightColorScheme,
    scaffoldBackgroundColor: AppColors.surface,
    textTheme: AppTypography.textTheme,
    iconTheme: AppIconography.outlined,
    primaryIconTheme: AppIconography.filled,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
        color: AppColors.onPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surfaceContainerLowest,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.xl),
        side: const BorderSide(color: AppColors.outlineVariant),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
      labelStyle: AppTypography.textTheme.labelLarge?.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
      errorStyle: AppTypography.textTheme.bodySmall,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: 0,
        textStyle: AppTypography.textTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: AppTypography.textTheme.labelLarge,
        side: const BorderSide(color: AppColors.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: AppTypography.textTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceContainerLow,
      selectedColor: AppColors.primaryContainer,
      secondarySelectedColor: AppColors.primaryContainer,
      disabledColor: AppColors.surfaceContainerHigh,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      labelStyle: AppTypography.textTheme.labelSmall!.copyWith(
        color: AppColors.onSurface,
      ),
      secondaryLabelStyle: AppTypography.textTheme.labelSmall!.copyWith(
        color: AppColors.onPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.full),
        side: const BorderSide(color: AppColors.outlineVariant),
      ),
      brightness: Brightness.light,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.outlineVariant,
      thickness: 1,
      space: 1,
    ),
  );
}
