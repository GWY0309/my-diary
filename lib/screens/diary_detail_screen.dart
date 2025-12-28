import 'dart:convert';
import 'dart:io'; // 记得导入 dart:io 用于显示本地图片
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../models/diary_model.dart';
import '../services/database_helper.dart';
import 'diary_edit_screen.dart';

class DiaryDetailScreen extends StatefulWidget {
  final DiaryEntry diary;

  const DiaryDetailScreen({super.key, required this.diary});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  late QuillController _controller;
  late DiaryEntry _currentDiary;

  @override
  void initState() {
    super.initState();
    _currentDiary = widget.diary;
    _loadContent();
  }

  void _loadContent() {
    try {
      final doc = Document.fromJson(jsonDecode(_currentDiary.content));
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      _controller = QuillController.basic();
    }
  }

  IconData _getMoodIcon(int index) {
    const icons = [
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_satisfied,
      Icons.sentiment_very_satisfied,
    ];
    return (index >= 0 && index < icons.length) ? icons[index] : Icons.sentiment_neutral;
  }

  Color _getMoodColor(int index) {
    const colors = [
      AppColors.error,
      Colors.orange,
      Colors.grey,
      AppColors.success,
      AppColors.primary,
    ];
    return (index >= 0 && index < colors.length) ? colors[index] : Colors.grey;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除日记'),
        content: const Text('确定要删除这篇日记吗？此操作不可撤销。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          TextButton(
            onPressed: () async {
              if (_currentDiary.id != null) {
                await DatabaseHelper.instance.deleteDiary(_currentDiary.id!);
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                }
              }
            },
            child: const Text('删除', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondaryColor = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: theme.iconTheme,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final updatedDiary = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiaryEditScreen(diary: _currentDiary),
                ),
              );

              if (updatedDiary != null && updatedDiary is DiaryEntry) {
                setState(() {
                  _currentDiary = updatedDiary;
                  _loadContent();
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            _currentDiary.title,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Text(
                DateFormat('yyyy年MM月dd日 HH:mm').format(_currentDiary.date),
                style: TextStyle(color: secondaryColor),
              ),
              const Spacer(),
              Icon(_getMoodIcon(_currentDiary.mood), size: 24, color: _getMoodColor(_currentDiary.mood)),
              const SizedBox(width: 8),
              const Icon(Icons.wb_sunny, size: 24, color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 16),

          if (_currentDiary.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              children: _currentDiary.tags.map((tag) => DetailTagChip(
                label: tag,
                color: AppColors.primary,
              )).toList(),
            ),

          // 【新增】图片展示区域
          if (_currentDiary.images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _currentDiary.images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_currentDiary.images[index]), // 显示本地图片
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                            width: 120, height: 120, color: Colors.grey,
                            child: const Icon(Icons.error)
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(),
          ),

          QuillEditor.basic(
            configurations: QuillEditorConfigurations(
              controller: _controller,
              readOnly: true,
              showCursor: false,
              enableInteractiveSelection: true,
              padding: EdgeInsets.zero,
              sharedConfigurations: const QuillSharedConfigurations(
                locale: Locale('zh', 'CN'),
              ),
              customStyles: DefaultStyles(
                paragraph: DefaultTextBlockStyle(
                    TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: isDark ? Colors.white : const Color(0xFF202124),
                    ),
                    const VerticalSpacing(0, 0),
                    const VerticalSpacing(0, 0),
                    null
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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