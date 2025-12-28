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

  // 初始化数据库并创建表
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
    // SQL 语句：创建日记表
    await db.execute('''
      CREATE TABLE diaries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        mood INTEGER NOT NULL,
        weather INTEGER NOT NULL,
        tags TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  // 插入日记
  Future<int> insertDiary(DiaryEntry diary) async {
    final db = await instance.database;
    return await db.insert('diaries', diary.toMap());
  }

  // 查询所有日记（按日期倒序）
  Future<List<DiaryEntry>> getAllDiaries() async {
    final db = await instance.database;
    final result = await db.query('diaries', orderBy: 'date DESC');
    return result.map((json) => DiaryEntry.fromMap(json)).toList();
  }

  // 删除日记
  Future<int> deleteDiary(int id) async {
    final db = await instance.database;
    return await db.delete('diaries', where: 'id = ?', whereArgs: [id]);
  }

  // 更新日记
  Future<int> updateDiary(DiaryEntry diary) async {
    final db = await instance.database;
    return await db.update(
      'diaries',
      diary.toMap(),
      where: 'id = ?', // 根据 ID 找到那条日记
      whereArgs: [diary.id],
    );
  }
}