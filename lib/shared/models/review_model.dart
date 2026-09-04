class Review {
  final String id;
  final String bookingId;
  final String customerId;
  final String customerName;
  final String workerId;
  final String? cooperativeId;
  final double rating;
  final double professionalism;
  final double serviceQuality;
  final double coordination;
  final String comment;
  final List<String> tags;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.bookingId,
    required this.customerId,
    required this.customerName,
    required this.workerId,
    this.cooperativeId,
    required this.rating,
    this.professionalism = 5.0,
    this.serviceQuality = 5.0,
    this.coordination = 5.0,
    required this.comment,
    this.tags = const [],
    required this.createdAt,
  });
}

class DisputeItem {
  final String id;
  final String bookingId;
  final String customerId;
  final String customerName;
  final String workerOrCoopName;
  final String reason;
  final double disputedAmount;
  final String status; // 'open', 'in_mediation', 'resolved', 'refunded'
  final String? resolutionNotes;
  final DateTime createdAt;

  const DisputeItem({
    required this.id,
    required this.bookingId,
    required this.customerId,
    required this.customerName,
    required this.workerOrCoopName,
    required this.reason,
    required this.disputedAmount,
    this.status = 'open',
    this.resolutionNotes,
    required this.createdAt,
  });

  DisputeItem copyWith({
    String? id,
    String? bookingId,
    String? customerId,
    String? customerName,
    String? workerOrCoopName,
    String? reason,
    double? disputedAmount,
    String? status,
    String? resolutionNotes,
    DateTime? createdAt,
  }) {
    return DisputeItem(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      workerOrCoopName: workerOrCoopName ?? this.workerOrCoopName,
      reason: reason ?? this.reason,
      disputedAmount: disputedAmount ?? this.disputedAmount,
      status: status ?? this.status,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AuditLog {
  final String id;
  final String actorId;
  final String actorName;
  final String actorRole;
  final String action;
  final String targetId;
  final String targetType;
  final String before;
  final String after;
  final DateTime timestamp;

  const AuditLog({
    required this.id,
    required this.actorId,
    required this.actorName,
    required this.actorRole,
    required this.action,
    required this.targetId,
    required this.targetType,
    required this.before,
    required this.after,
    required this.timestamp,
  });
}

class CategoryDemand {
  final String category;
  final int currentDemand;
  final int predictedDemand;
  final double percentageChange;
  final String recommendedAction;

  const CategoryDemand({
    required this.category,
    required this.currentDemand,
    required this.predictedDemand,
    required this.percentageChange,
    required this.recommendedAction,
  });
}

class ForecastData {
  final String date;
  final List<CategoryDemand> categoryDemands;
  final List<String> highDemandAreas;
  final List<String> aiRecommendations;

  const ForecastData({
    required this.date,
    required this.categoryDemands,
    required this.highDemandAreas,
    required this.aiRecommendations,
  });
}
