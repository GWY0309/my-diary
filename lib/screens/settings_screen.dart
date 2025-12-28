import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/colors.dart';
import 'settings/app_lock_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  final _storage = const FlutterSecureStorage();

  bool _isBiometricEnabled = false; // 生物识别开关状态
  bool _isAppLockEnabled = false;   // 【新增】应用锁总开关状态
  bool _isPinSet = false;           // 是否已设置过密码

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// 加载所有安全配置
  Future<void> _loadSettings() async {
    String? bioEnabled = await _storage.read(key: 'biometric_enabled');
    String? lockEnabled = await _storage.read(key: 'app_lock_enabled'); // 读取总开关
    String? pin = await _storage.read(key: 'app_lock_pin');

    setState(() {
      _isBiometricEnabled = bioEnabled == 'true';
      _isAppLockEnabled = lockEnabled == 'true';
      _isPinSet = pin != null;
    });
  }

  /// 【核心逻辑】切换应用锁开关
  Future<void> _toggleAppLock(bool value) async {
    if (value) {
      // 开启逻辑
      if (_isPinSet) {
        // 如果密码已存在，直接开启
        await _storage.write(key: 'app_lock_enabled', value: 'true');
        setState(() => _isAppLockEnabled = true);
      } else {
        // 如果密码不存在，去设置页
        await _navigateToSetPin();
      }
    } else {
      // 关闭逻辑
      await _storage.write(key: 'app_lock_enabled', value: 'false');
      // 联动关闭生物识别（因为生物识别依赖应用锁）
      await _storage.write(key: 'biometric_enabled', value: 'false');

      setState(() {
        _isAppLockEnabled = false;
        _isBiometricEnabled = false;
      });
    }
  }

  /// 切换生物识别开关
  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      // 开启前检查：必须先开启应用锁
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

  /// 跳转到密码设置页
  Future<void> _navigateToSetPin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AppLockScreen()),
    );
    // 返回后刷新状态
    _loadSettings();
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
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
          _buildSettingsTile(
            icon: Icons.dark_mode_outlined,
            title: '深色模式',
            trailing: Switch(value: false, onChanged: (v) {}, activeColor: AppColors.primary),
          ),

          const Divider(height: 32),
          _buildSectionTitle('安全'),

          // 1. 数字密码锁（带开关）
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: '数字密码锁',
            // 如果已开启，点击整行可以去修改密码；如果未开启，点击无反应或去开启
            onTap: _isAppLockEnabled ? _navigateToSetPin : null,
            trailing: Switch(
              value: _isAppLockEnabled,
              onChanged: _toggleAppLock, // 绑定新逻辑
              activeColor: AppColors.primary,
            ),
          ),

          // 2. 生物识别解锁
          _buildSettingsTile(
            icon: Icons.fingerprint,
            title: '生物识别解锁',
            // 如果主开关没开，禁用此选项
            onTap: _isAppLockEnabled ? () => _toggleBiometric(!_isBiometricEnabled) : null,
            trailing: Switch(
              value: _isBiometricEnabled,
              onChanged: _isAppLockEnabled ? _toggleBiometric : null, // 禁用状态处理
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
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimaryLight),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
      tileColor: AppColors.surfaceLight,
      // 视觉上区分禁用状态
      enabled: onTap != null || trailing is Switch,
    );
  }
}