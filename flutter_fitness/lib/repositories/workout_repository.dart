import '../data/db/database.dart';
import '../models/workout.dart';

class WorkoutRepository {
  final AppDatabase db;
  final int userId;
  WorkoutRepository(this.db, this.userId);

  Future<List<Workout>> list() => db.listWorkouts(userId);
  Future<int> create(Workout w) => db.insertWorkout(w);
  Future<int> update(Workout w) => db.updateWorkout(w);
  Future<int> delete(int id) => db.deleteWorkout(id);
}
