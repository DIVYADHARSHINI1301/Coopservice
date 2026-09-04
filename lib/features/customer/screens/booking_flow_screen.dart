import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/models/worker_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/interactive_map_widget.dart';

class BookingFlowScreen extends ConsumerStatefulWidget {
  final WorkerProfile worker;
  final bool isEmergency;

  const BookingFlowScreen({
    super.key,
    required this.worker,
    this.isEmergency = false,
  });

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  int _selectedSlotIndex = 0;
  String _selectedSubtype = 'Diagnostics & Repair';
  final _addressController = TextEditingController(
      text: 'Plot 42, 2nd Avenue, Anna Nagar East, Chennai - 600102');
  final _instructionsController = TextEditingController();
  String _paymentMethod = 'UPI / Cash on Completion';
  bool _isLoading = false;

  final List<String> _timeSlots = [
    'Today • 2:30 PM',
    'Today • 4:00 PM',
    'Today • 6:00 PM',
    'Tomorrow • 10:00 AM',
    'Tomorrow • 2:00 PM'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.worker.skills.isNotEmpty) {
      _selectedSubtype = widget.worker.skills.first;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _confirmBooking() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final repo = ref.read(platformRepositoryProvider);
    final booking = repo.createBooking(
      worker: widget.worker,
      serviceSubtype: _selectedSubtype,
      scheduledAt: DateTime.now().add(const Duration(minutes: 30)),
      location: BookingLocation(
        address: _addressController.text.trim(),
        lat: 13.0850,
        lng: 80.2101,
      ),
      instructions: _instructionsController.text.trim(),
      price: widget.worker.hourlyRate,
      isEmergency: widget.isEmergency,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                size: 54, color: AppColors.seaGreen),
            const SizedBox(height: 12),
            Text(
              'Booking Requested!',
              style: AppTypography.headlineSmall(color: AppColors.darkEmerald),
            ),
            const SizedBox(height: 6),
            Text(
              'Your request for ${widget.worker.name} (${booking.id}) was sent to ${widget.worker.cooperativeName}.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 18),
            CustomButton(
              text: 'View Booking & Track',
              onPressed: () {
                Navigator.pop(ctx);
                context.go(AppRoutes.customerBookings);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final basePrice = widget.worker.hourlyRate;
    const welfareFee = 15.0;
    final totalPrice = basePrice + welfareFee;

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: Text(
          widget.isEmergency ? 'Emergency Booking' : 'Schedule Service',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Worker Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.celadon,
                    child: Text(
                      widget.worker.name.substring(0, 1),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.worker.name,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.worker.primaryCategory} • ${widget.worker.cooperativeName}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${widget.worker.hourlyRate.toInt()}/hr',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.seaGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Step 1: Select Service Subtype
            _buildSectionHeader('1. Specific Service Needed'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.celadon),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSubtype,
                  isExpanded: true,
                  items: widget.worker.skills
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedSubtype = v!),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Step 2: Time Slot Picker
            _buildSectionHeader('2. Choose Appointment Slot'),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_timeSlots.length, (index) {
                  final isSelected = _selectedSlotIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_timeSlots[index]),
                      selected: isSelected,
                      selectedColor: AppColors.seaGreen,
                      backgroundColor: AppColors.white,
                      labelStyle: TextStyle(
                        color:
                            isSelected ? AppColors.white : AppColors.evergreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) =>
                          setState(() => _selectedSlotIndex = index),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Step 3: Service Location Picker with Map
            _buildSectionHeader('3. Service Address & Location'),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on, color: AppColors.seaGreen),
                hintText: 'Enter complete service address',
              ),
            ),
            const SizedBox(height: 8),
            InteractiveMapWidget(
              height: 120,
              customerAddress: _addressController.text,
            ),
            const SizedBox(height: 16),

            // Step 4: Additional Notes / Instructions
            _buildSectionHeader('4. Specific Problem or Instructions (Optional)'),
            const SizedBox(height: 8),
            TextField(
              controller: _instructionsController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText:
                    'e.g. Breaker keeps tripping in bedroom, bring spare MCB.',
              ),
            ),
            const SizedBox(height: 16),

            // Step 5: Price Breakdown & Co-op Assurance
            _buildSectionHeader('5. Cooperative Transparent Pricing'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Column(
                children: [
                  _priceRow('Base Technician Wage', '₹${basePrice.toInt()}'),
                  const SizedBox(height: 6),
                  _priceRow('Co-op Member Health & Safety Fund',
                      '₹${welfareFee.toInt()}'),
                  const SizedBox(height: 6),
                  _priceRow('Platform Convenience Fee', '₹0 (Free / Co-op)'),
                  const Divider(height: 16, color: AppColors.celadon),
                  _priceRow('Total Estimated Price', '₹${totalPrice.toInt()}',
                      isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: widget.isEmergency
                  ? 'Request Priority Emergency Dispatch'
                  : 'Confirm & Send Booking',
              isLoading: _isLoading,
              trailingIcon: Icons.check,
              onPressed: _confirmBooking,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.darkEmerald,
      ),
    );
  }

  Widget _priceRow(String label, String amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 14 : 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? AppColors.evergreen : AppColors.textSecondary,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isBold ? 15 : 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? AppColors.seaGreen : AppColors.evergreen,
          ),
        ),
      ],
    );
  }
}
