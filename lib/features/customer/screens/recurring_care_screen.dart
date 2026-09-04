import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/customer_model.dart';
import '../../../shared/widgets/status_badge.dart';

class RecurringCareScreen extends ConsumerWidget {
  const RecurringCareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final customer = repo.currentCustomerProfile;
    final plans = customer.recurringPlans;

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'Recurring Cooperative Care Plans',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Care Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.pineTeal, AppColors.evergreen],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.autorenew, color: AppColors.mintLeaf, size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Zero-Hassle Preventative Guild Care',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Pre-scheduled home wellness checks with guaranteed cooperative technicians and 1-tap skip anytime.',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.frostedMint,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Your Active Subscriptions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 10),

            if (plans.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.celadon),
                ),
                child: const Center(
                  child: Text(
                    'No active care plans. Explore curated plans below!',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ...plans.map((plan) => _buildActivePlanCard(context, ref, plan)),

            const SizedBox(height: 24),
            const Text(
              'Explore Curated Co-op Care Plans',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 10),

            _buildAvailablePlanCard(
              context: context,
              ref: ref,
              title: 'Quarterly Inverter & Earth Pit Health Check',
              category: 'Electrician',
              frequency: 'Quarterly (Every 3 Months)',
              price: 420.0,
              desc:
                  'Comprehensive earthing resistance test, battery terminal cleaning, voltage surge check, and circuit inspection.',
            ),
            const SizedBox(height: 12),
            _buildAvailablePlanCard(
              context: context,
              ref: ref,
              title: 'Monthly Kitchen Drain & Trap De-clog',
              category: 'Plumber',
              frequency: 'Monthly',
              price: 250.0,
              desc:
                  'Eco-friendly enzymatic trap flush, waste pipe leak check, and tap aerator descaling.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlanCard(
      BuildContext context, WidgetRef ref, RecurringCarePlan plan) {
    final dateStr =
        DateFormat('dd MMMM yyyy').format(plan.nextScheduledDate);

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
                plan.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.evergreen,
                ),
              ),
              StatusBadge(
                label: plan.isActive ? 'Active' : 'Paused',
                status:
                    plan.isActive ? BadgeStatus.active : BadgeStatus.pending,
                fontSize: 10,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${plan.serviceCategory} • ${plan.frequency} • ${plan.cooperativeName}',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.frostedMint.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Next Scheduled Visit:',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald),
                    ),
                    Text(
                      dateStr,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen),
                    ),
                  ],
                ),
                Text(
                  '₹${plan.estimatedCost.toInt()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.seaGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(platformRepositoryProvider).skipNextCareCycle(plan.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cycle skipped! Next visit pushed forward.'),
                        backgroundColor: AppColors.seaGreen,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('Skip This Cycle',
                      style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(platformRepositoryProvider).toggleCarePlan(plan.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        plan.isActive ? AppColors.darkEmerald : AppColors.seaGreen,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(plan.isActive ? 'Pause Plan' : 'Resume Plan',
                      style: const TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePlanCard({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String category,
    required String frequency,
    required double price,
    required String desc,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.evergreen,
                ),
              ),
              Text(
                '₹${price.toInt()}/cycle',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.seaGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$category • $frequency',
            style: const TextStyle(
                fontSize: 11,
                color: AppColors.darkEmerald,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final newPlan = RecurringCarePlan(
                  id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
                  title: title,
                  serviceCategory: category,
                  frequency: frequency.contains('Monthly') ? 'Monthly' : 'Quarterly',
                  nextScheduledDate: DateTime.now().add(const Duration(days: 30)),
                  estimatedCost: price,
                  cooperativeId: 'coop_anna_nagar',
                  cooperativeName: 'Anna Nagar Electrical & Trades Co-op',
                );
                ref.read(platformRepositoryProvider).subscribeCarePlan(newPlan);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Subscribed to "$title" with 15% co-op savings!'),
                    backgroundColor: AppColors.seaGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.seaGreen,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text('Subscribe to Care Plan',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
