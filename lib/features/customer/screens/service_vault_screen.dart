import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/widgets/status_badge.dart';

class ServiceVaultScreen extends ConsumerStatefulWidget {
  const ServiceVaultScreen({super.key});

  @override
  ConsumerState<ServiceVaultScreen> createState() => _ServiceVaultScreenState();
}

class _ServiceVaultScreenState extends ConsumerState<ServiceVaultScreen> {
  final TextEditingController _revisitReasonController = TextEditingController();

  @override
  void dispose() {
    _revisitReasonController.dispose();
    super.dispose();
  }

  void _claimRevisitDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.verified_user, color: AppColors.seaGreen, size: 22),
            const SizedBox(width: 8),
            Text(
              'Claim Re-Visit Guarantee',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking #${booking.id} • ${booking.serviceSubtype}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.evergreen,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Cooperative 90-Day Zero-Fee Guarantee is active. This will auto-route a re-inspection back to technician without extra platform charges.',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.35),
              ),
              const SizedBox(height: 14),
              const Text(
                'Describe recurring issue symptoms:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.darkEmerald),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _revisitReasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'e.g. Fan makes humming noise on regulator step 3...',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_revisitReasonController.text.isNotEmpty) {
                ref.read(platformRepositoryProvider).raiseRevisitRequest(
                      bookingId: booking.id,
                      issueDescription: _revisitReasonController.text.trim(),
                    );
                _revisitReasonController.clear();
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Re-visit scheduled! Assigned to original co-op technician at ₹0.'),
                    backgroundColor: AppColors.seaGreen,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.seaGreen,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Confirm Warranty Re-Visit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final completedBookings =
        repo.allBookings.where((b) => b.status == BookingStatus.completed).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'Digital Job Card & Service Vault',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Vault Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.pineTeal, AppColors.evergreen],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.evergreen.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HOME SERVICE VAULT & DIGITAL JOB CARDS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: AppColors.celadon,
                        ),
                      ),
                      Icon(Icons.folder_special, color: AppColors.mintLeaf, size: 22),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${completedBookings.length} Permanent Records',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Every completed service generates a permanent certified job card with before/after photos, materials list, and active 90-day cooperative re-visit protection.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.frostedMint,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Your Home Service Records',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 10),

            if (completedBookings.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.celadon),
                ),
                child: const Center(
                  child: Text(
                    'No completed service job cards yet.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ...completedBookings.map((b) => _buildJobCardItem(context, b)),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCardItem(BuildContext context, Booking booking) {
    final jc = booking.jobCard;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.celadon),
        boxShadow: [
          BoxShadow(
            color: AppColors.evergreen.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Job Card ID & Warranty Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jc?.jobCardId ?? 'JC-${booking.id}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.seaGreen,
                      ),
                    ),
                    Text(
                      booking.serviceSubtype,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.evergreen,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.frostedMint,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.seaGreen),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, color: AppColors.darkEmerald, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '90-Day Warranty Active',
                        style: TextStyle(
                          fontSize: 10,
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

            // Technician & Guild
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(booking.workerPhotoUrl.isNotEmpty
                      ? booking.workerPhotoUrl
                      : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Certified by ${booking.workerName}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen,
                        ),
                      ),
                      Text(
                        booking.cooperativeName,
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
            const SizedBox(height: 12),

            // Before / After Photos
            if (jc != null && (jc.beforePhotos.isNotEmpty || jc.afterPhotos.isNotEmpty)) ...[
              const Text(
                'Work Completion Photographic Evidence:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (jc.beforePhotos.isNotEmpty) ...[
                    _photoThumb(jc.beforePhotos.first, 'Initial Diagnostic'),
                    const SizedBox(width: 10),
                  ],
                  if (jc.afterPhotos.isNotEmpty) ...[
                    _photoThumb(jc.afterPhotos.first, 'Certified Repair'),
                  ],
                ],
              ),
              const SizedBox(height: 12),
            ],

            // Materials Used List
            if (jc != null && jc.materialsUsed.isNotEmpty) ...[
              const Text(
                'Materials & Parts Installed:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              const SizedBox(height: 6),
              ...jc.materialsUsed.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      children: [
                        const Icon(Icons.check, size: 13, color: AppColors.seaGreen),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            m,
                            style: const TextStyle(fontSize: 11, color: AppColors.evergreen),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 12),
            ],

            // Re-visit Guarantee Status (if already raised)
            if (jc != null && jc.revisitRequests.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.amberWarning.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.amberWarning.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.replay, color: AppColors.evergreen, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Active Re-visit Claim: "${jc.revisitRequests.last.issueDescription}"',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.evergreen),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Action Buttons: Track & Re-visit Guarantee
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.push(AppRoutes.activeBookingTracking, extra: booking);
                    },
                    icon: const Icon(Icons.receipt_long, size: 16),
                    label: const Text('View Ledger Split', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _claimRevisitDialog(context, booking),
                    icon: const Icon(Icons.shield, size: 16),
                    label: const Text('Claim Re-Visit', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.seaGreen,
                      foregroundColor: AppColors.white,
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

  Widget _photoThumb(String url, String caption) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 90,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.celadon),
            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          caption,
          style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
