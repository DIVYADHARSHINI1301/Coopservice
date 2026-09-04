enum BookingStatus {
  requested,
  accepted,
  onTheWay,
  arrived,
  inProgress,
  completed,
  cancelled;

  static BookingStatus fromString(String status) {
    switch (status) {
      case 'accepted':
        return BookingStatus.accepted;
      case 'on_the_way':
      case 'onTheWay':
        return BookingStatus.onTheWay;
      case 'arrived':
        return BookingStatus.arrived;
      case 'in_progress':
      case 'inProgress':
        return BookingStatus.inProgress;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'requested':
      default:
        return BookingStatus.requested;
    }
  }

  String toDbString() {
    switch (this) {
      case BookingStatus.requested:
        return 'requested';
      case BookingStatus.accepted:
        return 'accepted';
      case BookingStatus.onTheWay:
        return 'on_the_way';
      case BookingStatus.arrived:
        return 'arrived';
      case BookingStatus.inProgress:
        return 'in_progress';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
    }
  }

  String get label {
    switch (this) {
      case BookingStatus.requested:
        return 'Requested';
      case BookingStatus.accepted:
        return 'Accepted';
      case BookingStatus.onTheWay:
        return 'On The Way';
      case BookingStatus.arrived:
        return 'Arrived at Site';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get nextWorkerActionLabel {
    switch (this) {
      case BookingStatus.requested:
        return 'Accept Job';
      case BookingStatus.accepted:
        return 'Start Travel';
      case BookingStatus.onTheWay:
        return "I've Arrived";
      case BookingStatus.arrived:
        return 'Start Service';
      case BookingStatus.inProgress:
        return 'Complete Job';
      case BookingStatus.completed:
        return 'Job Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class BookingLocation {
  final String address;
  final double lat;
  final double lng;

  const BookingLocation({
    required this.address,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() => {
        'address': address,
        'lat': lat,
        'lng': lng,
      };

  factory BookingLocation.fromMap(Map<String, dynamic> map) => BookingLocation(
        address: map['address'] ?? '',
        lat: (map['lat'] as num?)?.toDouble() ?? 13.0827,
        lng: (map['lng'] as num?)?.toDouble() ?? 80.2707,
      );
}

class AssignedTeamWorker {
  final String workerId;
  final String workerName;
  final String role;
  final String photoUrl;
  final String phone;

  const AssignedTeamWorker({
    required this.workerId,
    required this.workerName,
    required this.role,
    this.photoUrl = '',
    this.phone = '',
  });

  Map<String, dynamic> toMap() => {
        'workerId': workerId,
        'workerName': workerName,
        'role': role,
        'photoUrl': photoUrl,
        'phone': phone,
      };

  factory AssignedTeamWorker.fromMap(Map<String, dynamic> map) =>
      AssignedTeamWorker(
        workerId: map['workerId'] ?? '',
        workerName: map['workerName'] ?? '',
        role: map['role'] ?? 'Technician',
        photoUrl: map['photoUrl'] ?? '',
        phone: map['phone'] ?? '',
      );
}

class FairSplitPricing {
  final double totalAmount;
  final double workerDirectEarnings; // 85%
  final double cooperativeWelfareFund; // 12%
  final double platformSupportFee; // 3%

  double get serviceTotal => totalAmount;

  const FairSplitPricing({
    required this.totalAmount,
    required this.workerDirectEarnings,
    required this.cooperativeWelfareFund,
    required this.platformSupportFee,
  });

  factory FairSplitPricing.calculate(double total) {
    final worker = (total * 0.85).roundToDouble();
    final coop = (total * 0.12).roundToDouble();
    final platform = total - worker - coop;
    return FairSplitPricing(
      totalAmount: total,
      workerDirectEarnings: worker,
      cooperativeWelfareFund: coop,
      platformSupportFee: platform,
    );
  }
}

class RevisitRequest {
  final String id;
  final String bookingId;
  final String issueDescription;
  final List<String> photoUrls;
  final String status; // 'submitted', 'assigned', 'resolved'
  final DateTime requestedAt;
  final DateTime? resolvedAt;

  const RevisitRequest({
    required this.id,
    required this.bookingId,
    required this.issueDescription,
    this.photoUrls = const [],
    this.status = 'submitted',
    required this.requestedAt,
    this.resolvedAt,
  });
}

class DigitalJobCard {
  final String jobCardId;
  final List<String> beforePhotos;
  final List<String> afterPhotos;
  final List<String> materialsUsed;
  final DateTime warrantyExpiryDate;
  final bool isWarrantyActive;
  final String technicianSignature;
  final List<RevisitRequest> revisitRequests;

  const DigitalJobCard({
    required this.jobCardId,
    this.beforePhotos = const [],
    this.afterPhotos = const [],
    this.materialsUsed = const [],
    required this.warrantyExpiryDate,
    this.isWarrantyActive = true,
    this.technicianSignature = 'K. Anbarasan (Certified Guild #402)',
    this.revisitRequests = const [],
  });

  DigitalJobCard copyWith({
    String? jobCardId,
    List<String>? beforePhotos,
    List<String>? afterPhotos,
    List<String>? materialsUsed,
    DateTime? warrantyExpiryDate,
    bool? isWarrantyActive,
    String? technicianSignature,
    List<RevisitRequest>? revisitRequests,
  }) {
    return DigitalJobCard(
      jobCardId: jobCardId ?? this.jobCardId,
      beforePhotos: beforePhotos ?? this.beforePhotos,
      afterPhotos: afterPhotos ?? this.afterPhotos,
      materialsUsed: materialsUsed ?? this.materialsUsed,
      warrantyExpiryDate: warrantyExpiryDate ?? this.warrantyExpiryDate,
      isWarrantyActive: isWarrantyActive ?? this.isWarrantyActive,
      technicianSignature: technicianSignature ?? this.technicianSignature,
      revisitRequests: revisitRequests ?? this.revisitRequests,
    );
  }
}

class GroupBookingSplit {
  final String groupCode;
  final String societyName;
  final int totalParticipants;
  final double splitAmountPerMember;
  final List<String> paidMemberNames;
  final String shareLink;

  const GroupBookingSplit({
    required this.groupCode,
    required this.societyName,
    required this.totalParticipants,
    required this.splitAmountPerMember,
    this.paidMemberNames = const [],
    required this.shareLink,
  });
}

class Booking {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String workerId;
  final String workerName;
  final String workerPhotoUrl;
  final String cooperativeId;
  final String cooperativeName;
  final String serviceCategory;
  final String serviceSubtype;
  final BookingStatus status;
  final DateTime scheduledAt;
  final BookingLocation location;
  final String instructions;
  final double estimatedPrice;
  final double finalPrice;
  final FairSplitPricing pricing;
  final String paymentStatus;
  final String paymentMethod;
  final bool isEmergency;
  final bool isTeamBooking;
  final int teamSize;
  final List<AssignedTeamWorker> assignedWorkers;
  final List<String> workProofPhotos;
  final int? ratingGiven;
  final double? professionalismRating;
  final double? qualityRating;
  final double? coordinationRating;
  final String? reviewComment;
  final DigitalJobCard? jobCard;
  final GroupBookingSplit? groupSplit;
  final int neighborhoodTrustCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Booking({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerPhone = '+91 98401 23456',
    required this.workerId,
    required this.workerName,
    this.workerPhotoUrl = '',
    required this.cooperativeId,
    required this.cooperativeName,
    required this.serviceCategory,
    required this.serviceSubtype,
    required this.status,
    required this.scheduledAt,
    required this.location,
    this.instructions = '',
    required this.estimatedPrice,
    required this.finalPrice,
    required this.pricing,
    this.paymentStatus = 'pending',
    this.paymentMethod = 'UPI / Cash on Completion',
    this.isEmergency = false,
    this.isTeamBooking = false,
    this.teamSize = 1,
    this.assignedWorkers = const [],
    this.workProofPhotos = const [],
    this.ratingGiven,
    this.professionalismRating,
    this.qualityRating,
    this.coordinationRating,
    this.reviewComment,
    this.jobCard,
    this.groupSplit,
    this.neighborhoodTrustCount = 14,
    required this.createdAt,
    required this.updatedAt,
  });

  Booking copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? workerId,
    String? workerName,
    String? workerPhotoUrl,
    String? cooperativeId,
    String? cooperativeName,
    String? serviceCategory,
    String? serviceSubtype,
    BookingStatus? status,
    DateTime? scheduledAt,
    BookingLocation? location,
    String? instructions,
    double? estimatedPrice,
    double? finalPrice,
    FairSplitPricing? pricing,
    String? paymentStatus,
    String? paymentMethod,
    bool? isEmergency,
    bool? isTeamBooking,
    int? teamSize,
    List<AssignedTeamWorker>? assignedWorkers,
    List<String>? workProofPhotos,
    int? ratingGiven,
    double? professionalismRating,
    double? qualityRating,
    double? coordinationRating,
    String? reviewComment,
    DigitalJobCard? jobCard,
    GroupBookingSplit? groupSplit,
    int? neighborhoodTrustCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
      workerPhotoUrl: workerPhotoUrl ?? this.workerPhotoUrl,
      cooperativeId: cooperativeId ?? this.cooperativeId,
      cooperativeName: cooperativeName ?? this.cooperativeName,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      serviceSubtype: serviceSubtype ?? this.serviceSubtype,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      location: location ?? this.location,
      instructions: instructions ?? this.instructions,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      pricing: pricing ?? this.pricing,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isEmergency: isEmergency ?? this.isEmergency,
      isTeamBooking: isTeamBooking ?? this.isTeamBooking,
      teamSize: teamSize ?? this.teamSize,
      assignedWorkers: assignedWorkers ?? this.assignedWorkers,
      workProofPhotos: workProofPhotos ?? this.workProofPhotos,
      ratingGiven: ratingGiven ?? this.ratingGiven,
      professionalismRating:
          professionalismRating ?? this.professionalismRating,
      qualityRating: qualityRating ?? this.qualityRating,
      coordinationRating: coordinationRating ?? this.coordinationRating,
      reviewComment: reviewComment ?? this.reviewComment,
      jobCard: jobCard ?? this.jobCard,
      groupSplit: groupSplit ?? this.groupSplit,
      neighborhoodTrustCount:
          neighborhoodTrustCount ?? this.neighborhoodTrustCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
