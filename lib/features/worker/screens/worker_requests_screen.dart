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
    final worker = repo.getWorkerForUser(user);
    final requests = repo.allBookings
        .where((b) =>
            b.workerId == worker.uid &&
            (b.status == BookingStatus.bookingCreated ||
                b.status == BookingStatus.workerSearching ||
                b.status == BookingStatus.requested))
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
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: const BoxDecoration(
                        color: AppColors.frostedMint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.inbox,
                          size: 48, color: AppColors.seaGreen),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'No pending job dispatches right now.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.evergreen,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'When customers book your skilled services in your neighborhood cluster, dispatch notifications appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '#${req.id}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.seaGreen,
                                  ),
                                ),
                                Text(
                                  req.serviceSubtype,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkEmerald,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${req.pricing.workerDirectEarnings.toInt()}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.seaGreen,
                                ),
                              ),
                              const Text(
                                'Your Net Pay',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (req.workDescription.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.celadon.withOpacity(0.6)),
                          ),
                          child: Text(
                            req.workDescription,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'Customer: ${req.customerName} • ${req.customerPhone}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.evergreen,
                        ),
                      ),
                      Text(
                        'Location: ${req.location.address}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (req.requestedDateText.isNotEmpty ||
                          req.requestedTimeText.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.schedule,
                                size: 13, color: AppColors.seaGreen),
                            const SizedBox(width: 4),
                            Text(
                              '${req.requestedDateText} (${req.requestedTimeText})',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.darkEmerald,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (req.problemPhotoUrls.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: req.problemPhotoUrls
                              .map((url) => Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: AppColors.celadon),
                                      image: DecorationImage(
                                        image: NetworkImage(url),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                repo.declineBooking(
                                  req.id,
                                  reason: 'Technician unavailable for selected time',
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.redDestructive,
                                side: const BorderSide(
                                    color: Color(0xFFFCA5A5)),
                              ),
                              child: const Text('Deny'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                final updated = repo.updateBookingStatus(
                                  req.id,
                                  BookingStatus.workerAccepted,
                                );
                                context.push(
                                  AppRoutes.workerJobDetail,
                                  extra: updated,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.seaGreen,
                                foregroundColor: AppColors.white,
                              ),
                              child: const Text('Accept Work Request'),
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
