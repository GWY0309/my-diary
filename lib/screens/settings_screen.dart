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
                          _getLanguageName(localeProvider.locale),
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
  String _getLanguageName(Locale? locale) {
    if (locale == null) return 'System';

    // 特殊处理繁体中文
    if (locale.languageCode == 'zh') {
      if (locale.scriptCode == 'Hant') return '繁體中文';
      return '简体中文';
    }

    switch (locale.languageCode) {
      case 'en': return 'English';
      case 'ja': return '日本語';
      case 'ko': return '한국어';
      case 'es': return 'Español';
      case 'fr': return 'Français';
      case 'de': return 'Deutsch';
      case 'fil': return 'Filipino';
      case 'it': return 'Italiano';
      case 'pt': return 'Português';
      case 'ru': return 'Русский';
      case 'sv': return 'Svenska';
      case 'tr': return 'Türkçe';
      case 'nl': return 'Nederlands';
      case 'pl': return 'Polski';
      case 'ro': return 'Română';
      case 'id': return 'Bahasa Indonesia';
      case 'ms': return 'Bahasa Melayu';
      case 'th': return 'ไทย';
      case 'vi': return 'Tiếng Việt';
      case 'ar': return 'العربية';
      case 'fa': return 'فارسی';
      case 'hi': return 'हिन्दी';
      default: return locale.languageCode;
    }
  }

  // 辅助方法 2：显示底部选择框
  void _showLanguageBottomSheet(BuildContext context, LocaleProvider provider) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许弹窗高度自适应
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7, // 初始高度 70%
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Text(l10n.selectLanguage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    controller: controller,
                    children: [
                      _buildLanguageItem(context, provider, 'English', const Locale('en')),
                      _buildLanguageItem(context, provider, '简体中文', const Locale('zh')),
                      _buildLanguageItem(context, provider, '繁體中文', const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')),
                      _buildLanguageItem(context, provider, '日本語', const Locale('ja')),
                      _buildLanguageItem(context, provider, '한국어', const Locale('ko')),
                      _buildLanguageItem(context, provider, 'Español', const Locale('es')),
                      _buildLanguageItem(context, provider, 'Français', const Locale('fr')),
                      _buildLanguageItem(context, provider, 'Deutsch', const Locale('de')),
                      _buildLanguageItem(context, provider, 'Filipino', const Locale('fil')),
                      _buildLanguageItem(context, provider, 'Italiano', const Locale('it')),
                      _buildLanguageItem(context, provider, 'Português', const Locale('pt')),
                      _buildLanguageItem(context, provider, 'Русский', const Locale('ru')),
                      _buildLanguageItem(context, provider, 'Svenska', const Locale('sv')),
                      _buildLanguageItem(context, provider, 'Türkçe', const Locale('tr')),
                      _buildLanguageItem(context, provider, 'Nederlands', const Locale('nl')),
                      _buildLanguageItem(context, provider, 'Polski', const Locale('pl')),
                      _buildLanguageItem(context, provider, 'Română', const Locale('ro')),
                      _buildLanguageItem(context, provider, 'Bahasa Indonesia', const Locale('id')), // 注意这里印尼语代码通常是 id
                      _buildLanguageItem(context, provider, 'Bahasa Melayu', const Locale('ms')),
                      _buildLanguageItem(context, provider, 'ไทย', const Locale('th')),
                      _buildLanguageItem(context, provider, 'Tiếng Việt', const Locale('vi')),
                      _buildLanguageItem(context, provider, 'العربية', const Locale('ar')),
                      _buildLanguageItem(context, provider, 'فارسی', const Locale('fa')),
                      _buildLanguageItem(context, provider, 'हिन्दी', const Locale('hi')),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageItem(BuildContext context, LocaleProvider provider, String name, Locale locale) {
    // 判断选中状态：繁体中文需要特别判断 scriptCode
    bool isSelected = false;
    if (provider.locale == null) {
      isSelected = false;
    } else if (locale.languageCode == 'zh') {
      isSelected = provider.locale!.languageCode == 'zh' && provider.locale!.scriptCode == locale.scriptCode;
    } else {
      isSelected = provider.locale!.languageCode == locale.languageCode;
    }

    return ListTile(
      title: Text(name, textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppColors.primary : null,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          )),
      onTap: () {
        provider.setLocale(locale);
        Navigator.pop(context);
      },
    );
  }
}