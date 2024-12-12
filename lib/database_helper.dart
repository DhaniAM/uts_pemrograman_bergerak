import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/password.dart';

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
          CREATE TABLE passwords(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            username TEXT,
            password TEXT)
            ''');
      },
      version: 1,
    );
  }

  // Create
  Future<void> insertPassword(Password password) async {
    final db = await database;
    await db.insert('password', password.toMap());
  }

  // Read
  Future<List<Password>> getPasswords() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('passwords');
    return List.generate(maps.length, (i) {
      return Password.fromMap(maps[i]);
    });
  }

  // Update
  Future<void> updatePassword(Password password) async {
    final db = await database;
    await db.update('passwords', password.toMap(), where: 'id = ?', whereArgs: [password.id]);
  }

  // Delete
  Future<void> deletePassword(int id) async {
    final db = await database;
    await db.delete(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
