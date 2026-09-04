class CooperativeStory {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int workersImpacted;
  final String date;

  const CooperativeStory({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.workersImpacted = 12,
    this.date = 'August 2026',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'workersImpacted': workersImpacted,
        'date': date,
      };

  factory CooperativeStory.fromMap(Map<String, dynamic> map) =>
      CooperativeStory(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        workersImpacted: map['workersImpacted'] ?? 12,
        date: map['date'] ?? '',
      );
}

class ShiftAvailability {
  final int morning; // available worker count
  final int afternoon;
  final int evening;

  const ShiftAvailability({
    this.morning = 8,
    this.afternoon = 6,
    this.evening = 4,
  });

  int get totalAvailable => morning + afternoon + evening;
}

class CooperativeFinancialLedger {
  final double totalBookingVolume;
  final double workerDirectPayouts;
  final double cooperativeWelfareFund;
  final double platformSupportFees;
  final double reserveFunds;

  const CooperativeFinancialLedger({
    this.totalBookingVolume = 612000.0,
    this.workerDirectPayouts = 520200.0, // ~85%
    this.cooperativeWelfareFund = 73440.0, // ~12%
    this.platformSupportFees = 18360.0, // ~3%
    this.reserveFunds = 95000.0,
  });
}

class Cooperative {
  final String id;
  final String name;
  final String nameTamil;
  final String region;
  final String registrationNumber;
  final String status; // active, pending, suspended
  final String verificationStatus; // verified, pending
  final String description;
  final String address;
  final String phone;
  final String email;
  final int establishedYear;
  final List<String> adminIds;
  final List<String> adminNames;
  final int workerCount;
  final int activeWorkerCount;
  final int availableTodayCount;
  final double serviceAreaRadiusKm;
  final int completedJobsCount;
  final double rating;
  final int ratingCount;
  final double revenueThisMonth;
  final List<String> serviceCategories;
  final List<String> skills;
  final Map<String, ShiftAvailability> skillAvailability;
  final List<CooperativeStory> stories;
  final CooperativeFinancialLedger financialLedger;
  final String coverUrl;
  final String logoUrl;
  final DateTime createdAt;

  const Cooperative({
    required this.id,
    required this.name,
    this.nameTamil = '',
    required this.region,
    required this.registrationNumber,
    this.status = 'active',
    this.verificationStatus = 'verified',
    this.description =
        'Democratic worker-owned cooperative providing certified home repairs and skilled crafts with 100% fair pay guarantee.',
    this.address = '24, 2nd Main Road, Anna Nagar East, Chennai - 600102',
    this.phone = '+91 44 2621 8890',
    this.email = 'coordinator@annanagar.coop',
    this.establishedYear = 2021,
    required this.adminIds,
    this.adminNames = const [],
    this.workerCount = 54,
    this.activeWorkerCount = 38,
    this.availableTodayCount = 14,
    this.serviceAreaRadiusKm = 15.0,
    this.completedJobsCount = 2840,
    this.rating = 4.88,
    this.ratingCount = 342,
    this.revenueThisMonth = 612000.0,
    this.serviceCategories = const [
      'Electrician',
      'Plumber',
      'Carpenter',
      'AC & Appliance'
    ],
    this.skills = const [
      'Residential Wiring',
      'Inverter & Solar',
      'Pipe Leak Diagnostics',
      'Modular Kitchen Fitting',
      'Foam Jet AC Cleaning'
    ],
    this.skillAvailability = const {
      'Electrician': ShiftAvailability(morning: 5, afternoon: 4, evening: 3),
      'Plumber': ShiftAvailability(morning: 4, afternoon: 3, evening: 2),
      'Carpenter': ShiftAvailability(morning: 3, afternoon: 2, evening: 1),
      'AC & Appliance': ShiftAvailability(morning: 4, afternoon: 4, evening: 2),
    },
    this.stories = const [],
    this.financialLedger = const CooperativeFinancialLedger(),
    this.coverUrl =
        'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
    this.logoUrl =
        'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150',
    required this.createdAt,
  });

  Cooperative copyWith({
    String? id,
    String? name,
    String? nameTamil,
    String? region,
    String? registrationNumber,
    String? status,
    String? verificationStatus,
    String? description,
    String? address,
    String? phone,
    String? email,
    int? establishedYear,
    List<String>? adminIds,
    List<String>? adminNames,
    int? workerCount,
    int? activeWorkerCount,
    int? availableTodayCount,
    double? serviceAreaRadiusKm,
    int? completedJobsCount,
    double? rating,
    int? ratingCount,
    double? revenueThisMonth,
    List<String>? serviceCategories,
    List<String>? skills,
    Map<String, ShiftAvailability>? skillAvailability,
    List<CooperativeStory>? stories,
    CooperativeFinancialLedger? financialLedger,
    String? coverUrl,
    String? logoUrl,
    DateTime? createdAt,
  }) {
    return Cooperative(
      id: id ?? this.id,
      name: name ?? this.name,
      nameTamil: nameTamil ?? this.nameTamil,
      region: region ?? this.region,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      status: status ?? this.status,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      establishedYear: establishedYear ?? this.establishedYear,
      adminIds: adminIds ?? this.adminIds,
      adminNames: adminNames ?? this.adminNames,
      workerCount: workerCount ?? this.workerCount,
      activeWorkerCount: activeWorkerCount ?? this.activeWorkerCount,
      availableTodayCount: availableTodayCount ?? this.availableTodayCount,
      serviceAreaRadiusKm: serviceAreaRadiusKm ?? this.serviceAreaRadiusKm,
      completedJobsCount: completedJobsCount ?? this.completedJobsCount,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      revenueThisMonth: revenueThisMonth ?? this.revenueThisMonth,
      serviceCategories: serviceCategories ?? this.serviceCategories,
      skills: skills ?? this.skills,
      skillAvailability: skillAvailability ?? this.skillAvailability,
      stories: stories ?? this.stories,
      financialLedger: financialLedger ?? this.financialLedger,
      coverUrl: coverUrl ?? this.coverUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
