import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('设置', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle('通用'),
          _buildSettingsTile(
            icon: Icons.dark_mode_outlined,
            title: '深色模式',
            trailing: Switch(value: false, onChanged: (v) {}), // TODO: 集成主题管理
          ),
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: '语言设置',
            onTap: () {},
          ),

          const Divider(height: 32),
          _buildSectionTitle('安全'),
          _buildSettingsTile(
            icon: Icons.fingerprint,
            title: '生物识别解锁',
            trailing: Switch(value: true, onChanged: (v) {}), // TODO: 集成 local_auth
          ),
          _buildSettingsTile(
            icon: Icons.cloud_upload_outlined,
            title: '日记备份与同步',
            onTap: () {}, // TODO: 集成 Firebase Sync
          ),

          const Divider(height: 32),
          _buildSectionTitle('关于'),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: '软件版本',
            trailing: const Text('v1.0.0'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(title,
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimaryLight),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
      tileColor: AppColors.surfaceLight,
    );
  }
}