import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart'; //
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; //
import '../../constants/colors.dart';

class AppLockVerifyScreen extends StatefulWidget {
  final VoidCallback onUnlocked; // 解锁成功后的回调逻辑
  const AppLockVerifyScreen({super.key, required this.onUnlocked});

  @override
  State<AppLockVerifyScreen> createState() => _AppLockVerifyScreenState();
}

class _AppLockVerifyScreenState extends State<AppLockVerifyScreen> {
  final _storage = const FlutterSecureStorage();
  final _auth = LocalAuthentication();
  final List<String> _inputPin = [];
  String _savedPin = "";

  @override
  void initState() {
    super.initState();
    // 【修复点】：等待首帧渲染完成后再触发，防止指纹弹窗不弹出
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBiometrics();
    });
  }

  /// 尝试生物识别解锁
  Future<void> _checkBiometrics() async {
    String? biometricEnabled = await _storage.read(key: 'biometric_enabled');

    if (biometricEnabled == 'true') {
      // 稍微延迟，避开页面切换时的原生通道竞争
      await Future.delayed(const Duration(milliseconds: 500));

      try {
        bool canCheck = await _auth.canCheckBiometrics;
        bool isSupported = await _auth.isDeviceSupported();

        if (canCheck && isSupported) {
          bool didAuthenticate = await _auth.authenticate(
            localizedReason: '请验证身份以进入日记',
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: false, // 允许在指纹失败时使用系统密码
            ),
          );

          if (didAuthenticate) {
            widget.onUnlocked(); // 验证成功，调用回调
          }
        }
      } catch (e) {
        debugPrint("生物识别调用异常: $e");
      }
    }

    // 无论是否开启生物识别，都读取数字密码作为备份
    _savedPin = await _storage.read(key: 'app_lock_pin') ?? "";
  }

  /// 处理数字按键点击
  void _onKeyTap(String value) {
    if (_inputPin.length < 4) {
      setState(() => _inputPin.add(value));

      if (_inputPin.length == 4) {
        if (_inputPin.join() == _savedPin) {
          widget.onUnlocked(); // 【关键】：不再使用 Navigator.pop，直接回调
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('密码错误'), duration: Duration(seconds: 1)),
          );
          setState(() => _inputPin.clear());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 使用 WillPopScope 拦截物理返回键，防止在锁屏时退出
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight, //
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.lock_person_rounded, size: 64, color: AppColors.primary),
              const SizedBox(height: 24),
              const Text('应用已锁定',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight)),
              const SizedBox(height: 40),

              // 密码圆点显示区
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < _inputPin.length ? AppColors.primary : AppColors.surfaceLight,
                    border: Border.all(color: AppColors.primary),
                  ),
                )),
              ),

              const Spacer(),

              // 数字键盘
              _buildKeyboard(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 1; i <= 9; i++) _buildKey(i.toString()),
          const SizedBox.shrink(), // 空位
          _buildKey('0'),
          IconButton(
            onPressed: () => setState(() => _inputPin.isNotEmpty ? _inputPin.removeLast() : null),
            icon: const Icon(Icons.backspace_outlined, size: 28, color: AppColors.textPrimaryLight),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String value) {
    return InkWell(
      onTap: () => _onKeyTap(value),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceLight //
        ),
        alignment: Alignment.center,
        child: Text(value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight)),
      ),
    );
  }
}