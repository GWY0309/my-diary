import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // 初始化加载主题设置
  Future<void> loadTheme() async {
    String? value = await _storage.read(key: 'theme_mode');
    if (value == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (value == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  // 切换主题
  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await _storage.write(key: 'theme_mode', value: isDark ? 'dark' : 'light');
    notifyListeners();
  }
}