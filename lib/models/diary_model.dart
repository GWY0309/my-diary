class DiaryEntry {
  final int? id;
  final String title;
  final String content;
  final DateTime date;
  final int mood;
  final int weather;
  final List<String> tags;
  final List<String> images;

  // ✅ 新增：所属用户 ID
  final int? userId;

  DiaryEntry({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.mood,
    required this.weather,
    required this.tags,
    required this.images,
    this.userId, // ✅
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'mood': mood,
      'weather': weather,
      'tags': tags.join(','),
      'images': images.join(','),
      'userId': userId, // ✅ 保存时写入数据库
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      mood: map['mood'],
      weather: map['weather'],
      tags: map['tags'].toString().isEmpty ? [] : map['tags'].toString().split(','),
      images: map['images'].toString().isEmpty ? [] : map['images'].toString().split(','),
      userId: map['userId'], // ✅ 读取时获取
    );
  }
}