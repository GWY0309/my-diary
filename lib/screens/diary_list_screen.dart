import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../constants/colors.dart';
import '../services/database_helper.dart';
import '../models/diary_model.dart';
import 'diary_edit_screen.dart';
import 'settings_screen.dart';
import 'diary_detail_screen.dart';
import 'statistics_screen.dart';
import '../l10n/app_localizations.dart'; // 确保导入

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
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDiaries() async {
    setState(() => _isLoading = true);
    try {
      final diaries = await DatabaseHelper.instance.getAllDiaries();
      setState(() {
        _allDiaries = diaries;
        _filterList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("加载日记失败: $e");
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    _filterList();
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredDiaries = _allDiaries.where((diary) {
        final plainContent = _parseQuillContent(diary.content).toLowerCase();
        final matchesQuery = diary.title.toLowerCase().contains(query) ||
            plainContent.contains(query);

        bool matchesDate = true;
        if (_selectedDateRange != null) {
          matchesDate = diary.date.isAfter(_selectedDateRange!.start.subtract(const Duration(seconds: 1))) &&
              diary.date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
        }

        bool matchesTag = true;
        if (_selectedTag != null) {
          matchesTag = diary.tags.contains(_selectedTag);
        }

        return matchesQuery && matchesDate && matchesTag;
      }).toList();
    });
  }

  String _parseQuillContent(String jsonString) {
    try {
      final doc = quill.Document.fromJson(jsonDecode(jsonString));
      return doc.toPlainText().replaceAll('\n', ' ').trim();
    } catch (e) {
      return "";
    }
  }

  Future<void> _deleteSelected() async {
    for (var id in _selectedIds) {
      await DatabaseHelper.instance.deleteDiary(id);
    }
    _selectedIds.clear();
    _isSelectionMode = false;
    _loadDiaries();
    if (mounted) {
      // 【修改】使用翻译变量
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.deleteSuccess)));
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

  Future<void> _navigateToEdit() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DiaryEditScreen())
    );
    if (result != null) {
      _loadDiaries();
    }
  }

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
    // 【修改】将标签列表改为动态获取翻译
    final l10n = AppLocalizations.of(context)!;
    final tags = [
      l10n.tagLife,
      l10n.tagWork,
      l10n.tagTravel,
      l10n.tagMood,
      l10n.tagFood,
      l10n.tagStudy
    ];

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.cardColor,
          // 【修改】标题翻译
          title: Text(l10n.filterByTag, style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
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
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        if (_isSelectionMode) {
          setState(() {
            _isSelectionMode = false;
            _selectedIds.clear();
          });
          return;
        }

        if (_showSearch) {
          setState(() {
            _showSearch = false;
            _searchController.clear();
            _selectedDateRange = null;
            _selectedTag = null;
            _filterList();
          });
          return;
        }

        final now = DateTime.now();
        if (_lastPressedAt == null || now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).clearSnackBars();
          // 【修改】退出提示翻译
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.tapAgainToExit),
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }

        SystemNavigator.pop();
      },
      child: Scaffold(
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
              // 【修改】标题翻译： "已选" 和 App标题
              title: _isSelectionMode
                  ? Text('${l10n.selected} ${_selectedIds.length}', style: TextStyle(color: theme.textTheme.bodyLarge?.color))
                  : Text(l10n.appTitle, style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.bold),),
              centerTitle: true,
              actions: [
                if (_isSelectionMode)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    onPressed: _deleteSelected,
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
              bottom: _showSearch ? PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          // 【修改】搜索提示翻译
                          hintText: l10n.searchHint,
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
                      // 【修改】空状态提示翻译
                      Text(l10n.noDiariesFound, style: TextStyle(color: theme.disabledColor)),
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
                      final isSelected = _selectedIds.contains(diary.id);
                      final previewText = _parseQuillContent(diary.content);

                      return DiaryCard(
                        title: diary.title,
                        content: previewText,
                        date: diary.date,
                        tags: diary.tags,
                        mood: diary.mood,
                        isSelected: isSelected,
                        isSelectionMode: _isSelectionMode,
                        onTap: () {
                          if (_isSelectionMode) {
                            if (diary.id != null) _toggleSelection(diary.id!);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DiaryDetailScreen(diary: diary)
                              ),
                            ).then((_) {
                              _loadDiaries();
                            });
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
          onPressed: _navigateToEdit,
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
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

class DiaryCard extends StatelessWidget {
  final String title;
  final String content;
  final DateTime date;
  final List<String> tags;
  final int mood;
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

    // 【新增】1. 获取当前语言代码
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    // 【新增】2. 根据语言决定日期格式
    // 中文：2023年10月24日
    // 英文：Oct 24, 2023
    final dateStr = isZh
        ? DateFormat('yyyy年MM月dd日').format(date)
        : DateFormat('MMM dd, yyyy').format(date);

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
                            // 【修改】3. 使用动态生成的日期字符串
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