import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/worker_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/status_badge.dart';
import '../widgets/skill_provenance_modal.dart';

class WorkerProfileScreen extends ConsumerWidget {
  final WorkerProfile worker;

  const WorkerProfileScreen({super.key, required this.worker});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final customer = repo.currentCustomerProfile;
    final isRegular =
        customer.myRegularWorkerIds[worker.primaryCategory] == worker.uid;

    final reviews =
        repo.allReviews.where((r) => r.workerId == worker.uid).toList();
    final coop = repo.allCooperatives.firstWhere(
      (c) => c.id == worker.cooperativeId,
      orElse: () => repo.allCooperatives.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: Text(
          worker.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${worker.hourlyRate.toInt()}/hr',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.evergreen,
                    ),
                  ),
                  const Text(
                    'Standard Co-op Rate',
                    style:
                        TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomButton(
                  text: 'Book This Technician',
                  icon: Icons.calendar_today,
                  onPressed: () {
                    context.push(
                      AppRoutes.bookingFlow,
                      extra: {'worker': worker, 'isEmergency': false},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(worker.photoUrl),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        worker.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified,
                          color: AppColors.seaGreen, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${worker.primaryCategory} • ${worker.experienceYears} Years Experience',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rating & Completed jobs count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star,
                          color: AppColors.amberWarning, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${worker.rating} (${worker.ratingCount} reviews)',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '• ${worker.completedJobsCount} jobs completed',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Inspectable Badges (Clickable to open SkillProvenanceModal)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: worker.badges.map((badge) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => SkillProvenanceModal.show(context, worker),
                        child: StatusBadge(
                          label: '$badge ℹ️',
                          status: BadgeStatus.skillVerified,
                          fontSize: 10,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Pin as My Regular Action
                  OutlinedButton.icon(
                    onPressed: () {
                      if (isRegular) {
                        repo.unpinRegularWorker(worker.primaryCategory);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Unpinned ${worker.name} from My Regulars.'),
                          ),
                        );
                      } else {
                        repo.pinRegularWorker(
                            worker.primaryCategory, worker.uid);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Pinned ${worker.name} as your regular ${worker.primaryCategory}!'),
                            backgroundColor: AppColors.seaGreen,
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      isRegular ? Icons.push_pin : Icons.push_pin_outlined,
                      size: 16,
                      color: isRegular ? AppColors.white : AppColors.seaGreen,
                    ),
                    label: Text(
                      isRegular
                          ? 'Pinned as Your Regular ${worker.primaryCategory}'
                          : 'Pin as My Regular ${worker.primaryCategory}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isRegular ? AppColors.white : AppColors.seaGreen,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          isRegular ? AppColors.seaGreen : Colors.transparent,
                      side: const BorderSide(color: AppColors.seaGreen),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Neighborhood Trust Signal Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.frostedMint.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_city,
                      color: AppColors.darkEmerald, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Neighborhood Trust Signal',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        Text(
                          '⚡ Booked 18 times in Anna Nagar East this month with 100% zero-revisit resolution.',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.darkEmerald,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Cooperative Association Banner
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                context.push(AppRoutes.cooperativeProfile, extra: coop);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.mintLeaf2),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(coop.logoUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coop.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.evergreen,
                            ),
                          ),
                          Text(
                            'Member Artisan • ${coop.region}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.seaGreen),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bio
            const Text(
              'About the Technician',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              worker.bio,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Verified Skills
            const Text(
              'Verified Skill Set',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: worker.skills.map((skill) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.celadon),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle,
                          size: 14, color: AppColors.seaGreen),
                      const SizedBox(width: 6),
                      Text(
                        skill,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.evergreen,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Certifications & Provenance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Certifications & Accreditations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkEmerald,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      SkillProvenanceModal.show(context, worker),
                  child: const Text('View Audit Trail',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.seaGreen)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...worker.certifications.map((cert) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.celadon),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.workspace_premium,
                        color: AppColors.seaGreen, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        cert.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen,
                        ),
                      ),
                    ),
                    const StatusBadge(
                      label: 'Verified',
                      status: BadgeStatus.coopVerified,
                      fontSize: 9,
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // Reviews
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customer Reviews (${reviews.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkEmerald,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...reviews.map((rev) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.celadon),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          rev.customerName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: AppColors.amberWarning, size: 14),
                            Text(
                              ' ${rev.rating}',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rev.comment,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
