import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../models/diary_model.dart';
import '../services/database_helper.dart';
import '../../l10n/app_localizations.dart'; // ✅ 确保导入国际化文件

class DiaryEditScreen extends StatefulWidget {
  final DiaryEntry? diary; // 如果是 null 表示新建，否则是编辑
  const DiaryEditScreen({super.key, this.diary});

  @override
  State<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends State<DiaryEditScreen> {
  late TextEditingController _titleController;
  late quill.QuillController _quillController;

  // 图片相关
  final ImagePicker _picker = ImagePicker();
  List<String> _selectedImages = []; // 存储图片路径

  // 其他元数据
  late DateTime _selectedDate;
  int _selectedMood = 2; // 默认平静
  int _selectedWeather = 0; // 默认晴天
  List<String> _selectedTags = [];
  bool _showToolbar = false;

  final FocusNode _editorFocusNode = FocusNode();

  // 定义图标数据
  final List<IconData> _moodIcons = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];


  final List<IconData> _weatherIcons = [
    Icons.wb_sunny, Icons.cloud,  Icons.umbrella,
    Icons.ac_unit, Icons.thunderstorm, Icons.air,
  ];

  final List<String> _availableTags = ['Life', 'Work', 'Travel', 'Mood', 'Food', 'Study'];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _titleController = TextEditingController(text: widget.diary?.title ?? '');
    _selectedDate = widget.diary?.date ?? DateTime.now();
    _selectedMood = widget.diary?.mood ?? 2;
    _selectedWeather = widget.diary?.weather ?? 0; // ✅ 恢复天气字段
    _selectedTags = List.from(widget.diary?.tags ?? []);
    _selectedImages = List.from(widget.diary?.images ?? []); // ✅ 恢复图片回显

