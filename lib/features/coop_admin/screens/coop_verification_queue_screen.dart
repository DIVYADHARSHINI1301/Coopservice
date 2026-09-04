import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/status_badge.dart';

class CoopVerificationQueueScreen extends ConsumerStatefulWidget {
  const CoopVerificationQueueScreen({super.key});

  @override
  ConsumerState<CoopVerificationQueueScreen> createState() =>
      _CoopVerificationQueueScreenState();
}

class _CoopVerificationQueueScreenState
    extends ConsumerState<CoopVerificationQueueScreen> {
  void _openVerificationDialog(AppUser applicant) {
    bool idChecked = true;
    bool tradeCertChecked = true;
    final reasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Verify Worker Application',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkEmerald,
                            ),
                          ),
                          Text(
                            'Application #CS-84920 • ${applicant.name}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Candidate Overview
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2FBF6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.celadon),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.celadon,
                          child: Text(
                            applicant.name.substring(0, 1),
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
                                applicant.name,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Email: ${applicant.email} • Phone: ${applicant.phone}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Document Checklist
                  const Text(
                    'Verification Document Inspection:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const SizedBox(height: 8),

                  _docInspectItem(
                    title: 'Government Identity Proof (Aadhaar/Voter)',
                    verified: idChecked,
                    onToggle: () =>
                        setModalState(() => idChecked = !idChecked),
                  ),
                  const SizedBox(height: 8),
                  _docInspectItem(
                    title: 'Vocational Trade Certificate / License',
                    verified: tradeCertChecked,
                    onToggle: () => setModalState(
                        () => tradeCertChecked = !tradeCertChecked),
                  ),
                  const SizedBox(height: 14),

                  // Correction Notes
                  const Text(
                    'Correction / Rejection Notes (Optional):',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: reasonController,
                    decoration: const InputDecoration(
                      hintText:
                          'e.g. Please upload higher resolution copy of ITI certificate',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ref
                                .read(platformRepositoryProvider)
                                .verifyWorkerApplication(
                                  workerUid: applicant.uid,
                                  approve: false,
                                  rejectionReason:
                                      reasonController.text.trim().isEmpty
                                          ? 'Document illegible'
                                          : reasonController.text.trim(),
                                );
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Worker application rejected.'),
                                backgroundColor: AppColors.redDestructive,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.redDestructive,
                            side: const BorderSide(
                                color: AppColors.redDestructive),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Reject / Request Fix'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(platformRepositoryProvider)
                                .verifyWorkerApplication(
                                  workerUid: applicant.uid,
                                  approve: true,
                                );
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Worker verified and activated successfully!'),
                                backgroundColor: AppColors.seaGreen,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.seaGreen,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Approve & Activate'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _docInspectItem({
    required String title,
    required bool verified,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.evergreen,
              ),
            ),
          ),
          Checkbox(
            value: verified,
            activeColor: AppColors.seaGreen,
            onChanged: (_) => onToggle(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final pendingWorkers =
        repo.allUsers.where((u) => u.status == UserStatus.pending).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.pineTeal,
        title: Text(
          'Verification Queue (${pendingWorkers.length})',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: pendingWorkers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified,
                      size: 52, color: AppColors.seaGreen),
                  const SizedBox(height: 12),
                  const Text(
                    'No pending worker verification requests.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const Text(
                    'All member-owner applications are up to date.',
                    style:
                        TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pendingWorkers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final applicant = pendingWorkers[index];
                return Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.celadon,
                                child: Text(
                                  applicant.name.substring(0, 1),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkEmerald),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    applicant.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Trade: Carpenter • Experience: 5 yrs',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const StatusBadge(
                            label: 'Pending',
                            status: BadgeStatus.pending,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: AppColors.frostedMint),
                      const SizedBox(height: 8),
                      const Text(
                        'Uploaded Documents: 2 files (Aadhaar ID, Carpentry Trade Cert)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _openVerificationDialog(applicant),
                          icon: const Icon(Icons.fact_check, size: 16),
                          label: const Text('Inspect & Verify Application'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.seaGreen,
                            foregroundColor: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
