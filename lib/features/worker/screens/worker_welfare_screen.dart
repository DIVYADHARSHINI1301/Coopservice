import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';

class WorkerWelfareScreen extends StatelessWidget {
  const WorkerWelfareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'Cooperative Welfare & Benefits',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Shield status hero
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.pineTeal,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.health_and_safety,
                      size: 40, color: AppColors.frostedMint),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'National Co-op Health Shield',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Active • Policy #COOP-IN-88902',
                          style:
                              TextStyle(fontSize: 12, color: AppColors.celadon),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _welfareBenefitCard(
              title: 'Accidental & Medical Insurance',
              desc:
                  'Cashless cover up to ₹5,00,000 for on-duty injury or hospital stay across 140+ empaneled hospitals.',
              icon: Icons.local_hospital,
            ),
            const SizedBox(height: 12),

            _welfareBenefitCard(
              title: 'Cooperative Child Education Grant',
              desc:
                  'Annual ₹15,000 scholarship support for up to 2 school-going children of active member-owners.',
              icon: Icons.school,
            ),
            const SizedBox(height: 12),

            _welfareBenefitCard(
              title: 'Zero-Interest Equipment Loan',
              desc:
                  'Advance up to ₹40,000 for certified testing meters, drills, and power tools with transparent 12-month repayments.',
              icon: Icons.handyman,
            ),
            const SizedBox(height: 20),

            CustomButton(
              text: 'File Emergency Welfare Claim',
              icon: Icons.report_problem_outlined,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Claim application submitted to Co-op Welfare Committee.'),
                    backgroundColor: AppColors.seaGreen,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _welfareBenefitCard({
    required String title,
    required String desc,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFDCF3E7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.seaGreen, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkEmerald,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.35,
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
