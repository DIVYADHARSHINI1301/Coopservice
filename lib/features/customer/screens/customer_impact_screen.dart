import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';

class CustomerImpactScreen extends ConsumerWidget {
  const CustomerImpactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final customer = repo.currentCustomerProfile;
    final stats = customer.impactStats;

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'My Community Impact',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Impact Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.pineTeal, AppColors.evergreen],
                ),
                borderRadius: BorderRadius.circular(20),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'FAIR EARNINGS ENABLED BY YOU',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: AppColors.celadon,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.volunteer_activism,
                            color: AppColors.mintLeaf, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${stats.totalWorkerEarningsDirected.toInt()}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '100% of your service spend went directly to neighborhood artisans and their community health funds with 0% corporate extraction.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.frostedMint,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4 Impact Metric Cards Grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.people_alt,
                    title: 'Workers Supported',
                    value: '${stats.workersSupported}',
                    subtitle: 'Local guild members',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.diversity_3,
                    title: 'Cooperatives Engaged',
                    value: '${stats.cooperativesEngaged}',
                    subtitle: 'Chennai local clusters',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.task_alt,
                    title: 'Jobs Completed',
                    value: '${stats.totalJobsCompleted}',
                    subtitle: 'Verified transparent fixes',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.health_and_safety,
                    title: 'Health Fund Contribution',
                    value: '₹${stats.totalCooperativeFundGenerated.toInt()}',
                    subtitle: 'Cashless cover generated',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Community Reinvestment Visual Guide
            const Text(
              'How Your Booking Reinvests',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 12),

            _buildReinvestItem(
              percentage: '85%',
              title: 'Direct Artisan Living Wage',
              desc:
                  'Technicians earn 35% higher net income compared to aggregator gig apps.',
              icon: Icons.currency_rupee,
              color: AppColors.seaGreen,
            ),
            const SizedBox(height: 10),
            _buildReinvestItem(
              percentage: '12%',
              title: 'Guild Health & Tool Welfare',
              desc:
                  'Family medical shield, zero-interest tool upgrades, and yearly member profit dividend.',
              icon: Icons.healing,
              color: AppColors.darkEmerald,
            ),
            const SizedBox(height: 10),
            _buildReinvestItem(
              percentage: '3%',
              title: 'Platform Maintenance & Hosting',
              desc:
                  'Cooperative digital infrastructure, open-source tooling, and identity verification.',
              icon: Icons.cloud_done,
              color: AppColors.pineTeal,
            ),
            const SizedBox(height: 24),

            // Cooperative Movement Badge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.celadon),
              ),
              child: const Row(
                children: [
                  Icon(Icons.military_tech,
                      color: AppColors.seaGreen, size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Neighborhood Solidarity Champion',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        Text(
                          'You are among the top 10% of local households strengthening Tamil Nadu\'s democratic worker movement.',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
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

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
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
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.frostedMint,
            child: Icon(icon, color: AppColors.darkEmerald, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.evergreen,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.darkEmerald,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReinvestItem({
    required String percentage,
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              percentage,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.evergreen,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
