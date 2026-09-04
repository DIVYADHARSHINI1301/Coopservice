import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/cooperative_model.dart';
import '../../../shared/models/worker_model.dart';
import '../../../shared/widgets/interactive_map_widget.dart';
import '../../../shared/widgets/status_badge.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData _getCategoryIcon(String iconName) {
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
  Widget build(BuildContext context) {
    final loc = AppLocalization.of(context);
    final repo = ref.watch(platformRepositoryProvider);
    final workers = repo.allWorkers.where((w) => w.online).toList();
    final cooperatives = repo.allCooperatives;
    final services = repo.allServices;
    final activeUser = repo.currentUser;
    final customer = repo.currentCustomerProfile;

    // Get My Regulars workers
    final regularWorkers = repo.allWorkers
        .where((w) => customer.myRegularWorkerIds.containsValue(w.uid))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.diversity_3,
                size: 20,
                color: AppColors.seaGreen,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.tr('appName'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const Text(
                  'ANNA NAGAR GUILD #402',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: AppColors.celadon,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Greeting & Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vanakkam, ${activeUser.name.split(' ').first} 👋',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkEmerald,
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: AppColors.seaGreen),
                        SizedBox(width: 4),
                        Text(
                          'Plot 42, 2nd Ave, Anna Nagar East',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Emergency Priority Rail
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.pineTeal, AppColors.evergreen],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.evergreen.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: AppColors.redDestructive,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flash_on,
                        color: AppColors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              loc.tr('emergencyService'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            StatusBadge(
                              label: loc.tr('priority'),
                              status: BadgeStatus.emergency,
                              fontSize: 9,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          loc.tr('standbyDesc'),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.frostedMint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.push(
                        AppRoutes.bookingFlow,
                        extra: {
                          'worker': repo.allWorkers.first,
                          'isEmergency': true,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redDestructive,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Dispatch',
                        style: TextStyle(fontSize: 12, color: AppColors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search electrician, plumber, AC service or co-op...',
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.darkEmerald),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune, color: AppColors.seaGreen),
                  onPressed: () => context.push(AppRoutes.workerDiscovery),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // MY REGULARS Rail (Fast 1-Tap Rebooking)
            if (regularWorkers.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.push_pin, size: 16, color: AppColors.seaGreen),
                      SizedBox(width: 6),
                      Text(
                        'My Regular Technicians',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${regularWorkers.length} Pinned',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.seaGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 88,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: regularWorkers.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final w = regularWorkers[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        context.push(
                          AppRoutes.bookingFlow,
                          extra: {'worker': w, 'isEmergency': false},
                        );
                      },
                      child: Container(
                        width: 210,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.celadon),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(w.photoUrl),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    w.name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.evergreen,
                                    ),
                                  ),
                                  Text(
                                    'Regular ${w.primaryCategory}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.darkEmerald,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Text(
                                    '1-Tap Rebook →',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.seaGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
            ],

            // Service Categories Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loc.tr('serviceCategories'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkEmerald,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.customerServices),
                  child: Text(
                    loc.tr('seeAll'),
                    style: const TextStyle(
                        color: AppColors.seaGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 105,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: services.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final s = services[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => context.push(AppRoutes.workerDiscovery),
                    child: Container(
                      width: 90,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.celadon),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.frostedMint,
                            child: Icon(
                              _getCategoryIcon(s.iconName),
                              color: AppColors.darkEmerald,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            s.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.evergreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // 3 Ecosystem Hub Shortcuts: Service Vault | Society Split | Care Plans
            Row(
              children: [
                Expanded(
                  child: _hubCard(
                    icon: Icons.folder_special,
                    title: 'Service Vault',
                    subtitle: 'Job Cards & 90d Warranty',
                    onTap: () => context.push(AppRoutes.customerVault),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _hubCard(
                    icon: Icons.apartment,
                    title: 'Society Split',
                    subtitle: 'Multi-Flat Repairs',
                    onTap: () => context.push(AppRoutes.groupBooking),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _hubCard(
                    icon: Icons.autorenew,
                    title: 'Care Plans',
                    subtitle: '15% Off Subscriptions',
                    onTap: () => context.push(AppRoutes.recurringCare),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // LOCAL COOPERATIVES NEAR YOU Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loc.tr('localCooperatives'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkEmerald,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.workerDiscovery),
                  child: const Text(
                    'All Guilds',
                    style: TextStyle(
                        color: AppColors.seaGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Cooperative Cards Carousel
            SizedBox(
              height: 195,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cooperatives.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final coop = cooperatives[index];
                  return _buildCooperativeCard(coop);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Custom Work Request Banner
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.push(AppRoutes.customWorkRequest),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.mintLeaf2),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.frostedMint,
                      child: const Icon(Icons.post_add,
                          color: AppColors.darkEmerald, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.tr('customRequest'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.evergreen,
                            ),
                          ),
                          Text(
                            loc.tr('customRequestDesc'),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.seaGreen),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Nearby Verified Workers List with Neighborhood Trust Signal & Smart Match chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loc.tr('nearbyWorkers'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkEmerald,
                  ),
                ),
                Text(
                  '${workers.length} ${loc.tr('onlineCount')}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.seaGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...workers.take(2).map((w) => _buildWorkerCard(w)),
          ],
        ),
      ),
    );
  }

  Widget _hubCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.celadon),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.seaGreen, size: 22),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.evergreen,
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCooperativeCard(Cooperative coop) {
    return Container(
      width: 255,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.celadon),
        boxShadow: [
          BoxShadow(
            color: AppColors.evergreen.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push(AppRoutes.cooperativeProfile, extra: coop);
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(coop.logoUrl),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coop.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.evergreen,
                            ),
                          ),
                          Text(
                            coop.region,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Neighborhood Trust Signal
                Row(
                  children: [
                    const Icon(Icons.bolt, color: AppColors.amberWarning, size: 14),
                    Text(
                      '⚡ 38 local homes served this month',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkEmerald,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    StatusBadge(
                      label: 'Verified Guild',
                      status: BadgeStatus.coopVerified,
                      fontSize: 9,
                    ),
                    const SizedBox(width: 6),
                    StatusBadge(
                      label: '${coop.availableTodayCount} Avail',
                      status: BadgeStatus.active,
                      fontSize: 9,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '★ ${coop.rating} (${coop.completedJobsCount}+ jobs)',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'View Co-op →',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.seaGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkerCard(WorkerProfile worker) {
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
                          const SizedBox(width: 6),
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
                          const SizedBox(width: 8),
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

            // Neighborhood Trust Signal & Smart Matching Explanation Chips
            Row(
              children: [
                const Icon(Icons.auto_awesome,
                    size: 13, color: AppColors.seaGreen),
                const SizedBox(width: 4),
                const Text(
                  'Trust Signal:',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.seaGreen),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _matchChip('⚡ 18 local bookings in Anna Nagar'),
                        _matchChip('Skill Verified'),
                        _matchChip('Co-op Owner'),
                      ],
                    ),
                  ),
                ),
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
                    child: const Text('Book Now',
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

  Widget _matchChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
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
