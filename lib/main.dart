import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_workout_screen.dart';
import 'screens/edit_workout_screen.dart';
import 'screens/workout_details_screen.dart';
import 'screens/add_meal_screen.dart';
import 'screens/edit_meal_screen.dart';
import 'screens/summary_screen.dart';
import 'screens/progress_chart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/tips_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FitnessApp());
}

class FitnessApp extends StatefulWidget {
  const FitnessApp({super.key});

  @override
  State<FitnessApp> createState() => _FitnessAppState();
}

class _FitnessAppState extends State<FitnessApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('is_dark_theme');
    setState(() {
      _themeMode = isDark == null
          ? ThemeMode.system
          : (isDark ? ThemeMode.dark : ThemeMode.light);
    });
  }

  Future<void> _setTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_theme', isDark);
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      themeMode: _themeMode,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(onThemeChanged: _setTheme),
        AddWorkoutScreen.routeName: (context) => const AddWorkoutScreen(),
        EditWorkoutScreen.routeName: (context) => const EditWorkoutScreen(),
        WorkoutDetailsScreen.routeName: (context) => const WorkoutDetailsScreen(),
        AddMealScreen.routeName: (context) => const AddMealScreen(),
        EditMealScreen.routeName: (context) => const EditMealScreen(),
        SummaryScreen.routeName: (context) => const SummaryScreen(),
        ProgressChartScreen.routeName: (context) => const ProgressChartScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        TipsScreen.routeName: (context) => const TipsScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(onThemeChanged: _setTheme),
        AboutScreen.routeName: (context) => const AboutScreen(),
      },
    );
  }
}
