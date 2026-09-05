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
  bool _onlyOnline = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final allWorkers = repo.allWorkers;
    final onlineWorkers = repo.onlineWorkers;
    final allCoops = repo.allCooperatives;

    final baseWorkers = _onlyOnline
        ? allWorkers.where((w) => w.online).toList()
        : allWorkers;

    final searchQuery = _searchController.text.trim().toLowerCase();

    bool matchesWorker(WorkerProfile w) {
      if (_selectedCategory != 'All') {
        final sel = _selectedCategory.trim().toLowerCase();
        final primary = w.primaryCategory.toLowerCase();
        final hasCatMatch = primary.contains(sel) ||
            sel.contains(primary) ||
            ((sel.contains('ac') || sel.contains('appliance')) &&
                (primary.contains('ac') || primary.contains('appliance'))) ||
            ((sel.contains('clean') || sel.contains('cleaner')) &&
                (primary.contains('clean') || primary.contains('cleaner'))) ||
            w.skills.any((s) =>
                s.toLowerCase().contains(sel) || sel.contains(s.toLowerCase()));
        if (!hasCatMatch) return false;
      }
      if (searchQuery.isNotEmpty) {
        final inName = w.name.toLowerCase().contains(searchQuery);
        final inCategory = w.primaryCategory.toLowerCase().contains(searchQuery);
        final inSkills =
            w.skills.any((s) => s.toLowerCase().contains(searchQuery));
        final inCoop = w.cooperativeName.toLowerCase().contains(searchQuery);
        final inAreas =
            w.serviceAreas.any((a) => a.toLowerCase().contains(searchQuery));
        return inName || inCategory || inSkills || inCoop || inAreas;
      }
      return true;
    }

    final filteredWorkers = baseWorkers.where(matchesWorker).toList();

    bool matchesCoop(Cooperative c) {
      if (_selectedCategory != 'All') {
        final sel = _selectedCategory.trim().toLowerCase();
        final hasMatch = c.serviceCategories.any((sc) =>
                sc.toLowerCase().contains(sel) ||
                sel.contains(sc.toLowerCase())) ||
            c.skills.any((s) =>
                s.toLowerCase().contains(sel) ||
                sel.contains(s.toLowerCase()));
        if (!hasMatch) return false;
      }
      if (searchQuery.isNotEmpty) {
        final inName = c.name.toLowerCase().contains(searchQuery);
        final inRegion = c.region.toLowerCase().contains(searchQuery);
        final inCats = c.serviceCategories
            .any((cat) => cat.toLowerCase().contains(searchQuery));
        final inSkills =
            c.skills.any((s) => s.toLowerCase().contains(searchQuery));
        return inName || inRegion || inCats || inSkills;
      }
      return true;
    }

    final filteredCoops = allCoops.where(matchesCoop).toList();

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
          // Search Input Bar
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.celadon),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: "Search by technician name, skill, or area...",
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.seaGreen, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear,
                              size: 18, color: AppColors.textSecondary),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          // Segmented Toggle: Workers vs Cooperatives
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        'Verified Workers (${filteredWorkers.length})',
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
                        'Local Guilds (${filteredCoops.length})',
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

          // Availability Sub-Filter Strip (All vs Online Now)
          if (!_isCoopView)
            Container(
              color: const Color(0xFFF0FDF4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => _onlyOnline = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: !_onlyOnline
                            ? AppColors.darkEmerald
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'All Available (${allWorkers.length})',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: !_onlyOnline
                              ? AppColors.white
                              : AppColors.darkEmerald,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => setState(() => _onlyOnline = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _onlyOnline
                            ? AppColors.seaGreen
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _onlyOnline
                              ? AppColors.seaGreen
                              : AppColors.celadon,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '⚡ Online Now (${onlineWorkers.length})',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _onlyOnline
                                  ? AppColors.white
                                  : AppColors.darkEmerald,
                            ),
                          ),
                        ],
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

          // Results List / Empty State
          Expanded(
            child: !_isCoopView
                ? (filteredWorkers.isEmpty
                    ? _buildEmptyWorkersState(context)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredWorkers.length,
                        itemBuilder: (context, index) {
                          final w = filteredWorkers[index];
                          return _buildWorkerItem(w);
                        },
                      ))
                : (filteredCoops.isEmpty
                    ? _buildEmptyCoopsState(context)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredCoops.length,
                        itemBuilder: (context, index) {
                          final c = filteredCoops[index];
                          return _buildCooperativeItem(c);
                        },
                      )),
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
        border: Border.all(
          color: worker.online ? AppColors.seaGreen.withOpacity(0.6) : AppColors.celadon,
          width: worker.online ? 1.2 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(worker.photoUrl),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: worker.online ? const Color(0xFF10B981) : const Color(0xFF9CA3AF),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
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
                              worker.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.evergreen,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified,
                              color: AppColors.seaGreen, size: 16),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: worker.online
                                  ? const Color(0xFFDCFCE7)
                                  : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: worker.online
                                    ? const Color(0xFF86EFAC)
                                    : const Color(0xFFD1D5DB),
                              ),
                            ),
                            child: Text(
                              worker.online ? '● ONLINE' : '○ OFFLINE',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: worker.online
                                    ? const Color(0xFF166534)
                                    : const Color(0xFF4B5563),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${worker.primaryCategory} • ${worker.cooperativeName}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.darkEmerald,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                    child: Text(
                      worker.online ? 'Book Worker ⚡' : 'Book Worker',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
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

  Widget _buildEmptyWorkersState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.celadon),
            boxShadow: [
              BoxShadow(
                color: AppColors.evergreen.withOpacity(0.04),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.frostedMint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.engineering_outlined,
                  size: 42,
                  color: AppColors.seaGreen,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                _selectedCategory == 'All'
                    ? 'No Registered Workers Online'
                    : 'No $_selectedCategory Workers Online',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.evergreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                _selectedCategory == 'All'
                    ? 'When a member registers as a worker, their profile and real-time availability will appear here immediately.'
                    : 'No active technicians found under $_selectedCategory yet. Try exploring another trade or post a Custom Request!',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              if (_selectedCategory != 'All')
                OutlinedButton.icon(
                  onPressed: () => setState(() => _selectedCategory = 'All'),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('View All Categories'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.seaGreen,
                    side: const BorderSide(color: AppColors.seaGreen),
                  ),
                ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.customWorkRequest),
                icon: const Icon(Icons.add_task, size: 16),
                label: const Text('Post Custom Work Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.seaGreen,
                  foregroundColor: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCoopsState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.celadon),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_city, size: 40, color: AppColors.seaGreen),
              SizedBox(height: 12),
              Text(
                'No Guilds Match Selected Category',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.evergreen,
                ),
              ),
            ],
          ),
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
