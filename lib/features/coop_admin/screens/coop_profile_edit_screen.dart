import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/cooperative_model.dart';

class CoopProfileEditScreen extends ConsumerStatefulWidget {
  const CoopProfileEditScreen({super.key});

  @override
  ConsumerState<CoopProfileEditScreen> createState() =>
      _CoopProfileEditScreenState();
}

class _CoopProfileEditScreenState extends ConsumerState<CoopProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  double _radius = 15.0;

  @override
  void initState() {
    super.initState();
    final coop = ref.read(platformRepositoryProvider).allCooperatives.first;
    _nameController = TextEditingController(text: coop.name);
    _descController = TextEditingController(text: coop.description);
    _addressController = TextEditingController(text: coop.address);
    _phoneController = TextEditingController(text: coop.phone);
    _emailController = TextEditingController(text: coop.email);
    _radius = coop.serviceAreaRadiusKm;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final user = repo.currentUser;
    final coop = repo.allCooperatives.firstWhere(
      (c) => c.id == user.cooperativeId,
      orElse: () => repo.allCooperatives.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.pineTeal,
        title: const Text(
          'Cooperative Public Profile Hub',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            tooltip: 'Preview as Customer',
            onPressed: () {
              context.push(AppRoutes.cooperativeProfile, extra: coop);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Guild Info Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.celadon),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(coop.logoUrl),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coop.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.evergreen,
                            ),
                          ),
                          Text(
                            'Registration #${coop.registrationNumber}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${coop.workerCount} Active Members • ★ ${coop.rating}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.seaGreen,
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
                'Cooperative Society Name',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Public Guild Mission & Description',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 16),

              const Text(
                'Cluster Hub Address',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  prefixIcon:
                      Icon(Icons.location_on, color: AppColors.seaGreen),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Coordinator Contact Phone',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkEmerald,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone,
                                color: AppColors.seaGreen, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Co-op Email',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkEmerald,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email,
                                color: AppColors.seaGreen, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Coverage Radius Slider
              Text(
                'Service Area Coverage Radius: ${_radius.toInt()} km',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              Slider(
                value: _radius,
                min: 5.0,
                max: 40.0,
                divisions: 7,
                activeColor: AppColors.seaGreen,
                label: '${_radius.toInt()} km',
                onChanged: (val) => setState(() => _radius = val),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final updatedCoop = coop.copyWith(
                      name: _nameController.text,
                      description: _descController.text,
                      address: _addressController.text,
                      phone: _phoneController.text,
                      email: _emailController.text,
                      serviceAreaRadiusKm: _radius,
                    );
                    repo.updateCooperativeProfile(updatedCoop);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cooperative public profile updated!'),
                        backgroundColor: AppColors.seaGreen,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.seaGreen,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Save Profile Changes',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
