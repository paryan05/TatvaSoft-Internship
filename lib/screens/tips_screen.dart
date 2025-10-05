import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  static const String routeName = '/tips';
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const tips = [
      'Stay hydrated before, during, and after workouts.',
      'Prioritize sleep for recovery and performance.',
      'Balance strength, cardio, and mobility training.',
      'Track your progress to stay motivated.',
      'Consistent small steps beat occasional big pushes.'
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Tips')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.check_circle_outline),
          title: Text(tips[index]),
        ),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: tips.length,
      ),
    );
  }
}
