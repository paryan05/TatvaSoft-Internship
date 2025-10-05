import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/workout_model.dart';

class EditWorkoutScreen extends StatefulWidget {
  static const String routeName = '/workout/edit';
  const EditWorkoutScreen({super.key});

  @override
  State<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  DateTime _date = DateTime.now();
  final TextEditingController _notesController = TextEditingController();
  bool _saving = false;
  WorkoutModel? _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is WorkoutModel && _model == null) {
      _model = arg;
      _titleController.text = arg.title;
      _typeController.text = arg.type;
      _durationController.text = arg.durationMinutes.toString();
      _caloriesController.text = arg.caloriesBurned.toString();
      _date = arg.date;
      _notesController.text = arg.notes ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_model == null) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final updated = _model!.copyWith(
        title: _titleController.text.trim(),
        type: _typeController.text.trim(),
        durationMinutes: int.parse(_durationController.text.trim()),
        caloriesBurned: int.parse(_caloriesController.text.trim()),
        date: _date,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
      await DatabaseHelper.instance.updateWorkout(updated.id!, updated.toMap());
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Workout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Type')
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
              validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Enter minutes' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _caloriesController,
              decoration: const InputDecoration(labelText: 'Calories burned'),
              keyboardType: TextInputType.number,
              validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Enter calories' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(_date.toLocal().toString().split(' ').first),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving ? const CircularProgressIndicator() : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
