import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthRole { user, worker }

class AuthProvider with ChangeNotifier {
  AuthProvider() {
    _loadFromPrefs();
  }

  static const String keyRole = 'auth_role';
  static const String _keyPhone = 'auth_phone';

  AuthRole? _role;
  String _phone = '';

  AuthRole? get role => _role;
  String get phone => _phone;
  bool get isLoggedIn => _role != null;
  bool get isUser => _role == AuthRole.user;
  bool get isWorker => _role == AuthRole.worker;

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final roleIndex = prefs.getInt(keyRole);
    _role = roleIndex != null ? AuthRole.values[roleIndex] : null;
    _phone = prefs.getString(_keyPhone) ?? '';
    notifyListeners();
  }

  Future<void> login(AuthRole role, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyRole, role.index);
    await prefs.setString(_keyPhone, phone);
    _role = role;
    _phone = phone;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyRole);
    await prefs.remove(_keyPhone);
    _role = null;
    _phone = '';
    notifyListeners();
  }
}
