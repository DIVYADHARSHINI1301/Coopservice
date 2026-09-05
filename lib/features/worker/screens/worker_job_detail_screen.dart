import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/fair_split_pricing_card.dart';
import '../../../shared/widgets/interactive_map_widget.dart';
import '../../../shared/widgets/status_badge.dart';

class WorkerJobDetailScreen extends ConsumerStatefulWidget {
  final Booking booking;

  const WorkerJobDetailScreen({super.key, required this.booking});

  @override
  ConsumerState<WorkerJobDetailScreen> createState() =>
      _WorkerJobDetailScreenState();
}

class _WorkerJobDetailScreenState extends ConsumerState<WorkerJobDetailScreen> {
  bool _isLoading = false;

  void _advanceState(Booking currentBooking) async {
    final repo = ref.read(platformRepositoryProvider);
    BookingStatus? nextStatus;

    switch (currentBooking.status) {
      case BookingStatus.bookingCreated:
      case BookingStatus.workerSearching:
        nextStatus = BookingStatus.workerAccepted;
        break;
      case BookingStatus.workerAccepted:
        nextStatus = BookingStatus.workerOnTheWay;
        break;
      case BookingStatus.workerOnTheWay:
        nextStatus = BookingStatus.workerArrived;
        break;
      case BookingStatus.workerArrived:
        nextStatus = BookingStatus.workStarted;
        break;
      case BookingStatus.workStarted:
        nextStatus = BookingStatus.workInProgress;
        break;
      case BookingStatus.workInProgress:
        nextStatus = BookingStatus.workCompleted;
        break;
      case BookingStatus.workCompleted:
      case BookingStatus.customerConfirmed:
      case BookingStatus.closed:
      case BookingStatus.workerDeclined:
      case BookingStatus.cancelled:
        return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    repo.updateBookingStatus(currentBooking.id, nextStatus);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (nextStatus == BookingStatus.workCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Work marked completed! Awaiting customer inspection and sign-off.'),
          backgroundColor: AppColors.seaGreen,
        ),
      );
    }
  }

  void _uploadProofDialog(String bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Upload Work-Proof Photo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Attach a photo of the completed electrical wiring, repaired motor, or sanitized fitting.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.frostedMint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.seaGreen),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: AppColors.darkEmerald, size: 32),
                  SizedBox(height: 4),
                  Text('Capture / Choose Work Photo',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(platformRepositoryProvider).uploadWorkProof(
                    bookingId,
                    'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400',
                  );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Work proof photo attached to booking!'),
                  backgroundColor: AppColors.seaGreen,
                ),
              );
            },
            child: const Text('Attach Proof'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final currentBooking = repo.allBookings.firstWhere(
      (b) => b.id == widget.booking.id,
      orElse: () => widget.booking,
    );

    final isClosedOrConfirmed =
        currentBooking.status == BookingStatus.customerConfirmed ||
            currentBooking.status == BookingStatus.closed;
    final isAwaitingCustomer =
        currentBooking.status == BookingStatus.workCompleted ||
            currentBooking.status == BookingStatus.completed;

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: Text(
          'Job #${currentBooking.id}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      bottomNavigationBar: isClosedOrConfirmed
          ? Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.white,
              child: const Text(
                '✅ Job Confirmed by Customer & Payout Settled',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.seaGreen,
                ),
              ),
            )
          : isAwaitingCustomer
              ? Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.white,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.hourglass_top,
                          color: AppColors.seaGreen, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Awaiting Customer Inspection & Confirmation',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.evergreen.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: CustomButton(
                      text: currentBooking.status.nextWorkerActionLabel,
                      isLoading: _isLoading,
                      onPressed: () => _advanceState(currentBooking),
                    ),
                  ),
                ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Directions
            InteractiveMapWidget(
              height: 180,
              showLiveRoute:
                  currentBooking.status == BookingStatus.workerOnTheWay ||
                      currentBooking.status == BookingStatus.onTheWay,
            ),
            const SizedBox(height: 16),

            // Service Details Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentBooking.serviceCategory,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                      StatusBadge(
                        label: currentBooking.status.label,
                        status: isClosedOrConfirmed
                            ? BadgeStatus.completed
                            : BadgeStatus.onTheWay,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentBooking.serviceSubtype,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.evergreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (currentBooking.workDescription.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.celadon.withOpacity(0.6)),
                      ),
                      child: Text(
                        'Work Description: ${currentBooking.workDescription}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                  if (currentBooking.requestedDateText.isNotEmpty ||
                      currentBooking.requestedTimeText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _infoRow(
                      Icons.schedule,
                      'Appointment Schedule',
                      '${currentBooking.requestedDateText} • ${currentBooking.requestedTimeText}',
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.celadon),
                  const SizedBox(height: 8),
                  _infoRow(
                      Icons.person, 'Customer', currentBooking.customerName),
                  const SizedBox(height: 6),
                  _infoRow(Icons.phone, 'Contact Phone',
                      currentBooking.customerPhone),
                  const SizedBox(height: 6),
                  _infoRow(Icons.location_on, 'Service Address',
                      currentBooking.location.address),
                  if (currentBooking.instructions.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _infoRow(Icons.notes, 'Instructions',
                        currentBooking.instructions),
                  ],
                  if (currentBooking.problemPhotoUrls.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Text(
                      'Customer Problem Photos:',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: currentBooking.problemPhotoUrls
                          .map((url) => Container(
                                margin: const EdgeInsets.only(right: 6),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.celadon),
                                  image: DecorationImage(
                                    image: NetworkImage(url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Work Proof Photos Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Work-Proof Photos',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.add_a_photo,
                            size: 16, color: AppColors.seaGreen),
                        label: const Text('Upload Proof',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.seaGreen)),
                        onPressed: () => _uploadProofDialog(currentBooking.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (currentBooking.workProofPhotos.isEmpty)
                    const Text(
                      'No work proof uploaded yet. Please upload a photo before completing the job.',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    )
                  else
                    Row(
                      children: currentBooking.workProofPhotos
                          .map((url) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Transparent Earnings Split
            FairSplitPricingCard(pricing: currentBooking.pricing),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String val) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.seaGreen),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                val,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.evergreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
