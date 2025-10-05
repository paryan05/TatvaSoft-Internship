import 'package:flutter/material.dart';
import '../data/db/database.dart';

class AppProvider extends ChangeNotifier {
  late final AppDatabase database;
  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    database = await AppDatabase.open();
    _initialized = true;
    notifyListeners();
  }
}