    if (widget.diary != null && widget.diary!.content.isNotEmpty) {
      try {
        final doc = quill.Document.fromJson(jsonDecode(widget.diary!.content));
        _quillController = quill.QuillController(document: doc, selection: const TextSelection.collapsed(offset: 0));
      } catch (e) {
        _quillController = quill.QuillController.basic();
      }
    } else {
      _quillController = quill.QuillController.basic();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  // ✅ 核心修复：保存逻辑
  Future<void> _saveDiary() async {
    final l10n = AppLocalizations.of(context)!;
    final contentJson = jsonEncode(_quillController.document.toDelta().toJson());
    final plainText = _quillController.document.toPlainText().trim();

    if (plainText.isEmpty && _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pleaseEnterContent)));
      return;
    }

    // 1. 处理图片持久化
    List<String> finalImagePaths = [];
    final appDir = await getApplicationDocumentsDirectory();

    for (String imgPath in _selectedImages) {
      final file = File(imgPath);
      if (await file.exists()) {
        if (path.isWithin(appDir.path, imgPath)) {
          finalImagePaths.add(imgPath); // 已在沙盒中
        } else {
          // 复制到沙盒
          final fileName = path.basename(imgPath);
          final newPath = '${appDir.path}/$fileName';
          await file.copy(newPath);
          finalImagePaths.add(newPath);
        }
      }
    }

    // 2. 创建对象 (✅ 修复参数报错)
    final newDiary = DiaryEntry(
      id: widget.diary?.id,
      title: _titleController.text.isEmpty ? '无标题' : _titleController.text,
      content: contentJson,
      date: _selectedDate,
      mood: _selectedMood,
      weather: _selectedWeather, // ✅ 补上 weather
      tags: _selectedTags,
      images: finalImagePaths,   // ✅ 补上 images
      // isSynced: false,        // ❌ 删除 model 中不存在的 isSynced
    );

    // 3. 写入数据库 (✅ 修正方法名为 insertDiary)
    if (widget.diary == null) {
      await DatabaseHelper.instance.insertDiary(newDiary); // ✅ 用 insertDiary
    } else {
      await DatabaseHelper.instance.updateDiary(newDiary);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.diary == null ? l10n.saveButton : '更新成功')) // 这里简单用 saveButton 代替提示，也可加新词条
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 9) return;
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _selectedImages.add(image.path));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final secondaryColor = theme.brightness == Brightness.dark ? Colors.white70 : AppColors.textSecondaryLight;

    String getWeatherName(int index) {
      switch (index) {
        case 0: return l10n.weatherSunny;    // 晴天
        case 1: return l10n.weatherCloudy;   // 多云
        case 2: return l10n.weatherRainy;    // 雨天
        case 3: return l10n.weatherSnowy;    // 雪天
        case 4: return l10n.weatherThunder;  // 雷雨
        case 5: return l10n.weatherWindy;    // 大风
        default: return l10n.weatherLabel;   // 默认显示 "天气"
      }
    }

    // 动态翻译标签 (如果标签不在列表里则原样显示)
    String getLocalizedTag(String tag) {
      if (tag == 'Life') return l10n.tagLife;
      if (tag == 'Work') return l10n.tagWork;
      if (tag == 'Travel') return l10n.tagTravel;
      if (tag == 'Mood') return l10n.tagMood;
      if (tag == 'Food') return l10n.tagFood;
      if (tag == 'Study') return l10n.tagStudy;
      // 兼容中文旧标签
      if (tag == '生活') return l10n.tagLife;
      if (tag == '工作') return l10n.tagWork;
      if (tag == '旅行') return l10n.tagTravel;
      if (tag == '心情') return l10n.tagMood;
      if (tag == '美食') return l10n.tagFood;
      if (tag == '学习') return l10n.tagStudy;
      return tag;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.diary == null ? l10n.newDiaryTitle : l10n.editDiaryTitle),
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
            child: Text(l10n.saveButton, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          // 工具栏动画容器
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showToolbar ? 60 : 0,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: quill.QuillSimpleToolbar(
                configurations: quill.QuillSimpleToolbarConfigurations(
                  controller: _quillController, // ✅ v9 写法
                  showFontFamily: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showSmallButton: false,
                  showSearchButton: false,
                  buttonOptions: quill.QuillSimpleToolbarButtonOptions(
                    base: quill.QuillToolbarBaseButtonOptions(
                      iconTheme: quill.QuillIconTheme(
                        iconButtonSelectedData: quill.IconButtonData(color: theme.primaryColor),
                        iconButtonUnselectedData: quill.IconButtonData(color: secondaryColor),
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
                  // 标题输入
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: l10n.titleHint,
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 22, color: theme.hintColor),
                    ),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  // 图片横向展示
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
                                        File(_selectedImages[index]),
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

                  // 属性选择区 (日期、心情、天气、标签)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: _pickDate,
                              child: Row(children: [
                                Icon(Icons.calendar_today, size: 20, color: theme.primaryColor),
                                const SizedBox(width: 6),
                                Text(DateFormat('yyyy-MM-dd').format(_selectedDate), style: TextStyle(color: secondaryColor)),
                              ]),
                            ),
                            const SizedBox(width: 24),
                            // 心情选择
                            _buildSelector(context, _moodIcons[_selectedMood], l10n.moodLabel,
                                    () => _showIconPicker(l10n.moodLabel, _moodIcons, (i) => setState(() => _selectedMood = i))),
                            const SizedBox(width: 24),
                            // 天气选择 (这里暂时简单用“天气”二字，您可以在 arb 加 key)
                            _buildSelector(
                                context,
                                _weatherIcons[_selectedWeather],
                                getWeatherName(_selectedWeather), // <--- ✅ 这里改成调用刚才定义的函数
                                    () => _showIconPicker(l10n.weatherLabel, _weatherIcons, (i) => setState(() => _selectedWeather = i))
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ..._selectedTags.map((tag) => Chip(
                              label: Text(getLocalizedTag(tag), style: const TextStyle(fontSize: 12)),
                              onDeleted: () => setState(() => _selectedTags.remove(tag)),
                              deleteIcon: const Icon(Icons.close, size: 14),
                              backgroundColor: theme.primaryColor.withOpacity(0.1),
                            )),
                            ActionChip(
                              avatar: const Icon(Icons.image_outlined, size: 16),
                              label: const Text('Add Img'), // 可在 arb 加 imageBtn
                              onPressed: _pickImage,
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.add, size: 16),
                              label: Text(l10n.tagsLabel),
                              onPressed: _showTagPicker,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  // 编辑器区域
                  Container(
                    constraints: const BoxConstraints(minHeight: 300),
                    child: quill.QuillEditor.basic(
                      configurations: quill.QuillEditorConfigurations(
                        // ❌ 删除 focusNode: _editorFocusNode,
                        // 让 Quill 内部自己管理焦点，通常能解决问题且不影响使用
                        controller: _quillController,
                        placeholder: l10n.contentHint,
                        padding: EdgeInsets.zero,
                        sharedConfigurations: const quill.QuillSharedConfigurations(
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

  // 辅助方法：构建选择器
  Widget _buildSelector(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    final theme = Theme.of(context);
    final secondaryColor = theme.brightness == Brightness.dark ? Colors.white70 : AppColors.textSecondaryLight;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(children: [
          Icon(icon, size: 22, color: theme.primaryColor),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: secondaryColor))
        ]),
      ),
    );
  }

  // 辅助方法：图标选择弹窗
  void _showIconPicker(String title, List<IconData> icons, Function(int) onSelected) {
    showModalBottomSheet(context: context, builder: (ctx) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: List.generate(icons.length, (i) => IconButton(
                icon: Icon(icons[i], size: 32, color: AppColors.primary),
                onPressed: () { onSelected(i); Navigator.pop(context); }
            ))
        ),
      );
    });
  }

  // 辅助方法：标签选择弹窗
  void _showTagPicker() {
    showModalBottomSheet(context: context, builder: (ctx) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
            spacing: 10,
            children: _availableTags.map((t) => ActionChip(
                label: Text(t),
                onPressed: () {
                  setState(() => _selectedTags.contains(t) ? null : _selectedTags.add(t));
                  Navigator.pop(context);
                }
            )).toList()
        ),
      );
    });
  }
}