import 'dart:convert';

class DiaryEntry {
  final int? id;             // 数据库自动生成的 ID
  final String title;        // 标题
  final String content;      // 富文本内容 (JSON 格式的字符串)
  final int mood;            // 心情索引
  final int weather;         // 天气索引
  final List<String> tags;   // 标签列表
  final DateTime date;       // 创建日期

  DiaryEntry({
    this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.weather,
    required this.tags,
    required this.date,
  });

  // 1. 将数据库读出的 Map 转换为模型对象
  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      mood: map['mood'],
      weather: map['weather'],
      tags: List<String>.from(jsonDecode(map['tags'])), // 将字符串转回列表
      date: DateTime.parse(map['date']),
    );
  }

  // 2. 将模型对象转换为存入数据库的 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mood': mood,
      'weather': weather,
      'tags': jsonEncode(tags), // 将列表转为字符串存储
      'date': date.toIso8601String(),
    };
  }
}