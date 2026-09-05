import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/worker_model.dart';
import '../../../shared/widgets/custom_button.dart';

class WorkerSkillsScreen extends ConsumerStatefulWidget {
  const WorkerSkillsScreen({super.key});

  @override
  ConsumerState<WorkerSkillsScreen> createState() => _WorkerSkillsScreenState();
}

class _WorkerSkillsScreenState extends ConsumerState<WorkerSkillsScreen> {
  double _radius = 12.0;

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
          'Skills & Certifications',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Radius Config
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Active Service Radius',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                      Text(
                        '${_radius.toInt()} km',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.seaGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Slider(
                    value: _radius,
                    min: 2,
                    max: 30,
                    divisions: 28,
                    activeColor: AppColors.seaGreen,
                    inactiveColor: AppColors.celadon,
                    onChanged: (val) {
                      setState(() => _radius = val);
                    },
                  ),
                  const Text(
                    'You will receive instant dispatches within this neighborhood perimeter.',
                    style:
                        TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Verified Trade Skills
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Trade Skills & Services',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle,
                            color: AppColors.seaGreen, size: 22),
                        tooltip: 'Add Skill',
                        onPressed: () =>
                            _showAddSkillDialog(context, repo, worker),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: worker.skills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        backgroundColor: const Color(0xFFDCF3E7),
                        side: const BorderSide(color: AppColors.celadon),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () {
                          final updated = List<String>.from(worker.skills)
                            ..remove(skill);
                          repo.updateWorkerSkills(worker.uid, updated);
                        },
                        labelStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkEmerald,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Certifications
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
                  const Text(
                    'Verified Certifications',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (final cert in worker.certifications) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            cert.verified
                                ? Icons.verified
                                : Icons.hourglass_top,
                            color: cert.verified
                                ? AppColors.seaGreen
                                : AppColors.amberWarning,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              cert.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            cert.verified ? 'Verified' : 'Pending',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: cert.verified
                                  ? AppColors.seaGreen
                                  : AppColors.amberWarning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            CustomButton(
              text: 'Upload New Certification (Co-op Review)',
              icon: Icons.upload_file,
              type: ButtonType.secondary,
              onPressed: () => _showAddCertDialog(context, repo, worker),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSkillDialog(
      BuildContext context, PlatformRepository repo, WorkerProfile worker) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Skill or Trade Specialization'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: 'e.g. 3-Phase Industrial DB Wiring',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                final updated = List<String>.from(worker.skills)
                  ..add(ctrl.text.trim());
                repo.updateWorkerSkills(worker.uid, updated);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Specialization added!'),
                    backgroundColor: AppColors.seaGreen,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.seaGreen),
            child: const Text('Add', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddCertDialog(
      BuildContext context, PlatformRepository repo, WorkerProfile worker) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Trade Certificate for Guild Review'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: 'e.g. ITI National Trade Certificate (Electrical)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                repo.addWorkerCertification(worker.uid, ctrl.text.trim());
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Certificate "${ctrl.text.trim()}" submitted for Guild Review.'),
                    backgroundColor: AppColors.seaGreen,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.seaGreen),
            child:
                const Text('Submit', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }
}
