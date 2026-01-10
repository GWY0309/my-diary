import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';
import 'dart:io' as io;
import '../constants/colors.dart';
import '../models/diary_model.dart';
import '../services/database_helper.dart';
import 'diary_edit_screen.dart';
import '../../l10n/app_localizations.dart';

class DiaryDetailScreen extends StatefulWidget {
  final DiaryEntry diary;

  const DiaryDetailScreen({super.key, required this.diary});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  late quill.QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _initQuill();
  }

  void _initQuill() {
    try {
      final doc = quill.Document.fromJson(jsonDecode(widget.diary.content));
      _quillController = quill.QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      _quillController = quill.QuillController.basic();
    }
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  // ✅ 核心修复：处理编辑返回
  Future<void> _navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryEditScreen(diary: widget.diary),
      ),
    );

    // 如果编辑页返回 true (表示已保存)
    if (result == true) {
      if (!mounted) return;
      // 直接关闭详情页，并把 true 传给列表页，触发刷新
      Navigator.pop(context, true);
    }
  }

  // 处理删除
  Future<void> _deleteDiary() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteTitle),
        content: Text(l10n.deleteConfirm('1')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.deleteAction, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && widget.diary.id != null) {
      await DatabaseHelper.instance.deleteDiary(widget.diary.id!);
      if (!mounted) return;
      // 删除成功后，也返回 true 给列表页刷新
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final diary = widget.diary;
    final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(diary.date);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(dateStr, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: theme.iconTheme,
        actions: [
          // 编辑按钮
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEdit, // ✅ 调用修复后的方法
          ),
          // 删除按钮
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteDiary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Text(
              diary.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 标签、心情、天气行
            Wrap(
              spacing: 8,
              children: [
                _buildInfoChip(Icons.sentiment_satisfied, _getMoodText(diary.mood, l10n), theme),
                _buildInfoChip(Icons.wb_sunny, _getWeatherText(diary.weather, l10n), theme),
                ...diary.tags.map((tag) => _buildInfoChip(Icons.tag, tag, theme)),
              ],
            ),
            const SizedBox(height: 24),

            // 图片展示
            if (diary.images.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: diary.images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        // 简单的图片加载 (如果是本地文件路径)
                        child: Image.file(
                          io.File(diary.images[index]), // 需要 import 'dart:io' as java;
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                              width: 150,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image)
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (diary.images.isNotEmpty) const SizedBox(height: 24),

            // 内容编辑器 (只读模式)
            quill.QuillEditor.basic(
              configurations: quill.QuillEditorConfigurations(
                controller: _quillController,
                sharedConfigurations: const quill.QuillSharedConfigurations(
                  locale: Locale('zh', 'CN'),
                ),
                // 设置为只读
                // readOnly: true, // 新版 quill 可能移除了这个直接属性，用下面的方式：
                // enabled: false, // 或者不显示光标

              ),
              // 让它看起来像普通文本
              focusNode: FocusNode(canRequestFocus: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: Colors.grey[800], fontSize: 12)),
        ],
      ),
    );
  }

  String _getMoodText(int mood, AppLocalizations l10n) {
    // 简单映射，您可以根据自己的逻辑完善
    return l10n.moodLabel;
  }

  String _getWeatherText(int weather, AppLocalizations l10n) {
    return l10n.weatherLabel;
  }
}

// 补一个 dart:io 的引用，避免 Image.file 报错
// 在文件头部 import 'dart:io' as java;