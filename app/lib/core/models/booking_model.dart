import 'cart_item.dart';

enum BookingStatus { active, completed, cancelled }

class BookingModel {
  BookingModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.address,
    required this.date,
    required this.timeSlot,
    required this.createdAt,
    this.status = BookingStatus.active,
    this.engineerPhone,
    this.latitude,
    this.longitude,
  });

  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String address;
  final String date;
  final String timeSlot;
  final DateTime createdAt;
  BookingStatus status;
  String? engineerPhone;
  final double? latitude;
  final double? longitude;

  String get serviceNames => items.map((e) => e.service.name).join(', ');

  bool get canTrack =>
      status == BookingStatus.active && engineerPhone != null;

  bool get canReview => status == BookingStatus.completed;

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((e) => e.toJson()).toList(),
        'totalAmount': totalAmount,
        'address': address,
        'date': date,
        'timeSlot': timeSlot,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'status': status.name,
        'engineerPhone': engineerPhone,
        'latitude': latitude,
        'longitude': longitude,
      };

  static BookingModel fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    final items = itemsList
        .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final statusStr = json['status'] as String? ?? 'active';
    BookingStatus status = BookingStatus.active;
    for (final s in BookingStatus.values) {
      if (s.name == statusStr) {
        status = s;
        break;
      }
    }
    final createdAt = json['createdAt'];
    final lat = json['latitude'];
    final lng = json['longitude'];
    return BookingModel(
      id: json['id'] as String? ?? '',
      items: items,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      address: json['address'] as String? ?? '',
      date: json['date'] as String? ?? '',
      timeSlot: json['timeSlot'] as String? ?? '',
      createdAt: createdAt != null
          ? DateTime.fromMillisecondsSinceEpoch(createdAt as int)
          : DateTime.now(),
      status: status,
      engineerPhone: json['engineerPhone'] as String?,
      latitude: lat != null ? (lat as num).toDouble() : null,
      longitude: lng != null ? (lng as num).toDouble() : null,
    );
  }
}
