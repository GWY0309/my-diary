import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 【新增】引入存储库
import '../../../constants/colors.dart';
import 'register_screen.dart';
import '../diary_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // 【新增】控制自动登录勾选状态
  bool _isAutoLogin = false;
  // 【新增】实例化存储对象
  final _storage = const FlutterSecureStorage();

  Future<void> _handleLogin() async {
    // 简单模拟验证：只要不为空即可
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {

      // 【新增】处理自动登录保存逻辑
      if (_isAutoLogin) {
        // 如果勾选了，写入标记
        await _storage.write(key: 'is_auto_login', value: 'true');
        // 在真实场景中，这里通常还会保存 token 或用户加密信息
      } else {
        // 如果没勾选，清除标记
        await _storage.delete(key: 'is_auto_login');
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DiaryListScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入账号和密码')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              // 1. 顶部应用图标
              const Icon(Icons.book_rounded, size: 80, color: AppColors.primary),
              const SizedBox(height: 16),
              const Text(
                'My Diary',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
              ),
              const SizedBox(height: 48),

              // 2. 表单区域
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: '邮箱地址',
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
                  labelText: '密码',
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

              // 【新增】自动登录勾选框 + 忘记密码
              Row(
                children: [
                  // 自动登录部分
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
                    child: const Text(
                      '自动登录',
                      style: TextStyle(color: AppColors.textPrimaryLight),
                    ),
                  ),

                  const Spacer(),

                  // 忘记密码部分
                  TextButton(
                    onPressed: () {}, // TODO: 忘记密码页
                    child: const Text('忘记密码？', style: TextStyle(color: AppColors.textSecondaryLight)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. 登录按钮
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('登 录', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 24),
              // 4. 底部注册链接
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('还没有账号？'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                    },
                    child: const Text('立即注册', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
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