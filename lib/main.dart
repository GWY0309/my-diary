import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'screens/diary_list_screen.dart'; // 导入我们创建的日记列表页面

void main() {
  runApp(const MyDiaryApp());
}

class MyDiaryApp extends StatelessWidget {
  const MyDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Diary',
      debugShowCheckedModeBanner: false,

      // 日间模式主题配置
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          primary: AppColors.primary,
          background: AppColors.backgroundLight,
          surface: AppColors.surfaceLight,
        ),
        // 按照文档设置卡片圆角为 16dp
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        // 统一配置 AppBar 样式
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),

      // 夜间模式主题配置
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          primary: AppColors.primaryLight,
          background: AppColors.backgroundDark,
          surface: AppColors.surfaceDark,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),

      // 设置首页为真正的日记列表页面
      home: const DiaryListScreen(),
    );
  }
}