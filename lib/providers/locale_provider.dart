import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final String? scriptCode = prefs.getString('script_code'); // 加载脚本代码 (用于繁体)

    if (languageCode != null) {
      if (languageCode == 'zh' && scriptCode == 'Hant') {
        _locale = const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
      } else {
        _locale = Locale(languageCode);
      }
      notifyListeners();
    }
  }

  // 切换并保存语言
  Future<void> setLocale(Locale locale) async {
    // 简单的支持列表检查 (为了安全)
    const supported = [
      'en', 'zh', 'ja', 'ko', 'es', 'fr', 'de', 'fil', 'it',
      'pt', 'ru', 'sv', 'tr', 'nl', 'pl', 'ro', 'id', 'ms',
      'th', 'vi', 'ar', 'fa', 'hi'
    ];

    // 如果不是支持的语言代码，直接返回 (繁体中文 languageCode 也是 zh，所以能通过)
    if (!supported.contains(locale.languageCode)) return;

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);

    // 特殊处理繁体中文的 scriptCode
    if (locale.scriptCode != null) {
      await prefs.setString('script_code', locale.scriptCode!);
    } else {
      await prefs.remove('script_code');
    }
  }
}