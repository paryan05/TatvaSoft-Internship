import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../repositories/meal_repository.dart';
import '../../models/meal.dart';

class MealsListScreen extends StatefulWidget {
  const MealsListScreen({super.key});

  @override
  State<MealsListScreen> createState() => _MealsListScreenState();
}

class _MealsListScreenState extends State<MealsListScreen> {
  List<Meal> meals = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final app = context.read<AppProvider>();
    final auth = context.read<AuthProvider>();
    meals = await MealRepository(app.database, auth.userId).list();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meals'), actions: [
        IconButton(onPressed: () async {
          final created = await Navigator.push(context, MaterialPageRoute(builder: (_) => MealFormScreen()));
          if (created == true) _load();
        }, icon: const Icon(Icons.add))
      ]),
      body: ListView.separated(
        itemCount: meals.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final m = meals[i];
          return ListTile(
            title: Text(m.name),
            subtitle: Text('${m.calories} cal · P${m.proteinG}/C${m.carbsG}/F${m.fatG}')
,            trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () async {
              await context.read<AppProvider>().database.deleteMeal(m.id!);
              _load();
            }),
            onTap: () async {
              final updated = await Navigator.push(context, MaterialPageRoute(builder: (_) => MealFormScreen(meal: m)));
              if (updated == true) _load();
            },
          );
        },
      ),
    );
  }
}

class MealFormScreen extends StatefulWidget {
  final Meal? meal;
  MealFormScreen({super.key, this.meal});

  @override
  State<MealFormScreen> createState() => _MealFormScreenState();
}

class _MealFormScreenState extends State<MealFormScreen> {
  final _name = TextEditingController();
  final _calories = TextEditingController();
  final _protein = TextEditingController();
  final _carbs = TextEditingController();
  final _fat = TextEditingController();
  final _notes = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    final m = widget.meal;
    if (m != null) {
      _name.text = m.name;
      _calories.text = m.calories.toString();
      _protein.text = m.proteinG.toString();
      _carbs.text = m.carbsG.toString();
      _fat.text = m.fatG.toString();
      _notes.text = m.notes ?? '';
      _date = m.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.meal == null ? 'Add Meal' : 'Edit Meal')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: _calories, decoration: const InputDecoration(labelText: 'Calories'), keyboardType: TextInputType.number),
          TextField(controller: _protein, decoration: const InputDecoration(labelText: 'Protein (g)'), keyboardType: TextInputType.number),
          TextField(controller: _carbs, decoration: const InputDecoration(labelText: 'Carbs (g)'), keyboardType: TextInputType.number),
          TextField(controller: _fat, decoration: const InputDecoration(labelText: 'Fat (g)'), keyboardType: TextInputType.number),
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
            final m = Meal(
              id: widget.meal?.id,
              userId: auth.userId,
              name: _name.text.trim(),
              calories: int.tryParse(_calories.text) ?? 0,
              proteinG: int.tryParse(_protein.text) ?? 0,
              carbsG: int.tryParse(_carbs.text) ?? 0,
              fatG: int.tryParse(_fat.text) ?? 0,
              notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              date: _date,
              createdAt: widget.meal?.createdAt ?? DateTime.now(),
              updatedAt: DateTime.now(),
            );
            if (widget.meal == null) {
              await app.database.insertMeal(m);
            } else {
              await app.database.updateMeal(m);
            }
            if (mounted) Navigator.pop(context, true);
          }, child: const Text('Save')),
        ],
      ),
    );
  }
}
