import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthRole { user, worker }

class AuthProvider with ChangeNotifier {
  AuthProvider() {
    _loadFromPrefs();
  }

  static const String keyRole = 'auth_role';
  static const String _keyPhone = 'auth_phone';
  static const String keyProfileCreated = 'profile_created';
  static const String _keyUserName = 'user_name';

  AuthRole? _role;
  String _phone = '';
  bool _profileCreated = false;
  String _userName = '';

  AuthRole? get role => _role;
  String get phone => _phone;
  bool get profileCreated => _profileCreated;
  String get userName => _userName;
  bool get isLoggedIn => _role != null;
  bool get isUser => _role == AuthRole.user;
  bool get isWorker => _role == AuthRole.worker;

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final roleIndex = prefs.getInt(keyRole);
    _role = roleIndex != null ? AuthRole.values[roleIndex] : null;
    _phone = prefs.getString(_keyPhone) ?? '';
    _profileCreated = prefs.getBool(keyProfileCreated) ?? false;
    _userName = prefs.getString(_keyUserName) ?? '';
    notifyListeners();
  }

  Future<void> login(AuthRole role, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyRole, role.index);
    await prefs.setString(_keyPhone, phone);
    _role = role;
    _phone = phone;
    _profileCreated = false;
    _userName = '';
    await prefs.remove(keyProfileCreated);
    await prefs.remove(_keyUserName);
    notifyListeners();
  }

  Future<void> setProfileCreated(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyProfileCreated, true);
    await prefs.setString(_keyUserName, name.trim());
    _profileCreated = true;
    _userName = name.trim();
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyRole);
    await prefs.remove(_keyPhone);
    await prefs.remove(keyProfileCreated);
    await prefs.remove(_keyUserName);
    _role = null;
    _phone = '';
    _profileCreated = false;
    _userName = '';
    notifyListeners();
  }
}
