import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ 核心引用
import '../constants/colors.dart';
import 'auth/login_screen.dart';
import 'diary_list_screen.dart';
import '../../l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // 不需要 FlutterSecureStorage 了，因为 LoginScreen 用的是 SharedPreferences

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // 使用 Future.wait 确保至少展示 2 秒动画，同时也去读取数据
    // 这样不会因为读取数据太快导致闪屏
    final results = await Future.wait([
      Future.delayed(const Duration(seconds: 2)), // 保证 UI 至少停留 2 秒
      _getLoginState(), // 去读取本地存储
    ]);

    // 结果索引 1 是 _getLoginState 的返回值
    final bool shouldGoToHome = results[1] as bool;

    if (!mounted) return;

    // 根据判断结果跳转
    if (shouldGoToHome) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DiaryListScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  // ✅ 核心逻辑：读取 SharedPreferences
  Future<bool> _getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('current_user_id');
    final isRemembered = prefs.getBool('is_remembered') ?? false;

    // 只有当【有用户ID】且【用户勾选了记住我】时，才返回 true (去主页)
    return userId != null && isRemembered;
  }

  // 👇 下面是您的 UI 代码，我完全保持原样，未做任何修改 👇
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