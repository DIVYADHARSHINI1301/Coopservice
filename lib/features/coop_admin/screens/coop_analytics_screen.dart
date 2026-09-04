import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/widgets/chart_widgets.dart';

class CoopAnalyticsScreen extends ConsumerWidget {
  const CoopAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final user = repo.currentUser;
    final coop = repo.allCooperatives.firstWhere(
      (c) => c.id == user.cooperativeId,
      orElse: () => repo.allCooperatives.first,
    );
    final ledger = coop.financialLedger;

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.pineTeal,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cooperative Financial Ledger',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              coop.name,
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
            // Ledger Hero
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL MONTHLY GROSS BOOKINGS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: AppColors.celadon,
                        ),
                      ),
                      Icon(Icons.account_balance,
                          color: AppColors.mintLeaf, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${ledger.totalBookingVolume.toInt()}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.pineTeal),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ledgerPill(
                        'Worker Payout (85%)',
                        '₹${ledger.workerDirectPayouts.toInt()}',
                        AppColors.mintLeaf2,
                      ),
                      _ledgerPill(
                        'Welfare Fund (12%)',
                        '₹${ledger.cooperativeWelfareFund.toInt()}',
                        AppColors.amberWarning,
                      ),
                      _ledgerPill(
                        'Platform (3%)',
                        '₹${ledger.platformSupportFees.toInt()}',
                        AppColors.frostedMint,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Performance Bar Chart
            const Text(
              'Weekly Booking Volume (₹ in Thousands)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.celadon),
              ),
              child: const SizedBox(
                height: 160,
                child: SimpleBarChart(
                  values: [120, 145, 138, 162, 175, 190, 185],
                  labels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Category Demand Breakdown
            const Text(
              'Service Category Revenue Distribution',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.celadon),
              ),
              child: const SizedBox(
                height: 160,
                child: SimpleDonutChart(
                  sections: [
                    DonutSection(value: 38, color: AppColors.seaGreen, label: 'Electrician (38%)'),
                    DonutSection(value: 28, color: AppColors.mintLeaf2, label: 'Plumber (28%)'),
                    DonutSection(value: 20, color: AppColors.darkEmerald, label: 'AC Service (20%)'),
                    DonutSection(value: 14, color: AppColors.celadon, label: 'Carpenter (14%)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Welfare Fund Allocation Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welfare & Tooling Fund Balances',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _fundRow('National Health Shield Premium', '₹42,000',
                      'Active for 54 families'),
                  const Divider(color: AppColors.celadon),
                  _fundRow('Tool Loan & Upgrade Reserve', '₹18,500',
                      '6 active zero-interest loans'),
                  const Divider(color: AppColors.celadon),
                  _fundRow('Year-End Dividend Escrow', '₹12,940',
                      'Target ₹18,000/member payout'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ledgerPill(String title, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 10, color: AppColors.celadon)),
        Text(amount,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _fundRow(String title, String amount, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.evergreen)),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
        Text(amount,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.seaGreen)),
      ],
    );
  }
}
