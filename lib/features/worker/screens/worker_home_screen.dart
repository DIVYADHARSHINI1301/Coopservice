import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/widgets/status_badge.dart';
import 'worker_welfare_screen.dart';

class WorkerHomeScreen extends ConsumerWidget {
  const WorkerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final user = repo.currentUser;
    final worker = repo.allWorkers.firstWhere(
      (w) => w.uid == user.uid,
      orElse: () => repo.allWorkers.first,
    );
    final coop = repo.allCooperatives.firstWhere(
      (c) => c.id == worker.cooperativeId,
      orElse: () => repo.allCooperatives.first,
    );
    final bookings =
        repo.allBookings.where((b) => b.workerId == worker.uid).toList();
    final requestedBookings =
        bookings.where((b) => b.status == BookingStatus.requested).toList();
    final activeBookings = bookings
        .where((b) =>
            b.status == BookingStatus.accepted ||
            b.status == BookingStatus.onTheWay ||
            b.status == BookingStatus.arrived ||
            b.status == BookingStatus.inProgress)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              worker.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '${worker.primaryCategory} • ${worker.cooperativeName}',
              style: const TextStyle(fontSize: 11, color: AppColors.celadon),
            ),
          ],
        ),
        actions: [
          // Online / Offline Switch
          Row(
            children: [
              Text(
                worker.online ? 'ONLINE' : 'OFFLINE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: worker.online
                      ? AppColors.frostedMint
                      : AppColors.white.withOpacity(0.6),
                ),
              ),
              Switch(
                value: worker.online,
                activeColor: AppColors.mintLeaf2,
                onChanged: (val) {
                  repo.toggleWorkerOnline(worker.uid, val);
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Good Day" Dashboard Hero
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.pineTeal, AppColors.evergreen],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.evergreen.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
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
                            'Good Day, ${worker.name.split(' ').first}! ⚡',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          const Text(
                            'Anna Nagar Co-op • Certified Member',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.celadon,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: worker.online
                              ? AppColors.seaGreen
                              : AppColors.redDestructive.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          worker.online ? 'Accepting Jobs' : 'On Break',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _dashMetric('Today\'s Payout',
                          '₹${worker.earnings.today.toInt()}'),
                      _dashMetric('This Week',
                          '₹${worker.earnings.week.toInt()}'),
                      _dashMetric('Rating', '★ ${worker.rating}'),
                      _dashMetric(
                          'Jobs Done', '${worker.completedJobsCount}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Incoming Request Alert Banner (if any)
            if (requestedBookings.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.pineTeal,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.evergreen.withOpacity(0.2),
                      blurRadius: 10,
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
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.amberWarning,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'NEW SERVICE DISPATCH REQUEST',
                          style: TextStyle(
                            color: AppColors.celadon,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      requestedBookings.first.serviceSubtype,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Client: ${requestedBookings.first.customerName} • ${requestedBookings.first.location.address}',
                      style: const TextStyle(
                        color: AppColors.frostedMint,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              repo.updateBookingStatus(
                                requestedBookings.first.id,
                                BookingStatus.cancelled,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.white,
                              side: const BorderSide(color: AppColors.celadon),
                            ),
                            child: const Text('Decline'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              repo.updateBookingStatus(
                                requestedBookings.first.id,
                                BookingStatus.accepted,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.seaGreen,
                              foregroundColor: AppColors.white,
                            ),
                            child: Text('Accept Job (₹${requestedBookings.first.finalPrice.toInt()})'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // "My Cooperative" Quick Access Panel
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () =>
                  context.push(AppRoutes.cooperativeProfile, extra: coop),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.celadon),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(coop.logoUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MY HOME COOPERATIVE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: AppColors.darkEmerald,
                            ),
                          ),
                          Text(
                            coop.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.evergreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.seaGreen),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Active / Ongoing Jobs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Active Jobs in Queue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkEmerald,
                  ),
                ),
                Text(
                  '${activeBookings.length} Active',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.seaGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (activeBookings.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.celadon),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 36, color: AppColors.seaGreen),
                    SizedBox(height: 8),
                    Text(
                      'No active jobs right now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.evergreen,
                      ),
                    ),
                    Text(
                      'Turn your switch ONLINE above to receive neighborhood dispatch requests.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...activeBookings.map((b) => _buildActiveJobCard(context, ref, b)),

            const SizedBox(height: 20),

            // Fair Co-op Wage Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.frostedMint.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.celadon),
              ),
              child: const Row(
                children: [
                  Icon(Icons.volunteer_activism,
                      color: AppColors.seaGreen, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Zero Commission Cooperative Policy',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkEmerald,
                          ),
                        ),
                        Text(
                          'You receive ~85% directly on job completion. 12% is held in your health fund & tooling dividends.',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.evergreen,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashMetric(String title, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 10, color: AppColors.celadon),
        ),
        Text(
          val,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveJobCard(
      BuildContext context, WidgetRef ref, Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.id,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.seaGreen,
                ),
              ),
              StatusBadge(
                label: booking.status.label,
                status: BadgeStatus.onTheWay,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            booking.serviceSubtype,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.evergreen,
            ),
          ),
          Text(
            'Client: ${booking.customerName} • ${booking.location.address}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.push(AppRoutes.workerJobDetail, extra: booking);
                  },
                  child: const Text('Job Console'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _advanceJobStatus(ref, booking);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.seaGreen,
                    foregroundColor: AppColors.white,
                  ),
                  child: Text(booking.status.nextWorkerActionLabel,
                      style: const TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _advanceJobStatus(WidgetRef ref, Booking b) {
    final repo = ref.read(platformRepositoryProvider);
    switch (b.status) {
      case BookingStatus.requested:
        repo.updateBookingStatus(b.id, BookingStatus.accepted);
        break;
      case BookingStatus.accepted:
        repo.updateBookingStatus(b.id, BookingStatus.onTheWay);
        break;
      case BookingStatus.onTheWay:
        repo.updateBookingStatus(b.id, BookingStatus.arrived);
        break;
      case BookingStatus.arrived:
        repo.updateBookingStatus(b.id, BookingStatus.inProgress);
        break;
      case BookingStatus.inProgress:
        repo.updateBookingStatus(b.id, BookingStatus.completed);
        break;
      default:
        break;
    }
  }
}
