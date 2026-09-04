import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../models/booking_model.dart';

class FairSplitPricingCard extends StatefulWidget {
  final FairSplitPricing pricing;
  final bool initiallyExpanded;

  const FairSplitPricingCard({
    super.key,
    required this.pricing,
    this.initiallyExpanded = true,
  });

  @override
  State<FairSplitPricingCard> createState() => _FairSplitPricingCardState();
}

class _FairSplitPricingCardState extends State<FairSplitPricingCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.celadon, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.evergreen.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Toggle
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.frostedMint,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.handshake,
                          color: AppColors.darkEmerald,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Transparent Fair-Split Pricing',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.evergreen,
                            ),
                          ),
                          Text(
                            'Total Service Value: ₹${widget.pricing.serviceTotal.toInt()}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.seaGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.evergreen,
                  ),
                ],
              ),
            ),
          ),

          if (_expanded) ...[
            const Divider(height: 1, color: AppColors.celadon),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSplitRow(
                    label: 'Direct Worker Payout (~85%)',
                    subtitle: 'Directly paid to technician on job completion',
                    amount: widget.pricing.workerDirectEarnings,
                    icon: Icons.person_outline,
                    color: AppColors.seaGreen,
                  ),
                  const SizedBox(height: 10),
                  _buildSplitRow(
                    label: 'Cooperative Welfare & Tool Fund (~12%)',
                    subtitle:
                        'Member health cover, tool loans & annual dividend',
                    amount: widget.pricing.cooperativeWelfareFund,
                    icon: Icons.diversity_3,
                    color: AppColors.darkEmerald,
                  ),
                  const SizedBox(height: 10),
                  _buildSplitRow(
                    label: 'Platform Maintenance Support (~3%)',
                    subtitle: 'App hosting, SMS, maps & verification tooling',
                    amount: widget.pricing.platformSupportFee,
                    icon: Icons.hub_outlined,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 14),

                  // Zero Extraction Guarantee
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.frostedMint.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.mintLeaf2.withOpacity(0.4)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.verified,
                            color: AppColors.seaGreen, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your booking supports both the local technician and their cooperative guild. Zero commission extraction.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.evergreen,
                              fontWeight: FontWeight.w500,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSplitRow({
    required String label,
    required String subtitle,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.evergreen,
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
        ),
        Text(
          '₹${amount.toInt()}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
