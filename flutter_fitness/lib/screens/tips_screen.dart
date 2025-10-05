import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tips & Motivation')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Set realistic goals'),
            Text('• Consistency beats intensity'),
            Text('• Balanced meals and hydration'),
            Text('• Rest well'),
          ],
        ),
      ),
    );
  }
}
