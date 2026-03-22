// lib/core/constants/app_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgCard,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent1,
      surface: AppColors.bgCard,
      error: AppColors.error,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColors.bgPrimary,
      indicatorColor: Colors.transparent,
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.bgCard,
      thumbColor: AppColors.textPrimary,
    ),
    fontFamily: 'NotoSansSC', // 或使用 SF Pro / Poppins
  );
}
