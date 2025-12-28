import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 【新增】导入 provider
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/colors.dart';
import '../providers/theme_provider.dart'; // 【新增】导入主题提供者
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

  Future<void> _toggleAppLock(bool value) async {
    if (value) {
      if (_isPinSet) {
        await _storage.write(key: 'app_lock_enabled', value: 'true');
        setState(() => _isAppLockEnabled = true);
      } else {
        await _navigateToSetPin();
      }
    } else {
      await _storage.write(key: 'app_lock_enabled', value: 'false');
      await _storage.write(key: 'biometric_enabled', value: 'false');

      setState(() {
        _isAppLockEnabled = false;
        _isBiometricEnabled = false;
      });
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      if (!_isAppLockEnabled) {
        _showSnackBar("请先开启数字密码锁");
        return;
      }

      bool canCheck = await _auth.canCheckBiometrics;
      bool isSupported = await _auth.isDeviceSupported();

      if (!canCheck || !isSupported) {
        _showSnackBar("您的设备不支持或未开启生物识别");
        return;
      }
    }

    await _storage.write(key: 'biometric_enabled', value: value.toString());
    setState(() => _isBiometricEnabled = value);
  }

  Future<void> _navigateToSetPin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AppLockScreen()),
    );
    _loadSettings();
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // 【关键修复 1】：获取 ThemeProvider 实例
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      // 使用主题背景色，而不是硬编码的颜色，确保切换时背景也会变
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('设置', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle('通用'),

          // 【关键修复 2】：连接真实的开关逻辑
          _buildSettingsTile(
            icon: Icons.dark_mode_outlined,
            title: '深色模式',
            trailing: Switch(
              // 绑定当前是否为深色模式
              value: themeProvider.isDarkMode,
              // 绑定切换逻辑
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
              activeColor: AppColors.primary,
            ),
          ),

          const Divider(height: 32),
          _buildSectionTitle('安全'),

          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: '数字密码锁',
            onTap: _isAppLockEnabled ? _navigateToSetPin : null,
            trailing: Switch(
              value: _isAppLockEnabled,
              onChanged: _toggleAppLock,
              activeColor: AppColors.primary,
            ),
          ),

          _buildSettingsTile(
            icon: Icons.fingerprint,
            title: '生物识别解锁',
            onTap: _isAppLockEnabled ? () => _toggleBiometric(!_isBiometricEnabled) : null,
            trailing: Switch(
              value: _isBiometricEnabled,
              onChanged: _isAppLockEnabled ? _toggleBiometric : null,
              activeColor: AppColors.primary,
            ),
          ),

          const Divider(height: 32),
          _buildSectionTitle('关于'),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: '软件版本',
            trailing: const Text('v1.0.0', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(title, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap
  }) {
    // 获取当前主题的卡片颜色，确保在深色模式下列表项背景正确
    // 如果没有特别定义卡片颜色，可以使用 Theme.of(context).cardColor
    final tileColor = Theme.of(context).cardColor;

    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimaryLight), // 注意：这里的颜色可能也需要根据主题适配，后续可以优化
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
      tileColor: tileColor, // 使用动态颜色
      enabled: onTap != null || trailing is Switch,
    );
  }
}