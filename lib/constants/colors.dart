import 'package:flutter/material.dart';

class AppColors {
  // -------- 基础颜色定义 --------
  static const Color primary = Color(0xFF6366F1);       // 靛蓝色
  static const Color primaryLight = Color(0xFF818CF8);  // 浅靛蓝
  static const Color secondary = Color(0xFFEC4899);     // 粉色
  static const Color backgroundLight = Color(0xFFF9FAFB); // 浅色背景
  static const Color surfaceLight = Color(0xFFFFFFFF);    // 浅色卡片
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF6B7280);

  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);

  // -------- 深色模式颜色 --------
  static const Color backgroundDark = Color(0xFF111827); // 深色背景
  static const Color surfaceDark = Color(0xFF1F2937);    // 深色卡片
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // -------- ✅ 新增：亮色主题定义 (lightTheme) --------
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceLight,
    dividerColor: Colors.grey.shade200,

    // 字体主题
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textPrimaryLight),
      bodyMedium: TextStyle(color: textPrimaryLight),
      bodySmall: TextStyle(color: textSecondaryLight),
      titleMedium: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
    ),

    // 图标主题
    iconTheme: const IconThemeData(color: textPrimaryLight),

    // 颜色方案 (Material 3)
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      surface: surfaceLight,
      error: error,
    ),

    // AppBar 主题
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundLight,
      foregroundColor: textPrimaryLight,
      elevation: 0,
      iconTheme: IconThemeData(color: textPrimaryLight),
    ),

    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  // -------- ✅ 新增：深色主题定义 (darkTheme) --------
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: backgroundDark,
    cardColor: surfaceDark,
    dividerColor: Colors.grey.shade800,

    // 字体主题
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textPrimaryDark),
      bodyMedium: TextStyle(color: textPrimaryDark),
      bodySmall: TextStyle(color: textSecondaryDark),
      titleMedium: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
    ),

    // 图标主题
    iconTheme: const IconThemeData(color: textPrimaryDark),

    // 颜色方案 (Material 3)
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryLight,
      brightness: Brightness.dark,
      surface: surfaceDark,
      error: error,
    ),

    // AppBar 主题
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      iconTheme: IconThemeData(color: textPrimaryDark),
    ),

    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}