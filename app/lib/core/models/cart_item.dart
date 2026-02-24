import 'service_model.dart';

class CartItem {
  CartItem({required this.service, this.quantity = 1});

  final ServiceModel service;
  int quantity;

  double get total => service.basePrice * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      service: service,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
        'serviceId': service.id,
        'quantity': quantity,
      };

  static CartItem fromJson(Map<String, dynamic> json) {
    final id = json['serviceId'] as String? ?? '';
    final service = ServiceModel.getById(id) ?? kUnknownService;
    return CartItem(
      service: service,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}
