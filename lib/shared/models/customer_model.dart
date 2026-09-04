class SavedAddress {
  final String id;
  final String label;
  final String address;
  final double lat;
  final double lng;
  final bool isDefault;

  const SavedAddress({
    required this.id,
    required this.label,
    required this.address,
    required this.lat,
    required this.lng,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'label': label,
        'address': address,
        'lat': lat,
        'lng': lng,
        'isDefault': isDefault,
      };

  factory SavedAddress.fromMap(Map<String, dynamic> map) => SavedAddress(
        id: map['id'] ?? '',
        label: map['label'] ?? '',
        address: map['address'] ?? '',
        lat: (map['lat'] as num?)?.toDouble() ?? 13.0827,
        lng: (map['lng'] as num?)?.toDouble() ?? 80.2707,
        isDefault: map['isDefault'] ?? false,
      );
}

class CustomerImpactStats {
  final int workersSupported;
  final int cooperativesEngaged;
  final int totalJobsCompleted;
  final double totalWorkerEarningsDirected;
  final double totalCooperativeFundGenerated;

  const CustomerImpactStats({
    this.workersSupported = 8,
    this.cooperativesEngaged = 3,
    this.totalJobsCompleted = 14,
    this.totalWorkerEarningsDirected = 11400.0,
    this.totalCooperativeFundGenerated = 1620.0,
  });
}

class CustomWorkRequest {
  final String id;
  final String customerId;
  final String title;
  final String description;
  final String serviceCategory;
  final String address;
  final double? budget;
  final DateTime preferredDate;
  final List<String> photoUrls;
  final String status; // 'open', 'quotes_received', 'booked'
  final DateTime createdAt;

  const CustomWorkRequest({
    required this.id,
    required this.customerId,
    required this.title,
    required this.description,
    required this.serviceCategory,
    required this.address,
    this.budget,
    required this.preferredDate,
    this.photoUrls = const [],
    this.status = 'open',
    required this.createdAt,
  });
}

class RecurringCarePlan {
  final String id;
  final String title;
  final String serviceCategory;
  final String frequency; // 'Monthly', 'Quarterly', 'Bi-Annual'
  final DateTime nextScheduledDate;
  final double estimatedCost;
  final int discountPercent;
  final String cooperativeId;
  final String cooperativeName;
  final bool isActive;

  const RecurringCarePlan({
    required this.id,
    required this.title,
    required this.serviceCategory,
    required this.frequency,
    required this.nextScheduledDate,
    required this.estimatedCost,
    this.discountPercent = 15,
    required this.cooperativeId,
    required this.cooperativeName,
    this.isActive = true,
  });

  RecurringCarePlan copyWith({
    String? id,
    String? title,
    String? serviceCategory,
    String? frequency,
    DateTime? nextScheduledDate,
    double? estimatedCost,
    int? discountPercent,
    String? cooperativeId,
    String? cooperativeName,
    bool? isActive,
  }) {
    return RecurringCarePlan(
      id: id ?? this.id,
      title: title ?? this.title,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      frequency: frequency ?? this.frequency,
      nextScheduledDate: nextScheduledDate ?? this.nextScheduledDate,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      discountPercent: discountPercent ?? this.discountPercent,
      cooperativeId: cooperativeId ?? this.cooperativeId,
      cooperativeName: cooperativeName ?? this.cooperativeName,
      isActive: isActive ?? this.isActive,
    );
  }
}

class PreBookingInquiry {
  final String id;
  final String customerId;
  final String cooperativeId;
  final String cooperativeName;
  final String serviceCategory;
  final String question;
  final String? coordinatorReply;
  final String status; // 'pending', 'replied'
  final DateTime createdAt;
  final DateTime? repliedAt;

  const PreBookingInquiry({
    required this.id,
    required this.customerId,
    required this.cooperativeId,
    required this.cooperativeName,
    required this.serviceCategory,
    required this.question,
    this.coordinatorReply,
    this.status = 'pending',
    required this.createdAt,
    this.repliedAt,
  });
}

class CustomerProfile {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final List<SavedAddress> savedAddresses;
  final List<String> savedCooperativeIds;
  final Map<String, String> myRegularWorkerIds; // Category -> workerUid
  final List<RecurringCarePlan> recurringPlans;
  final List<PreBookingInquiry> inquiries;
  final CustomerImpactStats impactStats;
  final String preferredLanguage;
  final bool notificationsEnabled;
  final int loyaltyBookingsCount;

  const CustomerProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.savedAddresses = const [],
    this.savedCooperativeIds = const ['coop_anna_nagar'],
    this.myRegularWorkerIds = const {'Electrician': 'worker_1', 'Plumber': 'worker_2'},
    this.recurringPlans = const [],
    this.inquiries = const [],
    this.impactStats = const CustomerImpactStats(),
    this.preferredLanguage = 'English',
    this.notificationsEnabled = true,
    this.loyaltyBookingsCount = 6,
  });

  CustomerProfile copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    List<SavedAddress>? savedAddresses,
    List<String>? savedCooperativeIds,
    Map<String, String>? myRegularWorkerIds,
    List<RecurringCarePlan>? recurringPlans,
    List<PreBookingInquiry>? inquiries,
    CustomerImpactStats? impactStats,
    String? preferredLanguage,
    bool? notificationsEnabled,
    int? loyaltyBookingsCount,
  }) {
    return CustomerProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      savedCooperativeIds: savedCooperativeIds ?? this.savedCooperativeIds,
      myRegularWorkerIds: myRegularWorkerIds ?? this.myRegularWorkerIds,
      recurringPlans: recurringPlans ?? this.recurringPlans,
      inquiries: inquiries ?? this.inquiries,
      impactStats: impactStats ?? this.impactStats,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      loyaltyBookingsCount:
          loyaltyBookingsCount ?? this.loyaltyBookingsCount,
    );
  }
}
