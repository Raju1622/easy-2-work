import 'package:flutter/foundation.dart';

/// Tracks which booking IDs the current worker has accepted (in-memory for now).
class WorkerJobsProvider with ChangeNotifier {
  final List<String> _acceptedBookingIds = [];

  List<String> get acceptedBookingIds => List.unmodifiable(_acceptedBookingIds);

  void acceptJob(String bookingId) {
    if (!_acceptedBookingIds.contains(bookingId)) {
      _acceptedBookingIds.add(bookingId);
      notifyListeners();
    }
  }

  void clear() {
    _acceptedBookingIds.clear();
    notifyListeners();
  }
}
