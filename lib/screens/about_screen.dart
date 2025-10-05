import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const String routeName = '/about';
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Fitness App\n\nA simple fitness tracker built with Flutter and SQLite.\nTrack workouts and meals, view summaries and progress charts, and manage your profile.',
        ),
      ),
    );
  }
}
