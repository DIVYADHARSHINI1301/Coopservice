import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/interactive_map_widget.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/fair_split_pricing_card.dart';

class ActiveBookingTrackingScreen extends ConsumerStatefulWidget {
  final Booking booking;

  const ActiveBookingTrackingScreen({super.key, required this.booking});

  @override
  ConsumerState<ActiveBookingTrackingScreen> createState() =>
      _ActiveBookingTrackingScreenState();
}

class _ActiveBookingTrackingScreenState
    extends ConsumerState<ActiveBookingTrackingScreen> {
  int _selectedRating = 5;
  final TextEditingController _reviewCommentController =
      TextEditingController(text: 'Work completed very cleanly and promptly!');
  bool _isConfirming = false;

  @override
  void dispose() {
    _reviewCommentController.dispose();
    super.dispose();
  }

  void _confirmJobCompletion(Booking booking) async {
    setState(() => _isConfirming = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final repo = ref.read(platformRepositoryProvider);
    repo.confirmCustomerCompletion(
      booking.id,
      rating: _selectedRating,
      reviewComment: _reviewCommentController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isConfirming = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.frostedMint,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified,
                  size: 48, color: AppColors.seaGreen),
            ),
            const SizedBox(height: 14),
            Text(
              'Job Confirmed & Closed!',
              style: AppTypography.headlineSmall(color: AppColors.darkEmerald),
            ),
            const SizedBox(height: 8),
            Text(
              'Thank you for confirming. Direct earnings of ₹${booking.pricing.workerDirectEarnings.toInt()} have been released to ${booking.workerName}.',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 18),
            CustomButton(
              text: 'Done',
              onPressed: () {
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final activeBooking = repo.allBookings.firstWhere(
      (b) => b.id == widget.booking.id,
      orElse: () => widget.booking,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activeBooking.groupSplit != null
                  ? 'Society Split Dispatch'
                  : (activeBooking.isTeamBooking
                      ? 'Co-op Team Dispatch'
                      : 'Live Work Tracking'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '#${activeBooking.id} • ${activeBooking.serviceCategory}',
              style: const TextStyle(fontSize: 11, color: AppColors.celadon),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            tooltip: 'Live Reactive (Auto-updating)',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connected to live cooperative dispatch network.'),
                  duration: Duration(seconds: 1),
                  backgroundColor: AppColors.seaGreen,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Status Banner
            _buildStatusHeaderBanner(activeBooking),
            const SizedBox(height: 16),

            // Live Route / Map
            InteractiveMapWidget(
              height: 190,
              showLiveRoute:
                  activeBooking.status == BookingStatus.workerOnTheWay ||
                      activeBooking.status == BookingStatus.onTheWay,
            ),
            const SizedBox(height: 16),

            // Customer Confirmation Card (Prominent when worker completes work)
            if (activeBooking.status == BookingStatus.workCompleted ||
                activeBooking.status == BookingStatus.completed) ...[
              _buildCustomerConfirmationCard(activeBooking),
              const SizedBox(height: 16),
            ],

            // 10-Stage Real-Time Vertical Timeline
            _build10StageTimelineCard(activeBooking),
            const SizedBox(height: 16),

            // Assigned Worker / Team Profile Card
            if (activeBooking.isTeamBooking &&
                activeBooking.assignedWorkers.isNotEmpty)
              _buildTeamAssignedCard(activeBooking)
            else
              _buildSingleWorkerCard(context, activeBooking),
            const SizedBox(height: 16),

            // Work Description & Problem Photos
            _buildWorkDetailsCard(activeBooking),
            const SizedBox(height: 16),

            // Work-Proof Photos (if uploaded by worker)
            if (activeBooking.workProofPhotos.isNotEmpty) ...[
              _buildWorkProofCard(activeBooking),
              const SizedBox(height: 16),
            ],

            // Digital Job Card Action Banner (if closed / completed)
            if (activeBooking.status == BookingStatus.closed ||
                activeBooking.status == BookingStatus.customerConfirmed ||
                activeBooking.jobCard != null) ...[
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.push(AppRoutes.customerVault),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.pineTeal, AppColors.evergreen],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.folder_special,
                          color: AppColors.mintLeaf, size: 28),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Certified Digital Job Card Available',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              'View materials used, before/after photos & 90-day guarantee',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.frostedMint,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AppColors.mintLeaf),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Per-Booking Transparent Fund Breakdown Card
            FairSplitPricingCard(pricing: activeBooking.pricing),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeaderBanner(Booking booking) {
    Color bgGradient1;
    Color bgGradient2;
    IconData statusIcon;

    switch (booking.status) {
      case BookingStatus.bookingCreated:
      case BookingStatus.workerSearching:
        bgGradient1 = const Color(0xFF0D9488);
        bgGradient2 = AppColors.darkEmerald;
        statusIcon = Icons.hourglass_top;
        break;
      case BookingStatus.workerAccepted:
        bgGradient1 = const Color(0xFF059669);
        bgGradient2 = AppColors.evergreen;
        statusIcon = Icons.thumb_up_alt;
        break;
      case BookingStatus.workerOnTheWay:
        bgGradient1 = const Color(0xFF0284C7);
        bgGradient2 = const Color(0xFF0369A1);
        statusIcon = Icons.directions_bike;
        break;
      case BookingStatus.workerArrived:
        bgGradient1 = const Color(0xFFD97706);
        bgGradient2 = const Color(0xFFB45309);
        statusIcon = Icons.location_on;
        break;
      case BookingStatus.workStarted:
      case BookingStatus.workInProgress:
        bgGradient1 = const Color(0xFF2563EB);
        bgGradient2 = const Color(0xFF1D4ED8);
        statusIcon = Icons.engineering;
        break;
      case BookingStatus.workCompleted:
        bgGradient1 = const Color(0xFF16A34A);
        bgGradient2 = const Color(0xFF15803D);
        statusIcon = Icons.assignment_turned_in;
        break;
      case BookingStatus.customerConfirmed:
      case BookingStatus.closed:
        bgGradient1 = AppColors.darkEmerald;
        bgGradient2 = const Color(0xFF064E3B);
        statusIcon = Icons.verified;
        break;
      case BookingStatus.workerDeclined:
      case BookingStatus.cancelled:
        bgGradient1 = const Color(0xFFDC2626);
        bgGradient2 = const Color(0xFF991B1B);
        statusIcon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [bgGradient1, bgGradient2]),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.evergreen.withOpacity(0.16),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: AppColors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      booking.status.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'LIVE',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  booking.status.customerStatusDescription(booking.workerName),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.celadon,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerConfirmationCard(Booking booking) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.seaGreen, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.seaGreen.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.frostedMint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified,
                    color: AppColors.seaGreen, size: 22),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Work Completed! Customer Confirmation Required',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkEmerald,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${booking.workerName} has completed the service. Please inspect the finished work and rate the experience to release payout and close the job.',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),

          // Rating Stars
          Row(
            children: [
              const Text(
                'Rate Experience:',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.evergreen),
              ),
              const SizedBox(width: 8),
              Row(
                children: List.generate(5, (index) {
                  final star = index + 1;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRating = star),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Icon(
                        Icons.star,
                        size: 24,
                        color: star <= _selectedRating
                            ? AppColors.amberWarning
                            : AppColors.celadon,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Feedback comment input
          TextField(
            controller: _reviewCommentController,
            decoration: InputDecoration(
              hintText: 'Share a note about the technician’s craft and timeliness',
              hintStyle:
                  const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              fillColor: const Color(0xFFF9FAFB),
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.celadon),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Confirmation and Dispute buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomButton(
                  text: 'Confirm Completion',
                  isLoading: _isConfirming,
                  trailingIcon: Icons.check,
                  onPressed: () => _confirmJobCompletion(booking),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _showReportIssueDialog(context, booking),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.redDestructive,
                  side: const BorderSide(color: Color(0xFFFCA5A5)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                child: const Text('Issue?', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReportIssueDialog(BuildContext context, Booking booking) {
    final issueController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.report_problem, color: AppColors.amberWarning),
            SizedBox(width: 8),
            Text('Report Service Issue'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'If the service was incomplete or needs a revisit by ${booking.workerName}, let the cooperative know:',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: issueController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Describe what needs adjustment or fixing...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Issue reported to Cooperative Guild Coordinator for immediate mediation.'),
                  backgroundColor: AppColors.seaGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.seaGreen,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Submit to Guild'),
          ),
        ],
      ),
    );
  }

  Widget _build10StageTimelineCard(Booking booking) {
    // 10 stages in operational order
    final stages = [
      _StageInfo(
        status: BookingStatus.bookingCreated,
        title: 'Booking Created',
        subtitle: 'Request dispatched to worker and cooperative cluster',
        timestamp: booking.createdAt,
      ),
      _StageInfo(
        status: BookingStatus.workerSearching,
        title: 'Technician Searching & Assignment',
        subtitle: 'Designated cooperative technician alert triggered',
        timestamp: booking.createdAt,
      ),
      _StageInfo(
        status: BookingStatus.workerAccepted,
        title: 'Worker Accepted',
        subtitle: '${booking.workerName} confirmed job acceptance',
        timestamp: booking.workerAcceptedAt,
      ),
      _StageInfo(
        status: BookingStatus.workerOnTheWay,
        title: 'Worker On The Way',
        subtitle: 'Technician en-route with safety tooling equipment',
        timestamp: booking.journeyStartedAt,
      ),
      _StageInfo(
        status: BookingStatus.workerArrived,
        title: 'Worker Arrived',
        subtitle: 'Technician arrived at service premises',
        timestamp: booking.arrivedAt,
      ),
      _StageInfo(
        status: BookingStatus.workStarted,
        title: 'Work Started',
        subtitle: 'Diagnostics & repair work in active execution',
        timestamp: booking.workStartedAt,
      ),
      _StageInfo(
        status: BookingStatus.workInProgress,
        title: 'Work In Progress',
        subtitle: 'Active assembly, testing, and component fitting',
        timestamp: booking.workInProgressAt,
      ),
      _StageInfo(
        status: BookingStatus.workCompleted,
        title: 'Work Completed',
        subtitle: 'Technician finished repair; ready for customer inspection',
        timestamp: booking.completedAt,
      ),
      _StageInfo(
        status: BookingStatus.customerConfirmed,
        title: 'Customer Confirmed',
        subtitle: 'Work inspected and completion signed off',
        timestamp: booking.customerConfirmedAt,
      ),
      _StageInfo(
        status: BookingStatus.closed,
        title: 'Job Closed & Settled',
        subtitle: 'Zero-commission fair payout processed to worker wallet',
        timestamp: booking.closedAt,
      ),
    ];

    final currentStageOrder = _getStatusStageOrder(booking.status);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.celadon),
        boxShadow: [
          BoxShadow(
            color: AppColors.evergreen.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Live Work Progress Timeline',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              StatusBadge(
                label: 'Step ${currentStageOrder + 1} of 10',
                status: currentStageOrder >= 7
                    ? BadgeStatus.completed
                    : BadgeStatus.onTheWay,
                fontSize: 10,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(stages.length, (index) {
            final stage = stages[index];
            final isCompleted = index < currentStageOrder;
            final isCurrent = index == currentStageOrder;
            final isLast = index == stages.length - 1;

            return _buildTimelineRow(
              stage: stage,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  int _getStatusStageOrder(BookingStatus status) {
    switch (status) {
      case BookingStatus.bookingCreated:
        return 0;
      case BookingStatus.workerSearching:
        return 1;
      case BookingStatus.workerAccepted:
        return 2;
      case BookingStatus.workerOnTheWay:
        return 3;
      case BookingStatus.workerArrived:
        return 4;
      case BookingStatus.workStarted:
        return 5;
      case BookingStatus.workInProgress:
        return 6;
      case BookingStatus.workCompleted:
        return 7;
      case BookingStatus.customerConfirmed:
        return 8;
      case BookingStatus.closed:
        return 9;
      case BookingStatus.workerDeclined:
      case BookingStatus.cancelled:
        return 0;
    }
  }

  Widget _buildTimelineRow({
    required _StageInfo stage,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
  }) {
    Color circleColor;
    Widget icon;

    if (isCompleted) {
      circleColor = AppColors.seaGreen;
      icon = const Icon(Icons.check, size: 12, color: AppColors.white);
    } else if (isCurrent) {
      circleColor = AppColors.seaGreen;
      icon = Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
      );
    } else {
      circleColor = AppColors.celadon.withOpacity(0.5);
      icon = Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column with dot and connector line
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: AppColors.seaGreen.withOpacity(0.4),
                            blurRadius: 6,
                            spreadRadius: 2,
                          )
                        ]
                      : null,
                ),
                child: Center(child: icon),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? AppColors.seaGreen : AppColors.celadon,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stage.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isCurrent || isCompleted
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isCurrent
                              ? AppColors.darkEmerald
                              : (isCompleted
                                  ? AppColors.evergreen
                                  : AppColors.textSecondary),
                        ),
                      ),
                      if (stage.timestamp != null && (isCompleted || isCurrent))
                        Text(
                          _formatTime(stage.timestamp!),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.seaGreen,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stage.subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isCurrent
                          ? AppColors.evergreen
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Widget _buildWorkDetailsCard(Booking booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Work Scope & Problem Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.darkEmerald,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            booking.serviceSubtype,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.evergreen,
            ),
          ),
          if (booking.workDescription.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.celadon.withOpacity(0.5)),
              ),
              child: Text(
                booking.workDescription,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
            ),
          ],
          if (booking.requestedDateText.isNotEmpty ||
              booking.requestedTimeText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.event, size: 14, color: AppColors.seaGreen),
                const SizedBox(width: 6),
                Text(
                  '${booking.requestedDateText} • ${booking.requestedTimeText}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.evergreen,
                  ),
                ),
              ],
            ),
          ],
          if (booking.problemPhotoUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Customer Attached Photos:',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Row(
              children: booking.problemPhotoUrls
                  .map((url) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.celadon),
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
          const SizedBox(height: 10),
          const Divider(color: AppColors.celadon),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: AppColors.seaGreen),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  booking.location.address,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkProofCard(Booking booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Technician Work-Proof Photos',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              StatusBadge(
                label: 'Verified by Guild',
                status: BadgeStatus.skillVerified,
                fontSize: 10,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: booking.workProofPhotos
                .map((url) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.seaGreen),
                        image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleWorkerCard(BuildContext context, Booking b) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(b.workerPhotoUrl.isNotEmpty
                ? b.workerPhotoUrl
                : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.workerName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.evergreen,
                  ),
                ),
                Text(
                  '${b.serviceCategory} • ${b.cooperativeName}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.phone, color: AppColors.seaGreen),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Connecting phone call to ${b.workerName}...'),
                  backgroundColor: AppColors.seaGreen,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeamAssignedCard(Booking b) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Assigned Cooperative Team (${b.teamSize} Members)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              StatusBadge(
                label: b.cooperativeName,
                status: BadgeStatus.coopOwner,
                fontSize: 10,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...b.assignedWorkers.map((worker) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(worker.photoUrl.isNotEmpty
                        ? worker.photoUrl
                        : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          worker.workerName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        Text(
                          worker.role,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone,
                        color: AppColors.seaGreen, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StageInfo {
  final BookingStatus status;
  final String title;
  final String subtitle;
  final DateTime? timestamp;

  _StageInfo({
    required this.status,
    required this.title,
    required this.subtitle,
    this.timestamp,
  });
}
