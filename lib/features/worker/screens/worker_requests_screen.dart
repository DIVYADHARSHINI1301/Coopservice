import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';

class WorkerRequestsScreen extends ConsumerWidget {
  const WorkerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final user = repo.currentUser;
    final worker = repo.allWorkers.firstWhere(
      (w) => w.uid == user.uid,
      orElse: () => repo.allWorkers.first,
    );
    final requests = repo.allBookings
        .where((b) =>
            b.workerId == worker.uid && b.status == BookingStatus.requested)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: Text(
          'Incoming Job Requests (${requests.length})',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: requests.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 52,
                      color: AppColors.textSecondary.withValues(alpha: 0.4)),
                  const SizedBox(height: 12),
                  const Text(
                    'No pending dispatches right now.',
                    style:
                        TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final req = requests[index];
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
                            req.serviceSubtype,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₹${req.estimatedPrice.toInt()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.seaGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Customer: ${req.customerName}'),
                      Text(
                        'Location: ${req.location.address}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                repo.updateBookingStatus(
                                    req.id, BookingStatus.cancelled);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.redDestructive,
                                side: const BorderSide(
                                    color: AppColors.redDestructive),
                              ),
                              child: const Text('Decline'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                final updated = repo.updateBookingStatus(
                                    req.id, BookingStatus.accepted);
                                context.push(AppRoutes.workerJobDetail,
                                    extra: updated);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.seaGreen,
                                foregroundColor: AppColors.white,
                              ),
                              child: const Text('Accept Job'),
                            ),
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
