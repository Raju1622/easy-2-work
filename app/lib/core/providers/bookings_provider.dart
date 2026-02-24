import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/booking_model.dart';

const String _keyBookings = 'bookings_list';

class BookingsProvider with ChangeNotifier {
  BookingsProvider() {
    _loadFromPrefs();
  }

  final List<BookingModel> _bookings = [];

  List<BookingModel> get bookings => List.unmodifiable(_bookings);

  /// Active bookings – user ne book kiye, worker ko "Available Jobs" mein dikhenge
  List<BookingModel> get active =>
      _bookings.where((b) => b.status == BookingStatus.active).toList();

  List<BookingModel> get completed =>
      _bookings.where((b) => b.status == BookingStatus.completed).toList();

  List<BookingModel> get cancelled =>
      _bookings.where((b) => b.status == BookingStatus.cancelled).toList();

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyBookings);
    if (raw == null || raw.isEmpty) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>? ?? [];
      _bookings.clear();
      for (final e in list) {
        _bookings.add(BookingModel.fromJson(Map<String, dynamic>.from(e as Map)));
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _bookings.map((b) => b.toJson()).toList();
    await prefs.setString(_keyBookings, jsonEncode(list));
  }

  void addBooking(BookingModel booking) {
    _bookings.insert(0, booking);
    _saveToPrefs();
    notifyListeners();
  }

  BookingModel? getById(String id) {
    try {
      return _bookings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  void updateStatus(String id, BookingStatus status) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index >= 0) {
      _bookings[index].status = status;
      _saveToPrefs();
      notifyListeners();
    }
  }

  void cancelBooking(String id) {
    updateStatus(id, BookingStatus.cancelled);
  }

  void completeBooking(String id) {
    updateStatus(id, BookingStatus.completed);
  }
}
