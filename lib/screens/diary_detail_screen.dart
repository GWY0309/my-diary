import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../models/diary_model.dart';
import '../services/database_helper.dart';
import 'diary_edit_screen.dart';

class DiaryDetailScreen extends StatefulWidget {
  // 1. 接收从列表页传来的日记对象
  final DiaryEntry diary;

  const DiaryDetailScreen({super.key, required this.diary});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  late QuillController _controller;
  late DiaryEntry _currentDiary; // 用于本地显示和更新的数据

  @override
  void initState() {
    super.initState();
    _currentDiary = widget.diary; // 初始化为传入的数据
    _loadContent();
  }

  // 2. 解析富文本内容
  void _loadContent() {
    try {
      final doc = Document.fromJson(jsonDecode(_currentDiary.content));
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
        // 注意：不要在构造函数中设置 readOnly: true，否则可能报错
      );
      // 【关键】初始化后设置只读属性
    } catch (e) {
      _controller = QuillController.basic();
    }
  }

  // 获取心情图标
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

  // 获取心情颜色
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

  // 删除确认逻辑
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
                  Navigator.pop(context); // 关闭弹窗
                  Navigator.pop(context, true); // 返回列表页并通知刷新
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
          // 【核心功能】编辑按钮
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              // 1. 跳转到编辑页，并将当前日记传过去
              final updatedDiary = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiaryEditScreen(diary: _currentDiary),
                ),
              );

              // 2. 如果返回了更新后的数据，立即刷新界面
              if (updatedDiary != null && updatedDiary is DiaryEntry) {
                setState(() {
                  _currentDiary = updatedDiary;
                  _loadContent(); // 重新解析富文本，因为内容可能变了
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
          // 3. 使用 _currentDiary 显示数据（确保编辑后能变）
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
              // 天气暂用固定图标，您也可以仿照 mood 写个 _getWeatherIcon
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

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(),
          ),

          // 4. 正文预览
          QuillEditor.basic(
            configurations: QuillEditorConfigurations(
              controller: _controller,
              showCursor: false,
              readOnly: true,
              enableInteractiveSelection: true,
              padding: EdgeInsets.zero,
              sharedConfigurations: const QuillSharedConfigurations(
                locale: Locale('zh', 'CN'),
              ),
              // 【关键修改】：自定义样式，显式指定颜色
              customStyles: DefaultStyles( // 注意：这里把 const 去掉了
                paragraph: DefaultTextBlockStyle(
                    TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      // 根据主题亮度决定颜色：深色模式用白色，浅色模式用深灰/黑色
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

// 标签组件
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