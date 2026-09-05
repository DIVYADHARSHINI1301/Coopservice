enum BookingStatus {
  bookingCreated,
  workerSearching,
  workerAccepted,
  workerDeclined,
  workerOnTheWay,
  workerArrived,
  workStarted,
  workInProgress,
  workCompleted,
  customerConfirmed,
  closed,
  cancelled;

  // Backward-compatible static aliases
  static const BookingStatus requested = BookingStatus.bookingCreated;
  static const BookingStatus accepted = BookingStatus.workerAccepted;
  static const BookingStatus onTheWay = BookingStatus.workerOnTheWay;
  static const BookingStatus arrived = BookingStatus.workerArrived;
  static const BookingStatus inProgress = BookingStatus.workInProgress;
  static const BookingStatus completed = BookingStatus.workCompleted;

  static BookingStatus fromString(String status) {
    final clean = status.trim().toLowerCase().replaceAll('-', '_');
    switch (clean) {
      case 'booking_created':
      case 'bookingcreated':
      case 'requested':
        return BookingStatus.bookingCreated;
      case 'worker_searching':
      case 'workersearching':
      case 'searching':
        return BookingStatus.workerSearching;
      case 'worker_accepted':
      case 'workeraccepted':
      case 'accepted':
        return BookingStatus.workerAccepted;
      case 'worker_declined':
      case 'workerdeclined':
      case 'declined':
        return BookingStatus.workerDeclined;
      case 'worker_on_the_way':
      case 'workermontheway':
      case 'on_the_way':
      case 'ontheway':
        return BookingStatus.workerOnTheWay;
      case 'worker_arrived':
      case 'workerarrived':
      case 'arrived':
        return BookingStatus.workerArrived;
      case 'work_started':
      case 'workstarted':
        return BookingStatus.workStarted;
      case 'work_in_progress':
      case 'workinprogress':
      case 'in_progress':
      case 'inprogress':
        return BookingStatus.workInProgress;
      case 'work_completed':
      case 'workcompleted':
      case 'completed':
        return BookingStatus.workCompleted;
      case 'customer_confirmed':
      case 'customerconfirmed':
        return BookingStatus.customerConfirmed;
      case 'closed':
        return BookingStatus.closed;
      case 'cancelled':
      case 'canceled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.bookingCreated;
    }
  }

  String toDbString() {
    switch (this) {
      case BookingStatus.bookingCreated:
        return 'booking_created';
      case BookingStatus.workerSearching:
        return 'worker_searching';
      case BookingStatus.workerAccepted:
        return 'worker_accepted';
      case BookingStatus.workerDeclined:
        return 'worker_declined';
      case BookingStatus.workerOnTheWay:
        return 'worker_on_the_way';
      case BookingStatus.workerArrived:
        return 'worker_arrived';
      case BookingStatus.workStarted:
        return 'work_started';
      case BookingStatus.workInProgress:
        return 'work_in_progress';
      case BookingStatus.workCompleted:
        return 'work_completed';
      case BookingStatus.customerConfirmed:
        return 'customer_confirmed';
      case BookingStatus.closed:
        return 'closed';
      case BookingStatus.cancelled:
        return 'cancelled';
    }
  }

  String get label {
    switch (this) {
      case BookingStatus.bookingCreated:
        return 'Booking Created';
      case BookingStatus.workerSearching:
        return 'Worker Searching';
      case BookingStatus.workerAccepted:
        return 'Worker Accepted';
      case BookingStatus.workerDeclined:
        return 'Worker Declined';
      case BookingStatus.workerOnTheWay:
        return 'Worker On The Way';
      case BookingStatus.workerArrived:
        return 'Worker Arrived';
      case BookingStatus.workStarted:
        return 'Work Started';
      case BookingStatus.workInProgress:
        return 'Work In Progress';
      case BookingStatus.workCompleted:
        return 'Work Completed';
      case BookingStatus.customerConfirmed:
        return 'Customer Confirmed';
      case BookingStatus.closed:
        return 'Closed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  String customerStatusDescription([String? workerName]) {
    final name = workerName != null && workerName.isNotEmpty ? workerName : 'Worker';
    switch (this) {
      case BookingStatus.bookingCreated:
        return 'Your booking has been created and sent to the worker.';
      case BookingStatus.workerSearching:
        return 'Finding and dispatching your cooperative technician...';
      case BookingStatus.workerAccepted:
        return '$name has accepted your work request.';
      case BookingStatus.workerDeclined:
        return 'Worker declined this request.';
      case BookingStatus.workerOnTheWay:
        return '$name is on the way to your location.';
      case BookingStatus.workerArrived:
        return '$name has arrived at your location.';
      case BookingStatus.workStarted:
        return '$name has started the work.';
      case BookingStatus.workInProgress:
        return 'Work is currently in progress.';
      case BookingStatus.workCompleted:
        return 'Work completed. Please inspect and confirm completion.';
      case BookingStatus.customerConfirmed:
        return 'Completion confirmed by customer.';
      case BookingStatus.closed:
        return 'Job completed and closed. Thank you!';
      case BookingStatus.cancelled:
        return 'This booking was cancelled.';
    }
  }

  String get nextWorkerActionLabel {
    switch (this) {
      case BookingStatus.bookingCreated:
      case BookingStatus.workerSearching:
        return 'Accept Work';
      case BookingStatus.workerAccepted:
        return 'Start Journey';
      case BookingStatus.workerOnTheWay:
        return 'Arrived at Site';
      case BookingStatus.workerArrived:
        return 'Start Work';
      case BookingStatus.workStarted:
        return 'Work In Progress';
      case BookingStatus.workInProgress:
        return 'Complete Work';
      case BookingStatus.workCompleted:
        return 'Awaiting Customer Confirmation';
      case BookingStatus.customerConfirmed:
      case BookingStatus.closed:
        return 'Job Closed';
      case BookingStatus.workerDeclined:
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool isValidTransition(BookingStatus next) {
    if (next == BookingStatus.cancelled) return true;
    switch (this) {
      case BookingStatus.bookingCreated:
        return next == BookingStatus.workerSearching ||
            next == BookingStatus.workerAccepted ||
            next == BookingStatus.workerDeclined;
      case BookingStatus.workerSearching:
        return next == BookingStatus.workerAccepted ||
            next == BookingStatus.workerDeclined;
      case BookingStatus.workerAccepted:
        return next == BookingStatus.workerOnTheWay;
      case BookingStatus.workerOnTheWay:
        return next == BookingStatus.workerArrived;
      case BookingStatus.workerArrived:
        return next == BookingStatus.workStarted ||
            next == BookingStatus.workInProgress;
      case BookingStatus.workStarted:
        return next == BookingStatus.workInProgress ||
            next == BookingStatus.workCompleted;
      case BookingStatus.workInProgress:
        return next == BookingStatus.workCompleted;
      case BookingStatus.workCompleted:
        return next == BookingStatus.customerConfirmed ||
            next == BookingStatus.closed;
      case BookingStatus.customerConfirmed:
        return next == BookingStatus.closed;
      case BookingStatus.closed:
      case BookingStatus.workerDeclined:
      case BookingStatus.cancelled:
        return false;
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
  final String workDescription;
  final String requestedDateText;
  final String requestedTimeText;
  final List<String> problemPhotoUrls;
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
  final DateTime? workerAcceptedAt;
  final DateTime? journeyStartedAt;
  final DateTime? arrivedAt;
  final DateTime? workStartedAt;
  final DateTime? workInProgressAt;
  final DateTime? completedAt;
  final DateTime? customerConfirmedAt;
  final DateTime? closedAt;

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
    this.workDescription = '',
    this.requestedDateText = '',
    this.requestedTimeText = '',
    this.problemPhotoUrls = const [],
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
    this.workerAcceptedAt,
    this.journeyStartedAt,
    this.arrivedAt,
    this.workStartedAt,
    this.workInProgressAt,
    this.completedAt,
    this.customerConfirmedAt,
    this.closedAt,
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
    String? workDescription,
    String? requestedDateText,
    String? requestedTimeText,
    List<String>? problemPhotoUrls,
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
    DateTime? workerAcceptedAt,
    DateTime? journeyStartedAt,
    DateTime? arrivedAt,
    DateTime? workStartedAt,
    DateTime? workInProgressAt,
    DateTime? completedAt,
    DateTime? customerConfirmedAt,
    DateTime? closedAt,
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
      workDescription: workDescription ?? this.workDescription,
      requestedDateText: requestedDateText ?? this.requestedDateText,
      requestedTimeText: requestedTimeText ?? this.requestedTimeText,
      problemPhotoUrls: problemPhotoUrls ?? this.problemPhotoUrls,
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
      workerAcceptedAt: workerAcceptedAt ?? this.workerAcceptedAt,
      journeyStartedAt: journeyStartedAt ?? this.journeyStartedAt,
      arrivedAt: arrivedAt ?? this.arrivedAt,
      workStartedAt: workStartedAt ?? this.workStartedAt,
      workInProgressAt: workInProgressAt ?? this.workInProgressAt,
      completedAt: completedAt ?? this.completedAt,
      customerConfirmedAt: customerConfirmedAt ?? this.customerConfirmedAt,
      closedAt: closedAt ?? this.closedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'workerId': workerId,
      'workerName': workerName,
      'workerPhotoUrl': workerPhotoUrl,
      'cooperativeId': cooperativeId,
      'cooperativeName': cooperativeName,
      'serviceCategory': serviceCategory,
      'serviceSubtype': serviceSubtype,
      'workDescription': workDescription,
      'requestedDateText': requestedDateText,
      'requestedTimeText': requestedTimeText,
      'problemPhotoUrls': problemPhotoUrls,
      'status': status.name,
      'scheduledAt': scheduledAt.toIso8601String(),
      'location': {
        'address': location.address,
        'lat': location.lat,
        'lng': location.lng,
      },
      'instructions': instructions,
      'estimatedPrice': estimatedPrice,
      'finalPrice': finalPrice,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'isEmergency': isEmergency,
      'isTeamBooking': isTeamBooking,
      'teamSize': teamSize,
      'workProofPhotos': workProofPhotos,
      'ratingGiven': ratingGiven,
      'reviewComment': reviewComment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'workerAcceptedAt': workerAcceptedAt?.toIso8601String(),
      'journeyStartedAt': journeyStartedAt?.toIso8601String(),
      'arrivedAt': arrivedAt?.toIso8601String(),
      'workStartedAt': workStartedAt?.toIso8601String(),
      'workInProgressAt': workInProgressAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'customerConfirmedAt': customerConfirmedAt?.toIso8601String(),
      'closedAt': closedAt?.toIso8601String(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic d, [DateTime? fallback]) {
      if (d == null) return fallback ?? DateTime.now();
      if (d is DateTime) return d;
      if (d is String) return DateTime.tryParse(d) ?? (fallback ?? DateTime.now());
      return fallback ?? DateTime.now();
    }

    final locMap = map['location'] as Map<String, dynamic>?;
    final bookingLocation = locMap != null
        ? BookingLocation(
            address: locMap['address'] as String? ?? 'Chennai Central Area',
            lat: (locMap['lat'] as num?)?.toDouble() ?? 13.0827,
            lng: (locMap['lng'] as num?)?.toDouble() ?? 80.2707,
          )
        : const BookingLocation(
            address: 'Plot 42, 2nd Avenue, Anna Nagar East',
            lat: 13.0827,
            lng: 80.2707,
          );

    final statusStr = map['status'] as String? ?? 'bookingCreated';
    final parsedStatus = BookingStatus.fromString(statusStr);
    final estPrice = (map['estimatedPrice'] as num?)?.toDouble() ?? 350.0;

    return Booking(
      id: map['id'] as String? ?? 'BK-${DateTime.now().millisecondsSinceEpoch}',
      customerId: map['customerId'] as String? ?? '',
      customerName: map['customerName'] as String? ?? 'Customer',
      customerPhone: map['customerPhone'] as String? ?? '+91 98401 54321',
      workerId: map['workerId'] as String? ?? '',
      workerName: map['workerName'] as String? ?? 'Specialist',
      workerPhotoUrl: map['workerPhotoUrl'] as String? ?? '',
      cooperativeId: map['cooperativeId'] as String? ?? 'coop_anna_nagar',
      cooperativeName: map['cooperativeName'] as String? ??
          'Anna Nagar Electrical & Trades Co-op',
      serviceCategory: map['serviceCategory'] as String? ?? 'Electrician',
      serviceSubtype: map['serviceSubtype'] as String? ?? 'Service Repair',
      workDescription: map['workDescription'] as String? ?? '',
      requestedDateText: map['requestedDateText'] as String? ?? '',
      requestedTimeText: map['requestedTimeText'] as String? ?? '',
      problemPhotoUrls: (map['problemPhotoUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      status: parsedStatus,
      scheduledAt: parseDate(map['scheduledAt']),
      location: bookingLocation,
      instructions: map['instructions'] as String? ?? '',
      estimatedPrice: estPrice,
      finalPrice: (map['finalPrice'] as num?)?.toDouble() ?? estPrice,
      pricing: FairSplitPricing.calculate(estPrice),
      paymentStatus: map['paymentStatus'] as String? ?? 'pending',
      paymentMethod:
          map['paymentMethod'] as String? ?? 'UPI / Cash on Completion',
      isEmergency: map['isEmergency'] as bool? ?? false,
      isTeamBooking: map['isTeamBooking'] as bool? ?? false,
      teamSize: (map['teamSize'] as num?)?.toInt() ?? 1,
      workProofPhotos: (map['workProofPhotos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      ratingGiven: (map['ratingGiven'] as num?)?.toInt(),
      reviewComment: map['reviewComment'] as String?,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
      workerAcceptedAt: map['workerAcceptedAt'] != null
          ? parseDate(map['workerAcceptedAt'])
          : null,
      journeyStartedAt: map['journeyStartedAt'] != null
          ? parseDate(map['journeyStartedAt'])
          : null,
      arrivedAt: map['arrivedAt'] != null ? parseDate(map['arrivedAt']) : null,
      workStartedAt: map['workStartedAt'] != null
          ? parseDate(map['workStartedAt'])
          : null,
      workInProgressAt: map['workInProgressAt'] != null
          ? parseDate(map['workInProgressAt'])
          : null,
      completedAt:
          map['completedAt'] != null ? parseDate(map['completedAt']) : null,
      customerConfirmedAt: map['customerConfirmedAt'] != null
          ? parseDate(map['customerConfirmedAt'])
          : null,
      closedAt: map['closedAt'] != null ? parseDate(map['closedAt']) : null,
    );
  }
}
