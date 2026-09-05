import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';
import 'worker_earnings_screen.dart';
import 'worker_home_screen.dart';
import 'worker_jobs_screen.dart';
import 'worker_schedule_screen.dart';
import 'worker_self_profile_screen.dart';

class WorkerShellScreen extends ConsumerStatefulWidget {
  const WorkerShellScreen({super.key});

  @override
  ConsumerState<WorkerShellScreen> createState() => _WorkerShellScreenState();
}

class _WorkerShellScreenState extends ConsumerState<WorkerShellScreen> {
  int _currentIndex = 0;
  final Set<String> _dismissedBookingIds = {};
  bool _isShowingDispatchPopup = false;

  final List<Widget> _screens = const [
    WorkerHomeScreen(),
    WorkerJobsScreen(),
    WorkerScheduleScreen(),
    WorkerEarningsScreen(),
    WorkerSelfProfileScreen(),
  ];

  void _checkIncomingDispatch(PlatformRepository repo) {
    if (_isShowingDispatchPopup) return;
    final worker = repo.getWorkerForUser(repo.currentUser);

    // Find any new booking waiting for this worker
    final incomingList = repo.allBookings.where((b) {
      final isMatch = b.workerId == worker.uid ||
          (b.isTeamBooking && b.assignedWorkers.any((aw) => aw.workerId == worker.uid));
      final isPending = b.status == BookingStatus.bookingCreated ||
          b.status == BookingStatus.workerSearching ||
          b.status == BookingStatus.requested;
      return isMatch && isPending && !_dismissedBookingIds.contains(b.id);
    }).toList();

    if (incomingList.isNotEmpty && mounted) {
      final nextBooking = incomingList.first;
      _isShowingDispatchPopup = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showIncomingDispatchModal(context, repo, nextBooking);
        }
      });
    }
  }

  void _showIncomingDispatchModal(
      BuildContext context, PlatformRepository repo, Booking booking) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 25,
                offset: Offset(0, -8),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(ctx).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Urgency Pulse Bar
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.celadon,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Alert Banner
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF881337), Color(0xFFE11D48)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE11D48).withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF34D399),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '🚨 LIVE DISPATCH ALERT • 15-MIN MATCH',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    Text(
                      '#${booking.id.length > 8 ? booking.id.substring(booking.id.length - 8) : booking.id}',
                      style: const TextStyle(
                        color: AppColors.frostedMint,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Service Title & Category
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.serviceSubtype.isNotEmpty
                              ? booking.serviceSubtype
                              : '${booking.serviceCategory} Service Request',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.frostedMint,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            booking.serviceCategory,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.seaGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Price Highlight
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'YOUR PAY (85%)',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.seaGreen,
                          ),
                        ),
                        Text(
                          '₹${booking.pricing.workerDirectEarnings.toInt()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.evergreen,
                          ),
                        ),
                        Text(
                          'Total Bill: ₹${booking.pricing.totalAmount.toInt()}',
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
              const SizedBox(height: 14),

              // Customer & Location Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.celadon,
                          child: Text(
                            booking.customerName.isNotEmpty
                                ? booking.customerName[0].toUpperCase()
                                : 'C',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.evergreen,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.customerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.evergreen,
                                ),
                              ),
                              Text(
                                booking.customerPhone,
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
                    const Divider(height: 16, color: Color(0xFFE2E8F0)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: AppColors.seaGreen),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            booking.location.address,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.evergreen,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (booking.requestedDateText.isNotEmpty ||
                        booking.requestedTimeText.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 16, color: AppColors.seaGreen),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${booking.requestedDateText} • ${booking.requestedTimeText}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkEmerald,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Problem Description
              if (booking.workDescription.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Problem Reported by Customer:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '"${booking.workDescription}"',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF78350F),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Action Buttons: DECLINE & ACCEPT
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _dismissedBookingIds.add(booking.id);
                        repo.declineBooking(
                          booking.id,
                          reason: 'Technician currently unavailable',
                        );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Job dispatch request declined.'),
                            backgroundColor: AppColors.redDestructive,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.redDestructive),
                        foregroundColor: AppColors.redDestructive,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'DECLINE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        _dismissedBookingIds.add(booking.id);
                        final updated = repo.updateBookingStatus(
                          booking.id,
                          BookingStatus.workerAccepted,
                        );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Dispatch Accepted! Opening job #${booking.id}...'),
                            backgroundColor: AppColors.seaGreen,
                          ),
                        );
                        context.push(AppRoutes.workerJobDetail, extra: updated);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.seaGreen,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.flash_on, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'ACCEPT DISPATCH (₹${booking.pricing.workerDirectEarnings.toInt()})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((_) {
      _isShowingDispatchPopup = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization.of(context);
    final repo = ref.watch(platformRepositoryProvider);

    // Actively check for live incoming dispatches
    _checkIncomingDispatch(repo);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.evergreen.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.seaGreen,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard, color: AppColors.seaGreen),
              label: loc.tr('dashboard'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.work_outline),
              activeIcon: const Icon(Icons.work, color: AppColors.seaGreen),
              label: loc.tr('jobs'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              activeIcon:
                  const Icon(Icons.calendar_today, color: AppColors.seaGreen),
              label: loc.tr('schedule'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              activeIcon: const Icon(Icons.account_balance_wallet,
                  color: AppColors.seaGreen),
              label: loc.tr('earnings'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle_outlined),
              activeIcon:
                  const Icon(Icons.account_circle, color: AppColors.seaGreen),
              label: loc.tr('profile'),
            ),
          ],
        ),
      ),
    );
  }
}
