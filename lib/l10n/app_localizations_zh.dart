// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '我的日记';

  @override
  String get settings => '设置';

  @override
  String get darkMode => '深色模式';

  @override
  String get login => '登录';

  @override
  String get logout => '退出登录';

  @override
  String get appLock => '应用锁';
}
