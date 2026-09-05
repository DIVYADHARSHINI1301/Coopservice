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
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCancelDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.redDestructive),
            SizedBox(width: 8),
            Text('Cancel Booking?'),
          ],
        ),
        content: Text(
          'Are you sure you want to cancel booking ${booking.id} for ${booking.serviceSubtype}? No cancellation fee applies before dispatch.',
          style: const TextStyle(fontSize: 13, height: 1.3),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(platformRepositoryProvider).updateBookingStatus(
                    booking.id,
                    BookingStatus.cancelled,
                  );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking ${booking.id} cancelled.'),
                  backgroundColor: AppColors.redDestructive,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redDestructive,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Confirm Cancel'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context, Booking booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(booking.workerPhotoUrl.isNotEmpty
                      ? booking.workerPhotoUrl
                      : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.workerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen,
                        ),
                      ),
                      Text(
                        '${booking.serviceCategory} • ${booking.cooperativeName}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.frostedMint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone, color: AppColors.seaGreen),
              ),
              title: const Text('Direct Voice Call',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Connect with assigned technician'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling ${booking.workerName}...'),
                    backgroundColor: AppColors.seaGreen,
                  ),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chat, color: Color(0xFF16A34A)),
              ),
              title: const Text('WhatsApp Guild Coordinator',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Local dispatch support desk'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening WhatsApp Guild Helpdesk...'),
                    backgroundColor: AppColors.seaGreen,
                  ),
                );
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
    final allBookings = repo.allBookings;

    final upcoming = allBookings
        .where((b) =>
            b.status == BookingStatus.bookingCreated ||
            b.status == BookingStatus.workerSearching ||
            b.status == BookingStatus.workerAccepted ||
            b.status == BookingStatus.requested ||
            b.status == BookingStatus.accepted)
        .toList();

    final ongoing = allBookings
        .where((b) =>
            b.status == BookingStatus.workerOnTheWay ||
            b.status == BookingStatus.workerArrived ||
            b.status == BookingStatus.workStarted ||
            b.status == BookingStatus.workInProgress ||
            b.status == BookingStatus.onTheWay ||
            b.status == BookingStatus.arrived ||
            b.status == BookingStatus.inProgress)
        .toList();

    final completed = allBookings
        .where((b) =>
            b.status == BookingStatus.workCompleted ||
            b.status == BookingStatus.customerConfirmed ||
            b.status == BookingStatus.closed ||
            b.status == BookingStatus.completed)
        .toList();

    final cancelled = allBookings
        .where((b) =>
            b.status == BookingStatus.cancelled ||
            b.status == BookingStatus.workerDeclined)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF9),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'My Cooperative Bookings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppColors.mintLeaf,
          indicatorWeight: 3,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.celadon.withOpacity(0.7),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(text: 'All (${allBookings.length})'),
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
          _buildBookingList(allBookings, 'No bookings in your account yet.'),
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.frostedMint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long,
                    size: 42, color: AppColors.seaGreen),
              ),
              const SizedBox(height: 16),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.workerDiscovery),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.seaGreen,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Explore Cooperative Services'),
              ),
            ],
          ),
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
    final canCancel = booking.status == BookingStatus.bookingCreated ||
        booking.status == BookingStatus.workerSearching ||
        booking.status == BookingStatus.workerAccepted ||
        booking.status == BookingStatus.requested ||
        booking.status == BookingStatus.accepted;
    final isCompleted = booking.status == BookingStatus.workCompleted ||
        booking.status == BookingStatus.customerConfirmed ||
        booking.status == BookingStatus.closed ||
        booking.status == BookingStatus.completed;

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
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Booking ID, Category & Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${booking.id}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.seaGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.serviceCategory,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge(
                  label: booking.status.label,
                  status: isCompleted
                      ? BadgeStatus.completed
                      : (booking.status == BookingStatus.cancelled ||
                              booking.status == BookingStatus.workerDeclined
                          ? BadgeStatus.rejected
                          : BadgeStatus.active),
                  fontSize: 10,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Service Subtype
            Text(
              booking.serviceSubtype,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.darkEmerald,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (booking.workDescription.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                booking.workDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 6),

            // Worker & Guild
            Row(
              children: [
                Icon(
                  booking.isTeamBooking ? Icons.groups : Icons.person,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${booking.workerName} • ${booking.cooperativeName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            if (booking.requestedDateText.isNotEmpty ||
                booking.requestedTimeText.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.schedule,
                      size: 13, color: AppColors.seaGreen),
                  const SizedBox(width: 4),
                  Text(
                    '${booking.requestedDateText} (${booking.requestedTimeText})',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.evergreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
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
                const SizedBox(width: 8),
                Flexible(
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      // Contact Button
                      IconButton(
                        icon: const Icon(Icons.phone_in_talk,
                            size: 18, color: AppColors.darkEmerald),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.frostedMint,
                          padding: const EdgeInsets.all(8),
                          minimumSize: Size.zero,
                        ),
                        onPressed: () => _showContactDialog(context, booking),
                      ),

                      // Track & Details
                      ElevatedButton(
                        onPressed: () {
                          context.push(
                            AppRoutes.activeBookingTracking,
                            extra: booking,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.seaGreen,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Live Track',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold)),
                      ),

                      // Cancel if pending
                      if (canCancel)
                        OutlinedButton(
                          onPressed: () => _showCancelDialog(context, booking),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.redDestructive,
                            side: const BorderSide(color: Color(0xFFFCA5A5)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                          child:
                              const Text('Cancel', style: TextStyle(fontSize: 11)),
                        ),

                      // Rate button if completed and unrated
                      if (isCompleted && booking.ratingGiven == null)
                        OutlinedButton(
                          onPressed: () {
                            context.push(
                              AppRoutes.activeBookingTracking,
                              extra: booking,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.seaGreen),
                            foregroundColor: AppColors.seaGreen,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                          child: const Text('Confirm/Rate',
                              style: TextStyle(fontSize: 11)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
