import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ 1. 引入 SP
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
  bool _isObscure = true;
  bool _rememberMe = false; // ✅ 新增：控制“记住我”的勾选状态

  @override
  void initState() {
    super.initState();
    _loadUserEmail(); // 可选：初始化时如果之前记住了，可以回填邮箱
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 可选：如果之前勾选过记住我，可以自动填入邮箱方便用户
  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final isRemembered = prefs.getBool('is_remembered') ?? false;

    if (mounted && isRemembered && savedEmail != null) {
      setState(() {
        _emailController.text = savedEmail;
        _rememberMe = true;
      });
    }
  }

  // 核心登录逻辑
  Future<void> _handleLogin() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterEmailAndPassword)),
      );
      return;
    }

    setState(() => _isLoading = true);

    // 1. 验证账号密码
    final bool isSuccess = await DatabaseHelper.instance.loginUser(email, password);

    if (isSuccess) {
      // ✅ 2. 获取用户 ID
      final userId = await DatabaseHelper.instance.getUserId(email);

      if (userId != null) {
        // ✅ 3. 保存登录状态
        final prefs = await SharedPreferences.getInstance();

        // 必须保存 ID，否则列表页无法加载数据
        await prefs.setInt('current_user_id', userId);

        // 保存“记住我”的状态
        await prefs.setBool('is_remembered', _rememberMe);

        // 如果勾选了“记住我”，可以顺便保存邮箱，下次登录回显
        if (_rememberMe) {
          await prefs.setString('saved_email', email);
        } else {
          await prefs.remove('saved_email');
        }

        print("✅ [登录成功] 用户ID: $userId 已保存, 记住我: $_rememberMe");
      } else {
        print("❌ [错误] 登录成功但无法获取 userId");
      }

      if (!mounted) return;
      setState(() => _isLoading = false);

      // 4. 跳转主页
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DiaryListScreen()),
            (route) => false,
      );
    } else {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('账号或密码错误'),
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
              const Icon(
                  Icons.book,
                  size: 80,
                  color: AppColors.primary
              ),
              const SizedBox(height: 16),

              Text(
                l10n.login,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.emailLabel,
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: l10n.passwordLabel,
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

              // ✅ 修改区域：将原来的 Align 改为 Row，加入复选框
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    // 记住我 复选框
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                      child: const Text("记住我"), // 这里您可以放入 l10n.rememberMe
                    ),

                    const Spacer(), // 撑开中间空间，让“忘记密码”靠右

                    // 忘记密码按钮
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请联系管理员重置密码')),
                        );
                      },
                      child: Text(l10n.forgotPassword),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16), // 稍微调整了间距

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
                  l10n.loginButton,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.noAccount),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: Text(
                      l10n.registerNow,
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