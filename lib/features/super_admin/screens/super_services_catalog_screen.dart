import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/service_model.dart';

class SuperServicesCatalogScreen extends ConsumerWidget {
  const SuperServicesCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(platformRepositoryProvider);
    final services = repo.allServices;

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.evergreen,
        title: const Text(
          'Platform Service Catalog',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Service Category',
            onPressed: () => _openServiceModal(context, repo, null),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final s = services[index];
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
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.frostedMint,
                          child: const Icon(Icons.handyman,
                              color: AppColors.darkEmerald, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.evergreen,
                              ),
                            ),
                            if (s.nameTamil.isNotEmpty)
                              Text(
                                s.nameTamil,
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
                      icon: const Icon(Icons.edit,
                          color: AppColors.seaGreen, size: 20),
                      onPressed: () => _openServiceModal(context, repo, s),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  s.description,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Base Rate: ₹${s.basePrice.toInt()}/hr',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.seaGreen,
                      ),
                    ),
                    Text(
                      '${s.subcategories.length} subcategories',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.darkEmerald,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: s.subcategories.map((sub) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.frostedMint.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        sub,
                        style: const TextStyle(
                          fontSize: 10,
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
    );
  }

  void _openServiceModal(
      BuildContext context, PlatformRepository repo, ServiceItem? service) {
    final nameController = TextEditingController(text: service?.name ?? '');
    final priceController =
        TextEditingController(text: service?.basePrice.toInt().toString() ?? '');
    final descController =
        TextEditingController(text: service?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(service == null ? 'Add Service' : 'Edit ${service.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Base Hourly Rate (₹)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newSrv = ServiceItem(
                  id: service?.id ??
                      'srv_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text.trim(),
                  iconName: service?.iconName ?? 'handyman',
                  description: descController.text.trim(),
                  basePrice: double.tryParse(priceController.text) ?? 400.0,
                  subcategories: service?.subcategories ?? ['General Repair'],
                );
                repo.saveServiceItem(newSrv);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Category'),
          ),
        ],
      ),
    );
  }
}
