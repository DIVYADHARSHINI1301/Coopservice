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
  int _selectedDayIndex = 0; // 0 = Today, 1 = Tomorrow, 2 = Pick Custom
  DateTime? _customDate;
  int _selectedSlotIndex = 1;
  String _selectedSubtype = 'Diagnostics & Repair';
  final _addressController = TextEditingController(
      text: 'Plot 42, 2nd Avenue, Anna Nagar East, Chennai - 600102');
  final _descriptionController = TextEditingController();
  final _instructionsController = TextEditingController();
  final List<String> _attachedPhotos = [];
  bool _isLoading = false;

  final List<String> _timeSlots = [
    '9:00 AM - 11:00 AM',
    '11:30 AM - 1:30 PM',
    '2:30 PM - 4:30 PM',
    '5:00 PM - 7:00 PM',
    '7:30 PM - 9:30 PM (Evening)',
  ];

  @override
  void initState() {
    super.initState();
    final skills = _availableSkills;
    if (skills.isNotEmpty) {
      _selectedSubtype = skills.first;
    }
  }

  List<String> get _availableSkills {
    if (widget.worker.skills.isNotEmpty) {
      return widget.worker.skills;
    }
    final category = widget.worker.primaryCategory.isNotEmpty
        ? widget.worker.primaryCategory
        : 'Service';
    return [
      '$category Diagnostic & Repair',
      'Standard Installation & Setup',
      'Fault Inspection & Maintenance',
      'Emergency Urgent Repair',
    ];
  }

  String get _selectedDateFormatted {
    if (_selectedDayIndex == 0) return 'Today (${_formatDate(DateTime.now())})';
    if (_selectedDayIndex == 1) {
      return 'Tomorrow (${_formatDate(DateTime.now().add(const Duration(days: 1)))})';
    }
    if (_customDate != null) return _formatDate(_customDate!);
    return 'Pick a Date';
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  DateTime get _effectiveScheduledDateTime {
    DateTime baseDate = DateTime.now();
    if (_selectedDayIndex == 1) {
      baseDate = baseDate.add(const Duration(days: 1));
    } else if (_selectedDayIndex == 2 && _customDate != null) {
      baseDate = _customDate!;
    }
    return DateTime(baseDate.year, baseDate.month, baseDate.day, 10, 0);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _addProblemPhoto() {
    final samplePhotos = [
      'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400',
      'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=400',
      'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=400',
    ];
    setState(() {
      if (_attachedPhotos.length < samplePhotos.length) {
        _attachedPhotos.add(samplePhotos[_attachedPhotos.length]);
      } else {
        _attachedPhotos.add(samplePhotos[0]);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Problem photo attached to booking request.'),
        backgroundColor: AppColors.seaGreen,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _confirmBooking() async {
    final workDesc = _descriptionController.text.trim();
    if (workDesc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a brief description of the work needed.'),
          backgroundColor: AppColors.redDestructive,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final repo = ref.read(platformRepositoryProvider);
    final booking = repo.createBooking(
      worker: widget.worker,
      serviceSubtype: _selectedSubtype,
      workDescription: workDesc,
      requestedDateText: _selectedDateFormatted,
      requestedTimeText: _timeSlots[_selectedSlotIndex],
      problemPhotoUrls: _attachedPhotos,
      scheduledAt: _effectiveScheduledDateTime,
      location: BookingLocation(
        address: _addressController.text.trim().isNotEmpty
            ? _addressController.text.trim()
            : 'Plot 42, 2nd Avenue, Anna Nagar East, Chennai - 600102',
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.frostedMint,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  size: 52, color: AppColors.seaGreen),
            ),
            const SizedBox(height: 16),
            Text(
              'Booking Requested!',
              style: AppTypography.headlineSmall(color: AppColors.darkEmerald),
            ),
            const SizedBox(height: 8),
            Text(
              'Your request #${booking.id} has been transmitted to ${widget.worker.name} & ${widget.worker.cooperativeName}.',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 18, color: AppColors.seaGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Live Tracking is active. You will be notified the instant the worker accepts.',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.evergreen),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Open Live Tracking',
              onPressed: () {
                Navigator.pop(ctx);
                context.pushReplacement(
                  AppRoutes.activeBookingTracking,
                  extra: booking,
                );
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go(AppRoutes.customerBookings);
              },
              child: const Text('View in My Bookings',
                  style: TextStyle(color: AppColors.darkEmerald)),
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
          widget.isEmergency ? 'Emergency Direct Booking' : 'Book Skilled Worker',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Worker Summary Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.celadon),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.evergreen.withOpacity(0.04),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(
                      widget.worker.photoUrl.isNotEmpty
                          ? widget.worker.photoUrl
                          : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.worker.name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.evergreen),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.worker.primaryCategory} • ${widget.worker.cooperativeName}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 14, color: AppColors.amberWarning),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.worker.rating} (${widget.worker.ratingCount} reviews)',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkEmerald),
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
                        '₹${widget.worker.hourlyRate.toInt()}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.seaGreen,
                        ),
                      ),
                      const Text(
                        '/ visit',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Section 1: Service Subtype
            _buildSectionHeader('1. Specific Service / Specialization'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.celadon),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _availableSkills.contains(_selectedSubtype)
                      ? _selectedSubtype
                      : _availableSkills.first,
                  isExpanded: true,
                  items: _availableSkills
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.evergreen)),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedSubtype = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Section 2: Detailed Work Description
            _buildSectionHeader('2. Detailed Work Description *'),
            const SizedBox(height: 4),
            const Text(
              'Describe the issue clearly so the technician comes prepared with the exact tools and spare parts.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText:
                    'e.g. Master bedroom ceiling fan stopped running; humming sound coming from regulator box. Need replacement capacitor.',
                hintStyle:
                    const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                fillColor: AppColors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.celadon),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.celadon),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.seaGreen, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Section 3: Date & Time Slot
            _buildSectionHeader('3. Preferred Date & Time Slot'),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildDayChip(0, 'Today'),
                const SizedBox(width: 8),
                _buildDayChip(1, 'Tomorrow'),
                const SizedBox(width: 8),
                _buildDayChip(2, _customDate != null ? _formatDate(_customDate!) : 'Pick Date'),
              ],
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 18),

            // Section 4: Problem Photos (Optional)
            _buildSectionHeader('4. Attach Problem Photos (Optional)'),
            const SizedBox(height: 8),
            Row(
              children: [
                ..._attachedPhotos.map((url) => Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.seaGreen),
                            image: DecorationImage(
                              image: NetworkImage(url),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: 2,
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _attachedPhotos.remove(url));
                            },
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: AppColors.redDestructive,
                              child: Icon(Icons.close,
                                  size: 12, color: AppColors.white),
                            ),
                          ),
                        ),
                      ],
                    )),
                if (_attachedPhotos.length < 3)
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _addProblemPhoto,
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.seaGreen,
                            style: BorderStyle.solid),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo,
                              size: 20, color: AppColors.seaGreen),
                          SizedBox(height: 2),
                          Text('Add Photo',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkEmerald)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),

            // Section 5: Address & Interactive Map
            _buildSectionHeader('5. Service Address & Map Pin'),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on, color: AppColors.seaGreen),
                hintText: 'Enter complete service address with landmark',
                fillColor: AppColors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 8),
            InteractiveMapWidget(
              height: 120,
              customerAddress: _addressController.text,
            ),
            const SizedBox(height: 18),

            // Section 6: Additional Gate / Parking Instructions
            _buildSectionHeader('6. Gate / Access Instructions (Optional)'),
            const SizedBox(height: 8),
            TextField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                hintText: 'e.g. Ring flat 302 bell or call security on arrival',
                fillColor: AppColors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 18),

            // Section 7: Cooperative Transparent Pricing Breakdown
            _buildSectionHeader('7. Cooperative Transparent Pricing'),
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
                  _priceRow('Direct Worker Earnings (85%)',
                      '₹${(basePrice * 0.85).toInt()}'),
                  const SizedBox(height: 6),
                  _priceRow('Co-op Welfare & Safety Fund (12%)',
                      '₹${(basePrice * 0.12).toInt()}'),
                  const SizedBox(height: 6),
                  _priceRow('Platform Maintenance Fee (3%)',
                      '₹${(basePrice * 0.03).toInt()}'),
                  const SizedBox(height: 6),
                  _priceRow('Neighborhood Cluster Fund', '₹${welfareFee.toInt()}'),
                  const Divider(height: 16, color: AppColors.celadon),
                  _priceRow('Total Estimated Price', '₹${totalPrice.toInt()}',
                      isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: widget.isEmergency
                  ? 'Request Emergency Dispatch Now'
                  : 'Confirm & Send Request',
              isLoading: _isLoading,
              trailingIcon: Icons.arrow_forward,
              onPressed: _confirmBooking,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDayChip(int index, String label) {
    final isSelected = _selectedDayIndex == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.seaGreen,
      backgroundColor: AppColors.white,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.white : AppColors.evergreen,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      onSelected: (_) async {
        if (index == 2) {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now().add(const Duration(days: 2)),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 30)),
          );
          if (picked != null) {
            setState(() {
              _customDate = picked;
              _selectedDayIndex = 2;
            });
          }
        } else {
          setState(() => _selectedDayIndex = index);
        }
      },
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
