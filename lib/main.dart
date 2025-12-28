import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 需要在 pubspec.yaml 添加 provider 依赖
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'providers/theme_provider.dart'; // 导入我们创建的主题 Provider
import 'screens/splash_screen.dart';
import 'screens/auth/app_lock_verify_screen.dart';

void main() async {
  // 确保 Flutter 绑定初始化，因为后面有异步操作
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // 1. 在顶层注入 ThemeProvider，让整个 App 都能访问主题状态
    ChangeNotifierProvider(
      create: (_) => ThemeProvider()..loadTheme(), // 启动时自动加载保存的主题
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
    WidgetsBinding.instance.addObserver(this); // 注册生命周期监听
    _checkInitialLock(); // 启动时检查锁状态
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 监听应用生命周期变化（后台/前台切换）
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 当 App 进入后台（暂停）时，标记为需要锁定
    // 这样当用户切回来时，builder 中的逻辑会重新渲染并显示锁屏
    if (state == AppLifecycleState.paused) {
      _lockApp();
    }
  }

  // 启动时检查配置
  Future<void> _checkInitialLock() async {
    String? enabled = await _storage.read(key: 'app_lock_enabled');
    if (enabled == 'true') {
      setState(() => _isLocked = true);
    }
  }

  // 切后台时锁定
  Future<void> _lockApp() async {
    String? enabled = await _storage.read(key: 'app_lock_enabled');
    if (enabled == 'true') {
      setState(() => _isLocked = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 2. 获取当前的主题状态
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'My Diary',
      debugShowCheckedModeBanner: false,

      // 3. 绑定动态主题模式 (跟随系统、强制浅色、强制深色)
      themeMode: themeProvider.themeMode,

      // 定义日间模式主题 (参考 UI 文档)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6), // AppColors.backgroundLight
        primaryColor: const Color(0xFF6366F1), // AppColors.primary
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
          surface: Colors.white, // 卡片背景
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF3F4F6),
          foregroundColor: Color(0xFF1F2937), // 黑色文字
          elevation: 0,
        ),
      ),

      // 定义夜间模式主题 (参考 UI 文档)
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111827), // 夜间背景
        primaryColor: const Color(0xFF818CF8), // 夜间主色
        cardColor: const Color(0xFF1F2937), // 夜间卡片色
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF818CF8),
          brightness: Brightness.dark,
          surface: const Color(0xFF1F2937),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111827),
          foregroundColor: Color(0xFFF9FAFB), // 白色文字
          elevation: 0,
        ),
      ),

      home: const SplashScreen(),

      // 4. 核心拦截逻辑：使用 builder 保持锁屏在最上层
      builder: (context, child) {
        return Stack(
          children: [
            // 底层是正常的 App 页面 (Navigator)
            if (child != null) child,

            // 顶层是锁屏页 (如果锁定且已启用)
            if (_isLocked)
              AppLockVerifyScreen(
                onUnlocked: () => setState(() => _isLocked = false),
              ),
          ],
        );
      },
    );
  }
}