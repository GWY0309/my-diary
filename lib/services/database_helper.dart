import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/diary_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('diary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE diaries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        mood INTEGER NOT NULL,
        weather INTEGER NOT NULL,
        tags TEXT NOT NULL,
        images TEXT,
        date TEXT NOT NULL
      )
    ''');
  }

  // 1. 基础 CRUD
  Future<int> insertDiary(DiaryEntry diary) async {
    final db = await instance.database;
    return await db.insert('diaries', diary.toMap());
  }

  Future<List<DiaryEntry>> getAllDiaries() async {
    final db = await instance.database;
    final result = await db.query('diaries', orderBy: 'date DESC');
    return result.map((json) => DiaryEntry.fromMap(json)).toList();
  }

  Future<int> deleteDiary(int id) async {
    final db = await instance.database;
    return await db.delete('diaries', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateDiary(DiaryEntry diary) async {
    final db = await instance.database;
    return await db.update(
      'diaries',
      diary.toMap(),
      where: 'id = ?',
      whereArgs: [diary.id],
    );
  }

  // === 【新增】统计相关查询 ===

  // 1. 获取日记总数
  Future<int> getDiaryCount() async {
    final db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM diaries')) ?? 0;
  }

  // 2. 获取近7天写作数量 (用于柱状图)
  // 返回一个长度为7的列表，索引0是6天前，索引6是今天
  Future<List<double>> getWeeklyStats() async {
    final db = await instance.database;
    List<double> stats = [];
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day); // 去掉时间部分

    for (int i = 6; i >= 0; i--) {
      DateTime targetDate = today.subtract(Duration(days: i));
      String dateStr = targetDate.toIso8601String().split('T')[0]; // 获取 "YYYY-MM-DD"

      // 查询该日期的记录数 (因为存的是 ISO 字符串，可以用 LIKE '2023-12-28%')
      final result = await db.rawQuery(
        "SELECT COUNT(*) as count FROM diaries WHERE date LIKE '$dateStr%'",
      );
      int count = Sqflite.firstIntValue(result) ?? 0;
      stats.add(count.toDouble());
    }
    return stats;
  }

  // 3. 获取心情统计 (用于饼图)
  // 返回 Map<心情索引, 数量>
  Future<Map<int, int>> getMoodStats() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      "SELECT mood, COUNT(*) as count FROM diaries GROUP BY mood",
    );

    Map<int, int> stats = {};
    // 初始化所有心情为0，防止饼图报错或缺失
    for (int i = 0; i < 5; i++) {
      stats[i] = 0;
    }

    for (var row in result) {
      stats[row['mood'] as int] = row['count'] as int;
    }
    return stats;
  }
}