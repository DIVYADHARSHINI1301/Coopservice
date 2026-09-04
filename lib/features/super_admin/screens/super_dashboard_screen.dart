import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/widgets/chart_widgets.dart';

class SuperDashboardScreen extends ConsumerWidget {
  const SuperDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final coops = repo.allCooperatives;
    final workers = repo.allWorkers;
    final bookings = repo.allBookings;
    final loc = AppLocalization.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.evergreen,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Super Admin Oversight',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Platform-wide Governance & AI Engine',
              style: TextStyle(fontSize: 11, color: AppColors.celadon),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Platform Metric Hero Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.pineTeal, AppColors.evergreen],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.evergreen.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PLATFORM GROSS TRANSACTION VALUE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: AppColors.celadon,
                        ),
                      ),
                      Icon(Icons.shield, color: AppColors.mintLeaf, size: 20),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '₹15,62,000',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.pineTeal),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Platform Extraction: 0% • 100% Flow to Workers & Guilds',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.frostedMint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stat Cards Grid
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'Active Cooperatives',
                    '${coops.length}',
                    Icons.corporate_fare,
                    AppColors.seaGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    'Co-op Admins',
                    '4',
                    Icons.admin_panel_settings,
                    AppColors.darkEmerald,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'Total Verified Workers',
                    '140',
                    Icons.engineering,
                    AppColors.seaGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    'Registered Patrons',
                    '840',
                    Icons.groups,
                    AppColors.pineTeal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // AI Demand Quick Teaser
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome,
                          color: AppColors.seaGreen, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'AI Demand Forecasting Alert',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '⚡ High demand surge predicted in Chennai North 6:00 PM - 9:00 PM for Electricians (+38.1%).',
                    style: TextStyle(
                        fontSize: 12, height: 1.35, color: AppColors.evergreen),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '💧 Monsoon AC & plumbing dispatch volume +25.8% anticipated next week.',
                    style: TextStyle(
                        fontSize: 12, height: 1.35, color: AppColors.evergreen),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Platform-wide Funnel
            const BookingFunnelChart(
              stages: [
                FunnelStage(
                  label: '1. Total Inquiries & Searches',
                  count: 480,
                  percentage: 1.0,
                  color: AppColors.seaGreen,
                ),
                FunnelStage(
                  label: '2. Confirmed Bookings',
                  count: 412,
                  percentage: 0.85,
                  color: AppColors.mintLeaf2,
                ),
                FunnelStage(
                  label: '3. Completed & Verified',
                  count: 395,
                  percentage: 0.82,
                  color: AppColors.darkEmerald,
                ),
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
                title,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary),
              ),
              Icon(icon, size: 18, color: color),
            ],
          ),
          const SizedBox(height: 6),
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
