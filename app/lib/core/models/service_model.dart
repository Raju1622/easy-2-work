/// Service model for Easy 2 Work
class ServiceModel {
  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    this.basePrice = 299,
    this.whatsIncluded = const [],
  });

  final String id;
  final String name;
  final String description;
  final String emoji;
  final double basePrice;
  final List<String> whatsIncluded;

  /// Lookup by id for loading persisted cart/booking items.
  static ServiceModel? getById(String id) {
    try {
      return allServices.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Placeholder when persisted service id is missing
const ServiceModel kUnknownService = ServiceModel(
  id: 'unknown',
  name: 'Service',
  description: '',
  emoji: '🔧',
  basePrice: 0,
);

/// All services from website - App mein same rahenge
final List<ServiceModel> allServices = [
  const ServiceModel(
    id: 'electrical',
    name: 'Electrical Repair',
    description:
        'Wiring, fuse, switch aur electrical fault fix. Certified electricians for safe repairs at home.',
    emoji: '⚡',
    basePrice: 299,
    whatsIncluded: [
      'Wiring check',
      'Fuse & switch fix',
      'Socket repair',
      'Safety inspection'
    ],
  ),
  const ServiceModel(
    id: 'ac',
    name: 'AC Servicing',
    description:
        'AC installation, repair aur maintenance. Gas refill, filter clean, cooling check.',
    emoji: '❄️',
    basePrice: 399,
    whatsIncluded: [
      'Filter cleaning',
      'Cooling check',
      'Gas refill (if needed)',
      'General service'
    ],
  ),
  const ServiceModel(
    id: 'cooler',
    name: 'Cooler Repair',
    description: 'Cooler repair aur servicing ghar par. Water pump, pad replacement.',
    emoji: '🌀',
    basePrice: 349,
    whatsIncluded: [
      'Water pump check',
      'Pad replacement',
      'Cleaning',
      'Full servicing'
    ],
  ),
  const ServiceModel(
    id: 'laundry',
    name: 'Laundry',
    description: 'Washing, ironing aur laundry help. Same-day pickup possible.',
    emoji: '🧺',
    basePrice: 199,
    whatsIncluded: ['Wash & dry', 'Ironing', 'Folding', 'Delivery'],
  ),
  const ServiceModel(
    id: 'window',
    name: 'Window Cleaning',
    description:
        'Andar-bahar window cleaning. Streak-free, inside and outside.',
    emoji: '🪟',
    basePrice: 249,
    whatsIncluded: [
      'Inside cleaning',
      'Outside cleaning',
      'Frame wipe',
      'Glass polish'
    ],
  ),
  const ServiceModel(
    id: 'utensils',
    name: 'Utensils Cleaning',
    description: 'Bartan dhona aur kitchen cleanup. Safe, hygienic cleaning.',
    emoji: '🍽️',
    basePrice: 199,
    whatsIncluded: [
      'Utensils wash',
      'Kitchen slab clean',
      'Sink clean',
      'Dry & arrange'
    ],
  ),
  const ServiceModel(
    id: 'balcony',
    name: 'Balcony Cleaning',
    description: 'Balcony sweep, mop aur upkeep. Dust and cobweb removal.',
    emoji: '🌿',
    basePrice: 249,
    whatsIncluded: ['Sweeping', 'Mopping', 'Cobweb removal', 'Dusting'],
  ),
  const ServiceModel(
    id: 'bathroom',
    name: 'Bathroom Cleaning',
    description: 'Bathroom deep clean aur sanitisation. Tiles, commode, basin.',
    emoji: '🚿',
    basePrice: 299,
    whatsIncluded: [
      'Tiles scrub',
      'Commode sanitise',
      'Basin clean',
      'Floor mop'
    ],
  ),
];

/// Home page grid: Electrical, AC, Laundry, Window, Cleaning, Repairs (6 items)
List<ServiceModel> get homeGridServices => [
      allServices[0], // Electrical
      allServices[1], // AC
      allServices[3], // Laundry
      allServices[4], // Window
      allServices[7], // Bathroom = Cleaning
      allServices[2], // Cooler = Repairs
    ];
