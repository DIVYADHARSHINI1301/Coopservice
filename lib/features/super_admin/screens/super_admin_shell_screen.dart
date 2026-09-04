import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/theme/app_colors.dart';
import 'super_dashboard_screen.dart';
import 'super_cooperatives_screen.dart';
import 'super_worker_approvals_screen.dart';
import 'super_disputes_screen.dart';
import 'super_services_catalog_screen.dart';
import 'super_ai_forecast_screen.dart';
import 'super_audit_logs_screen.dart';

class SuperAdminShellScreen extends ConsumerStatefulWidget {
  const SuperAdminShellScreen({super.key});

  @override
  ConsumerState<SuperAdminShellScreen> createState() =>
      _SuperAdminShellScreenState();
}

class _SuperAdminShellScreenState extends ConsumerState<SuperAdminShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SuperDashboardScreen(),
    SuperCooperativesScreen(),
    SuperWorkerApprovalsScreen(),
    SuperDisputesScreen(),
    SuperServicesCatalogScreen(),
    SuperAiForecastScreen(),
    SuperAuditLogsScreen(),
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
          selectedItemColor: AppColors.pineTeal,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.analytics_outlined),
              activeIcon:
                  const Icon(Icons.analytics, color: AppColors.pineTeal),
              label: loc.tr('dashboard'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.corporate_fare_outlined),
              activeIcon:
                  const Icon(Icons.corporate_fare, color: AppColors.pineTeal),
              label: loc.tr('cooperatives'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.how_to_reg_outlined),
              activeIcon:
                  const Icon(Icons.how_to_reg, color: AppColors.pineTeal),
              label: loc.tr('approvals'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.gavel_outlined),
              activeIcon: const Icon(Icons.gavel, color: AppColors.pineTeal),
              label: 'Disputes',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.category_outlined),
              activeIcon:
                  const Icon(Icons.category, color: AppColors.pineTeal),
              label: 'Catalog',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.auto_graph_outlined),
              activeIcon:
                  const Icon(Icons.auto_graph, color: AppColors.pineTeal),
              label: 'AI Forecast',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history_edu_outlined),
              activeIcon:
                  const Icon(Icons.history_edu, color: AppColors.pineTeal),
              label: 'Audit Logs',
            ),
          ],
        ),
      ),
    );
  }
}
