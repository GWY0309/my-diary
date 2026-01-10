import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:shared_preferences/shared_preferences.dart'; // ✅ 1. 引入 SP

import '../constants/colors.dart';
import '../services/database_helper.dart';
import '../models/diary_model.dart';
import 'diary_edit_screen.dart';
import 'settings_screen.dart';
import 'diary_detail_screen.dart';
import 'statistics_screen.dart';
import '../l10n/app_localizations.dart';

class DiaryListScreen extends StatefulWidget {
  const DiaryListScreen({super.key});

  @override
  State<DiaryListScreen> createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryListScreen> {
  List<DiaryEntry> _allDiaries = [];
  List<DiaryEntry> _filteredDiaries = [];

  bool _isLoading = true;
  bool _isSelectionMode = false;
  final Set<int> _selectedIds = {};

  final TextEditingController _searchController = TextEditingController();
  DateTimeRange? _selectedDateRange;
  String? _selectedTag;
  bool _showSearch = false;

  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    _loadDiaries();
  }

  // ✅ 2. 修改加载逻辑：带数据隔离
  // 📋 调试版加载方法
  // 📋 调试版加载方法
  Future<void> _loadDiaries() async {
    print("\n========== 🐛 [DEBUG START] ==========");
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('current_user_id');

    print("👉 [1] 从本地读取到的 userId: $userId");

    if (userId == null) {
      print("❌ [错误] userId 为空！说明没有登录成功，或者 SharedPreferences 没存进去。");
      print("👉 请尝试点击设置 -> 退出登录，然后重新登录。");
      setState(() => _isLoading = false);
      return;
    }

    // 这一步是为了查看数据库里到底有没有数据（不管是谁的）
    final allData = await DatabaseHelper.instance.database.then((db) => db.query('diaries'));
    print("👉 [2] 数据库里【所有】日记总数: ${allData.length} 条");
    if (allData.isNotEmpty) {
      print("   --- 第一条数据样本 ---");
      print("   ID: ${allData.first['id']}");
      print("   Title: ${allData.first['title']}");
      print("   UserId: ${allData.first['userId']} (如果是 null，说明保存时没存进去)");
      print("   ---------------------");
    }

    // 正常查询当前用户的
    final data = await DatabaseHelper.instance.getDiaries(userId);
    print("👉 [3] 查询 userId=$userId 的日记结果: ${data.length} 条");

    if (!mounted) return;

    setState(() {
      _allDiaries = data;
      _filteredDiaries = data;
      _isLoading = false;
    });

    print("========== 🐛 [DEBUG END] ==========\n");
  }

