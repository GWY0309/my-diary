import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // 【新增】
import 'package:path/path.dart' as path;         // 【新增】
import '../constants/colors.dart';
import '../models/diary_model.dart';
import '../services/database_helper.dart';

class DiaryEditScreen extends StatefulWidget {
  final DiaryEntry? diary;

  const DiaryEditScreen({super.key, this.diary});

  @override
  State<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends State<DiaryEditScreen> {
  late QuillController _quillController;
  late TextEditingController _titleController;
  // 保留您的 focusNode 修复
  final FocusNode _editorFocusNode = FocusNode();

  final ImagePicker _picker = ImagePicker();

  bool _showToolbar = false;

  int _selectedMood = 2;
  int _selectedWeather = 0;
  List<String> _selectedTags = [];
  List<String> _selectedImages = []; // 【修改】改为存储路径字符串

  final List<IconData> _moodIcons = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  final List<IconData> _weatherIcons = [
    Icons.wb_sunny, Icons.cloud, Icons.wb_cloudy, Icons.umbrella,
    Icons.ac_unit, Icons.thunderstorm, Icons.air,
  ];

  final List<String> _availableTags = ['生活', '工作', '旅行', '心情', '美食', '学习'];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    if (widget.diary != null) {
      final d = widget.diary!;
      _titleController = TextEditingController(text: d.title);
      _selectedMood = d.mood;
      _selectedWeather = d.weather;
      _selectedTags = List.from(d.tags);
      _selectedImages = List.from(d.images); // 【新增】回显图片

      try {
        final doc = Document.fromJson(jsonDecode(d.content));
        _quillController = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        _quillController = QuillController.basic();
      }
    } else {
      _titleController = TextEditingController();
      _quillController = QuillController.basic();
    }
  }

  @override
  void dispose() {
    _quillController.dispose();
    _titleController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  // 【核心修改】保存逻辑：处理图片持久化
  Future<void> _saveDiary() async {
    final title = _titleController.text.trim();
    final content = jsonEncode(_quillController.document.toDelta().toJson());

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入日记标题')));
      return;
    }

    // 1. 处理图片：将临时路径的图片拷贝到 App 文档目录
    List<String> finalImagePaths = [];
    final appDir = await getApplicationDocumentsDirectory();

    for (String imgPath in _selectedImages) {
      final file = File(imgPath);
      if (await file.exists()) {
        // 如果图片已经在 App 目录下（说明是旧图），直接保留
        if (path.isWithin(appDir.path, imgPath)) {
          finalImagePaths.add(imgPath);
        } else {
          // 如果是新选的图，复制进来
          final fileName = path.basename(imgPath);
          final newPath = '${appDir.path}/$fileName';
          await file.copy(newPath);
          finalImagePaths.add(newPath);
        }
      }
    }

    // 2. 创建对象
    final newEntry = DiaryEntry(
      id: widget.diary?.id,
      title: title,
      content: content,
      mood: _selectedMood,
      weather: _selectedWeather,
      tags: _selectedTags,
      images: finalImagePaths, // 保存最终路径
      date: widget.diary?.date ?? DateTime.now(),
    );

    // 3. 写入数据库
    if (widget.diary == null) {
      await DatabaseHelper.instance.insertDiary(newEntry);
    } else {
      await DatabaseHelper.instance.updateDiary(newEntry);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.diary == null ? '日记已发布' : '日记已更新'))
      );
      Navigator.pop(context, newEntry);
    }
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 9) return;
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // 【修改】直接存路径字符串
    if (image != null) setState(() => _selectedImages.add(image.path));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.brightness == Brightness.dark ? Colors.white70 : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: theme.cardColor,
      appBar: AppBar(
        title: Text(widget.diary == null ? '写日记' : '编辑日记',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              _showToolbar ? Icons.text_format : Icons.text_format_outlined,
              color: _showToolbar ? theme.primaryColor : secondaryColor,
            ),
            onPressed: () => setState(() => _showToolbar = !_showToolbar),
          ),
          TextButton(
            onPressed: _saveDiary,
            child: Text('保存', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
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
                  buttonOptions: QuillSimpleToolbarButtonOptions(
                    base: QuillToolbarBaseButtonOptions(
                      iconTheme: QuillIconTheme(
                        iconButtonSelectedData: IconButtonData(color: theme.primaryColor),
                        iconButtonUnselectedData: IconButtonData(color: secondaryColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (!_editorFocusNode.hasFocus) {
                  _editorFocusNode.requestFocus();
                }
              },
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: '今天的标题...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 22, color: theme.hintColor),
                    ),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  // 图片展示
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
                                    child: Image.file(
                                        File(_selectedImages[index]), // 【修改】从路径创建 File
                                        width: 100, height: 100, fit: BoxFit.cover
                                    ),
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

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildSelector(context, _moodIcons[_selectedMood], "心情",
                                    () => _showIconPicker("选择心情", _moodIcons, (i) => setState(() => _selectedMood = i))),
                            const SizedBox(width: 24),
                            _buildSelector(context, _weatherIcons[_selectedWeather], "天气",
                                    () => _showIconPicker("选择天气", _weatherIcons, (i) => setState(() => _selectedWeather = i))),
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
                              backgroundColor: theme.primaryColor.withOpacity(0.1),
                            )),
                            ActionChip(
                              avatar: const Icon(Icons.image_outlined, size: 16),
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

                  Container(
                    constraints: const BoxConstraints(minHeight: 300),
                    child: QuillEditor.basic(
                      // 【保留修复】focusNode 放在正确的位置
                      focusNode: _editorFocusNode,
                      configurations: QuillEditorConfigurations(
                        controller: _quillController,
                        placeholder: '记录今天的故事...',
                        padding: EdgeInsets.zero,
                        sharedConfigurations: const QuillSharedConfigurations(
                          locale: Locale('zh', 'CN'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 辅助方法保持不变
  Widget _buildSelector(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    final theme = Theme.of(context);
    final secondaryColor = theme.brightness == Brightness.dark ? Colors.white70 : AppColors.textSecondaryLight;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(children: [Icon(icon, size: 22, color: theme.primaryColor), const SizedBox(width: 6), Text(label, style: TextStyle(color: secondaryColor))]),
      ),
    );
  }

  void _showIconPicker(String title, List<IconData> icons, Function(int) onSelected) {
    showModalBottomSheet(context: context, builder: (ctx) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(spacing: 20, runSpacing: 20, children: List.generate(icons.length, (i) => IconButton(icon: Icon(icons[i], size: 32, color: AppColors.primary), onPressed: () { onSelected(i); Navigator.pop(context); }))),
      );
    });
  }

  void _showTagPicker() {
    showModalBottomSheet(context: context, builder: (ctx) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(spacing: 10, children: _availableTags.map((t) => ActionChip(label: Text(t), onPressed: () { setState(() => _selectedTags.contains(t) ? null : _selectedTags.add(t)); Navigator.pop(context); })).toList()),
      );
    });
  }
}