import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// 引入项目文件
import 'constants/colors.dart';
import 'l10n/app_localizations.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/app_lock_verify_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
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
  // ⚠️ 重点：如果有应用锁，我们希望默认先假设它是锁着的，或者尽快去检查
  // 但为了不闪屏，先设为 false，依靠下面的 checkInitialLock 快速覆盖
  bool _isLocked = false;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // ✅ 新增：App 刚启动（冷启动）时，也要检查是否需要锁屏
    _checkInitialLock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ✅ 新增：冷启动检查逻辑
  Future<void> _checkInitialLock() async {
    String? lockEnabled = await _storage.read(key: 'app_lock_enabled');
    if (lockEnabled == 'true') {
      setState(() {
        _isLocked = true;
      });
    }
  }

  // 监听应用生命周期（后台切前台逻辑，保持不变）
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
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return MaterialApp(
          title: 'My Diary',
          debugShowCheckedModeBanner: false,
          theme: AppColors.lightTheme,
          darkTheme: AppColors.darkTheme,
          themeMode: themeProvider.themeMode,
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,

          // 这里是 Splash，它在底层运行
          home: const SplashScreen(),

          // builder 这一层负责在所有页面之上覆盖“应用锁”
          builder: (context, child) {
            return Stack(
              children: [
                if (child != null) child,
                // 如果 _isLocked 为 true，这个 VerifyScreen 会盖住 SplashScreen 或 主页
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