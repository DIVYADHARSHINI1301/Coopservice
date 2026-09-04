import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/widgets/status_badge.dart';

class SuperDisputesScreen extends ConsumerWidget {
  const SuperDisputesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final disputes = repo.allDisputes;

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.evergreen,
        title: const Text(
          'Dispute Management & Mediation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: disputes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final d = disputes[index];
          final isResolved = d.status == 'resolved';

          return Container(
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
                      'Dispute #${d.id} • Booking ${d.bookingId}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkEmerald,
                      ),
                    ),
                    StatusBadge(
                      label: isResolved ? 'Resolved' : 'Open Mediation',
                      status: isResolved
                          ? BadgeStatus.completed
                          : BadgeStatus.pending,
                      fontSize: 10,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Complainant: ${d.customerName} vs ${d.workerOrCoopName}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.evergreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reason: ${d.reason}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (d.disputedAmount > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Disputed Amount: ₹${d.disputedAmount.toInt()}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.redDestructive,
                    ),
                  ),
                ],
                if (isResolved && d.resolutionNotes != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.frostedMint.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Resolution: ${d.resolutionNotes}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.darkEmerald,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                if (!isResolved) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              _resolveModal(context, repo, d.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.seaGreen,
                            foregroundColor: AppColors.white,
                          ),
                          child: const Text('Resolve Dispute'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _resolveModal(
      BuildContext context, PlatformRepository repo, String disputeId) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Resolve Dispute & Record Mediation'),
        content: TextField(
          controller: noteController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter resolution notes / settlement terms agreed...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              repo.resolveDispute(
                disputeId,
                noteController.text.isEmpty
                    ? 'Mediated and agreed upon cooperative resolution.'
                    : noteController.text,
              );
              Navigator.pop(ctx);
            },
            child: const Text('Record Resolution'),
          ),
        ],
      ),
    );
  }
}
