import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/theme/app_colors.dart';
import 'customer_home_screen.dart';
import 'worker_discovery_screen.dart';
import 'customer_bookings_screen.dart';
import 'customer_impact_screen.dart';
import 'customer_profile_screen.dart';

class CustomerShellScreen extends ConsumerStatefulWidget {
  const CustomerShellScreen({super.key});

  @override
  ConsumerState<CustomerShellScreen> createState() =>
      _CustomerShellScreenState();
}

class _CustomerShellScreenState extends ConsumerState<CustomerShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CustomerHomeScreen(),
    WorkerDiscoveryScreen(),
    CustomerBookingsScreen(),
    CustomerImpactScreen(),
    CustomerProfileScreen(),
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
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home, color: AppColors.seaGreen),
              label: loc.tr('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.explore_outlined),
              activeIcon: const Icon(Icons.explore, color: AppColors.seaGreen),
              label: loc.tr('explore'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
              activeIcon:
                  const Icon(Icons.calendar_month, color: AppColors.seaGreen),
              label: loc.tr('bookings'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.volunteer_activism_outlined),
              activeIcon: const Icon(Icons.volunteer_activism,
                  color: AppColors.seaGreen),
              label: loc.tr('impact'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle_outlined),
              activeIcon:
                  const Icon(Icons.account_circle, color: AppColors.seaGreen),
              label: loc.tr('account'),
            ),
          ],
        ),
      ),
    );
  }
}
