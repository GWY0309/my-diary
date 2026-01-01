import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../../constants/colors.dart';
import '../../l10n/app_localizations.dart';

class AppLockVerifyScreen extends StatefulWidget {
  final VoidCallback onUnlocked;
  const AppLockVerifyScreen({super.key, required this.onUnlocked});

  @override
  State<AppLockVerifyScreen> createState() => _AppLockVerifyScreenState();
}

class _AppLockVerifyScreenState extends State<AppLockVerifyScreen> {
  String _pin = "";
  final _storage = const FlutterSecureStorage();
  final _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    String? bioEnabled = await _storage.read(key: 'biometric_enabled');
    if (bioEnabled == 'true') {
      try {
        bool didAuthenticate = await _auth.authenticate(
          localizedReason: '请验证指纹以解锁', // 系统级提示通常由系统语言决定，也可以用 l10n.unlockTitle
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (didAuthenticate) {
          widget.onUnlocked();
        }
      } catch (e) {
        // ignore
      }
    }
  }

  void _onKeyPress(String val) async {
    setState(() {
      if (_pin.length < 4) _pin += val;
    });
    if (_pin.length == 4) {
      String? savedPin = await _storage.read(key: 'app_lock_pin');
      if (_pin == savedPin) {
        widget.onUnlocked();
      } else {
        setState(() => _pin = "");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.pinIncorrect))
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.lock, size: 48, color: AppColors.primary),
            const SizedBox(height: 20),
            Text(l10n.enterPinTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
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
            const Spacer(),
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.5),
              itemCount: 12,
              itemBuilder: (context, index) {
                if (index == 9) return const SizedBox();
                if (index == 11) return IconButton(
                  icon: const Icon(Icons.backspace_outlined),
                  onPressed: () => setState(() { if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1); }),
                );
                final number = index == 10 ? 0 : index + 1;
                return TextButton(
                  onPressed: () => _onKeyPress(number.toString()),
                  child: Text("$number", style: const TextStyle(fontSize: 24, color: Colors.black)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}