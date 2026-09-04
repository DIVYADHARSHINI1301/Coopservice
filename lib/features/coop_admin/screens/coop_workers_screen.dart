import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/worker_model.dart';
import '../../../shared/widgets/status_badge.dart';

class CoopWorkersScreen extends ConsumerStatefulWidget {
  const CoopWorkersScreen({super.key});

  @override
  ConsumerState<CoopWorkersScreen> createState() => _CoopWorkersScreenState();
}

class _CoopWorkersScreenState extends ConsumerState<CoopWorkersScreen> {
  String _filter = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final user = repo.currentUser;
    final coopWorkers = repo.allWorkers;

    final filtered = coopWorkers.where((w) {
      if (_filter == 'Active' && !w.online) return false;
      if (_filter != 'All' && _filter != 'Active' && w.primaryCategory != _filter) return false;
      if (_searchController.text.isNotEmpty) {
        return w.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            w.primaryCategory.toLowerCase().contains(_searchController.text.toLowerCase());
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.pineTeal,
        title: const Text(
          'Cooperative Workers Roster',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search member by name or skill...',
                    prefixIcon: Icon(Icons.search, color: AppColors.darkEmerald),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Active', 'Electrician', 'Plumber', 'AC & Appliance', 'Carpenter']
                        .map((f) {
                      final isSelected = _filter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(f),
                          selected: isSelected,
                          selectedColor: AppColors.seaGreen,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.white : AppColors.evergreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (_) => setState(() => _filter = f),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.celadon),

          // Worker list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final w = filtered[index];
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
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(w.photoUrl),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      w.name,
                                      style: const TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 6),
                                    if (w.online)
                                      const Icon(Icons.circle,
                                          color: AppColors.seaGreen, size: 10),
                                  ],
                                ),
                                Text(
                                  '${w.primaryCategory} • ${w.experienceYears} yrs • ★ ${w.rating} (${w.completedJobsCount} jobs)',
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_note, color: AppColors.seaGreen),
                            tooltip: 'Edit Member Skills',
                            onPressed: () => _editSkillsModal(context, repo, w),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Skills Chips
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: w.skills.map((s) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.frostedMint,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              s,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkEmerald,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _editSkillsModal(
      BuildContext context, PlatformRepository repo, WorkerProfile worker) {
    final skillController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            title: Text('Edit Skills — ${worker.name}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: worker.skills.map((skill) {
                      return Chip(
                        label: Text(skill, style: const TextStyle(fontSize: 11)),
                        onDeleted: () {
                          final updated = List<String>.from(worker.skills)..remove(skill);
                          repo.updateWorkerSkills(worker.uid, updated);
                          setModalState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: skillController,
                    decoration: const InputDecoration(
                      hintText: 'Add new skill...',
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (skillController.text.isNotEmpty) {
                    final updated = List<String>.from(worker.skills)
                      ..add(skillController.text.trim());
                    repo.updateWorkerSkills(worker.uid, updated);
                    skillController.clear();
                    setModalState(() {});
                  }
                },
                child: const Text('Add Skill'),
              ),
            ],
          );
        },
      ),
    );
  }
}
