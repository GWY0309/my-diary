import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../constants/colors.dart';
import 'diary_edit_screen.dart';

class DiaryDetailScreen extends StatelessWidget {
  const DiaryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 模拟一份富文本内容（实际开发中会从数据库读取）
    final QuillController _controller = QuillController.basic();

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        actions: [
          // 编辑按钮：点击跳转到编辑页
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const DiaryEditScreen())
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {}, // TODO: 分享功能
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () {}, // TODO: 删除确认弹窗
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. 标题展示
          const Text(
            '前端 UI 阶段性总结',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
          ),
          const SizedBox(height: 12),

          // 2. 日期、心情与天气
          Row(
            children: [
              Text('2025年12月28日 14:30', style: TextStyle(color: AppColors.textSecondaryLight)),
              const Spacer(),
              const Icon(Icons.sentiment_very_satisfied, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              const Icon(Icons.wb_sunny, size: 20, color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 16),

          // 3. 标签展示
          Wrap(
            spacing: 8,
            children: const [
              DetailTagChip(label: '开发', color: AppColors.primary),
              DetailTagChip(label: '个人', color: AppColors.success),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(),
          ),

          // 4. 正文预览（只读模式）
          QuillEditor.basic(
            configurations: QuillEditorConfigurations(
              controller: _controller,
              readOnly: true, // 设置为只读模式
              showCursor: false,
              enableInteractiveSelection: true,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

// 详情页专用的标签样式
class DetailTagChip extends StatelessWidget {
  final String label;
  final Color color;
  const DetailTagChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}