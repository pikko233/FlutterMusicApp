// lib/core/constants/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === 背景色系 ===
  static const Color bgPrimary = Color(0xFF0F0F1A); // 最深背景
  static const Color bgSecondary = Color(0xFF1A1A2E); // 次级背景
  static const Color bgCard = Color(0xFF1E1E30); // 卡片/列表项背景
  static const Color bgElevated = Color(0xFF252540); // 弹窗/底部导航
  static const Color bgAppBar = Color(0xFF1A0A2E); // 播放页顶部的氛围色

  // === 主色 (Indigo/Purple) ===
  static const Color primary = Color(0xFF6C63FF); // 主色调
  static const Color primaryLight = Color(0xFF8B84FF);
  static const Color primaryDark = Color(0xFF4A42DD);
  static const Color primaryAuth = Color(0xFF7C3BEB); // 登录页的色调

  // === 强调色 ===
  static const Color accent1 = Color(0xFFEC4899); // 粉紫 (like/热门)
  static const Color accent2 = Color(0xFF3B82F6); // 蓝色 (信息/链接)
  static const Color accent3 = Color(0xFF10B981); // 绿色 (成功/播放中)
  static const Color accent4 = Color(0xFFF59E0B); // 琥珀 (警告/精选)

  // === 渐变预设 ===
  static const LinearGradient gradientPrimary = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientPink = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientGreen = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientWarm = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientProgress = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFFEC4899)],
  );

  // === 文字色 ===
  static const Color textPrimary = Color(0xFFFFFFFF);
  static final Color textPrimary80 = const Color(
    0xFFFFFFFF,
  ).withValues(alpha: 0.8);
  static final Color textPrimary60 = const Color(
    0xFFFFFFFF,
  ).withValues(alpha: 0.6);
  static final Color textPrimary40 = const Color(
    0xFFFFFFFF,
  ).withValues(alpha: 0.4);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textHint = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF4B5563);

  // === 功能色 ===
  static const Color like = Color(0xFFEC4899);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // === 分割线/边框 ===
  static const Color divider = Color(0x14FFFFFF); // 8% white
  static const Color border = Color(0x29FFFFFF); // 16% white
}
