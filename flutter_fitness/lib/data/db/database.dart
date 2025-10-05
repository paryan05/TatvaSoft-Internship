import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/user.dart';
import '../../models/workout.dart';
import '../../models/meal.dart';

class AppDatabase {
  static const _dbName = 'fitness.sqlite3';
  static const _dbVersion = 1;

  late final Database _db;

  Database get raw => _db;

  static Future<AppDatabase> open() async {
    final documents = await getApplicationDocumentsDirectory();
    final dbPath = p.join(documents.path, _dbName);
    final db = await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  name TEXT NOT NULL,
  daily_calorie_goal INTEGER NOT NULL DEFAULT 2000
);
''');
        await db.execute('''
CREATE TABLE workouts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  type TEXT NOT NULL,
  duration_min INTEGER NOT NULL,
  calories_burned INTEGER NOT NULL DEFAULT 0,
  notes TEXT,
  date TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);
''');
        await db.execute('''
CREATE TABLE meals (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  calories INTEGER NOT NULL,
  protein_g INTEGER NOT NULL DEFAULT 0,
  carbs_g INTEGER NOT NULL DEFAULT 0,
  fat_g INTEGER NOT NULL DEFAULT 0,
  notes TEXT,
  date TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);
''');
      },
    );
    final wrapper = AppDatabase._(db);
    return wrapper;
  }

  AppDatabase._(this._db);

  // User methods
  Future<User?> getUserByEmail(String email) async {
    final rows = await _db.query('users', where: 'email = ?', whereArgs: [email]);
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
    }

  Future<int> insertUser({required String name, required String email, required String password}) async {
    return _db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
      'daily_calorie_goal': 2000,
    });
  }

  Future<int> updateUser(User user) => _db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);

  // Workout methods
  Future<List<Workout>> listWorkouts(int userId) async {
    final rows = await _db.query('workouts', where: 'user_id = ?', whereArgs: [userId], orderBy: 'date DESC, created_at DESC');
    return rows.map(Workout.fromMap).toList();
  }

  Future<int> insertWorkout(Workout workout) => _db.insert('workouts', workout.toMap());
  Future<int> updateWorkout(Workout workout) => _db.update('workouts', workout.toMap(), where: 'id = ?', whereArgs: [workout.id]);
  Future<int> deleteWorkout(int id) => _db.delete('workouts', where: 'id = ?', whereArgs: [id]);

  // Meal methods
  Future<List<Meal>> listMeals(int userId) async {
    final rows = await _db.query('meals', where: 'user_id = ?', whereArgs: [userId], orderBy: 'date DESC, created_at DESC');
    return rows.map(Meal.fromMap).toList();
  }

  Future<int> insertMeal(Meal meal) => _db.insert('meals', meal.toMap());
  Future<int> updateMeal(Meal meal) => _db.update('meals', meal.toMap(), where: 'id = ?', whereArgs: [meal.id]);
  Future<int> deleteMeal(int id) => _db.delete('meals', where: 'id = ?', whereArgs: [id]);
}
