import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/workout_model.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  static const String routeName = '/workout/details';
  const WorkoutDetailsScreen({super.key});

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  WorkoutModel? _workout;
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is int) {
      _load(arg);
    }
  }

  Future<void> _load(int id) async {
    setState(() => _loading = true);
    final map = await DatabaseHelper.instance.getWorkoutById(id);
    setState(() {
      _workout = map == null ? null : WorkoutModel.fromMap(map);
      _loading = false;
    });
  }

  Future<void> _delete() async {
    if (_workout == null || _workout!.id == null) return;
    await DatabaseHelper.instance.deleteWorkout(_workout!.id!);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
        actions: [
          IconButton(onPressed: _delete, icon: const Icon(Icons.delete))
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _workout == null
              ? const Center(child: Text('Not found'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_workout!.title, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text('${_workout!.type} • ${_workout!.durationMinutes} min • ${_workout!.caloriesBurned} kcal'),
                      const SizedBox(height: 8),
                      Text('Date: ${_workout!.date.toLocal().toString().split(' ').first}')
                    ],
                  ),
                ),
    );
  }
}
