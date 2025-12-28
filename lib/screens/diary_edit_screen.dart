import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import '../models/diary_model.dart';
import '../services/database_helper.dart';

class DiaryEditScreen extends StatefulWidget {
  const DiaryEditScreen({super.key});

  @override
  State<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends State<DiaryEditScreen> {
  // 控制器定义
  final QuillController _quillController = QuillController.basic();
  final TextEditingController _titleController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // 状态变量
  bool _showToolbar = false;
  int _selectedMood = 2; // 默认：一般
  int _selectedWeather = 0; // 默认：晴
  List<String> _selectedTags = [];
  List<File> _selectedImages = []; // 已选图片列表

  // 图标配置
  final List<IconData> _moodIcons = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  final List<IconData> _weatherIcons = [
    Icons.wb_sunny,     // 晴
    Icons.cloud,        // 多云
    Icons.wb_cloudy,    // 阴
    Icons.umbrella,     // 雨
    Icons.ac_unit,      // 雪
    Icons.thunderstorm, // 雷
    Icons.air,          // 风
  ];

  final List<String> _availableTags = ['生活', '工作', '旅行', '心情', '美食', '学习'];

  @override
  void dispose() {
    _quillController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  // 选择图片逻辑
  Future<void> _pickImage() async {
    if (_selectedImages.length >= 9) {
      _showSnackBar('最多只能添加9张图片');
      return;
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  // 保存日记逻辑
  Future<void> _saveDiary() async {
    final title = _titleController.text.trim();
    final content = jsonEncode(_quillController.document.toDelta().toJson());

    if (title.isEmpty) {
      _showSnackBar('请输入日记标题');
      return;
    }

    final entry = DiaryEntry(
      title: title,
      content: content,
      mood: _selectedMood,
      weather: _selectedWeather,
      tags: _selectedTags,
      date: DateTime.now(),
    );

    await DatabaseHelper.instance.insertDiary(entry);

    if (mounted) {
      _showSnackBar('日记已保存');
      Navigator.pop(context, true);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    // 【修改1】获取当前主题信息
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 定义动态的次级文字颜色（用于图标未选中状态、提示文字等）
    final secondaryColor = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    return Scaffold(
      // 【修改2】背景色跟随 Card 颜色 (main.dart 中定义：日间白/夜间深灰)
      backgroundColor: theme.cardColor,
      appBar: AppBar(
        title: const Text('写日记', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        // 确保 AppBar 背景透明或跟随 Scaffold
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              _showToolbar ? Icons.text_format : Icons.text_format_outlined,
              // 【修改3】动态图标颜色
              color: _showToolbar ? theme.primaryColor : secondaryColor,
            ),
            onPressed: () => setState(() => _showToolbar = !_showToolbar),
            tooltip: "编辑工具",
          ),
          TextButton(
            onPressed: _saveDiary,
            child: Text('保存',
                // 【修改4】动态主色
                style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. 下拉式工具栏
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _showToolbar ? 60 : 0,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
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
                  // 这里的图标颜色 Quill 会自动尝试适配，但部分背景可能需微调
                  buttonOptions: QuillSimpleToolbarButtonOptions(
                    base: QuillToolbarBaseButtonOptions(
                      iconTheme: QuillIconTheme(
                        iconButtonSelectedData: IconButtonData(
                          color: theme.primaryColor, // 选中颜色
                        ),
                        iconButtonUnselectedData: IconButtonData(
                          color: secondaryColor, // 未选中颜色
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // 2. 标题输入
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: '今天的标题...',
                    border: InputBorder.none,
                    // 【修改5】提示文字颜色动态化
                    hintStyle: TextStyle(fontSize: 22, color: theme.hintColor),
                  ),
                  // 输入文字颜色会自动跟随 theme.textTheme
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                // 3. 图片预览区域
                if (_selectedImages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(_selectedImages[index],
                                      width: 100, height: 100, fit: BoxFit.cover),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedImages.removeAt(index)),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                          color: Colors.black54, shape: BoxShape.circle),
                                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                // 4. 选择器与功能按钮行
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildSelector(
                            context: context, // 传入 context
                            icon: _moodIcons[_selectedMood],
                            label: "心情",
                            onTap: () => _showIconPicker("选择心情", _moodIcons, (index) {
                              setState(() => _selectedMood = index);
                            }),
                          ),
                          const SizedBox(width: 24),
                          _buildSelector(
                            context: context,
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
                        runSpacing: 8,
                        children: [
                          ..._selectedTags.map((tag) => Chip(
                            label: Text(tag, style: const TextStyle(fontSize: 12)),
                            onDeleted: () => setState(() => _selectedTags.remove(tag)),
                            deleteIcon: const Icon(Icons.close, size: 14),
                            // 【修改6】Chip 背景色动态化
                            backgroundColor: theme.primaryColor.withOpacity(0.1),
                          )),
                          ActionChip(
                            // 【修改7】ActionChip 图标颜色
                            avatar: Icon(Icons.image_outlined, size: 16, color: theme.primaryColor),
                            label: const Text('添加图片'),
                            onPressed: _pickImage,
                          ),
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

                // 5. 正文编辑器
                // 注意：flutter_quill 默认会适配 Theme，但在深色背景下可能需要显式配置样式
                QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    controller: _quillController,
                    readOnly: false,
                    placeholder: '记录今天的故事...',
                    padding: EdgeInsets.zero,
                    // 确保输入文字颜色正确（通常不需要手动设置，Quill 会跟随 Theme.textTheme）
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 辅助组件：选择器入口
  Widget _buildSelector({required BuildContext context, required IconData icon, required String label, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondaryColor = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            // 【修改8】图标颜色动态化
            Icon(icon, size: 22, color: theme.primaryColor),
            const SizedBox(width: 6),
            // 【修改9】标签文字颜色动态化
            Text(label, style: TextStyle(color: secondaryColor, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // 辅助组件：心情/天气选择弹窗
  void _showIconPicker(String title, List<IconData> icons, Function(int) onSelected) {
    showModalBottomSheet(
      context: context,
      // 允许 BottomSheet 自动适配深色模式背景
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        // 未选中图标的颜色
        final unselectedColor = isDark ? Colors.white38 : Colors.grey;

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
                  final isSelected = index == (title == "选择心情" ? _selectedMood : _selectedWeather);
                  return IconButton(
                    icon: Icon(
                      icons[index],
                      // 【修改10】弹窗内图标颜色动态化
                      color: isSelected ? theme.primaryColor : unselectedColor,
                      size: 32,
                    ),
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

  // 辅助组件：标签选择弹窗
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