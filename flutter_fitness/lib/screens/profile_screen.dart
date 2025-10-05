import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _name = TextEditingController();
  final _goal = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.text = context.read<AuthProvider>().userName;
    _goal.text = '2000';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _goal, decoration: const InputDecoration(labelText: 'Daily Calorie Goal'), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            FilledButton(onPressed: () async {
              final auth = context.read<AuthProvider>();
              final app = context.read<AppProvider>();
              final rows = await app.database.raw.query('users', where: 'id = ?', whereArgs: [auth.userId]);
              if (rows.isNotEmpty) {
                final user = User.fromMap(rows.first);
                final updated = User(
                  id: user.id,
                  email: user.email,
                  password: user.password,
                  name: _name.text.trim(),
                  dailyCalorieGoal: int.tryParse(_goal.text) ?? user.dailyCalorieGoal,
                );
                await app.database.updateUser(updated);
              }
              if (mounted) Navigator.pop(context);
            }, child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
