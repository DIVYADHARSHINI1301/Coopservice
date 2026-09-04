import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/widgets/interactive_map_widget.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/fair_split_pricing_card.dart';

class ActiveBookingTrackingScreen extends ConsumerWidget {
  final Booking booking;

  const ActiveBookingTrackingScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final activeBooking = repo.allBookings.firstWhere(
      (b) => b.id == booking.id,
      orElse: () => booking,
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
                      : 'Live Booking Tracking'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '${activeBooking.id} • ${activeBooking.serviceCategory}',
              style: const TextStyle(fontSize: 11, color: AppColors.celadon),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Tracking Map
            InteractiveMapWidget(
              height: 200,
              showLiveRoute: activeBooking.status == BookingStatus.onTheWay,
            ),
            const SizedBox(height: 16),

            // Status Progress Card
            Container(
              padding: const EdgeInsets.all(18),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeBooking.status.label,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkEmerald,
                            ),
                          ),
                          const Text(
                            'Estimated Arrival: In 15 minutes',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      StatusBadge(
                        label: activeBooking.status.label,
                        status: activeBooking.status == BookingStatus.completed
                            ? BadgeStatus.completed
                            : BadgeStatus.onTheWay,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Timeline Step Indicator
                  _buildTimeline(activeBooking.status),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Society Split Details (if group booking)
            if (activeBooking.groupSplit != null) ...[
              _buildSocietySplitCard(activeBooking.groupSplit!),
              const SizedBox(height: 16),
            ],

            // Assigned Team vs Individual Worker Card
            if (activeBooking.isTeamBooking &&
                activeBooking.assignedWorkers.isNotEmpty)
              _buildTeamAssignedCard(activeBooking)
            else
              _buildSingleWorkerCard(context, activeBooking),

            const SizedBox(height: 16),

            // Digital Job Card Action Banner (if completed or has job card)
            if (activeBooking.status == BookingStatus.completed ||
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

            const SizedBox(height: 16),

            // Service Details Card
            Container(
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
                    'Work Scope & Location',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    activeBooking.serviceSubtype,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.evergreen,
                    ),
                  ),
                  if (activeBooking.instructions.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Notes: "${activeBooking.instructions}"',
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
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
                          activeBooking.location.address,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocietySplitCard(GroupBookingSplit split) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.mintLeaf2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Society Split: ${split.societyName}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              StatusBadge(
                label: 'Code: ${split.groupCode}',
                status: BadgeStatus.skillVerified,
                fontSize: 10,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${split.paidMemberNames.length} of ${split.totalParticipants} flats contributed (₹${split.splitAmountPerMember.toInt()} per flat)',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: split.paidMemberNames.length / split.totalParticipants,
            backgroundColor: AppColors.celadon,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.seaGreen),
          ),
          const SizedBox(height: 8),
          ...split.paidMemberNames.map((name) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: AppColors.seaGreen, size: 14),
                    const SizedBox(width: 6),
                    Text(name,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.evergreen)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTimeline(BookingStatus current) {
    final steps = [
      BookingStatus.requested,
      BookingStatus.accepted,
      BookingStatus.onTheWay,
      BookingStatus.arrived,
      BookingStatus.inProgress,
      BookingStatus.completed,
    ];

    final currentIndex = steps.indexOf(current);

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final stepIndex = index ~/ 2;
          final isDone = stepIndex < currentIndex;
          return Expanded(
            child: Container(
              height: 3,
              color: isDone ? AppColors.seaGreen : AppColors.celadon,
            ),
          );
        } else {
          final stepIndex = index ~/ 2;
          final isDone = stepIndex <= currentIndex;
          return Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? AppColors.seaGreen : AppColors.white,
              border: Border.all(
                color: isDone ? AppColors.seaGreen : AppColors.celadon,
                width: 2,
              ),
            ),
          );
        }
      }),
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
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
