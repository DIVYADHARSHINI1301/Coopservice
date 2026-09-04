import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';

class CustomWorkRequestScreen extends ConsumerStatefulWidget {
  const CustomWorkRequestScreen({super.key});

  @override
  ConsumerState<CustomWorkRequestScreen> createState() =>
      _CustomWorkRequestScreenState();
}

class _CustomWorkRequestScreenState
    extends ConsumerState<CustomWorkRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _budgetController = TextEditingController();
  final _addressController = TextEditingController(
    text: 'Plot 42, 2nd Avenue, Anna Nagar East, Chennai',
  );
  String _selectedCategory = 'Electrician';
  final List<String> _photos = [
    'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=400'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _budgetController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final categories = repo.allServices.map((s) => s.name).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'Custom Work Request',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.celadon),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.assignment_outlined,
                        color: AppColors.seaGreen, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Post your project requirements and receive verified estimates from local cooperative coordinators.',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.evergreen,
                            height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              const Text(
                'Work Title',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Balcony Waterproofing & Root-barrier Drain',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Service Trade Category',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(),
                items: categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Detailed Description & Measurements',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText:
                      'Provide approximate area, symptoms, required materials, or any constraints...',
                ),
                validator: (val) => val == null || val.isEmpty
                    ? 'Description is required'
                    : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Site Photos (Optional)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ..._photos.map((url) => Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.celadon),
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _photos.add(
                            'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=400');
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.seaGreen,
                            style: BorderStyle.solid),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo,
                              color: AppColors.seaGreen, size: 22),
                          SizedBox(height: 2),
                          Text('Add',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.seaGreen,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                'Approximate Budget (₹ Optional)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'e.g. 3500',
                  prefixText: '₹ ',
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Site Address',
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
                validator: (val) =>
                    val == null || val.isEmpty ? 'Address is required' : null,
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.seaGreen,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Submit Request to Local Co-ops',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRequest() {
    if (_formKey.currentState?.validate() ?? false) {
      final repo = ref.read(platformRepositoryProvider);
      repo.submitCustomWorkRequest(
        title: _titleController.text,
        description: _descController.text,
        serviceCategory: _selectedCategory,
        address: _addressController.text,
        budget: double.tryParse(_budgetController.text),
        preferredDate: DateTime.now().add(const Duration(days: 2)),
        photos: _photos,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Custom work request broadcast to local guild!'),
          backgroundColor: AppColors.seaGreen,
        ),
      );
      context.pop();
    }
  }
}
