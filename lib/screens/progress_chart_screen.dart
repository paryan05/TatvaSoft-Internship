import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';

class ProgressChartScreen extends StatefulWidget {
  static const String routeName = '/progress';
  const ProgressChartScreen({super.key});

  @override
  State<ProgressChartScreen> createState() => _ProgressChartScreenState();
}

class _ProgressChartScreenState extends State<ProgressChartScreen> {
  bool _loading = true;
  List<FlSpot> _calorieBurnSpots = [];

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
    final db = DatabaseHelper.instance;
    final from = DateTime.now().subtract(const Duration(days: 14));
    final to = DateTime.now();
    final workouts = await db.getWorkoutsByUser(uid, from: from, to: to);
    workouts.sort((a, b) => (a['date'] as String).compareTo(b['date'] as String));

    final points = <FlSpot>[];
    for (int i = 0; i < workouts.length; i++) {
      final dayIndex = i.toDouble();
      final calories = (workouts[i]['calories_burned'] as int).toDouble();
      points.add(FlSpot(dayIndex, calories));
    }

    setState(() {
      _calorieBurnSpots = points;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress Charts')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: LineChart(
                LineChartData(
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      spots: _calorieBurnSpots,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _load,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
