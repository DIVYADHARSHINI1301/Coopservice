import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/models/worker_model.dart';

class CoopJobAssignmentScreen extends ConsumerStatefulWidget {
  final Booking booking;

  const CoopJobAssignmentScreen({super.key, required this.booking});

  @override
  ConsumerState<CoopJobAssignmentScreen> createState() =>
      _CoopJobAssignmentScreenState();
}

class _CoopJobAssignmentScreenState
    extends ConsumerState<CoopJobAssignmentScreen> {
  late List<AssignedTeamWorker> _assigned;

  @override
  void initState() {
    super.initState();
    _assigned = List.from(widget.booking.assignedWorkers);
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final availableWorkers = repo.allWorkers;

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.pineTeal,
        title: Text(
          'Assign Team — ${widget.booking.id}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Overview Card
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
                    widget.booking.serviceSubtype,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.evergreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Client: ${widget.booking.customerName} • Required Team Size: ${widget.booking.teamSize}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Location: ${widget.booking.location.address}',
                    style: const TextStyle(fontSize: 11, color: AppColors.seaGreen),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Currently Assigned (${_assigned.length}/${widget.booking.teamSize})',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkEmerald,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.person_add, size: 16),
                  label: const Text('Add Member'),
                  onPressed: () => _openAddMemberSheet(context, availableWorkers),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (_assigned.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.celadon),
                ),
                child: const Center(
                  child: Text(
                    'No members assigned yet. Tap "Add Member" to assign technicians.',
                    style:
                        TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ..._assigned.asMap().entries.map((entry) {
                final idx = entry.key;
                final worker = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.celadon),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(worker.photoUrl.isNotEmpty
                            ? worker.photoUrl
                            : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              worker.workerName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.evergreen,
                              ),
                            ),
                            Text(
                              worker.role,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.seaGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AppColors.redDestructive, size: 20),
                        onPressed: () {
                          setState(() {
                            _assigned.removeAt(idx);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  repo.assignWorkersToBooking(widget.booking.id, _assigned);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cooperative team dispatch updated!'),
                      backgroundColor: AppColors.seaGreen,
                    ),
                  );
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.seaGreen,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Save & Notify Assigned Members',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddMemberSheet(
      BuildContext context, List<WorkerProfile> availableWorkers) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Cooperative Member to Assign',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 12),
            ...availableWorkers.map((w) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(w.photoUrl),
                ),
                title: Text(
                  w.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: Text(
                  '${w.primaryCategory} • ${w.experienceYears} yrs exp',
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _assigned.add(AssignedTeamWorker(
                        workerId: w.uid,
                        workerName: w.name,
                        role: 'Cooperative Technician (${w.primaryCategory})',
                        photoUrl: w.photoUrl,
                        phone: '+91 98840 11223',
                      ));
                    });
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.seaGreen,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                  ),
                  child: const Text('Assign', style: TextStyle(fontSize: 11)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
