class WorkerCertification {
  final String id;
  final String name;
  final String fileUrl;
  final bool verified;
  final DateTime? expiry;

  const WorkerCertification({
    required this.id,
    required this.name,
    required this.fileUrl,
    required this.verified,
    this.expiry,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'fileUrl': fileUrl,
        'verified': verified,
        'expiry': expiry?.toIso8601String(),
      };

  factory WorkerCertification.fromMap(Map<String, dynamic> map) =>
      WorkerCertification(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        fileUrl: map['fileUrl'] ?? '',
        verified: map['verified'] ?? false,
        expiry: map['expiry'] != null ? DateTime.tryParse(map['expiry']) : null,
      );
}

class SkillProvenanceRecord {
  final String skillName;
  final String issuingBody; // e.g. "Tamil Nadu Skill Development Corp / ITI Guindy"
  final String verifiedByAdminName;
  final String verificationDate;
  final int practicalScorePercent;
  final String certificateNumber;

  const SkillProvenanceRecord({
    required this.skillName,
    required this.issuingBody,
    required this.verifiedByAdminName,
    required this.verificationDate,
    this.practicalScorePercent = 94,
    required this.certificateNumber,
  });
}

class WorkerEarnings {
  final double today;
  final double week;
  final double month;
  final double total;
  final double cooperativeDividends;
  final double welfareFundAccrued;

  const WorkerEarnings({
    this.today = 0,
    this.week = 0,
    this.month = 0,
    this.total = 0,
    this.cooperativeDividends = 18400.0,
    this.welfareFundAccrued = 5600.0,
  });

  Map<String, dynamic> toMap() => {
        'today': today,
        'week': week,
        'month': month,
        'total': total,
        'cooperativeDividends': cooperativeDividends,
        'welfareFundAccrued': welfareFundAccrued,
      };

  factory WorkerEarnings.fromMap(Map<String, dynamic> map) => WorkerEarnings(
        today: (map['today'] as num?)?.toDouble() ?? 0,
        week: (map['week'] as num?)?.toDouble() ?? 0,
        month: (map['month'] as num?)?.toDouble() ?? 0,
        total: (map['total'] as num?)?.toDouble() ?? 0,
        cooperativeDividends:
            (map['cooperativeDividends'] as num?)?.toDouble() ?? 18400.0,
        welfareFundAccrued:
            (map['welfareFundAccrued'] as num?)?.toDouble() ?? 5600.0,
      );
}

class WorkerWelfare {
  final String insuranceStatus; // Active, Enrolled, Pending
  final List<String> benefits;
  final List<String> training;
  final double healthFundContribution;

  const WorkerWelfare({
    this.insuranceStatus = 'Active (National Co-op Health Shield)',
    this.benefits = const [
      'Accident & Disability Cover ₹5,00,000',
      'Child Education Grant ₹15,000/yr',
      'Zero-Interest Tool Loan',
      'Annual Co-op Dividend Share'
    ],
    this.training = const [
      'Advanced High-Voltage Safety 2026',
      'Smart Home IoT Installation',
      'Customer Care & Fair Standards'
    ],
    this.healthFundContribution = 5600.0,
  });

  Map<String, dynamic> toMap() => {
        'insuranceStatus': insuranceStatus,
        'benefits': benefits,
        'training': training,
        'healthFundContribution': healthFundContribution,
      };

  factory WorkerWelfare.fromMap(Map<String, dynamic> map) => WorkerWelfare(
        insuranceStatus: map['insuranceStatus'] ?? 'Active',
        benefits: List<String>.from(map['benefits'] ?? []),
        training: List<String>.from(map['training'] ?? []),
        healthFundContribution:
            (map['healthFundContribution'] as num?)?.toDouble() ?? 0.0,
      );
}

class DayScheduleSlot {
  final String dayName; // Mon, Tue, Wed, Thu, Fri, Sat, Sun
  final bool morning; // 8:00 AM - 12:00 PM
  final bool afternoon; // 12:00 PM - 5:00 PM
  final bool evening; // 5:00 PM - 9:00 PM
  final bool isOffDay;

  const DayScheduleSlot({
    required this.dayName,
    this.morning = true,
    this.afternoon = true,
    this.evening = true,
    this.isOffDay = false,
  });

