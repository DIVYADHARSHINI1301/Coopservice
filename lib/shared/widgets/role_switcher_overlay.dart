import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localization.dart';
import '../../core/theme/app_colors.dart';
import '../data/repository.dart';
import '../models/user_model.dart';

class RoleSwitcherOverlay extends ConsumerWidget {
  final Widget child;

  const RoleSwitcherOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final user = repo.currentUser;

    return Stack(
      children: [
        child,

        // Floating Demo Quick-Switch Bar
        Positioned(
          top: MediaQuery.of(context).padding.top + 4,
          right: 12,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _showRoleSwitchSheet(context, ref),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.pineTeal.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.mintLeaf2, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.evergreen.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: user.status == UserStatus.active
                            ? AppColors.mintLeaf
                            : AppColors.amberWarning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Role: ${user.role.displayName}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.swap_horiz,
                        color: AppColors.mintLeaf, size: 14),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showRoleSwitchSheet(BuildContext context, WidgetRef ref) {
    final repo = ref.read(platformRepositoryProvider);
    final locale = ref.read(localeProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demo Role & Language Switcher',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                      Text(
                        'Test post-login routing & permissions in 1-click',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Language Toggle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.frostedMint.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.language,
                            size: 18, color: AppColors.seaGreen),
                        SizedBox(width: 8),
                        Text(
                          'Language / மொழி',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.evergreen,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('English'),
                          selected: locale.languageCode == 'en',
                          onSelected: (_) {
                            ref.read(localeProvider.notifier).state =
                                const Locale('en');
                          },
                          selectedColor: AppColors.seaGreen,
                          labelStyle: TextStyle(
                            color: locale.languageCode == 'en'
                                ? AppColors.white
                                : AppColors.evergreen,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        ChoiceChip(
                          label: const Text('தமிழ்'),
                          selected: locale.languageCode == 'ta',
                          onSelected: (_) {
                            ref.read(localeProvider.notifier).state =
                                const Locale('ta');
                          },
                          selectedColor: AppColors.seaGreen,
                          labelStyle: TextStyle(
                            color: locale.languageCode == 'ta'
                                ? AppColors.white
                                : AppColors.evergreen,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Select Persona:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              const SizedBox(height: 8),

              // Role Items
              _roleItem(
                title: 'Customer — Divya Dharshini',
                subtitle: 'Bookings, Worker Discovery & Live Tracking',
                icon: Icons.person,
                roleColor: AppColors.seaGreen,
                isSelected: repo.currentUser.uid == 'cust_divya',
                onTap: () {
                  repo.switchUser('cust_divya');
                  Navigator.pop(ctx);
                },
              ),
              _roleItem(
                title: 'Worker (Active) — Ravi Kumar (Electrician)',
                subtitle: 'Accept Jobs, Step-by-Step Lifecycle & Earnings',
                icon: Icons.handyman,
                roleColor: AppColors.seaGreen,
                isSelected: repo.currentUser.uid == 'worker_ravi',
                onTap: () {
                  repo.switchUser('worker_ravi');
                  Navigator.pop(ctx);
                },
              ),
              _roleItem(
                title: 'Worker (Pending) — Karthik Selvam (Applicant)',
                subtitle: 'Verification Pending Review Screen (#CS-84920)',
                icon: Icons.hourglass_top,
                roleColor: AppColors.amberWarning,
                isSelected: repo.currentUser.uid == 'worker_karthik_pending',
                onTap: () {
                  repo.switchUser('worker_karthik_pending');
                  Navigator.pop(ctx);
                },
              ),
              _roleItem(
                title: 'Cooperative Admin — M. Sundaram',
                subtitle: 'Anna Nagar Co-op • Verification Queue & Workers',
                icon: Icons.admin_panel_settings,
                roleColor: AppColors.darkEmerald,
                isSelected: repo.currentUser.uid == 'admin_sundaram',
                onTap: () {
                  repo.switchUser('admin_sundaram');
                  Navigator.pop(ctx);
                },
              ),
              _roleItem(
                title: 'Super Admin — Platform Master',
                subtitle: 'All Cooperatives, + Create Admin & AI Forecast',
                icon: Icons.shield,
                roleColor: AppColors.pineTeal,
                isSelected: repo.currentUser.uid == 'superadmin_master',
                onTap: () {
                  repo.switchUser('superadmin_master');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _roleItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color roleColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.frostedMint : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.seaGreen : AppColors.celadon,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        dense: true,
        onTap: onTap,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: roleColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: roleColor, size: 18),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.evergreen,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle,
                color: AppColors.seaGreen, size: 18)
            : null,
      ),
    );
  }
}
