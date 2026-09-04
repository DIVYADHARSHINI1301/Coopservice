import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class RoleChoiceScreen extends StatelessWidget {
  const RoleChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Action Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFDCF3E7),
                      foregroundColor: AppColors.evergreen,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6EEE2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.eco, size: 16, color: AppColors.seaGreen),
                        SizedBox(width: 6),
                        Text(
                          'Neighborhood Co-op',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkEmerald,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Header Section
              const Text(
                'JOIN THE COOPERATIVE MOVEMENT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.seaGreen,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                loc.tr('createAccount'),
                style: AppTypography.headlineLarge(
                  color: AppColors.evergreen,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'How would you like to join the ecosystem?',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Card 1: Continue as Customer
              _buildChoiceCard(
                context: context,
                icon: Icons.person,
                title: loc.tr('continueAsCustomer'),
                subtitle: loc.tr('bookServicesDesc'),
                onTap: () => context.push(AppRoutes.customerRegister),
              ),
              const SizedBox(height: 14),

              // Card 2: Register as Worker
              _buildChoiceCard(
                context: context,
                icon: Icons.construction,
                title: loc.tr('registerAsWorker'),
                subtitle: loc.tr('provideServicesDesc'),
                badge: loc.tr('coopMember'),
                onTap: () => context.push(AppRoutes.workerRegister),
              ),
              const SizedBox(height: 14),

              // Card 3: Register a Cooperative Society
              _buildChoiceCard(
                context: context,
                icon: Icons.diversity_3,
                title: loc.tr('registerAsCoop'),
                subtitle: loc.tr('registerAsCoopDesc'),
                badge: 'Guild Hub',
                onTap: () => context.push(AppRoutes.coopRegister),
              ),
              const SizedBox(height: 24),

              // Context Guarantee Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCF3E7).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.white,
                      child: Icon(Icons.verified_user,
                          size: 18, color: AppColors.seaGreen),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Fair pay guarantee, mutual community accountability, and zero platform extraction built into every booking.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.35,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bottom Governance Badge
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCF3E7),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.groups, size: 18, color: AppColors.seaGreen),
                      SizedBox(width: 8),
                      Text(
                        'Owned & governed by local workers & community',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.celadon, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.evergreen.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.seaGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.evergreen,
                              ),
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.celadon,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                badge,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkEmerald,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.mintLeaf2,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
