import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';

class SummaryScreen extends StatefulWidget {
  static const String routeName = '/summary';
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _loading = true;
  int _totalWorkouts = 0;
  int _totalWorkoutMinutes = 0;
  int _totalCaloriesBurned = 0;
  int _totalMealCalories = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getInt('current_user_id');
    if (uid == null) {
      setState(() => _loading = false);
      return;
    }
    final db = DatabaseHelper.instance;
    final from = DateTime.now().subtract(const Duration(days: 7));
    final to = DateTime.now();
    final workouts = await db.getWorkoutsByUser(uid, from: from, to: to);
    final meals = await db.getMealsByUser(uid, from: from, to: to);
    setState(() {
      _totalWorkouts = workouts.length;
      _totalWorkoutMinutes = workouts.fold(0, (sum, w) => sum + (w['duration_minutes'] as int));
      _totalCaloriesBurned = workouts.fold(0, (sum, w) => sum + (w['calories_burned'] as int));
      _totalMealCalories = meals.fold(0, (sum, m) => sum + (m['calories'] as int));
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MMM d');
    final from = df.format(DateTime.now().subtract(const Duration(days: 7)));
    final to = df.format(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: const Text('Summary')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Range: $from – $to'),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: const Text('Workouts'),
                      subtitle: Text('$_totalWorkouts sessions, $_totalWorkoutMinutes min total'),
                      trailing: Text('$_totalCaloriesBurned kcal'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      title: const Text('Meals'),
                      subtitle: const Text('Total calorie intake'),
                      trailing: Text('$_totalMealCalories kcal'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _load,
                      child: const Text('Refresh'),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
