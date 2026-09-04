import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/theme/app_colors.dart';
import 'worker_home_screen.dart';
import 'worker_jobs_screen.dart';
import 'worker_schedule_screen.dart';
import 'worker_earnings_screen.dart';
import 'worker_self_profile_screen.dart';

class WorkerShellScreen extends ConsumerStatefulWidget {
  const WorkerShellScreen({super.key});

  @override
  ConsumerState<WorkerShellScreen> createState() => _WorkerShellScreenState();
}

class _WorkerShellScreenState extends ConsumerState<WorkerShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    WorkerHomeScreen(),
    WorkerJobsScreen(),
    WorkerScheduleScreen(),
    WorkerEarningsScreen(),
    WorkerSelfProfileScreen(),
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
              color: AppColors.evergreen.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.seaGreen,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard, color: AppColors.seaGreen),
              label: loc.tr('dashboard'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.work_outline),
              activeIcon: const Icon(Icons.work, color: AppColors.seaGreen),
              label: loc.tr('jobs'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              activeIcon:
                  const Icon(Icons.calendar_today, color: AppColors.seaGreen),
              label: loc.tr('schedule'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              activeIcon: const Icon(Icons.account_balance_wallet,
                  color: AppColors.seaGreen),
              label: loc.tr('earnings'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle_outlined),
              activeIcon:
                  const Icon(Icons.account_circle, color: AppColors.seaGreen),
              label: loc.tr('profile'),
            ),
          ],
        ),
      ),
    );
  }
}
