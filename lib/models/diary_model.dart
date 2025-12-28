import 'dart:convert';

class DiaryEntry {
  final int? id;
  final String title;
  final String content;
  final int mood;
  final int weather;
  final List<String> tags;
  final List<String> images; // 【新增】图片路径列表
  final DateTime date;

  DiaryEntry({
    this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.weather,
    required this.tags,
    required this.images, // 【新增】
    required this.date,
  });

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      mood: map['mood'],
      weather: map['weather'],
      tags: List<String>.from(jsonDecode(map['tags'])),
      // 【新增】解析图片，处理数据库旧数据可能为 null 的情况
      images: map['images'] != null
          ? List<String>.from(jsonDecode(map['images']))
          : [],
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mood': mood,
      'weather': weather,
      'tags': jsonEncode(tags),
      'images': jsonEncode(images), // 【新增】
      'date': date.toIso8601String(),
    };
  }
}