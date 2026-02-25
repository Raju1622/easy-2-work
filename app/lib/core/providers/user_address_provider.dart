import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyAddress = 'user_saved_address';
const String _keyPinCode = 'user_saved_pincode';
const String _keyLat = 'user_saved_lat';
const String _keyLng = 'user_saved_lng';

/// User ka saved address + PIN + location – worker map se pahunchne ke liye
class UserAddressProvider with ChangeNotifier {
  UserAddressProvider() {
    _loadFromPrefs();
  }

  String _address = '';
  String _pinCode = '';
  double? _latitude;
  double? _longitude;

  String get address => _address;
  String get pinCode => _pinCode;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  bool get hasLocation => _latitude != null && _longitude != null;

  /// Full address with PIN – booking aur worker ke map navigation ke liye
  String get fullAddress {
    final a = _address.trim();
    final p = _pinCode.trim();
    if (p.isEmpty) return a;
    return '$a, $p';
  }

  bool get hasAddress => _address.trim().isNotEmpty;

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _address = prefs.getString(_keyAddress) ?? '';
    _pinCode = prefs.getString(_keyPinCode) ?? '';
    _latitude = prefs.getDouble(_keyLat);
    _longitude = prefs.getDouble(_keyLng);
    notifyListeners();
  }

  Future<void> setAddress(String value) async {
    _address = value.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAddress, _address);
    notifyListeners();
  }

  Future<void> setAddressAndPin(String addressLine, String pin) async {
    _address = addressLine.trim();
    _pinCode = pin.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAddress, _address);
    await prefs.setString(_keyPinCode, _pinCode);
    notifyListeners();
  }

  /// Phone location allow karke current position save karo – engineer map pe isko use karega
  Future<void> setLocation(double lat, double lng) async {
    _latitude = lat;
    _longitude = lng;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyLat, lat);
    await prefs.setDouble(_keyLng, lng);
    notifyListeners();
  }

  Future<void> clearAddress() async {
    _address = '';
    _pinCode = '';
    _latitude = null;
    _longitude = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAddress);
    await prefs.remove(_keyPinCode);
    await prefs.remove(_keyLat);
    await prefs.remove(_keyLng);
    notifyListeners();
  }
}
