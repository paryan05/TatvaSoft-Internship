import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(documentsDir.path, 'fitness_app.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onConfigure: (db) async {
        // Ensure foreign key constraints are enforced
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        avatar_url TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE workouts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        duration_minutes INTEGER NOT NULL,
        calories_burned INTEGER NOT NULL,
        date TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        calories INTEGER NOT NULL,
        protein_grams INTEGER NOT NULL,
        carbs_grams INTEGER NOT NULL,
        fat_grams INTEGER NOT NULL,
        date TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('CREATE INDEX idx_workouts_user_date ON workouts(user_id, date)');
    await db.execute('CREATE INDEX idx_meals_user_date ON meals(user_id, date)');
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Place schema migrations here for future versions
  }

  // User CRUD
  Future<int> insertUser(Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert('users', values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query('users', where: 'email = ?', whereArgs: [email], limit: 1);
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<int> updateUser(int id, Map<String, dynamic> values) async {
    final db = await database;
    return await db.update('users', values, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Workout CRUD
  Future<int> insertWorkout(Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert('workouts', values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getWorkoutsByUser(int userId, {DateTime? from, DateTime? to}) async {
    final db = await database;
    final where = StringBuffer('user_id = ?');
    final args = <Object>[userId];
    if (from != null) {
      where.write(' AND date >= ?');
      args.add(from.toIso8601String());
    }
    if (to != null) {
      where.write(' AND date <= ?');
      args.add(to.toIso8601String());
    }
    return await db.query('workouts', where: where.toString(), whereArgs: args, orderBy: 'date DESC');
  }

  Future<Map<String, dynamic>?> getWorkoutById(int id) async {
    final db = await database;
    final result = await db.query('workouts', where: 'id = ?', whereArgs: [id], limit: 1);
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<int> updateWorkout(int id, Map<String, dynamic> values) async {
    final db = await database;
    return await db.update('workouts', values, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteWorkout(int id) async {
    final db = await database;
    return await db.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }

  // Meal CRUD
  Future<int> insertMeal(Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert('meals', values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getMealsByUser(int userId, {DateTime? from, DateTime? to}) async {
    final db = await database;
    final where = StringBuffer('user_id = ?');
    final args = <Object>[userId];
    if (from != null) {
      where.write(' AND date >= ?');
      args.add(from.toIso8601String());
    }
    if (to != null) {
      where.write(' AND date <= ?');
      args.add(to.toIso8601String());
    }
    return await db.query('meals', where: where.toString(), whereArgs: args, orderBy: 'date DESC');
  }

  Future<Map<String, dynamic>?> getMealById(int id) async {
    final db = await database;
    final result = await db.query('meals', where: 'id = ?', whereArgs: [id], limit: 1);
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<int> updateMeal(int id, Map<String, dynamic> values) async {
    final db = await database;
    return await db.update('meals', values, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteMeal(int id) async {
    final db = await database;
    return await db.delete('meals', where: 'id = ?', whereArgs: [id]);
  }
}
