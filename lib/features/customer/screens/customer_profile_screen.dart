import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';

class CustomerProfileScreen extends ConsumerWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final user = repo.currentUser;
    final locale = ref.watch(localeProvider);
    final loc = AppLocalization.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: Text(
          loc.tr('profile'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.celadon,
                    child: Text(
                      user.name.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkEmerald,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          user.phone,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Differentiators Group: Service Vault, Society Split, Care Plans
            _profileTileGroup([
              _tile(
                icon: Icons.folder_special,
                title: 'Home Service Vault & Job Cards',
                subtitle: 'Permanent service records & 90-day warranty',
                onTap: () => context.push(AppRoutes.customerVault),
              ),
              _tile(
                icon: Icons.apartment,
                title: 'Society & Multi-Flat Bookings',
                subtitle: 'Split community repairs with neighbors',
                onTap: () => context.push(AppRoutes.groupBooking),
              ),
              _tile(
                icon: Icons.autorenew,
                title: 'Recurring Guild Care Plans',
                subtitle: 'Quarterly AC, drain & tank maintenance',
                onTap: () => context.push(AppRoutes.recurringCare),
              ),
            ]),
            const SizedBox(height: 14),

            // Settings List
            _profileTileGroup([
              _tile(
                icon: Icons.location_on_outlined,
                title: 'Saved Addresses',
                subtitle: 'Plot 42, 2nd Avenue, Anna Nagar East (Home)',
                onTap: () {},
              ),
              _tile(
                icon: Icons.language,
                title: 'Language / மொழி',
                subtitle: locale.languageCode == 'en' ? 'English' : 'தமிழ்',
                trailing: Switch(
                  value: locale.languageCode == 'ta',
                  activeColor: AppColors.seaGreen,
                  onChanged: (val) {
                    ref.read(localeProvider.notifier).state =
                        Locale(val ? 'ta' : 'en');
                  },
                ),
                onTap: () {},
              ),
              _tile(
                icon: Icons.notifications_none,
                title: 'Notifications',
                subtitle: 'Push updates on active technician status',
                trailing: const Icon(Icons.check, color: AppColors.seaGreen),
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 14),

            _profileTileGroup([
              _tile(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Payment Methods',
                subtitle: 'UPI, Cash on completion, Co-op wallet',
                onTap: () {},
              ),
              _tile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Neighborhood Co-op Guild Helpdesk',
                onTap: () {},
              ),
              _tile(
                icon: Icons.policy_outlined,
                title: 'Democratic Governance & Bylaws',
                subtitle: 'Fair wages & dividend charter',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 16),

            // Logout Button
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.celadon),
              ),
              tileColor: AppColors.white,
              leading: const Icon(Icons.logout, color: AppColors.redDestructive),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.redDestructive,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                ref.read(platformRepositoryProvider).logout();
                context.go(AppRoutes.login);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _profileTileGroup(List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Column(
        children: tiles,
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.seaGreen),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.evergreen,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
