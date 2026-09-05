import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/widgets/status_badge.dart';

class WorkerJobsScreen extends ConsumerStatefulWidget {
  const WorkerJobsScreen({super.key});

  @override
  ConsumerState<WorkerJobsScreen> createState() => _WorkerJobsScreenState();
}

class _WorkerJobsScreenState extends ConsumerState<WorkerJobsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final user = repo.currentUser;
    final worker = repo.getWorkerForUser(user);
    final bookings =
        repo.allBookings.where((b) => b.workerId == worker.uid).toList();

    final activeJobs = bookings
        .where((b) =>
            b.status == BookingStatus.workerAccepted ||
            b.status == BookingStatus.workerOnTheWay ||
            b.status == BookingStatus.workerArrived ||
            b.status == BookingStatus.workStarted ||
            b.status == BookingStatus.workInProgress ||
            b.status == BookingStatus.workCompleted ||
            b.status == BookingStatus.accepted ||
            b.status == BookingStatus.onTheWay ||
            b.status == BookingStatus.arrived ||
            b.status == BookingStatus.inProgress)
        .toList();

    final completedJobs = bookings
        .where((b) =>
            b.status == BookingStatus.customerConfirmed ||
            b.status == BookingStatus.closed ||
            b.status == BookingStatus.completed)
        .toList();

    final cancelledJobs = bookings
        .where((b) =>
            b.status == BookingStatus.cancelled ||
            b.status == BookingStatus.workerDeclined)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'My Assigned Jobs',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.mintLeaf,
          indicatorWeight: 3,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.frostedMint.withOpacity(0.7),
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(text: 'Active (${activeJobs.length})'),
            Tab(text: 'Completed (${completedJobs.length})'),
            Tab(text: 'Cancelled (${cancelledJobs.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJobsList(activeJobs, 'No active jobs right now'),
          _buildJobsList(completedJobs, 'No completed jobs yet'),
          _buildJobsList(cancelledJobs, 'No cancelled jobs'),
        ],
      ),
    );
  }

  Widget _buildJobsList(List<Booking> jobs, String emptyText) {
    if (jobs.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final job = jobs[index];
        final isCompleted = job.status == BookingStatus.closed ||
            job.status == BookingStatus.customerConfirmed ||
            job.status == BookingStatus.completed;

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
                  Text(
                    '#${job.id}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: AppColors.seaGreen,
                    ),
                  ),
                  StatusBadge(
                    label: job.status.label,
                    status: isCompleted
                        ? BadgeStatus.completed
                        : (job.status == BookingStatus.cancelled ||
                                job.status == BookingStatus.workerDeclined
                            ? BadgeStatus.rejected
                            : BadgeStatus.onTheWay),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                job.serviceSubtype,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              if (job.workDescription.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  job.workDescription,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                'Customer: ${job.customerName} • ${job.location.address}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${job.pricing.workerDirectEarnings.toInt()} net (${job.paymentStatus.toUpperCase()})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.push(AppRoutes.workerJobDetail, extra: job);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.seaGreen,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                    ),
                    child: const Text('Job Console'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
