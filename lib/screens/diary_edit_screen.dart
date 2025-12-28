import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../constants/colors.dart';

class DiaryEditScreen extends StatefulWidget {
  const DiaryEditScreen({super.key});

  @override
  State<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends State<DiaryEditScreen> {
  final QuillController _quillController = QuillController.basic();
  final TextEditingController _titleController = TextEditingController();

  // 控制工具栏是否显示的变量
  bool _showToolbar = false;

  int _selectedMood = 2;
  int _selectedWeather = 0;
  List<String> _selectedTags = [];

  final List<IconData> _moodIcons = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  final List<IconData> _weatherIcons = [
    Icons.wb_sunny,
    Icons.cloud,
    Icons.wb_cloudy,
    Icons.umbrella,
    Icons.ac_unit,
    Icons.thunderstorm,
    Icons.air,
  ];

  final List<String> _availableTags = ['生活', '工作', '旅行', '心情', '美食', '学习'];

  @override
  void dispose() {
    _quillController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: const Text('写日记', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          // 【新增】：切换工具栏显示的图标按钮
          IconButton(
            icon: Icon(
              _showToolbar ? Icons.text_format : Icons.text_format_outlined,
              color: _showToolbar ? AppColors.primary : AppColors.textSecondaryLight,
            ),
            onPressed: () {
              setState(() {
                _showToolbar = !_showToolbar;
              });
            },
            tooltip: "编辑工具",
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('保存',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          // 【核心修改】：使用 AnimatedContainer 实现下拉动画效果
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _showToolbar ? 60 : 0, // 展开高度为 60，折叠为 0
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(), // 防止内部滚动干扰
              child: QuillSimpleToolbar(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: _quillController,
                  showFontFamily: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showSmallButton: false,
                  showSearchButton: false,
                  showRedo: false,
                  showUndo: false,
                  // 可以根据需要在此隐藏更多不需要的按钮以节省空间
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: '今天的标题...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 22, color: AppColors.textSecondaryLight),
                  ),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildSelector(
                            icon: _moodIcons[_selectedMood],
                            label: "心情",
                            onTap: () => _showIconPicker("选择心情", _moodIcons, (index) {
                              setState(() => _selectedMood = index);
                            }),
                          ),
                          const SizedBox(width: 24),
                          _buildSelector(
                            icon: _weatherIcons[_selectedWeather],
                            label: "天气",
                            onTap: () => _showIconPicker("选择天气", _weatherIcons, (index) {
                              setState(() => _selectedWeather = index);
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          ..._selectedTags.map((tag) => Chip(
                            label: Text(tag, style: const TextStyle(fontSize: 12)),
                            onDeleted: () => setState(() => _selectedTags.remove(tag)),
                            deleteIcon: const Icon(Icons.close, size: 14),
                            backgroundColor: AppColors.primaryLight.withOpacity(0.1),
                          )),
                          ActionChip(
                            avatar: const Icon(Icons.add, size: 16),
                            label: const Text('添加标签'),
                            onPressed: _showTagPicker,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(),

                QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    controller: _quillController,
                    readOnly: false,
                    placeholder: '记录今天的故事...',
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 辅助方法保持不变...
  Widget _buildSelector({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  void _showIconPicker(String title, List<IconData> icons, Function(int) onSelected) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: List.generate(icons.length, (index) {
                  return IconButton(
                    icon: Icon(icons[index],
                        color: index == (title == "选择心情" ? _selectedMood : _selectedWeather)
                            ? AppColors.primary
                            : Colors.grey,
                        size: 32),
                    onPressed: () {
                      onSelected(index);
                      Navigator.pop(context);
                    },
                  );
                }),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  void _showTagPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('选择标签', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    children: _availableTags.map((tag) => FilterChip(
                      label: Text(tag),
                      selected: _selectedTags.contains(tag),
                      onSelected: (selected) {
                        setState(() {
                          selected ? _selectedTags.add(tag) : _selectedTags.remove(tag);
                        });
                        setModalState(() {});
                      },
                    )).toList(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }
}