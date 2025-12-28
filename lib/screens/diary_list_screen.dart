import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill; // 用于解析富文本预览
import '../constants/colors.dart';
import '../services/database_helper.dart'; // 导入数据库帮助类
import '../models/diary_model.dart';       // 导入模型
import 'diary_edit_screen.dart';
import 'settings_screen.dart';
import 'diary_detail_screen.dart';
import 'statistics_screen.dart';

class DiaryListScreen extends StatefulWidget {
  const DiaryListScreen({super.key});

  @override
  State<DiaryListScreen> createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryListScreen> {
  // 数据源改为 DiaryEntry 模型列表
  List<DiaryEntry> _allDiaries = [];
  List<DiaryEntry> _filteredDiaries = [];

  bool _isLoading = true; // 加载状态
  bool _isSelectionMode = false;
  final Set<int> _selectedIds = {}; // 改为存储 ID 而不是 index

  // 搜索与过滤控制器
  final TextEditingController _searchController = TextEditingController();
  DateTimeRange? _selectedDateRange;
  String? _selectedTag;
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _loadDiaries(); // 启动时加载数据
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 【核心】从数据库加载数据
  Future<void> _loadDiaries() async {
    setState(() => _isLoading = true);
    try {
      final diaries = await DatabaseHelper.instance.getAllDiaries();
      setState(() {
        _allDiaries = diaries;
        _filterList(); // 加载后应用当前的过滤条件
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("加载日记失败: $e");
      setState(() => _isLoading = false);
    }
  }

  // 搜索逻辑
  void _onSearchChanged() {
    _filterList();
  }

  // 【核心】过滤逻辑适配 DiaryEntry 对象
  void _filterList() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredDiaries = _allDiaries.where((diary) {
        // 1. 关键词匹配 (标题或纯文本内容)
        final plainContent = _parseQuillContent(diary.content).toLowerCase();
        final matchesQuery = diary.title.toLowerCase().contains(query) ||
            plainContent.contains(query);

        // 2. 日期范围匹配
        bool matchesDate = true;
        if (_selectedDateRange != null) {
          matchesDate = diary.date.isAfter(_selectedDateRange!.start.subtract(const Duration(seconds: 1))) &&
              diary.date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
        }

        // 3. 标签匹配
        bool matchesTag = true;
        if (_selectedTag != null) {
          matchesTag = diary.tags.contains(_selectedTag);
        }

        return matchesQuery && matchesDate && matchesTag;
      }).toList();
    });
  }

  // 【工具】将 Quill JSON 解析为纯文本用于预览
  String _parseQuillContent(String jsonString) {
    try {
      final doc = quill.Document.fromJson(jsonDecode(jsonString));
      return doc.toPlainText().replaceAll('\n', ' ').trim();
    } catch (e) {
      return ""; // 解析失败返回空
    }
  }

