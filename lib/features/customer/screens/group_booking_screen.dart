import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/widgets/fair_split_pricing_card.dart';

class GroupBookingScreen extends ConsumerStatefulWidget {
  const GroupBookingScreen({super.key});

  @override
  ConsumerState<GroupBookingScreen> createState() => _GroupBookingScreenState();
}

class _GroupBookingScreenState extends ConsumerState<GroupBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _societyNameController =
      TextEditingController(text: 'Greenwood Palms Apartments');
  final _serviceSubtypeController = TextEditingController(
      text: 'Apartment Complex Common Lighting & Phase Balancing');
  final _addressController = TextEditingController(
      text: '18, 4th Main Road, Anna Nagar West Extension, Chennai - 600101');
  final _instructionsController = TextEditingController(
      text: 'Generator backup changeover switch check and 4 staircase sensor lights.');
  int _participantsCount = 4;
  double _totalEstimate = 2800.0;
  String _selectedCategory = 'Electrician';

  @override
  void dispose() {
    _societyNameController.dispose();
    _serviceSubtypeController.dispose();
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final coop = repo.allCooperatives.first;
    final splitPerHead = (_totalEstimate / _participantsCount).roundToDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'Group / Society Booking Split',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Info Banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.pineTeal, AppColors.evergreen],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.apartment, color: AppColors.mintLeaf, size: 28),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shared Space & Society Repairs',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Co-create a single guild dispatch for common areas or multi-flat repairs with transparent split payments.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.frostedMint,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Apartment / Community Name',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkEmerald),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _societyNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.business, color: AppColors.seaGreen),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Society name required' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Work Scope & Common Area Fix',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkEmerald),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _serviceSubtypeController,
                decoration: const InputDecoration(),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Work title required' : null,
              ),
              const SizedBox(height: 16),

              // Split Headcount Counter
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.celadon),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Number of Contributing Flats',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        Text(
                          '₹${splitPerHead.toInt()} per flat / resident',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.seaGreen,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: AppColors.seaGreen),
                          onPressed: () {
                            if (_participantsCount > 2) {
                              setState(() => _participantsCount--);
                            }
                          },
                        ),
                        Text(
                          '$_participantsCount',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline,
                              color: AppColors.seaGreen),
                          onPressed: () {
                            if (_participantsCount < 20) {
                              setState(() => _participantsCount++);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Society Address & Location',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkEmerald),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  prefixIcon:
                      Icon(Icons.location_on, color: AppColors.seaGreen),
                ),
              ),
              const SizedBox(height: 16),

              // Transparent Fair Split
              FairSplitPricingCard(
                pricing: FairSplitPricing.calculate(_totalEstimate),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final newBooking = repo.createGroupSocietyBooking(
                        cooperative: coop,
                        serviceCategory: _selectedCategory,
                        serviceSubtype: _serviceSubtypeController.text,
                        societyName: _societyNameController.text,
                        totalParticipants: _participantsCount,
                        scheduledAt:
                            DateTime.now().add(const Duration(hours: 3)),
                        location: BookingLocation(
                          address: _addressController.text,
                          lat: 13.0850,
                          lng: 80.2101,
                        ),
                        instructions: _instructionsController.text,
                        price: _totalEstimate,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Group booking created! Share code: ${newBooking.groupSplit?.groupCode}'),
                          backgroundColor: AppColors.seaGreen,
                        ),
                      );

                      context.push(
                        AppRoutes.activeBookingTracking,
                        extra: newBooking,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.seaGreen,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Create Society Split Booking (₹${splitPerHead.toInt()}/flat)',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