  DayScheduleSlot copyWith({
    String? dayName,
    bool? morning,
    bool? afternoon,
    bool? evening,
    bool? isOffDay,
  }) {
    return DayScheduleSlot(
      dayName: dayName ?? this.dayName,
      morning: morning ?? this.morning,
      afternoon: afternoon ?? this.afternoon,
      evening: evening ?? this.evening,
      isOffDay: isOffDay ?? this.isOffDay,
    );
  }
}

class WorkerLeaveRequest {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status; // pending, approved, rejected

  const WorkerLeaveRequest({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.status = 'approved',
  });
}

class WorkerProfile {
  final String uid;
  final String name;
  final String photoUrl;
  final String cooperativeId;
  final String cooperativeName;
  final String primaryCategory;
  final List<String> skills;
  final List<String> serviceAreas;
  final int experienceYears;
  final int completedJobsCount;
  final List<WorkerCertification> certifications;
  final List<SkillProvenanceRecord> provenanceRecords;
  final List<String> badges; // Identity Verified, Skill Verified, Co-op Owner
  final double rating;
  final int ratingCount;
  final double serviceRadiusKm;
  final bool online;
  final double lat;
  final double lng;
  final double hourlyRate;
  final String distanceDisplay;
  final String availabilityDisplay;
  final List<DayScheduleSlot> weeklySchedule;
  final List<WorkerLeaveRequest> leaveRequests;
  final WorkerEarnings earnings;
  final WorkerWelfare welfare;
  final String bio;

  const WorkerProfile({
    required this.uid,
    required this.name,
    required this.photoUrl,
    required this.cooperativeId,
    required this.cooperativeName,
    required this.primaryCategory,
    required this.skills,
    this.serviceAreas = const ['Anna Nagar', 'Kilpauk', 'Shenoy Nagar', 'Aminjikarai'],
    required this.experienceYears,
    this.completedJobsCount = 142,
    this.certifications = const [],
    this.provenanceRecords = const [
      SkillProvenanceRecord(
        skillName: 'Residential & Commercial Wiring',
        issuingBody: 'National Skill Development Corp / ITI Guindy',
        verifiedByAdminName: 'M. Sundaram (Coordinator)',
        verificationDate: '12 Jan 2024',
        practicalScorePercent: 96,
        certificateNumber: 'ITI-TN-ELC-8921',
      ),
      SkillProvenanceRecord(
        skillName: 'Solar PV & Inverter Grid Connection',
        issuingBody: 'Tamil Nadu Energy Development Agency (TEDA)',
        verifiedByAdminName: 'Guild Technical Review Board',
        verificationDate: '08 Mar 2025',
        practicalScorePercent: 92,
        certificateNumber: 'TEDA-SOLAR-449',
      ),
    ],
    this.badges = const ['Identity Verified', 'Skill Verified', 'Co-op Member'],
    this.rating = 4.8,
    this.ratingCount = 126,
    this.serviceRadiusKm = 10.0,
    this.online = true,
    this.lat = 13.0827,
    this.lng = 80.2707,
    this.hourlyRate = 350.0,
    this.distanceDisplay = '1.8 km away',
    this.availabilityDisplay = 'Available in 25 mins',
    this.weeklySchedule = const [
      DayScheduleSlot(dayName: 'Monday', morning: true, afternoon: true, evening: true),
      DayScheduleSlot(dayName: 'Tuesday', morning: true, afternoon: true, evening: true),
      DayScheduleSlot(dayName: 'Wednesday', morning: true, afternoon: true, evening: true),
      DayScheduleSlot(dayName: 'Thursday', morning: true, afternoon: true, evening: true),
      DayScheduleSlot(dayName: 'Friday', morning: true, afternoon: true, evening: true),
      DayScheduleSlot(dayName: 'Saturday', morning: true, afternoon: true, evening: false),
      DayScheduleSlot(dayName: 'Sunday', isOffDay: true, morning: false, afternoon: false, evening: false),
    ],
    this.leaveRequests = const [],
    this.earnings = const WorkerEarnings(),
    this.welfare = const WorkerWelfare(),
    this.bio =
        'Experienced technician and proud cooperative owner committed to honest work, certified safety, and transparent community rates.',
  });

