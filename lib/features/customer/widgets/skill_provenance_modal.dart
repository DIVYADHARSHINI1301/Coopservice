import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/worker_model.dart';

class SkillProvenanceModal extends StatelessWidget {
  final WorkerProfile worker;

  const SkillProvenanceModal({super.key, required this.worker});

  static void show(BuildContext context, WorkerProfile worker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SkillProvenanceModal(worker: worker),
    );
  }

  @override
  Widget build(BuildContext context) {
    final records = worker.provenanceRecords;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.frostedMint,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified,
                        color: AppColors.seaGreen, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Skill Provenance & Audit Trail',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen,
                        ),
                      ),
                      Text(
                        'Artisan: ${worker.name} • ${worker.cooperativeName}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.celadon),
          const SizedBox(height: 10),

          const Text(
            'Factual Verification & Examination History:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.darkEmerald,
            ),
          ),
          const SizedBox(height: 10),

          ...records.map((rec) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.frostedMint.withOpacity(0.4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rec.skillName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.seaGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${rec.practicalScorePercent}% Score',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Issuing Academy: ${rec.issuingBody}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.darkEmerald,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Certificate #: ${rec.certificateNumber}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: AppColors.seaGreen, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Verified on ${rec.verificationDate} by ${rec.verifiedByAdminName}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.evergreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.celadon),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined,
                    color: AppColors.darkEmerald, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cooperative guilds maintain 100% auditable skill certifications to ensure safe electrical, plumbing, and mechanical standards.',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
