
import 'package:flutter/material.dart';

import 'typography.dart';
import 'colors.dart';

class AppThemeFactory {
  static ThemeData defaultTheme() {
    return ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.white,
        onPrimary: AppColors.brown,
        secondary: AppColors.brown,
        onSecondary: AppColors.white,
        error: AppColors.red,
        onError: AppColors.white,
        background: AppColors.white,
        onBackground: AppColors.brown,
        surface: AppColors.white,
        onSurface: AppColors.brown
      ),

      scaffoldBackgroundColor: AppColors.white,

/*
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBrown,
        shadowColor: AppColors.lightBrown,
        elevation: 0,
        centerTitle: true,
        actionsIconTheme: IconThemeData(
            color: AppColors.black
        ),
        iconTheme: IconThemeData(
          color: AppColors.black
        )
      ),
*/

      fontFamily: 'Lemon',

      textTheme: const TextTheme(
        headlineSmall: AppTypography.s24w400,
        headlineMedium: AppTypography.s24w400,
        headlineLarge: AppTypography.s24w400,

        titleSmall: AppTypography.s14w400,
        titleMedium: AppTypography.s14w400,

        bodySmall: AppTypography.s14w400,
        bodyMedium: AppTypography.s14w400,
      )
    );
  }
}