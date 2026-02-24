import 'package:flutter/foundation.dart';

class NavProvider with ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setIndex(int i) {
    if (_index != i) {
      _index = i;
      notifyListeners();
    }
  }
}
