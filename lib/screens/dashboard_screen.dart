import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';
import '../models/workout_model.dart';
import '../models/meal_model.dart';
import 'add_workout_screen.dart';
import 'edit_workout_screen.dart';
import 'workout_details_screen.dart';
import 'add_meal_screen.dart';
import 'edit_meal_screen.dart';
import 'summary_screen.dart';
import 'progress_chart_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'tips_screen.dart';
import 'about_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = '/dashboard';
  final Future<void> Function(bool isDark) onThemeChanged;
  const DashboardScreen({super.key, required this.onThemeChanged});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int? _userId;
  bool _loading = true;
  List<WorkoutModel> _workouts = [];
  List<MealModel> _meals = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getInt('current_user_id');
    if (uid == null) {
      setState(() {
        _loading = false;
      });
      return;
    }
    final db = DatabaseHelper.instance;
    final workoutsMaps = await db.getWorkoutsByUser(uid);
    final mealsMaps = await db.getMealsByUser(uid);
    setState(() {
      _userId = uid;
      _workouts = workoutsMaps.map((m) => WorkoutModel.fromMap(m)).toList();
      _meals = mealsMaps.map((m) => MealModel.fromMap(m)).toList();
      _loading = false;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');
    if (!mounted) return;
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'summary':
                  Navigator.of(context).pushNamed(SummaryScreen.routeName);
                  break;
                case 'progress':
                  Navigator.of(context).pushNamed(ProgressChartScreen.routeName);
                  break;
                case 'profile':
                  Navigator.of(context).pushNamed(ProfileScreen.routeName);
                  break;
                case 'settings':
                  Navigator.of(context).pushNamed(SettingsScreen.routeName);
                  break;
                case 'tips':
                  Navigator.of(context).pushNamed(TipsScreen.routeName);
                  break;
                case 'about':
                  Navigator.of(context).pushNamed(AboutScreen.routeName);
                  break;
                case 'logout':
                  await _logout();
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'summary', child: Text('Summary')),
              PopupMenuItem(value: 'progress', child: Text('Progress Charts')),
              PopupMenuItem(value: 'profile', child: Text('Profile')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'tips', child: Text('Tips')),
              PopupMenuItem(value: 'about', child: Text('About')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Workouts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushNamed(AddWorkoutScreen.routeName).then((_) => _loadData()),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  ..._workouts.take(5).map((w) => ListTile(
                        title: Text(w.title),
                        subtitle: Text('${w.type} • ${w.durationMinutes} min • ${w.caloriesBurned} kcal'),
                        onTap: () => Navigator.of(context).pushNamed(WorkoutDetailsScreen.routeName, arguments: w.id).then((_) => _loadData()),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => Navigator.of(context).pushNamed(EditWorkoutScreen.routeName, arguments: w).then((_) => _loadData()),
                        ),
                      )),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Meals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushNamed(AddMealScreen.routeName).then((_) => _loadData()),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  ..._meals.take(5).map((m) => ListTile(
                        title: Text(m.name),
                        subtitle: Text('${m.calories} kcal • P${m.proteinGrams}/C${m.carbsGrams}/F${m.fatGrams}')
                      )),
                ],
              ),
            ),
    );
  }
}
