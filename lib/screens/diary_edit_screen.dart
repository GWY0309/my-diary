import 'package:flutter/material.dart';
import '../constants/colors.dart';

class DiaryEditScreen extends StatefulWidget {
  const DiaryEditScreen({super.key});

  @override
  State<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends State<DiaryEditScreen> {
  // 对应数据库设计的字段
  int _selectedMood = 2; // 默认心情：一般
  int _selectedWeather = 0; // 默认天气：晴

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('写日记'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('保存', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 标题输入
            const TextField(
              decoration: InputDecoration(
                hintText: '输入标题...',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            // 心情与天气选择区域
            Row(
              children: [
                _buildIconOption(Icons.sentiment_satisfied, "心情", () {}),
                const SizedBox(width: 20),
                _buildIconOption(Icons.wb_sunny_outlined, "天气", () {}),
              ],
            ),
            const SizedBox(height: 10),
            // 正文区域
            const Expanded(
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: '记录今天的故事...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconOption(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondaryLight),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: AppColors.textSecondaryLight)),
        ],
      ),
    );
  }
}