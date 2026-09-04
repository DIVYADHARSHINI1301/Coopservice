import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/cooperative_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/status_badge.dart';

class SuperCooperativesScreen extends ConsumerStatefulWidget {
  const SuperCooperativesScreen({super.key});

  @override
  ConsumerState<SuperCooperativesScreen> createState() =>
      _SuperCooperativesScreenState();
}

class _SuperCooperativesScreenState
    extends ConsumerState<SuperCooperativesScreen> {
  void _showCreateCoopDialog() {
    final nameController = TextEditingController();
    final regionController = TextEditingController();
    final regNumberController = TextEditingController(text: 'COOP-TN-CHE-099');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Charter New Cooperative',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkEmerald,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Cooperative Name'),
                const SizedBox(height: 4),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Tambaram & Chromepet Trades Co-op',
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Territory / Region'),
                const SizedBox(height: 4),
                TextField(
                  controller: regionController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Chennai South-West Cluster',
                  ),
                ),
                const SizedBox(height: 12),
                const Text('State Registration Number'),
                const SizedBox(height: 4),
                TextField(
                  controller: regNumberController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. COOP-TN-CHE-099',
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Charter Cooperative',
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) return;
                    ref.read(platformRepositoryProvider).createCooperative(
                          name: nameController.text.trim(),
                          region: regionController.text.trim().isEmpty
                              ? 'Chennai'
                              : regionController.text.trim(),
                          regNumber: regNumberController.text.trim(),
                        );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('New Cooperative chartered and activated!'),
                        backgroundColor: AppColors.seaGreen,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final coops = repo.allCooperatives;

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.evergreen,
        title: Text(
          'Cooperatives Management (${coops.length})',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateCoopDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.seaGreen,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add_business),
        label: const Text('Charter Co-op'),
        onPressed: _showCreateCoopDialog,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: coops.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final coop = coops[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.celadon),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      coop.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const StatusBadge(
                      label: 'Active',
                      status: BadgeStatus.active,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Region: ${coop.region} • Reg: ${coop.registrationNumber}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _coopStat('Workers', '${coop.workerCount}'),
                    const SizedBox(width: 16),
                    _coopStat('Available Today', '${coop.availableTodayCount}'),
                    const SizedBox(width: 16),
                    _coopStat('Rating', '${coop.rating} ★'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Assigned Admin: ${coop.adminNames.isNotEmpty ? coop.adminNames.first : 'M. Sundaram'}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkEmerald,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Managing ${coop.name}...'),
                            backgroundColor: AppColors.seaGreen,
                          ),
                        );
                      },
                      child: const Text('Configure'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _coopStat(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        Text(val,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald)),
      ],
    );
  }
}
