import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../constants/colors.dart';
import '../../l10n/app_localizations.dart'; // ✅ 关键：导入翻译文件

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  String _pin = "";
  String _firstPin = ""; // 用于存储第一次输入的密码
  bool _isConfirming = false; // 是否处于“确认密码”阶段
  final _storage = const FlutterSecureStorage();

  // 处理数字按键点击
  void _onKeyPress(String val) {
    setState(() {
      if (_pin.length < 4) {
        _pin += val;
      }
      if (_pin.length == 4) {
        _handlePinComplete();
      }
    });
  }

  // 处理密码逻辑
  void _handlePinComplete() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_isConfirming) {
      // 第一步：记录第一次输入
      setState(() {
        _firstPin = _pin;
        _pin = "";
        _isConfirming = true;
      });
    } else {
      // 第二步：确认密码
      if (_pin == _firstPin) {
        // ✅ 密码一致 -> 保存
        await _storage.write(key: 'app_lock_pin', value: _pin);
        await _storage.write(key: 'app_lock_enabled', value: 'true');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.pinSetSuccess)) // ✅ 使用翻译变量
          );
          Navigator.pop(context);
        }
      } else {
        // ❌ 密码不一致 -> 重置
        setState(() {
          _pin = "";
          _firstPin = "";
          _isConfirming = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.pinNotMatch)) // ✅ 使用翻译变量
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            // ✅ 标题根据状态切换翻译
            _isConfirming ? l10n.confirmPinTitle : l10n.setPinTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),

          // 密码圆点
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 16, height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < _pin.length ? AppColors.primary : Colors.grey.shade300,
              ),
            )),
          ),
          const SizedBox(height: 60),

          // 数字键盘
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                if (index == 9) return const SizedBox(); // 空白键

                // 删除键
                if (index == 11) return IconButton(
                  icon: const Icon(Icons.backspace_outlined),
                  onPressed: () => setState(() {
                    if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
                  }),
                );

                // 数字键 (0 在索引 10 的位置)
                final number = index == 10 ? 0 : index + 1;
                return TextButton(
                  onPressed: () => _onKeyPress(number.toString()),
                  child: Text("$number", style: const TextStyle(fontSize: 24, color: Colors.black)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}