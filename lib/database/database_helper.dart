import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/password.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'password_manager.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            fullName TEXT,
            password TEXT)
            ''');
        await db.execute('''
          CREATE TABLE passwords(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            title TEXT,
            username TEXT,
            password TEXT,
            FOREIGN KEY(userId) REFERENCES users(userId))
            ''');
      },
      version: 1,
    );
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    try {
      return await db.insert('users', user.toMap());
    } catch (e) {
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getUserData(int id) async {
    final db = await database;
    try {
      return await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> loadPassword(int userId) async {
    final db = await database;
    return await db.query(
      'passwords',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // Password operations
  Future<int> insertPassword(Password password) async {
    final db = await database;
    try {
      return await db.insert('passwords', password.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<List<Password>> getPasswords() async {
    final db = await database;
    try {
      List<Map<String, dynamic>> maps = await db.query('passwords');
      return List.generate(maps.length, (i) {
        return Password.fromMap(maps[i]);
      });
    } catch (e) {
      return [];
    }
  }

  Future<int> updatePassword(Password password) async {
    final db = await database;
    try {
      return await db.update(
        'passwords',
        password.toMap(),
        where: 'id = ?',
        whereArgs: [password.id],
      );
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<int> deletePassword(int id) async {
    final db = await database;
    try {
      return await db.delete(
        'passwords',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return -1;
    }
  }

  Future login(String username, String password) async {
    final db = await database;
    final data = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return data.isNotEmpty ? data : null;
  }
}
