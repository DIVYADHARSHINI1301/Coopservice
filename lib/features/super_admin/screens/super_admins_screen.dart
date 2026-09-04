import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/status_badge.dart';

class SuperAdminsScreen extends ConsumerStatefulWidget {
  const SuperAdminsScreen({super.key});

  @override
  ConsumerState<SuperAdminsScreen> createState() => _SuperAdminsScreenState();
}

class _SuperAdminsScreenState extends ConsumerState<SuperAdminsScreen> {
  void _showCreateAdminDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedCoopId = 'coop_anna_nagar';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final repo = ref.watch(platformRepositoryProvider);
          final coops = repo.allCooperatives;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
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
                        const Text(
                          '+ Create Cooperative Admin',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkEmerald,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Admin accounts can only be authorized and created by Super Admin.',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    const Text('Admin Full Name'),
                    const SizedBox(height: 4),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Kavitha R',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Official Email Address'),
                    const SizedBox(height: 4),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. kavitha@adyar.coop',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Phone Number'),
                    const SizedBox(height: 4),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: '+91 98400 11223',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Assign Cooperative Guild'),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      value: selectedCoopId,
                      items: coops
                          .map((c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name),
                              ))
                          .toList(),
                      onChanged: (v) =>
                          setModalState(() => selectedCoopId = v!),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Authorize & Create Admin',
                      onPressed: () {
                        if (nameController.text.trim().isEmpty) return;
                        ref.read(platformRepositoryProvider).createCoopAdmin(
                              name: nameController.text.trim(),
                              email: emailController.text.trim().isEmpty
                                  ? 'admin@coop.org'
                                  : emailController.text.trim(),
                              phone: phoneController.text.trim().isEmpty
                                  ? '+91 98400 00000'
                                  : phoneController.text.trim(),
                              cooperativeId: selectedCoopId,
                            );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Co-op Admin created and authorized!'),
                            backgroundColor: AppColors.seaGreen,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final admins = repo.allUsers
        .where((u) =>
            u.role == UserRole.cooperativeAdmin ||
            u.role == UserRole.superAdmin)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.evergreen,
        title: const Text(
          'Admin Management',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showCreateAdminDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.seaGreen,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: const Text('+ Create Admin'),
        onPressed: _showCreateAdminDialog,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: admins.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final admin = admins[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.celadon),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.celadon,
                  child: Text(
                    admin.name.substring(0, 1),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkEmerald),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        admin.name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${admin.role.displayName} • ${admin.cooperativeName ?? "Platform Master"}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                      Text(
                        admin.email,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.seaGreen),
                      ),
                    ],
                  ),
                ),
                const StatusBadge(
                  label: 'Active',
                  status: BadgeStatus.active,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
