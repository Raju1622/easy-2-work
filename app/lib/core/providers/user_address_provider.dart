import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyAddress = 'user_saved_address';

/// User ka saved address – profile se add/edit, booking par use hota hai, worker ko dikhta hai
class UserAddressProvider with ChangeNotifier {
  UserAddressProvider() {
    _loadFromPrefs();
  }

  String _address = '';

  String get address => _address;
  bool get hasAddress => _address.trim().isNotEmpty;

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _address = prefs.getString(_keyAddress) ?? '';
    notifyListeners();
  }

  Future<void> setAddress(String value) async {
    _address = value.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAddress, _address);
    notifyListeners();
  }

  Future<void> clearAddress() async {
    _address = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAddress);
    notifyListeners();
  }
}
