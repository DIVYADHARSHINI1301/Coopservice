import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/worker_model.dart';

class WorkerScheduleScreen extends ConsumerStatefulWidget {
  const WorkerScheduleScreen({super.key});

  @override
  ConsumerState<WorkerScheduleScreen> createState() =>
      _WorkerScheduleScreenState();
}

class _WorkerScheduleScreenState extends ConsumerState<WorkerScheduleScreen> {
  final TextEditingController _leaveReasonController = TextEditingController();
  DateTime _leaveStart = DateTime.now().add(const Duration(days: 5));
  DateTime _leaveEnd = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _leaveReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final user = repo.currentUser;
    final worker = repo.getWorkerForUser(user);

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'My Availability & Schedule',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.pineTeal,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.hub_outlined, color: AppColors.mintLeaf, size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cooperative Shift Aggregation',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Your active time-blocks feed the Anna Nagar guild capacity matrix for instant neighborhood customer dispatch.',
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
              'Weekly Time-Block Configuration',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 10),

            // Weekly Slots List
            ...worker.weeklySchedule.asMap().entries.map((entry) {
              final index = entry.key;
              final slot = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: slot.isOffDay
                      ? const Color(0xFFF5F5F5)
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: slot.isOffDay
                        ? AppColors.subtleBorder
                        : AppColors.celadon,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          slot.dayName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: slot.isOffDay
                                ? AppColors.textSecondary
                                : AppColors.evergreen,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              slot.isOffDay ? 'Rest Day' : 'Working',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: slot.isOffDay
                                    ? AppColors.redDestructive
                                    : AppColors.seaGreen,
                              ),
                            ),
                            Switch(
                              value: !slot.isOffDay,
                              activeColor: AppColors.seaGreen,
                              onChanged: (val) {
                                final updated =
                                    List<DayScheduleSlot>.from(worker.weeklySchedule);
                                updated[index] = slot.copyWith(isOffDay: !val);
                                repo.updateWorkerSchedule(worker.uid, updated);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (!slot.isOffDay) ...[
                      const Divider(height: 1, color: AppColors.celadon),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _slotToggle(
                            title: 'Morning (8-12)',
                            active: slot.morning,
                            onToggle: (val) {
                              final updated =
                                  List<DayScheduleSlot>.from(worker.weeklySchedule);
                              updated[index] = slot.copyWith(morning: val);
                              repo.updateWorkerSchedule(worker.uid, updated);
                            },
                          ),
                          _slotToggle(
                            title: 'Afternoon (12-5)',
                            active: slot.afternoon,
                            onToggle: (val) {
                              final updated =
                                  List<DayScheduleSlot>.from(worker.weeklySchedule);
                              updated[index] = slot.copyWith(afternoon: val);
                              repo.updateWorkerSchedule(worker.uid, updated);
                            },
                          ),
                          _slotToggle(
                            title: 'Evening (5-9)',
                            active: slot.evening,
                            onToggle: (val) {
                              final updated =
                                  List<DayScheduleSlot>.from(worker.weeklySchedule);
                              updated[index] = slot.copyWith(evening: val);
                              repo.updateWorkerSchedule(worker.uid, updated);
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // Leave / Time-off Request Card
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
                  const Text(
                    'Request Leave / Planned Unavailability',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Notify your cooperative coordinator in advance for shift capacity adjustments.',
                    style:
                        TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _leaveReasonController,
                    decoration: const InputDecoration(
                      hintText: 'Reason (e.g., Family event, health checkup)',
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        repo.submitWorkerLeave(
                          workerUid: worker.uid,
                          startDate: _leaveStart,
                          endDate: _leaveEnd,
                          reason: _leaveReasonController.text.isEmpty
                              ? 'Planned personal leave'
                              : _leaveReasonController.text,
                        );
                        _leaveReasonController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Leave request recorded and synced with co-op admin!'),
                            backgroundColor: AppColors.seaGreen,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.seaGreen,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Submit Leave Request'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slotToggle({
    required String title,
    required bool active,
    required Function(bool) onToggle,
  }) {
    return InkWell(
      onTap: () => onToggle(!active),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.frostedMint : const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? AppColors.seaGreen : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? Icons.check_circle : Icons.circle_outlined,
              size: 14,
              color: active ? AppColors.seaGreen : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active ? AppColors.darkEmerald : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
