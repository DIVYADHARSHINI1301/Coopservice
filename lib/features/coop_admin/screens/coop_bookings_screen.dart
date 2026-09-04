import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/widgets/status_badge.dart';
import 'coop_job_assignment_screen.dart';

class CoopBookingsScreen extends ConsumerWidget {
  const CoopBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final bookings = repo.allBookings;

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.pineTeal,
        title: Text(
          'Guild Bookings Monitor (${bookings.length})',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final b = bookings[index];
          return Container(
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
                      '#${b.id} • ${b.serviceSubtype}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    StatusBadge(
                      label: b.status.label,
                      status: b.status.name == 'completed'
                          ? BadgeStatus.completed
                          : BadgeStatus.onTheWay,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Customer: ${b.customerName} → Worker/Team: ${b.workerName}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                Text(
                  'Address: ${b.location.address}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                if (b.isTeamBooking) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.groups,
                          size: 14, color: AppColors.seaGreen),
                      const SizedBox(width: 4),
                      Text(
                        'Team Booking (${b.assignedWorkers.length}/${b.teamSize} members assigned)',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.seaGreen,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price: ₹${b.finalPrice.toInt()} (${b.paymentStatus.toUpperCase()})',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkEmerald,
                      ),
                    ),
                    Row(
                      children: [
                        if (b.isTeamBooking)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CoopJobAssignmentScreen(booking: b),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.seaGreen,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                            ),
                            child: const Text('Manage Team',
                                style: TextStyle(fontSize: 11)),
                          )
                        else
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Coordinator intervention logged for this booking.'),
                                  backgroundColor: AppColors.seaGreen,
                                ),
                              );
                            },
                            child: const Text('Intervene'),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
