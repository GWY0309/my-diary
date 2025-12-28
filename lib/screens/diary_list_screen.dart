import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'diary_edit_screen.dart';
import 'settings_screen.dart';
import 'diary_detail_screen.dart';
import 'statistics_screen.dart';

class DiaryListScreen extends StatelessWidget {
  const DiaryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // 顶部应用栏
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 0,
            backgroundColor: AppColors.backgroundLight,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('我的日记',
                  style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            actions: [
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
            ],
          ),

          // 搜索栏区域
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '搜索日记、标签...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      // TODO: 清空搜索逻辑
                    },
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

          // 日记列表区域
          SliverPadding(
            padding: const EdgeInsets.all(16),
            // 【修复点】：将 child 修改为 sliver
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => const DiaryCard(),
                childCount: 5,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
  const DiaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DiaryDetailScreen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
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