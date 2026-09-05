import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/chart_widgets.dart';

class CoopDashboardScreen extends ConsumerWidget {
  const CoopDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final user = repo.currentUser;
    final workers = repo.allWorkers;
    final pendingUsers =
        repo.allUsers.where((u) => u.status == UserStatus.pending).toList();
    final bookings = repo.allBookings;
    final loc = AppLocalization.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.pineTeal,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Co-op Admin Operations',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              user.cooperativeName ?? 'Anna Nagar Local Cluster',
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
            // Pending Verification Banner
            if (pendingUsers.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.amberWarning.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.amberWarning.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: AppColors.amberWarning,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.hourglass_top,
                          color: AppColors.evergreen, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${pendingUsers.length} Worker Application(s) Pending Review',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.evergreen,
                            ),
                          ),
                          const Text(
                            'Candidate: Karthik Selvam (#CS-84920)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: AppColors.evergreen),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Stat Cards Grid
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'Total Co-op Workers',
                    '${workers.length + 51}',
                    Icons.people,
                    AppColors.seaGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    'Pending Review',
                    '${pendingUsers.length}',
                    Icons.pending_actions,
                    AppColors.amberWarning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    "Today's Bookings",
                    '${bookings.length + 19}',
                    Icons.assignment_turned_in,
                    AppColors.darkEmerald,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    'Average Rating',
                    '4.88 ★',
                    Icons.star,
                    AppColors.seaGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Booking Funnel Chart
            const BookingFunnelChart(
              stages: [
                FunnelStage(
                  label: '1. Service Requested',
                  count: 28,
                  percentage: 1.0,
                  color: AppColors.seaGreen,
                ),
                FunnelStage(
                  label: '2. Accepted & Dispatched',
                  count: 25,
                  percentage: 0.89,
                  color: AppColors.mintLeaf2,
                ),
                FunnelStage(
                  label: '3. On The Way / Arrived',
                  count: 22,
                  percentage: 0.78,
                  color: AppColors.mintLeaf,
                ),
                FunnelStage(
                  label: '4. Service Completed',
                  count: 20,
                  percentage: 0.71,
                  color: AppColors.darkEmerald,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Worker Distribution by Skill Card
            const SkillDistributionCard(
              items: [
                SkillBarItem(skill: 'Electrician', workerCount: 18, ratio: 0.9),
                SkillBarItem(skill: 'AC & Appliance', workerCount: 15, ratio: 0.75),
                SkillBarItem(skill: 'Plumber', workerCount: 14, ratio: 0.7),
                SkillBarItem(skill: 'Cleaner', workerCount: 11, ratio: 0.55),
                SkillBarItem(skill: 'Carpenter', workerCount: 9, ratio: 0.45),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, size: 18, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
