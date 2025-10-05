import '../data/db/database.dart';
import '../models/meal.dart';

class MealRepository {
  final AppDatabase db;
  final int userId;
  MealRepository(this.db, this.userId);

  Future<List<Meal>> list() => db.listMeals(userId);
  Future<int> create(Meal m) => db.insertMeal(m);
  Future<int> update(Meal m) => db.updateMeal(m);
  Future<int> delete(int id) => db.deleteMeal(id);
}
