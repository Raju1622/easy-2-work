import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/service_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _items.fold(0.0, (sum, item) => sum + item.total);

  void addToCart(ServiceModel service, {int quantity = 1}) {
    final existing = _items.indexWhere((i) => i.service.id == service.id);
    if (existing >= 0) {
      _items[existing] = _items[existing].copyWith(
        quantity: _items[existing].quantity + quantity,
      );
    } else {
      _items.add(CartItem(service: service, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(String serviceId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(serviceId);
      return;
    }
    final index = _items.indexWhere((i) => i.service.id == serviceId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void removeFromCart(String serviceId) {
    _items.removeWhere((i) => i.service.id == serviceId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
