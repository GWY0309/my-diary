import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 需要在 pubspec.yaml 添加此插件
import '../../constants/colors.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final _storage = const FlutterSecureStorage();
  final List<String> _pin = [];
  String _firstPin = ""; // 用于存储第一次输入的密码以进行确认
  bool _isConfirming = false; // 是否处于“确认密码”阶段

  // 处理数字按键点击
  void _onKeyTap(String value) {
    if (_pin.length < 4) {
      setState(() {
        _pin.add(value);
      });
    }

    if (_pin.length == 4) {
      _processPin();
    }
  }

  // 处理密码逻辑
  void _processPin() async {
    String currentPin = _pin.join();

    if (!_isConfirming) {
      // 第一步：记录第一次输入的密码并切换到确认阶段
      setState(() {
        _firstPin = currentPin;
        _isConfirming = true;
        _pin.clear();
      });
    } else {
      // 第二步：确认两次输入是否一致
      if (currentPin == _firstPin) {
        // 一致，使用加密存储保存
        await _storage.write(key: 'app_lock_pin', value: currentPin);
        await _storage.write(key: 'app_lock_enabled', value: 'true');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('密码设置成功！')),
          );
          Navigator.pop(context);
        }
      } else {
        // 不一致，重置状态
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('两次密码不一致，请重新设置')),
        );
        setState(() {
          _isConfirming = false;
          _pin.clear();
          _firstPin = "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('设置应用锁')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 提示文字
          Text(
            _isConfirming ? '请再次输入以确认' : '请设置 4 位数字密码',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),

          // 密码圆点展示
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < _pin.length ? AppColors.primary : AppColors.surfaceLight,
                border: Border.all(color: AppColors.primary),
              ),
            )),
          ),
          const SizedBox(height: 60),

          // 数字键盘布局
          _buildKeyboard(),
        ],
      ),
    );
  }

  Widget _buildKeyboard() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 1; i <= 9; i++) _buildKey(i.toString()),
          const SizedBox.shrink(),
          _buildKey('0'),
          IconButton(
            onPressed: () => setState(() => _pin.isNotEmpty ? _pin.removeLast() : null),
            icon: const Icon(Icons.backspace_outlined, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String value) {
    return InkWell(
      onTap: () => _onKeyTap(value),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceLight,
        ),
        alignment: Alignment.center,
        child: Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}