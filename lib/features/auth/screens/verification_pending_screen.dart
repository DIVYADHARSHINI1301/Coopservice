import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/widgets/custom_button.dart';

class VerificationPendingScreen extends ConsumerStatefulWidget {
  const VerificationPendingScreen({super.key});

  @override
  ConsumerState<VerificationPendingScreen> createState() =>
      _VerificationPendingScreenState();
}

class _VerificationPendingScreenState
    extends ConsumerState<VerificationPendingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization.of(context);
    final repo = ref.watch(platformRepositoryProvider);
    final user = repo.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Subtle ambient top ornament
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6EEE2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified_user,
                            size: 15, color: AppColors.seaGreen),
                        SizedBox(width: 5),
                        Text(
                          'Co-op Direct Registry',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkEmerald,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.seaGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Live Dispatch Sync',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Primary Hub Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.evergreen.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Visual Status Hero
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: AppColors.frostedMint,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 68,
                            height: 68,
                            decoration: const BoxDecoration(
                              color: AppColors.celadon,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.hourglass_top,
                              size: 36,
                              color: AppColors.seaGreen,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: AppColors.seaGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.sync,
                                size: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Status Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCF3E7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule,
                              size: 14, color: AppColors.seaGreen),
                          SizedBox(width: 6),
                          Text(
                            'Review in Progress',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkEmerald,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Heading
                    Text(
                      loc.tr('verificationPending'),
                      style: AppTypography.headlineLarge(
                        color: AppColors.darkEmerald,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Explanatory Body
                    Text(
                      loc.tr('verificationDesc'),
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Candidate Snapshot
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2FBF6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.celadon),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.celadon,
                                    child: const Icon(Icons.person,
                                        color: AppColors.darkEmerald),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name.isEmpty
                                            ? 'Karthik Selvam'
                                            : user.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.evergreen,
                                        ),
                                      ),
                                      const Text(
                                        'Member-Owner Queue',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.celadon,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Tier 1 Intake',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkEmerald,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Timeline progress bar (65%)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Stack(
                              children: [
                                Container(
                                  height: 6,
                                  color: AppColors.celadon.withOpacity(0.5),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.65,
                                  child: Container(
                                    height: 6,
                                    color: AppColors.seaGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Step 2 of 3 Completed',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '65%',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.seaGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Application Details Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.celadon),
                      ),
                      child: Column(
                        children: [
                          _detailRow(
                            label: 'Application ID',
                            valueWidget: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCF3E7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '#CS-84920',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.seaGreen,
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                              height: 16, color: AppColors.frostedMint),
                          _detailRow(
                            label: 'Submitted',
                            value: 'Today, 9:40 AM',
                            icon: Icons.calendar_today,
                          ),
                          const Divider(
                              height: 16, color: AppColors.frostedMint),
                          _detailRow(
                            label: 'Target Cooperative',
                            value: user.cooperativeName ??
                                'Anna Nagar Local Cluster',
                            icon: Icons.location_on,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Cooperative Pledge Banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.celadon.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.handshake,
                              color: AppColors.darkEmerald, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '100% of platform earnings flow directly to local neighborhood technicians.',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkEmerald,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons
                    CustomButton(
                      text: 'Enter Worker Dashboard →',
                      type: ButtonType.primary,
                      icon: Icons.dashboard,
                      onPressed: () => context.go(AppRoutes.workerHome),
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'Contact Co-op Admin Support',
                      type: ButtonType.secondary,
                      icon: Icons.support_agent,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Connecting you to Anna Nagar Co-op Helpdesk...'),
                            backgroundColor: AppColors.seaGreen,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () {
                        ref.read(platformRepositoryProvider).logout();
                        context.go(AppRoutes.login);
                      },
                      icon: const Icon(Icons.logout,
                          size: 16, color: AppColors.textSecondary),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Bottom Assurance Note
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield, size: 14, color: AppColors.seaGreen),
                  SizedBox(width: 6),
                  Text(
                    'Protected by Co-op Trust & Safety Bylaws',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow({
    required String label,
    String? value,
    Widget? valueWidget,
    IconData? icon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: AppColors.seaGreen),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        valueWidget ??
            Text(
              value ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.evergreen,
              ),
            ),
      ],
    );
  }
}
