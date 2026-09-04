import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/status_badge.dart';

class SuperWorkerApprovalsScreen extends ConsumerWidget {
  const SuperWorkerApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final pendingUsers =
        repo.allUsers.where((u) => u.status == UserStatus.pending).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.evergreen,
        title: const Text(
          'Worker Registration Approvals',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.pineTeal,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined,
                      color: AppColors.mintLeaf, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Platform Governance & Compliance',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          'Platform-level oversight on new worker registrations across all cooperatives.',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.frostedMint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Text(
              'Pending Intake Queue (${pendingUsers.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 10),

            if (pendingUsers.isEmpty)
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
                    'No pending worker registrations across the platform.',
                    style:
                        TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ...pendingUsers.map((u) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.celadon),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            u.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.evergreen,
                            ),
                          ),
                          StatusBadge(
                            label: 'Pending Review',
                            status: BadgeStatus.pending,
                            fontSize: 10,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Target Guild: ${u.cooperativeName ?? "Anna Nagar Co-op"}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkEmerald,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Email: ${u.email} • Phone: ${u.phone}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                repo.verifyWorkerApplication(
                                  workerUid: u.uid,
                                  approve: false,
                                  rejectionReason: 'Documentation incomplete',
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.redDestructive,
                              ),
                              child: const Text('Reject Intake'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                repo.verifyWorkerApplication(
                                  workerUid: u.uid,
                                  approve: true,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Worker registration approved!'),
                                    backgroundColor: AppColors.seaGreen,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.seaGreen,
                                foregroundColor: AppColors.white,
                              ),
                              child: const Text('Approve & Onboard'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