  WorkerProfile copyWith({
    String? uid,
    String? name,
    String? photoUrl,
    String? cooperativeId,
    String? cooperativeName,
    String? primaryCategory,
    List<String>? skills,
    List<String>? serviceAreas,
    int? experienceYears,
    int? completedJobsCount,
    List<WorkerCertification>? certifications,
    List<SkillProvenanceRecord>? provenanceRecords,
    List<String>? badges,
    double? rating,
    int? ratingCount,
    double? serviceRadiusKm,
    bool? online,
    double? lat,
    double? lng,
    double? hourlyRate,
    String? distanceDisplay,
    String? availabilityDisplay,
    List<DayScheduleSlot>? weeklySchedule,
    List<WorkerLeaveRequest>? leaveRequests,
    WorkerEarnings? earnings,
    WorkerWelfare? welfare,
    String? bio,
  }) {
    return WorkerProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      cooperativeId: cooperativeId ?? this.cooperativeId,
      cooperativeName: cooperativeName ?? this.cooperativeName,
      primaryCategory: primaryCategory ?? this.primaryCategory,
      skills: skills ?? this.skills,
      serviceAreas: serviceAreas ?? this.serviceAreas,
      experienceYears: experienceYears ?? this.experienceYears,
      completedJobsCount: completedJobsCount ?? this.completedJobsCount,
      certifications: certifications ?? this.certifications,
      provenanceRecords: provenanceRecords ?? this.provenanceRecords,
      badges: badges ?? this.badges,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      serviceRadiusKm: serviceRadiusKm ?? this.serviceRadiusKm,
      online: online ?? this.online,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      distanceDisplay: distanceDisplay ?? this.distanceDisplay,
      availabilityDisplay: availabilityDisplay ?? this.availabilityDisplay,
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
      leaveRequests: leaveRequests ?? this.leaveRequests,
      earnings: earnings ?? this.earnings,
      welfare: welfare ?? this.welfare,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'photoUrl': photoUrl,
      'cooperativeId': cooperativeId,
      'cooperativeName': cooperativeName,
      'primaryCategory': primaryCategory,
      'skills': skills,
      'serviceAreas': serviceAreas,
      'experienceYears': experienceYears,
      'completedJobsCount': completedJobsCount,
      'badges': badges,
      'rating': rating,
      'ratingCount': ratingCount,
      'serviceRadiusKm': serviceRadiusKm,
      'online': online,
      'lat': lat,
      'lng': lng,
      'hourlyRate': hourlyRate,
      'distanceDisplay': distanceDisplay,
      'availabilityDisplay': availabilityDisplay,
      'bio': bio,
    };
  }

  factory WorkerProfile.fromMap(Map<String, dynamic> map) {
    return WorkerProfile(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? 'Specialist',
      photoUrl: map['photoUrl'] as String? ??
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      cooperativeId: map['cooperativeId'] as String? ?? 'coop_anna_nagar',
      cooperativeName: map['cooperativeName'] as String? ??
          'Anna Nagar Electrical & Trades Co-op',
      primaryCategory: map['primaryCategory'] as String? ?? 'Electrician',
      skills: (map['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['General Diagnostics', 'Installation & Repair'],
      serviceAreas: (map['serviceAreas'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['Anna Nagar', 'Chennai'],
      experienceYears: (map['experienceYears'] as num?)?.toInt() ?? 3,
      completedJobsCount: (map['completedJobsCount'] as num?)?.toInt() ?? 0,
      badges: (map['badges'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['Identity Verified', 'Skill Verified', 'Co-op Member'],
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 1,
      serviceRadiusKm: (map['serviceRadiusKm'] as num?)?.toDouble() ?? 10.0,
      online: map['online'] as bool? ?? true,
      lat: (map['lat'] as num?)?.toDouble() ?? 13.0827,
      lng: (map['lng'] as num?)?.toDouble() ?? 80.2707,
      hourlyRate: (map['hourlyRate'] as num?)?.toDouble() ?? 350.0,
      distanceDisplay: map['distanceDisplay'] as String? ?? '1.2 km away',
      availabilityDisplay:
          map['availabilityDisplay'] as String? ?? 'Available now',
      bio: map['bio'] as String? ??
          'Experienced technician and proud cooperative owner committed to honest work, certified safety, and transparent community rates.',
    );
  }
}
