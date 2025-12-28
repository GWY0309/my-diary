import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../services/database_helper.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _touchedIndex = -1;
  bool _isLoading = true;

  // 真实统计数据
  int _totalDiaries = 0;
  List<double> _weeklyData = [0, 0, 0, 0, 0, 0, 0]; // 近7天数据
  Map<int, int> _moodData = {}; // 心情分布

  // 心情配置
  final List<Color> _moodColors = [
    AppColors.error,    // 0: 非常难过
    Colors.orange,      // 1: 难过
    Colors.grey,        // 2: 一般
    AppColors.success,  // 3: 开心
    AppColors.primary,  // 4: 非常开心
  ];
  final List<String> _moodLabels = ['极差', '难过', '一般', '开心', '超棒'];

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  // 【核心】加载真实数据
  Future<void> _loadStatistics() async {
    final count = await DatabaseHelper.instance.getDiaryCount();
    final weekly = await DatabaseHelper.instance.getWeeklyStats();
    final moods = await DatabaseHelper.instance.getMoodStats();

    if (mounted) {
      setState(() {
        _totalDiaries = count;
        _weeklyData = weekly;
        _moodData = moods;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = theme.cardColor;
    final gridColor = isDark ? Colors.white10 : Colors.black12;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('写作统计', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: theme.iconTheme,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 核心指标概览
            Row(
              children: [
                _buildStatCard(context, '累计日记', '$_totalDiaries', Icons.book_rounded, AppColors.primary),
                const SizedBox(width: 16),
                // 这里计算一下总字数太复杂，暂时先展示简单的“连续天数”或保留“本月天数”
                _buildStatCard(context, '记录心情', '${_moodData.values.fold<int>(0, (p, c) => p + c)}次', Icons.favorite, AppColors.error),
              ],
            ),
            const SizedBox(height: 24),

            // 2. 写作趋势 (近7天)
            Text('近7天写作热度', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              height: 250,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(24)),
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
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
                          // 动态生成最近7天的日期标签 (MM-dd)
                          // index 6 是今天，index 0 是6天前
                          final date = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                          final text = DateFormat('MM-dd').format(date);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(text, style: TextStyle(color: isDark ? Colors.white54 : Colors.grey, fontSize: 10)),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 == 0) { // 只显示整数刻度
                            return Text(value.toInt().toString(), style: TextStyle(color: isDark ? Colors.white30 : Colors.grey, fontSize: 12));
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: gridColor, strokeWidth: 1)),
                  barGroups: _generateBarGroups(isDark), // 使用真实数据
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. 心情分布饼图
            Text('心情分布', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              height: 280, // 稍微调高一点以免遮挡
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(24)),
              child: _moodData.values.every((v) => v == 0)
                  ? Center(child: Text("暂无心情数据", style: TextStyle(color: theme.disabledColor)))
                  : Row(
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
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _generatePieSections(), // 使用真实数据
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // 图例
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(_moodLabels.length, (index) {
                      // 只显示有数据的心情，或者全部显示
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _Indicator(
                          color: _moodColors[index],
                          text: '${_moodLabels[index]} (${_moodData[index]})',
                          isSquare: false,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(bool isDark) {
    return List.generate(7, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: _weeklyData[i], // 真实数据
            color: i == 6 ? AppColors.primary : (isDark ? Colors.white24 : AppColors.primaryLight), // 今天高亮
            width: 16,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _weeklyData.reduce((a, b) => a > b ? a : b) + 2, // 动态计算背景高度
              color: isDark ? Colors.white10 : Colors.grey.withOpacity(0.1),
            ),
          ),
        ],
      );
    });
  }

  List<PieChartSectionData> _generatePieSections() {
    List<PieChartSectionData> sections = [];
    // 计算总数
    int total = _moodData.values.fold<int>(0, (a, b) => a + b);

    if (total == 0) return [];

    // 【关键修复】定义一个计数器，记录当前是第几个显示的扇区
    int currentSectionIndex = 0;

    for (int i = 0; i < 5; i++) {
      final count = _moodData[i] ?? 0;
      if (count > 0) {
        // 【关键修复】使用 currentSectionIndex 来判断是否被点击，而不是使用 i
        final isTouched = currentSectionIndex == _touchedIndex;

        final fontSize = isTouched ? 18.0 : 14.0;
        final radius = isTouched ? 60.0 : 50.0;
        final percentage = (count / total * 100).toStringAsFixed(0);

        sections.add(PieChartSectionData(
          color: _moodColors[i],
          value: count.toDouble(),
          title: '$percentage%',
          radius: radius,
          titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
        ));

        // 每添加一个扇区，计数器加 1
        currentSectionIndex++;
      }
    }
    return sections;
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (theme.brightness == Brightness.light)
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