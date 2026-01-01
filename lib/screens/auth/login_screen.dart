import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../constants/colors.dart';
import 'register_screen.dart';
import '../diary_list_screen.dart';
import '../../l10n/app_localizations.dart'; // 确保导入

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  bool _isAutoLogin = false;
  final _storage = const FlutterSecureStorage();

  Future<void> _handleLogin() async {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {

      if (_isAutoLogin) {
        await _storage.write(key: 'is_auto_login', value: 'true');
      } else {
        await _storage.delete(key: 'is_auto_login');
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DiaryListScreen()),
        );
      }
    } else {
      // 【修改】使用翻译
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.enterEmailAndPassword)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取翻译实例
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Icon(Icons.book_rounded, size: 80, color: AppColors.primary),
              const SizedBox(height: 16),
              const Text(
                'My Diary', // 这个是 APP 品牌名，通常不翻译，也可以用 l10n.appTitle
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
              ),
              const SizedBox(height: 48),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  // 【修改】使用翻译
                  labelText: l10n.emailLabel,
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  // 【修改】使用翻译
                  labelText: l10n.passwordLabel,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _isAutoLogin,
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (value) {
                        setState(() {
                          _isAutoLogin = value ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _isAutoLogin = !_isAutoLogin),
                    child: Text(
                      // 【修改】使用翻译
                      l10n.autoLogin,
                      style: const TextStyle(color: AppColors.textPrimaryLight),
                    ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () {},
                    // 【修改】使用翻译
                    child: Text(l10n.forgotPassword, style: const TextStyle(color: AppColors.textSecondaryLight)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  // 【修改】使用翻译
                  child: Text(l10n.loginButton, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 【修改】使用翻译
                  Text(l10n.noAccount),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                    },
                    // 【修改】使用翻译
                    child: Text(l10n.registerNow, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}