  // ✅ 3. 补全筛选方法 (解决报错的关键)
  void _filterDiaries(String query) {
    List<DiaryEntry> temp = _allDiaries;

    // 关键词搜索 (标题或内容)
    if (query.isNotEmpty) {
      temp = temp.where((diary) {
        final plainText = _parseQuillContent(diary.content);
        return diary.title.contains(query) || plainText.contains(query);
      }).toList();
    }

    // 日期范围筛选
    if (_selectedDateRange != null) {
      temp = temp.where((diary) {
        return diary.date.isAfter(_selectedDateRange!.start.subtract(const Duration(days: 1))) &&
            diary.date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    // 标签筛选
    if (_selectedTag != null) {
      temp = temp.where((diary) => diary.tags.contains(_selectedTag)).toList();
    }

    setState(() {
      _filteredDiaries = temp;
    });
  }

  // 辅助：解析 Quill 内容为纯文本 (用于搜索)
  String _parseQuillContent(String jsonContent) {
    try {
      final doc = quill.Document.fromJson(jsonDecode(jsonContent));
      return doc.toPlainText().replaceAll('\n', ' ').trim();
    } catch (e) {
      return jsonContent;
    }
  }

  // 退出逻辑 (双击返回键)
  Future<bool> _onWillPop() async {
    if (_isSelectionMode) {
      setState(() {
        _isSelectionMode = false;
        _selectedIds.clear();
      });
      return false;
    }

    final now = DateTime.now();
    if (_lastPressedAt == null || now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
      _lastPressedAt = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('再按一次退出应用'), duration: Duration(seconds: 2)),
      );
      return false;
    }
    return true;
  }

  // 删除选中项
  Future<void> _deleteSelected() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteTitle),
        content: Text(l10n.deleteConfirm(_selectedIds.length.toString())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.deleteAction, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      for (var id in _selectedIds) {
        await DatabaseHelper.instance.deleteDiary(id);
      }
      setState(() {
        _isSelectionMode = false;
        _selectedIds.clear();
      });
      _loadDiaries();
    }
  }

  // 解析天气图标
  IconData _getWeatherIcon(int weather) {
    switch (weather) {
      case 0: return Icons.wb_sunny;
      case 1: return Icons.cloud;
      case 2: return Icons.umbrella;
      case 3: return Icons.ac_unit;
      case 4: return Icons.thunderstorm;
      case 5: return Icons.air;
      default: return Icons.wb_sunny;
    }
  }

  // 解析心情图标
  IconData _getMoodIcon(int mood) {
    switch (mood) {
      case 0: return Icons.sentiment_very_dissatisfied;
      case 1: return Icons.sentiment_dissatisfied;
      case 3: return Icons.sentiment_satisfied;
      case 4: return Icons.sentiment_very_satisfied;
      default: return Icons.sentiment_neutral;
    }
  }

  Color _getMoodColor(int mood) {
    switch (mood) {
      case 0: return AppColors.error;
      case 1: return Colors.orange;
      case 3: return AppColors.success;
      case 4: return AppColors.primary;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color;
    final secondaryTextColor = theme.textTheme.bodyMedium?.color;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ),
          backgroundColor: backgroundColor,
          elevation: 0,
          title: _showSearch
              ? TextField(
            controller: _searchController,
            autofocus: true,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              border: InputBorder.none,
              hintStyle: TextStyle(color: secondaryTextColor?.withOpacity(0.5)),
            ),
            onChanged: _filterDiaries,
          )
              : Text(
            _isSelectionMode ? '${_selectedIds.length} Selected' : l10n.appTitle,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          actions: _isSelectionMode
              ? [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteSelected,
            ),
            IconButton(
              icon: Icon(Icons.close, color: textColor),
              onPressed: () {
                setState(() {
                  _isSelectionMode = false;
                  _selectedIds.clear();
                });
              },
            ),
          ]
              : [
            if (!_showSearch)
              IconButton(
                icon: Icon(Icons.search, color: textColor),
                onPressed: () {
                  setState(() {
                    _showSearch = true;
                  });
                },
              )
            else
              IconButton(
                icon: Icon(Icons.close, color: textColor),
                onPressed: () {
                  setState(() {
                    _showSearch = false;
                    _searchController.clear();
                    _filterDiaries('');
                  });
                },
              ),
            IconButton(
              icon: Icon(Icons.calendar_month,
                  color: _selectedDateRange != null ? primaryColor : textColor),
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: theme.copyWith(
                        colorScheme: theme.colorScheme.copyWith(primary: primaryColor),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() => _selectedDateRange = picked);
                  _filterDiaries(_searchController.text);
                } else if (_selectedDateRange != null) {
                  setState(() => _selectedDateRange = null);
                  _filterDiaries(_searchController.text);
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.bar_chart, color: textColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatisticsScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings, color: textColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                ).then((_) => setState(() {}));
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator(color: primaryColor))
            : _filteredDiaries.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.book_outlined, size: 80, color: secondaryTextColor?.withOpacity(0.3)),
              const SizedBox(height: 16),
              Text(l10n.noDiariesFound,
                  style: TextStyle(color: secondaryTextColor?.withOpacity(0.5), fontSize: 16)),
            ],
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: _filteredDiaries.length,
          itemBuilder: (context, index) {
            final diary = _filteredDiaries[index];
            final isSelected = _selectedIds.contains(diary.id);
            return _buildDiaryCard(diary, isSelected, theme);
          },
        ),
        floatingActionButton: _isSelectionMode
            ? null
            : FloatingActionButton(
          backgroundColor: primaryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DiaryEditScreen()),
            );
            if (result == true) {
              _loadDiaries();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDiaryCard(DiaryEntry diary, bool isSelected, ThemeData theme) {
    final dateStr = DateFormat('yyyy-MM-dd').format(diary.date);
    final weekDay = DateFormat('EEE').format(diary.date);
    final title = diary.title;
    final content = _parseQuillContent(diary.content);
    final mood = diary.mood;
    final weather = diary.weather;
    final tags = diary.tags;
    final hasImage = diary.images.isNotEmpty;

    final cardColor = theme.cardColor;
    final secondaryTextColor = theme.textTheme.bodyMedium?.color;

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _isSelectionMode = true;
          _selectedIds.add(diary.id!);
        });
      },
      onTap: () async {
        if (_isSelectionMode) {
          setState(() {
            if (isSelected) {
              _selectedIds.remove(diary.id!);
              if (_selectedIds.isEmpty) _isSelectionMode = false;
            } else {
              _selectedIds.add(diary.id!);
            }
          });
        } else {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DiaryDetailScreen(diary: diary)),
          );
          if (result == true) _loadDiaries();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : cardColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
          boxShadow: [
            if (!isSelected && theme.brightness == Brightness.light)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 日期列
              Column(
                children: [
                  Text(DateFormat('dd').format(diary.date),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(weekDay.toUpperCase(),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: secondaryTextColor)),
                  const SizedBox(height: 8),
                  if (hasImage)
                    const Icon(Icons.image, size: 16, color: Colors.grey)
                ],
              ),
              const SizedBox(width: 16),
              // 垂直分割线
              Container(width: 2, height: 60, color: theme.dividerColor.withOpacity(0.5)),
              const SizedBox(width: 16),
              // 内容主体
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(_getWeatherIcon(weather), size: 16, color: secondaryTextColor),
                            const SizedBox(width: 4),
                            Text(dateStr,
                                style: TextStyle(color: secondaryTextColor, fontSize: 13)),
                          ],
                        ),
                        Icon(_getMoodIcon(mood), size: 20, color: _getMoodColor(mood)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(content,
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: secondaryTextColor, height: 1.5)),
                    const SizedBox(height: 10),
                    if (tags.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: tags.map((tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4)
                          ),
                          child: Text(tag, style: const TextStyle(color: AppColors.primary, fontSize: 10)),
                        )).toList(),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}