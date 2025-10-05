import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 16),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : FilledButton(
                    onPressed: () async {
                      setState(() { _loading = true; _error = null; });
                      final ok = await context.read<AuthProvider>().register(
                        _name.text.trim(), _email.text.trim(), _password.text,
                      );
                      setState(() { _loading = false; });
                      if (ok && mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (_) => false);
                      } else {
                        setState(() { _error = 'Email already registered'; });
                      }
                    },
                    child: const Text('Create account'),
                  ),
          ],
        ),
      ),
    );
  }
}
