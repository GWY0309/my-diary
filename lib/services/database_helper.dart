import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import '../models/diary_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // ✅ 1. 升级版本号为 3
  static const _databaseName = "my_diary.db";
  static const _databaseVersion = 3;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // 创建表
  Future _onCreate(Database db, int version) async {
    // 日记表
    await db.execute('''
      CREATE TABLE diaries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        date TEXT,
        mood INTEGER,
        weather INTEGER,
        tags TEXT,
        images TEXT,
        userId INTEGER  -- ✅ 必须有这个字段
      )
    ''');

    // 用户表
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  // 升级表
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT UNIQUE, password TEXT)');
    }
    if (oldVersion < 3) {
      // ✅ 补加 userId 字段
      try {
        await db.execute('ALTER TABLE diaries ADD COLUMN userId INTEGER');
      } catch (e) {
        print("Column userId might already exist");
      }
    }
  }

  // ================= 用户相关 =================

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> registerUser(String email, String password) async {
    final db = await instance.database;
    try {
      await db.insert('users', {
        'email': email,
        'password': _hashPassword(password),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, _hashPassword(password)],
    );
    return maps.isNotEmpty;
  }

  Future<bool> isEmailExist(String email) async {
    final db = await instance.database;
    final result = await db.query('users', where: 'email = ?', whereArgs: [email]);
    return result.isNotEmpty;
  }

  // ✅ 获取用户 ID (登录成功后调用)
  Future<int?> getUserId(String email) async {
    final db = await instance.database;
    final result = await db.query('users', columns: ['id'], where: 'email = ?', whereArgs: [email]);
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }
    return null;
  }

  // ================= 日记相关 (带数据隔离) =================

  Future<int> insertDiary(DiaryEntry diary) async {
    final db = await instance.database;
    return await db.insert('diaries', diary.toMap());
  }

  // ✅ 查：只查该 userId 的数据
  Future<List<DiaryEntry>> getDiaries(int userId) async {
    final db = await instance.database;
    final maps = await db.query(
      'diaries',
      where: 'userId = ?', // 过滤条件
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return maps.map((json) => DiaryEntry.fromMap(json)).toList();
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

  Future<int> deleteDiary(int id) async {
    final db = await instance.database;
    return await db.delete('diaries', where: 'id = ?', whereArgs: [id]);
  }

  // ================= 统计相关 (带数据隔离) =================

  Future<int> getDiaryCount(int userId) async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM diaries WHERE userId = ?', [userId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<double>> getWeeklyStats(int userId) async {
    final db = await instance.database;
    List<double> stats = List.filled(7, 0);
    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final targetDate = now.subtract(Duration(days: 6 - i));
      final dateStr = targetDate.toIso8601String().substring(0, 10);

      final result = await db.rawQuery(
          "SELECT COUNT(*) as count FROM diaries WHERE date LIKE '$dateStr%' AND userId = ?",
          [userId]
      );
      stats[i] = (Sqflite.firstIntValue(result) ?? 0).toDouble();
    }
    return stats;
  }

  Future<Map<int, int>> getMoodStats(int userId) async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT mood, COUNT(*) as count FROM diaries WHERE userId = ? GROUP BY mood',
        [userId]
    );

    Map<int, int> moodMap = {};
    for (var row in result) {
      moodMap[row['mood'] as int] = row['count'] as int;
    }
    return moodMap;
  }
}