import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _loading = true;

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
    final userMap = await DatabaseHelper.instance.getUserById(uid);
    setState(() {
      _user = userMap == null ? null : UserModel.fromMap(userMap);
      _loading = false;
    });
  }

  Future<void> _saveName() async {
    final controller = TextEditingController(text: _user?.name ?? '');
    final value = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(controller.text.trim()), child: const Text('Save')),
        ],
      ),
    );
    if (value != null && value.isNotEmpty && _user?.id != null) {
      await DatabaseHelper.instance.updateUser(_user!.id!, {'name': value});
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(child: Text('No user'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(radius: 40, child: Text(_user!.name.substring(0, 1).toUpperCase())),
                      const SizedBox(height: 12),
                      Text(_user!.name, style: Theme.of(context).textTheme.titleLarge),
                      Text(_user!.email, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: _saveName, child: const Text('Edit Name')),
                    ],
                  ),
                ),
    );
  }
}
