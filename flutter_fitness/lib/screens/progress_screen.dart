import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SvgPicture.asset('assets/progress.svg'),
        ),
      ),
    );
  }
}
