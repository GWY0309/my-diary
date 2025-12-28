import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'diary_edit_screen.dart'; // 确保该文件已创建

class DiaryListScreen extends StatelessWidget {
  const DiaryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight, // 使用文档定义的浅灰色背景
      appBar: AppBar(
        title: const Text('我的日记', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16), // 页面边距 16dp
        itemCount: 3, // 暂时放3个模拟数据
        itemBuilder: (context, index) {
          return const DiaryCard();
        },
      ),
      // 按照文档要求的悬浮按钮
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DiaryEditScreen()),
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
      // 修复此处：使用 EdgeInsets.only 来指定底部边距
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // 文档要求的16dp圆角
      child: const ListTile(
        contentPadding: EdgeInsets.all(16), // 元素内边距 16dp
        title: Text('今天项目开工了！', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text('终于开始写前端 UI 了，进展很顺利...', maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        trailing: Icon(Icons.wb_sunny, color: AppColors.warning), // 天气图标
      ),
    );
  }
}