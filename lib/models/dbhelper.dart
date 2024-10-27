import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = 'todo.db';
  static final _databaseVersion = 1;
  static final tache = 'tasks';

  // Singleton pattern pour garantir une seule instance de la classe
  static final DatabaseHelper instance = DatabaseHelper._private();
  DatabaseHelper._private();

  // Référence à la base de données
  static Database? _database;

// Méthode pour obtenir une instance de la base de données
  Future<Database> get database async {
    // Si la base de données existe déjà, la retourner directement
    if (_database != null) {
      return _database!;
    }

    // Sinon, initialiser la base de données
    _database = await _initDatabase();
    return _database!;
  }

  // Méthode d'initialisation de la base de données
  Future<Database> _initDatabase() async {
    // Récupérer le chemin du répertoire des bases de données
    final databasesPath = await getDatabasesPath();
    // Construire le chemin complet vers la base de données
    final path = join(databasesPath, 'todo.db');

    // Ouvrir la base de données et créer la table des tâches si elle n'existe pas
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Méthode de création de la table des tâches
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

  // Méthode pour insérer une nouvelle tâche dans la base de données
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('tache', row);
  }

  // Méthode pour récupérer toutes les tâches de la base de données
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query('tache');
  }

  // Méthode pour mettre à jour une tâche dans la base de données
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('tache', row, where: 'id = ?', whereArgs: [id]);
  }

  // Méthode pour supprimer une tâche de la base de données
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete('tache', where: 'id = ?', whereArgs: [id]);
  }
}