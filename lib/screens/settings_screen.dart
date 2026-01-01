import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/colors.dart';
import '../l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import 'auth/login_screen.dart';
import 'settings/app_lock_screen.dart';
import '../providers/locale_provider.dart';

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
    final l10n = AppLocalizations.of(context)!;
    if (value) {
      if (!_isAppLockEnabled) {
        // 【修改】使用翻译
        _showSnackBar(l10n.pleaseEnablePinFirst);
        return;
      }
      bool canCheck = await _auth.canCheckBiometrics;
      bool isSupported = await _auth.isDeviceSupported();

      if (!canCheck || !isSupported) {
        // 【修改】使用翻译
        _showSnackBar(l10n.biometricNotSupported);
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

  Future<void> _handleLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        // 【修改】翻译标题和内容
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirmation),
        actions: [
          TextButton(
            // 【修改】翻译按钮
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            // 【修改】翻译按钮
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirmLogout, style: const TextStyle(color: AppColors.error)),
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 【修改】分组标题翻译
          _buildSectionHeader(context, l10n.appearanceAndExperience),
          _buildCard(
            context,
            children: [
              SwitchListTile(
                title: Text(l10n.darkMode),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: themeProvider.isDarkMode,
                activeColor: AppColors.primary,
                onChanged: (value) => themeProvider.toggleTheme(value),
              ),
              const Divider(height: 1, indent: 56, endIndent: 16),

              Consumer<LocaleProvider>(
                builder: (context, localeProvider, _) {
                  return ListTile(
                    leading: const Icon(Icons.language, color: Colors.grey), // 图标颜色可根据主题调整
                    title: Text(l10n.language), // "语言"
                    trailing: Row( // 右侧显示当前语言 + 箭头
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getLanguageName(localeProvider.locale?.languageCode),
                          style: TextStyle(color: theme.disabledColor, fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 14, color: theme.disabledColor),
                      ],
                    ),
                    onTap: () => _showLanguageBottomSheet(context, localeProvider),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 【修改】分组标题翻译
          _buildSectionHeader(context, l10n.privacyAndSecurity),
          _buildCard(
            context,
            children: [
              SwitchListTile(
                // 【修改】标题翻译
                title: Text(l10n.pinLock),
                secondary: const Icon(Icons.lock_outline),
                value: _isAppLockEnabled,
                activeColor: AppColors.primary,
                onChanged: (value) => _toggleAppLock(value),
              ),
              if (_isAppLockEnabled)
                const Divider(height: 1, indent: 16, endIndent: 16),

              SwitchListTile(
                // 【修改】标题翻译
                title: Text(l10n.biometricUnlock),
                secondary: const Icon(Icons.fingerprint),
                // 【修改】副标题翻译
                subtitle: _isAppLockEnabled ? null : Text(l10n.enablePinFirst, style: const TextStyle(fontSize: 12)),
                value: _isBiometricEnabled,
                activeColor: AppColors.primary,
                onChanged: _isAppLockEnabled
                    ? (value) => _toggleBiometric(value)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 【修改】分组标题翻译
          _buildSectionHeader(context, l10n.account),
          _buildCard(
            context,
            children: [
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                // 【修改】标题翻译
                title: Text(
                  l10n.logout,
                  style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
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

  // 辅助方法 1：获取语言显示的名称
  String _getLanguageName(String? code) {
    switch (code) {
      case 'en': return 'English';
      case 'zh': return '中文';
      case 'ja': return '日本語';
      case 'ko': return '한국어';
      case 'es': return 'Español';
      case 'fr': return 'Français';
      default: return 'System'; // 跟随系统
    }
  }

  // 辅助方法 2：显示底部选择框
  void _showLanguageBottomSheet(BuildContext context, LocaleProvider provider) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(l10n.selectLanguage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              _buildLanguageItem(context, provider, 'English', 'en'),
              _buildLanguageItem(context, provider, '简体中文', 'zh'),
              _buildLanguageItem(context, provider, '日本語', 'ja'),
              _buildLanguageItem(context, provider, '한국어', 'ko'),
              _buildLanguageItem(context, provider, 'Español', 'es'),
              _buildLanguageItem(context, provider, 'Français', 'fr'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageItem(BuildContext context, LocaleProvider provider, String name, String code) {
    final isSelected = provider.locale?.languageCode == code;
    return ListTile(
      title: Text(name, textAlign: TextAlign.center,
          style: TextStyle(
              color: isSelected ? AppColors.primary : null,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
          )),
      onTap: () {
        provider.setLocale(Locale(code));
        Navigator.pop(context);
      },
    );
  }
}