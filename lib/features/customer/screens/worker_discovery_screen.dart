import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/cooperative_model.dart';
import '../../../shared/models/worker_model.dart';
import '../../../shared/widgets/interactive_map_widget.dart';
import '../../../shared/widgets/status_badge.dart';

class WorkerDiscoveryScreen extends ConsumerStatefulWidget {
  const WorkerDiscoveryScreen({super.key});

  @override
  ConsumerState<WorkerDiscoveryScreen> createState() =>
      _WorkerDiscoveryScreenState();
}

class _WorkerDiscoveryScreenState extends ConsumerState<WorkerDiscoveryScreen> {
  String _selectedCategory = 'All';
  bool _isCoopView = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final allWorkers = repo.allWorkers.where((w) => w.online).toList();
    final allCoops = repo.allCooperatives;

    final filteredWorkers = _selectedCategory == 'All'
        ? allWorkers
        : allWorkers
            .where((w) => w.primaryCategory == _selectedCategory)
            .toList();

    final filteredCoops = _selectedCategory == 'All'
        ? allCoops
        : allCoops
            .where((c) => c.serviceCategories.contains(_selectedCategory))
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'Explore Nearby Trades & Guilds',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          // Segmented Toggle: Workers vs Cooperatives
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isCoopView = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: !_isCoopView
                            ? AppColors.seaGreen
                            : AppColors.frostedMint,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Verified Workers (${allWorkers.length})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: !_isCoopView
                              ? AppColors.white
                              : AppColors.darkEmerald,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isCoopView = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _isCoopView
                            ? AppColors.seaGreen
                            : AppColors.frostedMint,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Local Guilds (${allCoops.length})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _isCoopView
                              ? AppColors.white
                              : AppColors.darkEmerald,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Categories Filter Scroll
          Container(
            color: AppColors.white,
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              children: [
                'All',
                'Electrician',
                'Plumber',
                'AC & Appliance',
                'Carpenter',
                'Cleaner',
                'Painter',
                'Driver',
              ].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.seaGreen,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.evergreen,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.celadon),

          // Search & Map Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: InteractiveMapWidget(
              height: 160,
              showCooperativesMode: _isCoopView,
              nearbyWorkers: filteredWorkers,
              nearbyCooperatives: filteredCoops,
              onWorkerTap: (w) =>
                  context.push(AppRoutes.workerProfile, extra: w),
              onCooperativeTap: (c) =>
                  context.push(AppRoutes.cooperativeProfile, extra: c),
            ),
          ),

          // Results List
          Expanded(
            child: !_isCoopView
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredWorkers.length,
                    itemBuilder: (context, index) {
                      final w = filteredWorkers[index];
                      return _buildWorkerItem(w);
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredCoops.length,
                    itemBuilder: (context, index) {
                      final c = filteredCoops[index];
                      return _buildCooperativeItem(c);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerItem(WorkerProfile worker) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(worker.photoUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            worker.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.evergreen,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified,
                              color: AppColors.seaGreen, size: 16),
                        ],
                      ),
                      Text(
                        '${worker.primaryCategory} • ${worker.cooperativeName}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.darkEmerald,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppColors.amberWarning, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            '${worker.rating} (${worker.ratingCount})',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '• ${worker.distanceDisplay}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${worker.hourlyRate.toInt()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.seaGreen,
                      ),
                    ),
                    const Text(
                      '/ hour base',
                      style: TextStyle(
                          fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.auto_awesome,
                    size: 13, color: AppColors.seaGreen),
                const SizedBox(width: 4),
                const Text(
                  'Why match:',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.seaGreen),
                ),
                const SizedBox(width: 6),
                _chip('Trade Certified'),
                const SizedBox(width: 4),
                _chip('85% Direct Pay'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push(AppRoutes.workerProfile, extra: worker);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('View Profile',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(
                        AppRoutes.bookingFlow,
                        extra: {'worker': worker, 'isEmergency': false},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.seaGreen,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Book Worker',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCooperativeItem(Cooperative coop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(coop.logoUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              coop.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.evergreen,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified,
                              color: AppColors.mintLeaf, size: 16),
                        ],
                      ),
                      Text(
                        '${coop.region} • Reg #${coop.registrationNumber}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '★ ${coop.rating} (${coop.ratingCount}) • ${coop.completedJobsCount}+ jobs',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                StatusBadge(
                  label: '${coop.availableTodayCount} Members Avail Today',
                  status: BadgeStatus.active,
                  fontSize: 10,
                ),
                const SizedBox(width: 8),
                StatusBadge(
                  label: '${coop.serviceAreaRadiusKm.toInt()}km Radius',
                  status: BadgeStatus.coopVerified,
                  fontSize: 10,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push(AppRoutes.cooperativeProfile, extra: coop);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Co-op Profile',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(AppRoutes.bookCooperative, extra: coop);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.seaGreen,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Book Co-op Team',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.frostedMint,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: AppColors.darkEmerald,
        ),
      ),
    );
  }
}
