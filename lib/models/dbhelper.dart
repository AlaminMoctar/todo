import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = 'todo.db';
  static final _databaseVersion = 1;
  static final tache = 'tasks';

  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._private();
  DatabaseHelper._private();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'todo.db');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        dueDate TEXT,
        status TEXT,
        priority TEXT
      )
    ''');
  }

  // Méthodes CRUD

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('tache', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query('tache');
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('tache', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete('tache', where: 'id = ?', whereArgs: [id]);
  }
}