import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/app_provider.dart';
import '../repositories/workout_repository.dart';
import '../repositories/meal_repository.dart';
import '../models/workout.dart';
import '../models/meal.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int caloriesBurned = 0;
  int caloriesConsumed = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final app = context.read<AppProvider>();
    final auth = context.read<AuthProvider>();
    final workouts = await WorkoutRepository(app.database, auth.userId).list();
    final meals = await MealRepository(app.database, auth.userId).list();
    setState(() {
      caloriesBurned = workouts.fold(0, (s, w) => s + w.caloriesBurned);
      caloriesConsumed = meals.fold(0, (s, m) => s + m.calories);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(onPressed: () => Navigator.pushNamed(context, '/settings'), icon: const Icon(Icons.settings)),
          IconButton(onPressed: () { context.read<AuthProvider>().logout(); Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false); }, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, ${auth.userName}', style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 16),
            Row(
              children: [
                _stat('Consumed', caloriesConsumed, Colors.red),
                const SizedBox(width: 12),
                _stat('Burned', caloriesBurned, Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                FilledButton(onPressed: () => Navigator.pushNamed(context, '/workouts'), child: const Text('Workouts')),
                FilledButton(onPressed: () => Navigator.pushNamed(context, '/meals'), child: const Text('Meals')),
                FilledButton(onPressed: () => Navigator.pushNamed(context, '/progress'), child: const Text('Progress')),
                FilledButton(onPressed: () => Navigator.pushNamed(context, '/profile'), child: const Text('Profile')),
                FilledButton(onPressed: () => Navigator.pushNamed(context, '/tips'), child: const Text('Tips')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, int value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(label),
              const SizedBox(height: 8),
              Text('$value', style: TextStyle(fontSize: 24, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
