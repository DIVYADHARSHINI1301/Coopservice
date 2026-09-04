import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/cooperative_model.dart';
import '../../../shared/models/worker_model.dart';
import '../../../shared/widgets/status_badge.dart';
import '../widgets/ask_coordinator_modal.dart';

class CooperativeProfileScreen extends ConsumerStatefulWidget {
  final Cooperative cooperative;

  const CooperativeProfileScreen({super.key, required this.cooperative});

  @override
  ConsumerState<CooperativeProfileScreen> createState() =>
      _CooperativeProfileScreenState();
}

class _CooperativeProfileScreenState
    extends ConsumerState<CooperativeProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final customer = repo.currentCustomerProfile;
    final isSaved = customer.savedCooperativeIds.contains(widget.cooperative.id);
    final coopWorkers = repo.allWorkers
        .where((w) => w.cooperativeId == widget.cooperative.id)
        .toList();
    final coopReviews = repo.allReviews
        .where((r) => r.cooperativeId == widget.cooperative.id)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              backgroundColor: AppColors.darkEmerald,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_border,
                    color: isSaved ? AppColors.redDestructive : AppColors.white,
                  ),
                  onPressed: () {
                    repo.toggleSaveCooperative(widget.cooperative.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isSaved
                              ? 'Removed from trusted cooperatives'
                              : 'Saved to your trusted cooperatives!',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: AppColors.white),
                  onPressed: () {},
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.cooperative.coverUrl,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            AppColors.evergreen.withOpacity(0.85),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white,
                              border: Border.all(
                                  color: AppColors.mintLeaf2, width: 2),
                              image: DecorationImage(
                                image:
                                    NetworkImage(widget.cooperative.logoUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.cooperative.name,
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified,
                                        color: AppColors.mintLeaf, size: 18),
                                  ],
                                ),
                                Text(
                                  '${widget.cooperative.region} • Reg: ${widget.cooperative.registrationNumber}',
                                  style: const TextStyle(
                                    color: AppColors.celadon,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: AppColors.amberWarning, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.cooperative.rating} (${widget.cooperative.ratingCount} reviews)',
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '• ${widget.cooperative.activeWorkerCount} members active',
                                      style: const TextStyle(
                                        color: AppColors.frostedMint,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppColors.mintLeaf,
                indicatorWeight: 3,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.celadon.withOpacity(0.7),
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: 'About'),
                  Tab(text: 'Services'),
                  Tab(text: 'Workers'),
                  Tab(text: 'Reviews'),
                  Tab(text: 'Availability'),
                  Tab(text: 'Impact'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAboutTab(),
            _buildServicesTab(),
            _buildWorkersTab(coopWorkers),
            _buildReviewsTab(coopReviews),
            _buildAvailabilityTab(),
            _buildImpactTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.evergreen.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: () {
                    AskCoordinatorModal.show(context, widget.cooperative);
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Ask Question', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.seaGreen),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(
                      AppRoutes.bookCooperative,
                      extra: widget.cooperative,
                    );
                  },
                  icon: const Icon(Icons.groups, size: 18),
                  label: const Text('Book Team', style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.seaGreen,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About This Cooperative',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkEmerald,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.cooperative.description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.evergreen,
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(color: AppColors.celadon),
                const SizedBox(height: 8),
                _infoRow(Icons.location_on_outlined, 'Address',
                    widget.cooperative.address),
                const SizedBox(height: 8),
                _infoRow(Icons.phone_outlined, 'Coordinator Contact',
                    widget.cooperative.phone),
                const SizedBox(height: 8),
                _infoRow(Icons.email_outlined, 'Co-op Email',
                    widget.cooperative.email),
                const SizedBox(height: 8),
                _infoRow(Icons.calendar_today_outlined, 'Established',
                    '${widget.cooperative.establishedYear} (${DateTime.now().year - widget.cooperative.establishedYear} yrs of service)'),
                const SizedBox(height: 8),
                _infoRow(Icons.radar_outlined, 'Service Coverage',
                    '${widget.cooperative.serviceAreaRadiusKm.toInt()} km radius from hub'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Co-op Guarantee
          _buildCard(
            bgColor: AppColors.frostedMint.withOpacity(0.6),
            borderColor: AppColors.mintLeaf2.withOpacity(0.5),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.seaGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shield,
                      color: AppColors.white, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cooperative Member Guarantee',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen,
                        ),
                      ),
                      Text(
                        'All workers are verified owners, insured under the National Health Shield, and vetted with trade licenses.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.3,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.cooperative.serviceCategories.length,
      itemBuilder: (context, index) {
        final cat = widget.cooperative.serviceCategories[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.frostedMint,
                  child: const Icon(Icons.handyman, color: AppColors.seaGreen),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cat,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen,
                        ),
                      ),
                      const Text(
                        'Certified technicians & apprentice teams available',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.push(
                      AppRoutes.bookCooperative,
                      extra: widget.cooperative,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.seaGreen,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text('Book', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWorkersTab(List<WorkerProfile> workers) {
    if (workers.isEmpty) {
      return const Center(child: Text('No workers listed in this cluster.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workers.length,
      itemBuilder: (context, index) {
        final w = workers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            onTap: () {
              context.push(AppRoutes.workerProfile, extra: w);
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(w.photoUrl),
            ),
            title: Text(
              w.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Text(
              '${w.primaryCategory} • ${w.experienceYears} yrs exp • ★ ${w.rating}',
              style: const TextStyle(fontSize: 11),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.seaGreen),
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab(List coopReviews) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: coopReviews.length,
      itemBuilder: (context, index) {
        final r = coopReviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      r.customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.evergreen,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: AppColors.amberWarning, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${r.rating}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  r.comment,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvailabilityTab() {
    final avail = widget.cooperative.skillAvailability;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Cooperative Shift Capacity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkEmerald,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Live aggregated member headcount available for dispatch',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ...avail.entries.map((entry) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        StatusBadge(
                          label: '${entry.value.totalAvailable} Members Today',
                          status: BadgeStatus.active,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _shiftBlock(
                            'Morning', '8 AM–12 PM', entry.value.morning),
                        _shiftBlock(
                            'Afternoon', '12 PM–5 PM', entry.value.afternoon),
                        _shiftBlock(
                            'Evening', '5 PM–9 PM', entry.value.evening),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _shiftBlock(String title, String timing, int count) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(timing,
            style: const TextStyle(
                fontSize: 10, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.frostedMint,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count avail',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.darkEmerald,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImpactTab() {
    final stories = widget.cooperative.stories;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cooperative Financial Impact Overview
          _buildCard(
            bgColor: AppColors.pineTeal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'COOPERATIVE REINVESTMENT LEDGER',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: AppColors.celadon,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '₹73,440 Allocated to Member Welfare',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Every booking direct contribution: 85% to artisan, 12% to community health fund & tool loans, 3% app maintenance.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.frostedMint,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Community & Worker Growth Stories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkEmerald,
            ),
          ),
          const SizedBox(height: 12),
          ...stories.map((story) {
            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      story.imageUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          story.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${story.workersImpacted} artisan families supported',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.seaGreen,
                              ),
                            ),
                            Text(
                              story.date,
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
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCard({
    required Widget child,
    Color bgColor = AppColors.white,
    Color borderColor = AppColors.celadon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: child,
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.seaGreen),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.evergreen,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
