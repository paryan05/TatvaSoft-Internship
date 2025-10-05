import 'package:flutter/material.dart';
import '../models/workout_model.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutModel workout;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const WorkoutCard({super.key, required this.workout, this.onTap, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(workout.title),
        subtitle: Text('${workout.type} • ${workout.durationMinutes} min • ${workout.caloriesBurned} kcal'),
        onTap: onTap,
        trailing: onEdit == null ? null : IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
      ),
    );
  }
}
