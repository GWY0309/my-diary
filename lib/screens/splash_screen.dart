import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/colors.dart';
import 'auth/login_screen.dart';
import 'diary_list_screen.dart';
import '../../l10n/app_localizations.dart'; // 导入

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      _processAutoLogin(),
    ]);
  }

  Future<void> _processAutoLogin() async {
    String? isAutoLogin = await _storage.read(key: 'is_auto_login');
    if (!mounted) return;
    if (isAutoLogin == 'true') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DiaryListScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // 启动页有时可能拿不到 context，如果报错可以用硬编码 'My Diary'
    // 但通常在 MaterialApp 构建后是可以拿到的
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryLight, AppColors.primary],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book_rounded, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              // 这里如果 l10n 报错（极少情况），可回退写死 'My Diary'
              // 因为 Splash 可能早于 Localization 初始化完成
              AppLocalizations.of(context)?.appTitle ?? 'My Diary',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white70)),
          ],
        ),
      ),
    );
  }
}