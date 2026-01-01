import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// 引入项目文件
import 'constants/colors.dart'; // 确保引入了 AppColors
import 'l10n/app_localizations.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart'; // ✅ 1. 引入 LocaleProvider
import 'screens/splash_screen.dart';
import 'screens/auth/app_lock_verify_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // ✅ 2. 使用 MultiProvider，同时注入 ThemeProvider 和 LocaleProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()), // 注入语言管理
      ],
      child: const MyDiaryApp(),
    ),
  );
}

class MyDiaryApp extends StatefulWidget {
  const MyDiaryApp({super.key});

  @override
  State<MyDiaryApp> createState() => _MyDiaryAppState();
}

class _MyDiaryAppState extends State<MyDiaryApp> with WidgetsBindingObserver {
  bool _isLocked = false;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 监听应用生命周期（切后台自动锁屏逻辑）
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      String? lockEnabled = await _storage.read(key: 'app_lock_enabled');
      if (lockEnabled == 'true') {
        setState(() {
          _isLocked = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 3. 改为 Consumer2，同时监听 ThemeProvider 和 LocaleProvider
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return MaterialApp(
          title: 'My Diary',
          debugShowCheckedModeBanner: false,

          // 主题配置
          theme: AppColors.lightTheme,
          darkTheme: AppColors.darkTheme,
          themeMode: themeProvider.themeMode,

          // ✅ 4. 核心：将 App 语言绑定到 Provider 的状态
          // 当 localeProvider.locale 改变时，App 会立即切换语言
          locale: localeProvider.locale,

          // 国际化配置
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // ✅ 5. 使用自动生成的支持语言列表 (包含 zh, en, ja, ko, es, fr)
          // 这样您添加新的 arb 文件后，不需要手动改这里
          supportedLocales: AppLocalizations.supportedLocales,

          home: const SplashScreen(),

          // 应用锁拦截器 (保持不变)
          builder: (context, child) {
            return Stack(
              children: [
                if (child != null) child,
                if (_isLocked)
                  Positioned.fill(
                    child: AppLockVerifyScreen(
                      onUnlocked: () {
                        setState(() {
                          _isLocked = false;
                        });
                      },
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}