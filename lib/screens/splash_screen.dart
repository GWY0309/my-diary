import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 【新增】
import '../constants/colors.dart';
import 'auth/login_screen.dart';
import 'diary_list_screen.dart'; // 【新增】导入日记列表页

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //实例化存储对象
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  //检查登录状态并跳转
  Future<void> _checkLoginStatus() async {
    // 1. 保持启动图展示至少 2 秒（避免闪退太快用户看不清）
    // 注意：读取存储是异步的，通常很快，所以我们用 Future.wait 来确保最少展示时间
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)), // 动画时间
      _processAutoLogin(), // 读取存储
    ]);
  }

  Future<void> _processAutoLogin() async {
    // 读取自动登录标记
    String? isAutoLogin = await _storage.read(key: 'is_auto_login');

    if (!mounted) return;

    if (isAutoLogin == 'true') {
      // 🟢 情况 A：开启了自动登录 -> 跳到首页
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DiaryListScreen()),
      );
    } else {
      // 🔴 情况 B：没开启或第一次用 -> 跳到登录页
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'My Diary',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}