import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/cooperative_model.dart';
import '../../../shared/models/customer_model.dart';
import '../../../shared/models/worker_model.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/widgets/status_badge.dart';

// Service Category Flashcard Model
class CategoryFlashcard {
  final String name;
  final String title;
  final String description;
  final String imageUrl;
  final String badge;
  final Color badgeColor;
  final String categoryFilter;

  const CategoryFlashcard({
    required this.name,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.badge,
    this.badgeColor = AppColors.seaGreen,
    required this.categoryFilter,
  });
}

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late PageController _carouselController;
  Timer? _autoSlideTimer;
  int _currentCarouselIndex = 0;
  String _selectedAddress = 'Plot 42, 2nd Avenue, Anna Nagar East';

  // Realistic, relevant work photography flashcards (NO generic lightning icons for Electrician!)
  final List<CategoryFlashcard> _flashcards = const [
    CategoryFlashcard(
      name: 'Electrician',
      title: 'MASTER ELECTRICIANS',
      description: 'Wiring, MCB switches, inverters & complete electrical repair',
      imageUrl:
          'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=700&auto=format&fit=crop&q=80',
      badge: '⚡ 15 Mins Dispatch',
      badgeColor: AppColors.seaGreen,
      categoryFilter: 'Electrician',
    ),
    CategoryFlashcard(
      name: 'Plumber',
      title: 'CERTIFIED PLUMBERS',
      description: 'Pipe leaks, bathroom fittings, motor pumps & drain clearing',
      imageUrl:
          'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?w=700&auto=format&fit=crop&q=80',
      badge: 'Certified Guild',
      badgeColor: Color(0xFF0284C7),
      categoryFilter: 'Plumber',
    ),
    CategoryFlashcard(
      name: 'AC & Appliance',
      title: 'AC & APPLIANCE REPAIR',
      description: 'Jet servicing, gas recharge, washing machine & fridge repair',
      imageUrl:
          'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?w=700&auto=format&fit=crop&q=80',
      badge: '90-Day Warranty',
      badgeColor: AppColors.darkEmerald,
      categoryFilter: 'AC & Appliance',
    ),
    CategoryFlashcard(
      name: 'Carpenter',
      title: 'CARPENTRY & WOODWORK',
      description: 'Custom furniture, door hinges, modular fittings & polish',
      imageUrl:
          'https://images.unsplash.com/photo-1538688525198-9b88f6f53126?w=700&auto=format&fit=crop&q=80',
      badge: 'Master Guild',
      badgeColor: Color(0xFFB45309),
      categoryFilter: 'Carpenter',
    ),
    CategoryFlashcard(
      name: 'Painter',
      title: 'PAINTING & WATERPROOF',
      description: 'Interior wall rolling, exterior texture & terrace proofing',
      imageUrl:
          'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?w=700&auto=format&fit=crop&q=80',
      badge: 'Eco Paints',
      badgeColor: Color(0xFFEA580C),
      categoryFilter: 'Painter',
    ),
    CategoryFlashcard(
      name: 'Cleaning',
      title: 'PROFESSIONAL CLEANING',
      description: 'Deep home disinfection, kitchen chimney & sofa shampooing',
      imageUrl:
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=700&auto=format&fit=crop&q=80',
      badge: 'Trained Staff',
      badgeColor: Color(0xFF0D9488),
      categoryFilter: 'Cleaning',
    ),
    CategoryFlashcard(
      name: 'Emergency',
      title: 'EMERGENCY EXPRESS 24/7',
      description: 'Power cut breakdown, burst pipe & urgent gas leak resolution',
      imageUrl:
          'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=700&auto=format&fit=crop&q=80',
      badge: '⚡ Priority Dispatch',
      badgeColor: AppColors.redDestructive,
      categoryFilter: 'Emergency',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _carouselController = PageController(viewportFraction: 0.88);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      if (_carouselController.hasClients) {
        final nextPage = (_currentCarouselIndex + 1) % _flashcards.length;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _carouselController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    context.push(AppRoutes.workerDiscovery);
  }

  void _showAddressSelector(BuildContext context, CustomerProfile customer) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Service Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.evergreen,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...customer.savedAddresses.map((addr) {
                final isSelected = _selectedAddress == addr.address;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.frostedMint.withOpacity(0.5)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.seaGreen : AppColors.celadon,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      addr.label.toLowerCase().contains('home')
                          ? Icons.home
                          : Icons.work,
                      color: isSelected ? AppColors.seaGreen : AppColors.darkEmerald,
                    ),
                    title: Text(
                      addr.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.evergreen,
                      ),
                    ),
                    subtitle: Text(
                      addr.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.seaGreen)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedAddress = addr.address;
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                );
              }),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push(AppRoutes.customerProfile);
                },
                icon: const Icon(Icons.add_location_alt, color: AppColors.seaGreen),
                label: const Text('Add / Manage Saved Addresses'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 46),
                  side: const BorderSide(color: AppColors.seaGreen),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final onlineWorkers = repo.onlineWorkers;
    final allRegisteredWorkers = repo.allWorkers;
    final cooperatives = repo.allCooperatives;
    final customer = repo.currentCustomerProfile;

    // Regular Pinned Workers
    final regularWorkers = repo.allWorkers
        .where((w) => customer.myRegularWorkerIds.containsValue(w.uid))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF9),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================================
            // 1. TOP HEADER (Deep Evergreen Brand Bar with Location & Search)
            // =========================================================
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF09241B), Color(0xFF11382A), Color(0xFF1A4D3B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Location ETA + Address Dropdown + Active Capsule
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on, color: AppColors.white, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () => _showAddressSelector(context, customer),
                              borderRadius: BorderRadius.circular(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'In 15 minutes',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          _selectedAddress,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.celadon,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 16,
                                        color: AppColors.celadon,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Active Guilds Capsule Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.white.withOpacity(0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.mintLeaf,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  '4 Guilds Active',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Functional Search Bar (Directly Above Carousel)
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.evergreen.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: _handleSearch,
                          decoration: InputDecoration(
                            hintText: "Search for 'Electrician, AC repair, Plumber...'",
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.darkEmerald,
                              size: 22,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.tune, color: AppColors.seaGreen, size: 20),
                              onPressed: () => context.push(AppRoutes.workerDiscovery),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // =========================================================
            // ACTIVE BOOKING LIVE TRACKING BANNER (Auto-reacting)
            // =========================================================
            if (repo.allBookings.any((b) =>
                b.customerId == repo.currentUser.uid &&
                (b.status == BookingStatus.bookingCreated ||
                    b.status == BookingStatus.workerSearching ||
                    b.status == BookingStatus.workerAccepted ||
                    b.status == BookingStatus.workerOnTheWay ||
                    b.status == BookingStatus.workerArrived ||
                    b.status == BookingStatus.workStarted ||
                    b.status == BookingStatus.workInProgress ||
                    b.status == BookingStatus.workCompleted))) ...[
              Builder(
                builder: (context) {
                  final activeB = repo.allBookings.firstWhere((b) =>
                      b.customerId == repo.currentUser.uid &&
                      (b.status == BookingStatus.bookingCreated ||
                          b.status == BookingStatus.workerSearching ||
                          b.status == BookingStatus.workerAccepted ||
                          b.status == BookingStatus.workerOnTheWay ||
                          b.status == BookingStatus.workerArrived ||
                          b.status == BookingStatus.workStarted ||
                          b.status == BookingStatus.workInProgress ||
                          b.status == BookingStatus.workCompleted));
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        context.push(
                          AppRoutes.activeBookingTracking,
                          extra: activeB,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF065F46), Color(0xFF047857)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.seaGreen.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.bolt,
                                  color: AppColors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'ACTIVE BOOKING #${activeB.id}',
                                        style: const TextStyle(
                                          color: AppColors.celadon,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.mintLeaf,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          activeB.status.label.toUpperCase(),
                                          style: const TextStyle(
                                            color: AppColors.darkEmerald,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${activeB.serviceSubtype} with ${activeB.workerName}',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    activeB.status.customerStatusDescription(
                                        activeB.workerName),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.frostedMint,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: AppColors.white),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],

            // =========================================================
            // 2. SLIDING SERVICE-CATEGORY FLASHCARDS (Real Work Photography)
            // =========================================================
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured Guild Trades',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.workerDiscovery),
                        child: const Text(
                          'View All Trades →',
                          style: TextStyle(
                            color: AppColors.seaGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Carousel Container with Auto-slide & Manual Swipe
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: _carouselController,
                    itemCount: _flashcards.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentCarouselIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = _flashcards[index];
                      return _buildSlidingCategoryCard(context, item);
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // Smooth Dots Indicator
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_flashcards.length, (idx) {
                      final isSelected = _currentCarouselIndex == idx;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isSelected ? 18 : 6,
                        height: 5,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.seaGreen : AppColors.celadon,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =========================================================
            // 3. CUSTOM WORK REQUEST — MAJOR PROMINENT FEATURE
            //    (Placing ABOVE Native Cooperative Tools as requested)
            // =========================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildCustomWorkRequestHeroCard(context),
            ),

            const SizedBox(height: 22),

            // =========================================================
            // 4. NATIVE COOPERATIVE TOOLS
            //    (Kept intact & enhanced below Custom Work Request)
            // =========================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Native Cooperative Tools',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.evergreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNativeProductCard(
                          icon: Icons.folder_special,
                          title: 'Service Vault',
                          subtitle: 'Digital Job Cards & 90d Warranty',
                          isNew: true,
                          onTap: () => context.push(AppRoutes.customerVault),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNativeProductCard(
                          icon: Icons.apartment,
                          title: 'Society Split',
                          subtitle: 'Multi-Flat Bulk Community Repairs',
                          isNew: false,
                          onTap: () => context.push(AppRoutes.groupBooking),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildCarePlanStrip(context),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Subtle Section Divider
            Container(height: 8, color: const Color(0xFFE2EFEA)),

            const SizedBox(height: 20),

            // =========================================================
            // 5A. ONLINE TECHNICIANS (Instant 15-Min Live Dispatch)
            // =========================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: onlineWorkers.isNotEmpty
                                    ? const Color(0xFF10B981)
                                    : AppColors.textSecondary,
                                shape: BoxShape.circle,
                                boxShadow: onlineWorkers.isNotEmpty
                                    ? [
                                        BoxShadow(
                                          color: AppColors.seaGreen.withOpacity(0.6),
                                          blurRadius: 6,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Online Technicians',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.evergreen,
                                    ),
                                  ),
                                  Text(
                                    onlineWorkers.isNotEmpty
                                        ? '⚡ Ready for instant 15-min dispatch in your area'
                                        : 'No workers toggled online right now',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.workerDiscovery),
                        child: Text(
                          'See All (${onlineWorkers.length}) →',
                          style: const TextStyle(
                            color: AppColors.seaGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (onlineWorkers.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.celadon),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: AppColors.frostedMint,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.wifi_tethering_off,
                                color: AppColors.seaGreen, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'No Technicians Online Yet',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.evergreen,
                                  ),
                                ),
                                Text(
                                  'When workers toggle online, they appear here live. Check all available registered workers below for bookings.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...onlineWorkers.map((w) => _buildSpotlightWorkerCard(w, isOnlineSection: true)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Subtle Section Divider
            Container(height: 8, color: const Color(0xFFE2EFEA)),

            const SizedBox(height: 20),

            // =========================================================
            // 5B. AVAILABLE GUILD WORKERS (All Registered Artisans)
            // =========================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Available Guild Workers',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.evergreen,
                              ),
                            ),
                            Text(
                              'All registered & certified cooperative technicians (${allRegisteredWorkers.length})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.workerDiscovery),
                        child: const Text(
                          'Explore Guild →',
                          style: TextStyle(
                            color: AppColors.seaGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (allRegisteredWorkers.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.celadon),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: AppColors.frostedMint,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.handyman_outlined,
                                color: AppColors.seaGreen, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'No Registered Workers Yet',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.evergreen,
                                  ),
                                ),
                                Text(
                                  'Newly registered cooperative members will appear here automatically.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...allRegisteredWorkers.map((w) => _buildSpotlightWorkerCard(w, isOnlineSection: false)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Subtle Section Divider
            Container(height: 8, color: const Color(0xFFE2EFEA)),

            const SizedBox(height: 20),

            // =========================================================
            // 6. MY REGULARS RAIL (Fast 1-Tap Rebooking)
            // =========================================================
            if (regularWorkers.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.push_pin, size: 16, color: AppColors.seaGreen),
                        SizedBox(width: 6),
                        Text(
                          'My Regular Technicians',
                          style: TextStyle(
                            fontSize: 16,
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
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 88,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
              const SizedBox(height: 20),
            ],

            // =========================================================
            // 7. LOCAL COOPERATIVE GUILDS
            // =========================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Local Cooperative Guilds',
                    style: TextStyle(
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
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 195,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: cooperatives.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final coop = cooperatives[index];
                  return _buildCooperativeCard(coop);
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HELPER WIDGETS
  // =========================================================

  // 1. Sliding Category Flashcard Item
  Widget _buildSlidingCategoryCard(BuildContext context, CategoryFlashcard item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.evergreen.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (item.name == 'Emergency') {
                final repo = ref.read(platformRepositoryProvider);
                if (repo.allWorkers.isNotEmpty) {
                  context.push(
                    AppRoutes.bookingFlow,
                    extra: {
                      'worker': repo.allWorkers.first,
                      'isEmergency': true,
                    },
                  );
                } else {
                  context.push(AppRoutes.workerDiscovery);
                }
              } else {
                context.push(AppRoutes.workerDiscovery);
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Real Work Photo Image with Fallback
                Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                    color: AppColors.pineTeal,
                    child: const Icon(Icons.handyman, color: AppColors.celadon, size: 48),
                  ),
                  loadingBuilder: (ctx, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: const Color(0xFFE2EFEA),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.seaGreen),
                      ),
                    );
                  },
                ),

                // Dark Gradient Scrim Overlay for High Text Readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0.85),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // Flashcard Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Badge
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: item.badgeColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Text(
                            item.badge,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),

                      // Title & Subtitle & CTA
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFE0ECE6),
                              fontSize: 11,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: const [
                              Text(
                                'Book Certified Guild Worker',
                                style: TextStyle(
                                  color: AppColors.mintLeaf,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, color: AppColors.mintLeaf, size: 14),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 2. Custom Work Request Prominent Hero Card
  Widget _buildCustomWorkRequestHeroCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C382A), Color(0xFF144D3A), Color(0xFF1E6B52)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.evergreen.withOpacity(0.2),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.mintLeaf.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.handyman_rounded, color: AppColors.mintLeaf, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.mintLeaf,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'UNIQUE & SPECIALIZED TASKS',
                          style: TextStyle(
                            color: Color(0xFF09241B),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Can't find the exact service you need?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Tell us what you need — our cooperative coordinators will review your requirements and match certified guild artisans with zero platform markup.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.frostedMint,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),

            // Feature Highlights Pills (Responsive Wrap - never overflows)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _highlightPill('⚡ Free Estimates'),
                _highlightPill('🛡️ 90d Warranty'),
                _highlightPill('🤝 Fair Pricing'),
              ],
            ),
            const SizedBox(height: 16),

            // Prominent CTA Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.customWorkRequest),
                icon: const Icon(Icons.edit_note_rounded, color: AppColors.evergreen, size: 20),
                label: const Text(
                  'Describe Your Custom Work →',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.evergreen,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mintLeaf,
                  foregroundColor: AppColors.evergreen,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _highlightPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.white.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // 3. Native Products Card
  Widget _buildNativeProductCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isNew,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.celadon),
          boxShadow: [
            BoxShadow(
              color: AppColors.evergreen.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.frostedMint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.darkEmerald, size: 20),
                ),
                if (isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.redDestructive,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'New',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.evergreen,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Care Plan Strip
  Widget _buildCarePlanStrip(BuildContext context) {
    return InkWell(
      onTap: () => context.push(AppRoutes.recurringCare),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.frostedMint.withOpacity(0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.mintLeaf2),
        ),
        child: Row(
          children: [
            const Icon(Icons.autorenew, color: AppColors.darkEmerald, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guild Care Plans (15% Off Subscriptions)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  Text(
                    'Scheduled seasonal AC, electrical & water filter servicing.',
                    style: TextStyle(fontSize: 10, color: AppColors.evergreen),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.seaGreen, size: 20),
          ],
        ),
      ),
    );
  }

  // 5. Spotlight Worker Card
  Widget _buildSpotlightWorkerCard(WorkerProfile worker, {bool isOnlineSection = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: worker.online ? AppColors.seaGreen.withOpacity(0.6) : AppColors.celadon,
          width: worker.online ? 1.2 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.evergreen.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
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
                          const Icon(Icons.verified, color: AppColors.seaGreen, size: 16),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.darkEmerald,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.amberWarning, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            '${worker.rating} (${worker.ratingCount})',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '• ${worker.distanceDisplay}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
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
                      style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Neighborhood Trust Signal
            Row(
              children: [
                const Icon(Icons.auto_awesome, size: 13, color: AppColors.seaGreen),
                const SizedBox(width: 4),
                const Text(
                  'Trust Signal:',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.seaGreen,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _matchChip(worker.online ? '⚡ 15 Mins Dispatch' : '📅 Advance Booking Available'),
                        _matchChip(worker.primaryCategory),
                        _matchChip('Skill Verified'),
                        _matchChip('Co-op Member'),
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
                      side: const BorderSide(color: AppColors.celadon),
                    ),
                    child: const Text('View Profile', style: TextStyle(fontSize: 12)),
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
                      worker.online ? 'Book Now ⚡' : 'Book Worker',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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

  // 6. Cooperative Card
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
                Row(
                  children: [
                    const Icon(Icons.bolt, color: AppColors.amberWarning, size: 14),
                    const Text(
                      '⚡ 38 local homes served this month',
                      style: TextStyle(
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
