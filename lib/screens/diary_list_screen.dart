import 'package:flutter/material.dart';
import '../constants/colors.dart';
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
  // 批量删除相关的状态变量
  bool _isSelectionMode = false;
  final Set<int> _selectedIndices = {};

  // 模拟数据量
  int _itemCount = 5;

  // 切换选中状态
  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        if (_selectedIndices.isEmpty) _isSelectionMode = false;
      } else {
        _selectedIndices.add(index);
        _isSelectionMode = true;
      }
    });
  }

  // 退出选择模式
  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedIndices.clear();
    });
  }

  // 删除确认对话框
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除选中的 ${_selectedIndices.length} 篇日记吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          TextButton(
            onPressed: () {
              setState(() {
                _itemCount -= _selectedIndices.length;
                _exitSelectionMode();
              });
              Navigator.pop(context);
            },
            child: const Text('删除', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // 1. 动态应用栏：根据是否处于选择模式切换 UI
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 0,
            backgroundColor: AppColors.backgroundLight,
            leading: _isSelectionMode
                ? IconButton(icon: const Icon(Icons.close), onPressed: _exitSelectionMode)
                : null,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_isSelectionMode ? '已选 ${_selectedIndices.length}' : '我的日记',
                  style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            actions: [
              if (_isSelectionMode)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: _showDeleteDialog,
                )
              else ...[
                IconButton(
                  icon: const Icon(Icons.bar_chart_rounded, color: AppColors.textSecondaryLight),
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const StatisticsScreen())
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondaryLight),
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const SettingsScreen())
                  ),
                ),
              ]
            ],
          ),

          // 搜索栏区域（选择模式下隐藏，保持简洁）
          if (!_isSelectionMode)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '搜索日记、标签...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {},
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

          // 2. 日记列表区域：传递选中状态
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final isSelected = _selectedIndices.contains(index);
                  return DiaryCard(
                    isSelected: isSelected,
                    isSelectionMode: _isSelectionMode,
                    onTap: () {
                      if (_isSelectionMode) {
                        _toggleSelection(index);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DiaryDetailScreen()),
                        );
                      }
                    },
                    onLongPress: () => _toggleSelection(index), // 长按开启选择模式
                  );
                },
                childCount: _itemCount,
              ),
            ),
          ),
        ],
      ),
      // 选择模式下隐藏添加按钮
      floatingActionButton: _isSelectionMode ? null : FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => const DiaryEditScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class DiaryCard extends StatelessWidget {
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const DiaryCard({
    super.key,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        // 选中时的边框反馈
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.1),
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
              // 3. 选择模式下的勾选框
              if (isSelectionMode)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isSelected ? AppColors.primary : Colors.grey,
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
                            const Icon(Icons.sentiment_satisfied, size: 20, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text('2025年12月28日',
                                style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
                          ],
                        ),
                        const Icon(Icons.wb_sunny, size: 18, color: AppColors.warning),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('前端 UI 完成了！',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('现在所有的页面跳转和基础交互都已经就绪...',
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: AppColors.textSecondaryLight, height: 1.5)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: const [
                        TagChip(label: '进度', color: AppColors.primary),
                        TagChip(label: '开心', color: AppColors.success),
                      ],
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

class TagChip extends StatelessWidget {
  final String label;
  final Color color;
  const TagChip({super.key, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}