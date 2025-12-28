import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  // 模拟触控索引，用于显示 Tooltip
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // 获取当前主题
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 定义动态颜色
    final cardColor = theme.cardColor;
    final gridColor = isDark ? Colors.white10 : Colors.black12;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('写作统计', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: theme.iconTheme, // 适配返回箭头颜色
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 核心指标概览卡片
            Row(
              children: [
                _buildStatCard(context, '累计日记', '128', Icons.book_rounded, AppColors.primary),
                const SizedBox(width: 16),
                _buildStatCard(context, '本月天数', '22', Icons.calendar_month_rounded, AppColors.success),
              ],
            ),
            const SizedBox(height: 24),

            // 2. 写作趋势柱状图 (BarChart)
            Text('近7天写作热度', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              height: 250,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      // 【修复点】0.66.0 版本使用 tooltipBgColor
                      tooltipBgColor: Colors.blueGrey,
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.round()} 篇',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              days[value.toInt() % 7],
                              style: TextStyle(color: isDark ? Colors.white54 : Colors.grey, fontSize: 12),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) {
                    return FlLine(color: gridColor, strokeWidth: 1);
                  }),
                  barGroups: _generateBarGroups(isDark), // 生成数据
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. 心情分布饼图 (PieChart)
            Text('心情分布', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              height: 250,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                _touchedIndex = -1;
                                return;
                              }
                              _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2, // 扇区间隔
                        centerSpaceRadius: 40, // 中空半径（甜甜圈图）
                        sections: _generatePieSections(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // 图例说明
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _Indicator(color: AppColors.primary, text: '开心', isSquare: false),
                      SizedBox(height: 8),
                      _Indicator(color: AppColors.success, text: '平静', isSquare: false),
                      SizedBox(height: 8),
                      _Indicator(color: AppColors.warning, text: '一般', isSquare: false),
                      SizedBox(height: 8),
                      _Indicator(color: AppColors.error, text: '难过', isSquare: false),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 辅助方法：生成柱状图数据
  List<BarChartGroupData> _generateBarGroups(bool isDark) {
    // 这里使用模拟数据，后续对接 DatabaseHelper
    final data = [2.0, 4.0, 1.0, 3.0, 5.0, 2.0, 4.0];
    return List.generate(7, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: data[i],
            color: i == 4 ? AppColors.primary : (isDark ? Colors.white24 : AppColors.primaryLight), // 高亮某一天
            width: 16,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 6, // 满格高度
              color: isDark ? Colors.white10 : Colors.grey.withOpacity(0.1),
            ),
          ),
        ],
      );
    });
  }

  // 辅助方法：生成饼图数据
  List<PieChartSectionData> _generatePieSections() {
    return List.generate(4, (i) {
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0; // 选中变大效果

      switch (i) {
        case 0:
          return PieChartSectionData(color: AppColors.primary, value: 40, title: '40%', radius: radius, titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white));
        case 1:
          return PieChartSectionData(color: AppColors.success, value: 30, title: '30%', radius: radius, titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white));
        case 2:
          return PieChartSectionData(color: AppColors.warning, value: 15, title: '15%', radius: radius, titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white));
        case 3:
          return PieChartSectionData(color: AppColors.error, value: 15, title: '15%', radius: radius, titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white));
        default:
          throw Error();
      }
    });
  }

  // 辅助组件：顶部统计小卡片
  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (theme.brightness == Brightness.light) // 仅日间模式显示阴影
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
            Text(title, style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// 内部组件：图例指示器
class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  const _Indicator({required this.color, required this.text, required this.isSquare});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 12, height: 12,
          decoration: BoxDecoration(shape: isSquare ? BoxShape.rectangle : BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.textTheme.bodyMedium?.color)),
      ],
    );
  }
}