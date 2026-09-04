import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/service_model.dart';

class CustomerServicesScreen extends ConsumerWidget {
  const CustomerServicesScreen({super.key});

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'bolt':
        return Icons.bolt;
      case 'plumbing':
        return Icons.plumbing;
      case 'carpenter':
        return Icons.carpenter;
      case 'format_paint':
        return Icons.format_paint;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'directions_car':
        return Icons.directions_car;
      case 'hvac':
      default:
        return Icons.hvac;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final services = repo.allServices;
    final loc = AppLocalization.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: Text(
          loc.tr('services'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cooperative Service Catalog',
              style: AppTypography.headlineMedium(color: AppColors.darkEmerald),
            ),
            const SizedBox(height: 4),
            const Text(
              'Standardized transparent rates backed by cooperative quality guarantee.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            // Services List
            for (final s in services) ...[
              _buildServiceAccordion(context, s),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServiceAccordion(BuildContext context, ServiceItem service) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.celadon),
        boxShadow: [
          BoxShadow(
            color: AppColors.evergreen.withOpacity(0.03),
            blurRadius: 8,
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFDCF3E7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getIcon(service.iconName),
                color: AppColors.seaGreen, size: 24),
          ),
          title: Text(
            service.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.evergreen,
            ),
          ),
          subtitle: Text(
            'Base rate ₹${service.basePrice.toInt()} • ${service.activeWorkerCount} workers active',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Available Sub-services:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: service.subcategories.map((sub) {
                      return GestureDetector(
                        onTap: () => context.push(AppRoutes.workerDiscovery),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2FBF6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.celadon),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.arrow_right,
                                  size: 16, color: AppColors.seaGreen),
                              Text(
                                sub,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.evergreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push(AppRoutes.workerDiscovery),
                      icon: const Icon(Icons.search, size: 16),
                      label: Text('Find Nearby ${service.name}s'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.seaGreen,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
