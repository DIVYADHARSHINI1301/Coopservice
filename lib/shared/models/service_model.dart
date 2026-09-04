class ServiceItem {
  final String id;
  final String name;
  final String nameTamil;
  final String iconName; // bolt, plumbing, carpenter, format_paint, cleaning_services, directions_car, hvac
  final String description;
  final double basePrice;
  final List<String> subcategories;
  final bool active;
  final bool isPopular;
  final int activeWorkerCount;

  const ServiceItem({
    required this.id,
    required this.name,
    this.nameTamil = '',
    required this.iconName,
    required this.description,
    required this.basePrice,
    required this.subcategories,
    this.active = true,
    this.isPopular = false,
    this.activeWorkerCount = 12,
  });

  ServiceItem copyWith({
    String? id,
    String? name,
    String? nameTamil,
    String? iconName,
    String? description,
    double? basePrice,
    List<String>? subcategories,
    bool? active,
    bool? isPopular,
    int? activeWorkerCount,
  }) {
    return ServiceItem(
      id: id ?? this.id,
      name: name ?? this.name,
      nameTamil: nameTamil ?? this.nameTamil,
      iconName: iconName ?? this.iconName,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      subcategories: subcategories ?? this.subcategories,
      active: active ?? this.active,
      isPopular: isPopular ?? this.isPopular,
      activeWorkerCount: activeWorkerCount ?? this.activeWorkerCount,
    );
  }
}
