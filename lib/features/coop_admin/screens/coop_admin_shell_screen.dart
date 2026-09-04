import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/theme/app_colors.dart';
import 'coop_dashboard_screen.dart';
import 'coop_workers_screen.dart';
import 'coop_verification_queue_screen.dart';
import 'coop_bookings_screen.dart';
import 'coop_analytics_screen.dart';
import 'coop_profile_edit_screen.dart';

class CoopAdminShellScreen extends ConsumerStatefulWidget {
  const CoopAdminShellScreen({super.key});

  @override
  ConsumerState<CoopAdminShellScreen> createState() =>
      _CoopAdminShellScreenState();
}

class _CoopAdminShellScreenState extends ConsumerState<CoopAdminShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CoopDashboardScreen(),
    CoopWorkersScreen(),
    CoopVerificationQueueScreen(),
    CoopBookingsScreen(),
    CoopAnalyticsScreen(),
    CoopProfileEditScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.evergreen.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.darkEmerald,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon:
                  const Icon(Icons.dashboard, color: AppColors.darkEmerald),
              label: loc.tr('dashboard'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_outline),
              activeIcon:
                  const Icon(Icons.people, color: AppColors.darkEmerald),
              label: loc.tr('workers'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.fact_check_outlined),
              activeIcon:
                  const Icon(Icons.fact_check, color: AppColors.darkEmerald),
              label: loc.tr('verification'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.assignment_outlined),
              activeIcon:
                  const Icon(Icons.assignment, color: AppColors.darkEmerald),
              label: loc.tr('bookings'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.insights_outlined),
              activeIcon:
                  const Icon(Icons.insights, color: AppColors.darkEmerald),
              label: loc.tr('analytics'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.storefront_outlined),
              activeIcon:
                  const Icon(Icons.storefront, color: AppColors.darkEmerald),
              label: 'Co-op Hub',
            ),
          ],
        ),
      ),
    );
  }
}
