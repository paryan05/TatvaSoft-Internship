import 'package:flutter/material.dart';
import '../data/db/database.dart';
import 'app_provider.dart';

class AuthProvider extends ChangeNotifier {
  final AppProvider app;
  AuthProvider(this.app);

  int? _userId;
  String? _userName;

  bool get isAuthenticated => _userId != null;
  int get userId => _userId!;
  String get userName => _userName ?? 'User';

  Future<bool> login(String email, String password) async {
    final db = app.database;
    final user = await db.getUserByEmail(email);
    if (user != null && user.password == password) {
      _userId = user.id;
      _userName = user.name;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    final existing = await app.database.getUserByEmail(email);
    if (existing != null) return false;
    final id = await app.database.insertUser(name: name, email: email, password: password);
    _userId = id;
    _userName = name;
    notifyListeners();
    return true;
  }

  void logout() {
    _userId = null;
    _userName = null;
    notifyListeners();
  }
}
