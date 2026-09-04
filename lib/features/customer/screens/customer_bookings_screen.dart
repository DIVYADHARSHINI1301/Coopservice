import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/widgets/status_badge.dart';

class CustomerBookingsScreen extends ConsumerStatefulWidget {
  const CustomerBookingsScreen({super.key});

  @override
  ConsumerState<CustomerBookingsScreen> createState() =>
      _CustomerBookingsScreenState();
}

class _CustomerBookingsScreenState extends ConsumerState<CustomerBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final allBookings = repo.allBookings;

    final upcoming = allBookings
        .where((b) =>
            b.status == BookingStatus.requested ||
            b.status == BookingStatus.accepted)
        .toList();

    final ongoing = allBookings
        .where((b) =>
            b.status == BookingStatus.onTheWay ||
            b.status == BookingStatus.arrived ||
            b.status == BookingStatus.inProgress)
        .toList();

    final completed = allBookings
        .where((b) => b.status == BookingStatus.completed)
        .toList();

    final cancelled = allBookings
        .where((b) => b.status == BookingStatus.cancelled)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'My Cooperative Bookings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.mintLeaf,
          indicatorWeight: 3,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.celadon.withOpacity(0.7),
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(text: 'Upcoming (${upcoming.length})'),
            Tab(text: 'Ongoing (${ongoing.length})'),
            Tab(text: 'Completed (${completed.length})'),
            Tab(text: 'Cancelled (${cancelled.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(upcoming, 'No upcoming bookings.'),
          _buildBookingList(ongoing, 'No active ongoing bookings right now.'),
          _buildBookingList(completed, 'No completed bookings yet.'),
          _buildBookingList(cancelled, 'No cancelled bookings.'),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<Booking> list, String emptyMessage) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long, size: 48, color: AppColors.celadon),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final b = list[index];
        return _buildBookingCard(context, b);
      },
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.celadon),
        boxShadow: [
          BoxShadow(
            color: AppColors.evergreen.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Booking ID, Category & Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.id,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.seaGreen,
                      ),
                    ),
                    Text(
                      booking.serviceCategory,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.evergreen,
                      ),
                    ),
                  ],
                ),
                StatusBadge(
                  label: booking.status.label,
                  status: booking.status == BookingStatus.completed
                      ? BadgeStatus.completed
                      : (booking.status == BookingStatus.cancelled
                          ? BadgeStatus.rejected
                          : BadgeStatus.active),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Service Subtype & Worker/Team
            Text(
              booking.serviceSubtype,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.darkEmerald,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  booking.isTeamBooking ? Icons.groups : Icons.person,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${booking.workerName} • ${booking.cooperativeName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.celadon),
            const SizedBox(height: 10),

            // Price & Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Fair Price',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '₹${booking.finalPrice.toInt()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.seaGreen,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        context.push(
                          AppRoutes.activeBookingTracking,
                          extra: booking,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                      ),
                      child: const Text('Track & Details',
                          style: TextStyle(fontSize: 12)),
                    ),
                    if (booking.status == BookingStatus.completed &&
                        booking.ratingGiven == null) ...[
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          context.push(
                            AppRoutes.ratingReview,
                            extra: booking,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.seaGreen,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                        ),
                        child:
                            const Text('Rate', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
