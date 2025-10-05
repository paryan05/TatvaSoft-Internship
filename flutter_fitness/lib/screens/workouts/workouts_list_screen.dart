import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../repositories/workout_repository.dart';
import '../../models/workout.dart';

class WorkoutsListScreen extends StatefulWidget {
  const WorkoutsListScreen({super.key});

  @override
  State<WorkoutsListScreen> createState() => _WorkoutsListScreenState();
}

class _WorkoutsListScreenState extends State<WorkoutsListScreen> {
  List<Workout> workouts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final app = context.read<AppProvider>();
    final auth = context.read<AuthProvider>();
    workouts = await WorkoutRepository(app.database, auth.userId).list();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts'), actions: [
        IconButton(onPressed: () async {
          final created = await Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutFormScreen()));
          if (created == true) _load();
        }, icon: const Icon(Icons.add))
      ]),
      body: ListView.separated(
        itemCount: workouts.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final w = workouts[i];
          return ListTile(
            title: Text(w.title),
            subtitle: Text('${w.type} · ${w.durationMin} min · ${w.caloriesBurned} cal'),
            trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () async {
              await context.read<AppProvider>().database.deleteWorkout(w.id!);
              _load();
            }),
            onTap: () async {
              final updated = await Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutFormScreen(workout: w)));
              if (updated == true) _load();
            },
          );
        },
      ),
    );
  }
}

class WorkoutFormScreen extends StatefulWidget {
  final Workout? workout;
  WorkoutFormScreen({super.key, this.workout});

  @override
  State<WorkoutFormScreen> createState() => _WorkoutFormScreenState();
}

class _WorkoutFormScreenState extends State<WorkoutFormScreen> {
  final _title = TextEditingController();
  final _type = TextEditingController();
  final _duration = TextEditingController();
  final _calories = TextEditingController();
  final _notes = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    final w = widget.workout;
    if (w != null) {
      _title.text = w.title;
      _type.text = w.type;
      _duration.text = w.durationMin.toString();
      _calories.text = w.caloriesBurned.toString();
      _notes.text = w.notes ?? '';
      _date = w.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.workout == null ? 'Add Workout' : 'Edit Workout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          TextField(controller: _type, decoration: const InputDecoration(labelText: 'Type')),
          TextField(controller: _duration, decoration: const InputDecoration(labelText: 'Duration (min)'), keyboardType: TextInputType.number),
          TextField(controller: _calories, decoration: const InputDecoration(labelText: 'Calories burned'), keyboardType: TextInputType.number),
          TextField(controller: _notes, decoration: const InputDecoration(labelText: 'Notes')),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('${_date.toLocal()}'.split(' ')[0]),
              const SizedBox(width: 12),
              OutlinedButton(onPressed: () async {
                final picked = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2100), initialDate: _date);
                if (picked != null) setState(() => _date = picked);
              }, child: const Text('Pick date')),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: () async {
            final app = context.read<AppProvider>();
            final auth = context.read<AuthProvider>();
            final w = Workout(
              id: widget.workout?.id,
              userId: auth.userId,
              title: _title.text.trim(),
              type: _type.text.trim(),
              durationMin: int.tryParse(_duration.text) ?? 0,
              caloriesBurned: int.tryParse(_calories.text) ?? 0,
              notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              date: _date,
              createdAt: widget.workout?.createdAt ?? DateTime.now(),
              updatedAt: DateTime.now(),
            );
            if (widget.workout == null) {
              await app.database.insertWorkout(w);
            } else {
              await app.database.updateWorkout(w);
            }
            if (mounted) Navigator.pop(context, true);
          }, child: const Text('Save')),
        ],
      ),
    );
  }
}
