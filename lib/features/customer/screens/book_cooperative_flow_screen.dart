import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/models/cooperative_model.dart';
import '../../../shared/widgets/fair_split_pricing_card.dart';

class BookCooperativeFlowScreen extends ConsumerStatefulWidget {
  final Cooperative cooperative;

  const BookCooperativeFlowScreen({super.key, required this.cooperative});

  @override
  ConsumerState<BookCooperativeFlowScreen> createState() =>
      _BookCooperativeFlowScreenState();
}

class _BookCooperativeFlowScreenState
    extends ConsumerState<BookCooperativeFlowScreen> {
  int _currentStep = 0;
  late String _selectedCategory;
  late String _selectedSubtype;
  int _teamSize = 2;
  String _selectedShift = 'Morning (8:00 AM - 12:00 PM)';
  DateTime _scheduledDate = DateTime.now().add(const Duration(days: 1));
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _addressController = TextEditingController(
    text: 'Plot 42, 2nd Avenue, Anna Nagar East, Chennai - 600102',
  );

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.cooperative.serviceCategories.first;
    _selectedSubtype = 'Full Service & Inspection';
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  double get _calculatedPrice {
    final basePrice = 600.0;
    return basePrice * _teamSize;
  }

  @override
  Widget build(BuildContext context) {
    final fairSplit = FairSplitPricing.calculate(_calculatedPrice);

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Book Cooperative Team',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              widget.cooperative.name,
              style: const TextStyle(fontSize: 11, color: AppColors.celadon),
            ),
          ],
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        type: StepperType.horizontal,
        elevation: 0,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep += 1);
          } else {
            _confirmBooking();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          } else {
            context.pop();
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.seaGreen,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentStep == 2
                          ? 'Confirm & Dispatch Team (₹${_calculatedPrice.toInt()})'
                          : 'Continue',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Scope'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: _buildStep1Scope(),
          ),
          Step(
            title: const Text('Schedule'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: _buildStep2Schedule(),
          ),
          Step(
            title: const Text('Review'),
            isActive: _currentStep >= 2,
            state: _currentStep == 2 ? StepState.editing : StepState.indexed,
            content: _buildStep3Review(fairSplit),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1Scope() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Service Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darkEmerald,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: widget.cooperative.serviceCategories.map((cat) {
            final isSelected = _selectedCategory == cat;
            return ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              selectedColor: AppColors.seaGreen,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.white : AppColors.evergreen,
                fontWeight: FontWeight.bold,
              ),
              onSelected: (_) => setState(() => _selectedCategory = cat),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        const Text(
          'Team Size (Cooperative Headcount)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darkEmerald,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.celadon),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_teamSize Certified Workers',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.evergreen,
                    ),
                  ),
                  Text(
                    _teamSize == 1
                        ? '1 Master Technician'
                        : '1 Lead Technician + ${_teamSize - 1} Assistants',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: AppColors.seaGreen),
                    onPressed: _teamSize > 1
                        ? () => setState(() => _teamSize -= 1)
                        : null,
                  ),
                  Text(
                    '$_teamSize',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline,
                        color: AppColors.seaGreen),
                    onPressed: _teamSize < 6
                        ? () => setState(() => _teamSize += 1)
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Job Details & Instructions',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darkEmerald,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _instructionsController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText:
                'Describe the scope of work, room sizes, or specific issues...',
          ),
        ),
      ],
    );
  }

  Widget _buildStep2Schedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Shift Slot',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darkEmerald,
          ),
        ),
        const SizedBox(height: 8),
        ...[
          'Morning (8:00 AM - 12:00 PM)',
          'Afternoon (12:00 PM - 5:00 PM)',
          'Evening (5:00 PM - 9:00 PM)',
        ].map((shift) {
          final isSelected = _selectedShift == shift;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.frostedMint : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.seaGreen : AppColors.celadon,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: RadioListTile<String>(
              value: shift,
              groupValue: _selectedShift,
              title: Text(
                shift,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              activeColor: AppColors.seaGreen,
              onChanged: (val) {
                if (val != null) setState(() => _selectedShift = val);
              },
            ),
          );
        }),
        const SizedBox(height: 16),
        const Text(
          'Service Location',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darkEmerald,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _addressController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.location_on, color: AppColors.seaGreen),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3Review(FairSplitPricing fairSplit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.celadon),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.cooperative.name} — Team of $_teamSize',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.evergreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_selectedCategory • $_selectedShift',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Location: ${_addressController.text}',
                style: const TextStyle(fontSize: 12, color: AppColors.evergreen),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FairSplitPricingCard(pricing: fairSplit),
      ],
    );
  }

  void _confirmBooking() {
    final repo = ref.read(platformRepositoryProvider);
    final booking = repo.createCooperativeTeamBooking(
      cooperative: widget.cooperative,
      serviceCategory: _selectedCategory,
      serviceSubtype: _selectedSubtype,
      teamSize: _teamSize,
      scheduledAt: _scheduledDate,
      location: BookingLocation(
        address: _addressController.text,
        lat: 13.0850,
        lng: 80.2101,
      ),
      instructions: _instructionsController.text.isEmpty
          ? 'Standard cooperative team dispatch.'
          : _instructionsController.text,
      price: _calculatedPrice,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cooperative team booked successfully!'),
        backgroundColor: AppColors.seaGreen,
      ),
    );

    context.pushReplacement(
      AppRoutes.activeBookingTracking,
      extra: booking,
    );
  }
}
