import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 需确保已添加 shared_preferences 包

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  // 加载保存的语言设置
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  // 切换并保存语言
  Future<void> setLocale(Locale locale) async {
    // 可以在这里限制支持的语言列表，防止出错
    if (!['en', 'zh', 'ja', 'ko', 'es', 'fr'].contains(locale.languageCode)) return;

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }
}