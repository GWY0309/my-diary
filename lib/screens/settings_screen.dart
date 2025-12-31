import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart'; // 需要 local_auth
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/colors.dart';
import '../l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import 'auth/login_screen.dart';
import 'settings/app_lock_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  final _storage = const FlutterSecureStorage();

  bool _isBiometricEnabled = false;
  bool _isAppLockEnabled = false;
  bool _isPinSet = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // 加载锁的状态
  Future<void> _loadSettings() async {
    String? bioEnabled = await _storage.read(key: 'biometric_enabled');
    String? lockEnabled = await _storage.read(key: 'app_lock_enabled');
    String? pin = await _storage.read(key: 'app_lock_pin');

    if (mounted) {
      setState(() {
        _isBiometricEnabled = bioEnabled == 'true';
        _isAppLockEnabled = lockEnabled == 'true';
        _isPinSet = pin != null;
      });
    }
  }

  // 切换数字密码锁
  Future<void> _toggleAppLock(bool value) async {
    if (value) {
      // 开启逻辑
      if (_isPinSet) {
        // 如果已经设置过密码，直接开启
        await _storage.write(key: 'app_lock_enabled', value: 'true');
        setState(() => _isAppLockEnabled = true);
      } else {
        // 没设过密码，去设置页面
        await _navigateToSetPin();
      }
    } else {
      // 关闭逻辑：同时关闭生物识别
      await _storage.write(key: 'app_lock_enabled', value: 'false');
      await _storage.write(key: 'biometric_enabled', value: 'false');
      setState(() {
        _isAppLockEnabled = false;
        _isBiometricEnabled = false;
      });
    }
  }

  // 切换生物识别
  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      // 开启前检查
      if (!_isAppLockEnabled) {
        _showSnackBar("请先开启数字密码锁");
        return;
      }
      // 检查设备支持
      bool canCheck = await _auth.canCheckBiometrics;
      bool isSupported = await _auth.isDeviceSupported();

      if (!canCheck || !isSupported) {
        _showSnackBar("您的设备不支持或未开启生物识别");
        return;
      }
    }
    // 保存状态
    await _storage.write(key: 'biometric_enabled', value: value.toString());
    setState(() => _isBiometricEnabled = value);
  }

  Future<void> _navigateToSetPin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AppLockScreen()),
    );
    // 返回后刷新状态（因为在那个页面可能设置成功了）
    _loadSettings();
  }

  // 处理退出登录
  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.logout),
        content: const Text('确定要退出当前账号吗？\n下次进入需要重新登录。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('退出', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    await _storage.delete(key: 'is_auto_login');

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 外观与体验
          _buildSectionHeader(context, '外观与体验'),
          _buildCard(
            context,
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.darkMode),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: themeProvider.isDarkMode,
                activeColor: AppColors.primary,
                onChanged: (value) => themeProvider.toggleTheme(value),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 2. 隐私安全 (这里把两个锁分开列出)
          _buildSectionHeader(context, '隐私安全'),
          _buildCard(
            context,
            children: [
              // 第一行：数字密码锁
              SwitchListTile(
                title: const Text('数字密码锁'),
                secondary: const Icon(Icons.lock_outline),
                value: _isAppLockEnabled,
                activeColor: AppColors.primary,
                onChanged: (value) => _toggleAppLock(value),
              ),
              // 分割线，让视觉更清晰
              if (_isAppLockEnabled)
                const Divider(height: 1, indent: 16, endIndent: 16),

              // 第二行：生物识别解锁 (仅在开启密码锁后可用)
              SwitchListTile(
                title: const Text('生物识别解锁'),
                secondary: const Icon(Icons.fingerprint),
                subtitle: _isAppLockEnabled ? null : const Text('需先开启数字密码锁', style: TextStyle(fontSize: 12)),
                value: _isBiometricEnabled,
                activeColor: AppColors.primary,
                onChanged: _isAppLockEnabled
                    ? (value) => _toggleBiometric(value)
                    : null, // 如果没开密码锁，禁用此开关
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 3. 账号 (退出登录)
          _buildSectionHeader(context, '账号'),
          _buildCard(
            context,
            children: [
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text(
                  '退出登录',
                  style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                ),
                onTap: () => _handleLogout(context),
              ),
            ],
          ),

          const SizedBox(height: 40),
          Center(
            child: Text(
              'My Diary v1.0.0',
              style: TextStyle(color: theme.disabledColor, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}