  // 批量删除逻辑 (对接数据库)
  Future<void> _deleteSelected() async {
    for (var id in _selectedIds) {
      await DatabaseHelper.instance.deleteDiary(id);
    }
    _selectedIds.clear();
    _isSelectionMode = false;
    _loadDiaries(); // 删除后刷新
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('删除成功')));
    }
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) _isSelectionMode = false;
      } else {
        _selectedIds.add(id);
        _isSelectionMode = true;
      }
    });
  }

  // 跳转到编辑页，并在返回时刷新
  Future<void> _navigateToEdit() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DiaryEditScreen())
    );
    // 如果返回 true (表示保存成功)，则刷新列表
    if (result == true) {
      _loadDiaries();
    }
  }

  // ... (保留 _pickDateRange, _showTagFilterDialog 等 UI 辅助方法不变) ...
  // 为节省篇幅，此处省略 _pickDateRange 和 _showTagFilterDialog 的具体实现
  // 请直接复用您之前代码中的这两个方法，逻辑完全通用
  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Theme.of(context).cardColor,
              onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDateRange = picked);
      _filterList();
    }
  }

  void _showTagFilterDialog() {
    // 简单模拟的标签列表，实际可从数据库聚合获取
    final tags = ['生活', '工作', '旅行', '心情', '美食', '学习'];
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: Text('按标签筛选', style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
          content: Wrap(
            spacing: 8,
            children: tags.map((tag) => FilterChip(
              label: Text(tag),
              selected: _selectedTag == tag,
              onSelected: (bool selected) {
                setState(() => _selectedTag = selected ? tag : null);
                _filterList();
                Navigator.pop(context);
              },
              backgroundColor: theme.scaffoldBackgroundColor,
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
            )).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: _showSearch ? 140.0 : 60.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
            iconTheme: theme.iconTheme,
            leading: _isSelectionMode
                ? IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() {
              _isSelectionMode = false;
              _selectedIds.clear();
            }))
                : null,
            title: _isSelectionMode
                ? Text('已选 ${_selectedIds.length}', style: TextStyle(color: theme.textTheme.bodyLarge?.color))
                : Text('我的日记', style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              if (_isSelectionMode)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: _deleteSelected, // 调用真实删除
                )
              else ...[
                IconButton(
                  icon: Icon(_showSearch ? Icons.search_off : Icons.search, color: theme.iconTheme.color),
                  onPressed: () => setState(() {
                    _showSearch = !_showSearch;
                    if (!_showSearch) {
                      _searchController.clear();
                      _selectedDateRange = null;
                      _selectedTag = null;
                      _filterList();
                    }
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.bar_chart_rounded),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StatisticsScreen())),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
                ),
              ]
            ],
            // 搜索栏 UI (与之前保持一致)
            bottom: _showSearch ? PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '搜索日记...',
                        hintStyle: TextStyle(color: theme.hintColor),
                        prefixIcon: Icon(Icons.search, color: theme.hintColor),
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.calendar_month,
                                  color: _selectedDateRange != null ? AppColors.primary : theme.hintColor),
                              onPressed: _pickDateRange,
                            ),
                            IconButton(
                              icon: Icon(Icons.local_offer,
                                  color: _selectedTag != null ? AppColors.primary : theme.hintColor),
                              onPressed: _showTagFilterDialog,
                            ),
                          ],
                        ),
                      ),
                      style: theme.textTheme.bodyLarge,
                    ),
                    if (_selectedDateRange != null || _selectedTag != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            if (_selectedDateRange != null)
                              _buildFilterChip(
                                label: '${DateFormat('MM/dd').format(_selectedDateRange!.start)} - ${DateFormat('MM/dd').format(_selectedDateRange!.end)}',
                                onDeleted: () { setState(() => _selectedDateRange = null); _filterList(); },
                              ),
                            if (_selectedTag != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: _buildFilterChip(
                                  label: '#$_selectedTag',
                                  onDeleted: () { setState(() => _selectedTag = null); _filterList(); },
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ) : null,
          ),

          // 列表区域
          if (_isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (_filteredDiaries.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Icon(Icons.inbox, size: 64, color: theme.disabledColor),
                    const SizedBox(height: 16),
                    Text('没有找到日记', style: TextStyle(color: theme.disabledColor)),
                  ],
                ),
              ),
            )
          else SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final diary = _filteredDiaries[index];
                    // 使用数据库 ID 进行选中判断
                    final isSelected = _selectedIds.contains(diary.id);
                    // 解析预览文本
                    final previewText = _parseQuillContent(diary.content);

                    return DiaryCard(
                      title: diary.title,
                      content: previewText,
                      date: diary.date,
                      tags: diary.tags,
                      mood: diary.mood, // 传递心情索引
                      isSelected: isSelected,
                      isSelectionMode: _isSelectionMode,
                      onTap: () {
                        if (_isSelectionMode) {
                          if (diary.id != null) _toggleSelection(diary.id!);
                        } else {
                          // TODO: 跳转详情页时传递 diary 对象
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const DiaryDetailScreen()));
                        }
                      },
                      onLongPress: () {
                        if (diary.id != null) _toggleSelection(diary.id!);
                      },
                    );
                  },
                  childCount: _filteredDiaries.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _isSelectionMode ? null : FloatingActionButton(
        onPressed: _navigateToEdit, // 改为调用带刷新的跳转方法
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip({required String label, required VoidCallback onDeleted}) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
      backgroundColor: AppColors.primary,
      deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white),
      onDeleted: onDeleted,
      visualDensity: VisualDensity.compact,
    );
  }
}

// 日记卡片组件
class DiaryCard extends StatelessWidget {
  final String title;
  final String content;
  final DateTime date;
  final List<String> tags;
  final int mood; // 新增心情字段
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const DiaryCard({
    super.key,
    required this.title,
    required this.content,
    required this.date,
    required this.tags,
    required this.mood,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
  });

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryTextColor = theme.brightness == Brightness.dark ? Colors.white70 : AppColors.textSecondaryLight;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? AppColors.primary : theme.dividerColor.withOpacity(0.05),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (isSelectionMode)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isSelected ? AppColors.primary : theme.disabledColor,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(DateFormat('yyyy年MM月dd日').format(date),
                                style: TextStyle(color: secondaryTextColor, fontSize: 13)),
                          ],
                        ),
                        // 动态显示心情图标
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