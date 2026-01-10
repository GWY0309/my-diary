import 'package:flutter/material.dart';
import '../../services/email_service.dart';
import '../../constants/colors.dart';
import '../../services/database_helper.dart';
import '../../l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 控制器
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // 验证码服务对象
  final EmailService _emailService = EmailService();

  // 状态变量
  bool _isLoading = false;
  bool _isOtpSent = false; // 验证码是否已发送
  bool _isObscurePass = true;
  bool _isObscureConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 1. 发送验证码逻辑
  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();

    // 基础校验
    if (email.isEmpty || !email.contains('@')) {
      _showSnackBar('请输入有效的邮箱地址');
      return;
    }

    setState(() => _isLoading = true);

    // A. 检查邮箱是否已注册 (调用 DatabaseHelper)
    final isExist = await DatabaseHelper.instance.isEmailExist(email);
    if (isExist) {
      setState(() => _isLoading = false);
      _showSnackBar('该邮箱已注册，请直接登录');
      return;
    }

    // B. 发送
    bool result = await _emailService.sendOtp(email);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result) {
      setState(() => _isOtpSent = true);
      _showSnackBar('验证码已发送至 $email，请注意查收');
    } else {
      _showSnackBar('发送失败，请检查网络或邮箱地址');
    }
  }

  // 2. 注册提交逻辑
  Future<void> _handleRegister() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    // 基础校验
    if (otp.isEmpty || otp.length < 6) {
      _showSnackBar('请输入6位验证码');
      return;
    }
    if (password.isEmpty) {
      _showSnackBar(l10n.passwordLabel); // "密码"
      return;
    }
    if (password != confirm) {
      _showSnackBar(l10n.passwordsDoNotMatch); // "两次输入的密码不一致"
      return;
    }

    setState(() => _isLoading = true);

    // A. 验证 OTP
    bool isOtpValid = _emailService.verifyOtp(email, otp);

    if (!isOtpValid) {
      setState(() => _isLoading = false);
      _showSnackBar('验证码错误或已过期');
      return;
    }

    // B. 写入数据库
    bool success = await DatabaseHelper.instance.registerUser(email, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      _showSnackBar(l10n.registerSuccess); // "注册成功"
      // 延迟一点跳转，让用户看清提示
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.pop(context); // 返回登录页
    } else {
      _showSnackBar('注册失败，请稍后重试');
    }
  }

  // 辅助方法：显示提示
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.registerTitle), // "注册账号"
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.textTheme.titleLarge?.color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.person_add_outlined, size: 64, color: AppColors.primary),
            const SizedBox(height: 32),

            // -------- 第一步：邮箱输入 --------
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !_isOtpSent, // 发送后锁定邮箱，防止修改
              decoration: InputDecoration(
                labelText: l10n.emailLabel,
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                // 如果已发送，显示一个小锁图标
                suffixIcon: _isOtpSent ? const Icon(Icons.lock, color: Colors.grey) : null,
              ),
            ),
            const SizedBox(height: 16),

            // -------- 按钮：获取验证码 --------
            if (!_isOtpSent)
              ElevatedButton(
                onPressed: _isLoading ? null : _sendOtp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('获取邮箱验证码', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),

            // -------- 第二步：填写验证码与密码 (发送成功后显示) --------
            if (_isOtpSent) ...[
              // 验证码输入框
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: '验证码', // 可添加到 arb: "otpLabel"
                  prefixIcon: const Icon(Icons.security),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  counterText: "",
                ),
              ),
              const SizedBox(height: 16),

              // 密码输入框
              TextField(
                controller: _passwordController,
                obscureText: _isObscurePass,
                decoration: InputDecoration(
                  labelText: l10n.passwordLabel,
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscurePass ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _isObscurePass = !_isObscurePass),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 确认密码输入框
              TextField(
                controller: _confirmPasswordController,
                obscureText: _isObscureConfirm,
                decoration: InputDecoration(
                  labelText: l10n.confirmPasswordLabel,
                  prefixIcon: const Icon(Icons.lock_clock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscureConfirm ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 注册按钮
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(l10n.registerNow, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // 允许用户重置流程（例如填错了邮箱）
                  setState(() {
                    _isOtpSent = false;
                    _otpController.clear();
                  });
                },
                child: const Text("更换邮箱 / 重新发送", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}