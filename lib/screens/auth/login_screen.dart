import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/database_helper.dart';
import '../../l10n/app_localizations.dart';
import '../diary_list_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isObscure = true; // 控制密码显示/隐藏

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 核心登录逻辑
  Future<void> _handleLogin() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 1. 基础非空校验
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterEmailAndPassword)), // "请输入账号和密码"
      );
      return;
    }

    setState(() => _isLoading = true);

    // 2. 数据库校验 (请确保 DatabaseHelper 已升级)
    final bool isSuccess = await DatabaseHelper.instance.loginUser(email, password);

    // 模拟一点网络延迟感，让用户看到加载圈 (可选)
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (isSuccess) {
      // 3. 登录成功：跳转到主页，并移除之前的所有页面
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DiaryListScreen()),
            (route) => false,
      );
    } else {
      // 4. 登录失败
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('账号或密码错误'), // 这里可以直接写死或加到 arb 文件中
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo 或 图标
              const Icon(
                  Icons.book,
                  size: 80,
                  color: AppColors.primary
              ),
              const SizedBox(height: 16),

              // 标题
              Text(
                l10n.login, // "登录"
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 40),

              // 邮箱输入框
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.emailLabel, // "邮箱地址"
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 密码输入框
              TextField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: l10n.passwordLabel, // "密码"
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // 忘记密码 (暂无功能，仅占位)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('请联系管理员重置密码')),
                    );
                  },
                  child: Text(l10n.forgotPassword), // "忘记密码？"
                ),
              ),

              const SizedBox(height: 24),

              // 登录按钮
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                )
                    : Text(
                  l10n.loginButton, // "登录"
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 24),

              // 去注册
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.noAccount), // "还没有账号？"
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: Text(
                      l10n.registerNow, // "立即注册"
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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