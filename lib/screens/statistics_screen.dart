import 'package:flutter/material.dart';
import '../constants/colors.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('统计分析', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. 核心指标卡片
          Row(
            children: [
              _buildStatCard('日记总数', '128', Icons.book_outlined, AppColors.primary),
              const SizedBox(width: 16),
              _buildStatCard('本月坚持', '22天', Icons.calendar_today_outlined, AppColors.success),
            ],
          ),
          const SizedBox(height: 24),

          // 2. 写作频率趋势图 (模拟图表)
          _buildSectionTitle('写作频率趋势'),
          const SizedBox(height: 12),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(0.4, 'Mon'),
                _buildBar(0.7, 'Tue'),
                _buildBar(0.5, 'Wed'),
                _buildBar(0.9, 'Thu'),
                _buildBar(0.6, 'Fri'),
                _buildBar(0.3, 'Sat'),
                _buildBar(0.8, 'Sun'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. 标签使用频率统计
          _buildSectionTitle('常用标签'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildTagRow('生活', 45, AppColors.primary),
                _buildTagRow('工作', 30, AppColors.success),
                _buildTagRow('旅行', 15, AppColors.warning),
                _buildTagRow('心情', 10, AppColors.error),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建核心指标小卡片
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // 构建模拟柱状图
  Widget _buildBar(double heightFactor, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 12,
          height: 120 * heightFactor,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.6),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
      ],
    );
  }

  // 构建标签进度条
  Widget _buildTagRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(label, style: const TextStyle(fontSize: 12))),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: count / 50,
                backgroundColor: AppColors.backgroundLight,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text('$count', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
    );
  }
}