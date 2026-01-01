import 'dart:convert';
import 'dart:io'; // ✅ 必须保留，用于显示本地图片
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../models/diary_model.dart';
import '../services/database_helper.dart';
import 'diary_edit_screen.dart';
import '../../l10n/app_localizations.dart'; // ✅ 引入国际化

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

  // 获取心情图标
  IconData _getMoodIcon(int index) {
    const icons = [
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_satisfied,
      Icons.sentiment_very_satisfied,
    ];
    if (index >= 0 && index < icons.length) return icons[index];
    return Icons.sentiment_neutral;
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
    if (index >= 0 && index < colors.length) return colors[index];
    return Colors.grey;
  }

  // 获取天气图标 (如果需要展示)
  IconData _getWeatherIcon(int index) {
    const icons = [
      Icons.wb_sunny, Icons.cloud, Icons.umbrella,
      Icons.ac_unit, Icons.thunderstorm, Icons.air,
    ];
    if (index >= 0 && index < icons.length) return icons[index];
    return Icons.wb_sunny;
  }

  Future<void> _deleteDiary() async {
    await DatabaseHelper.instance.deleteDiary(_currentDiary.id!);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _editDiary() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DiaryEditScreen(diary: _currentDiary)),
    );
    // 如果编辑页返回了新的日记对象（或者返回 true），则刷新页面
    if (result != null && result is DiaryEntry) {
      setState(() {
        _currentDiary = result;
        _loadContent(); // 重新加载 Quill 内容
      });
    } else if (result == true) {
      // 如果只返回 true，建议重新查库或者简单 pop
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!; // ✅ 获取翻译代理

    // 1. 动态日期格式
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    final dateStr = isZh
        ? DateFormat('MM月dd日').format(_currentDiary.date)
        : DateFormat('MMM dd').format(_currentDiary.date);

    final yearStr = DateFormat('yyyy').format(_currentDiary.date);
    final weekDayStr = isZh
        ? DateFormat('EEEE', 'zh_CN').format(_currentDiary.date)
        : DateFormat('EEEE').format(_currentDiary.date);

    // 2. 动态标签翻译 helper
    String getLocalizedTag(String tag) {
      if (tag == 'Life' || tag == '生活') return l10n.tagLife;
      if (tag == 'Work' || tag == '工作') return l10n.tagWork;
      if (tag == 'Travel' || tag == '旅行') return l10n.tagTravel;
      if (tag == 'Mood' || tag == '心情') return l10n.tagMood;
      if (tag == 'Food' || tag == '美食') return l10n.tagFood;
      if (tag == 'Study' || tag == '学习') return l10n.tagStudy;
      return tag;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // ✅ 标题翻译
        title: Text(l10n.diaryDetailTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: theme.iconTheme,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _editDiary,
            tooltip: l10n.editAction, // 提示文案也可以翻译
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: _deleteDiary,
            tooltip: l10n.deleteAction,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部日期和心情/天气栏
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(dateStr, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text(yearStr, style: TextStyle(fontSize: 16, color: theme.disabledColor, height: 1.5)),
                      ],
                    ),
                    Text(weekDayStr, style: TextStyle(fontSize: 14, color: theme.primaryColor)),
                  ],
                ),
                const Spacer(),
                // 心情图标
                Icon(_getMoodIcon(_currentDiary.mood), color: _getMoodColor(_currentDiary.mood), size: 32),
                const SizedBox(width: 16),
                // 天气图标
                Icon(_getWeatherIcon(_currentDiary.weather), color: theme.iconTheme.color, size: 28),
              ],
            ),
            const SizedBox(height: 24),

            // 标题
            Text(
              _currentDiary.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ✅ 图片展示区 (恢复您旧版的功能)
            if (_currentDiary.images.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _currentDiary.images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final path = _currentDiary.images[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(path),
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            width: 120, height: 120,
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // 标签栏
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _currentDiary.tags.map((tag) => DetailTagChip(
                label: getLocalizedTag(tag), // ✅ 标签翻译
                color: AppColors.primary,
              )).toList(),
            ),
            const SizedBox(height: 24),

            // 内容编辑器 (只读)
            QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _controller,
                readOnly: true,
                showCursor: false,
                enableInteractiveSelection: true,
                padding: EdgeInsets.zero,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('zh', 'CN'), // 这里也可以根据 context 动态设置
                ),
                // 自定义样式保持不变
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// 标签小组件
class DetailTagChip extends StatelessWidget {
  final String label;
  final Color color;
  const DetailTagChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}