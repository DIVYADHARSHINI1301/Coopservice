import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/widgets/custom_button.dart';

class WorkerRegisterScreen extends ConsumerStatefulWidget {
  const WorkerRegisterScreen({super.key});

  @override
  ConsumerState<WorkerRegisterScreen> createState() =>
      _WorkerRegisterScreenState();
}

class _WorkerRegisterScreenState extends ConsumerState<WorkerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Karthik Selvam');
  final _emailController = TextEditingController(text: 'karthik.selvam@chennai.coop');
  final _phoneController = TextEditingController(text: '+91 98840 99887');
  int _experienceYears = 5;
  String _selectedCategory = 'Carpenter';
  String _selectedCoop = 'coop_anna_nagar';
  bool _hasUploadedId = true;
  bool _hasUploadedCert = true;
  bool _isLoading = false;

  final List<String> _categories = [
    'Electrician',
    'Plumber',
    'Carpenter',
    'Painter',
    'Cleaner',
    'Driver',
    'AC & Appliance'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    final repo = ref.read(platformRepositoryProvider);
    repo.registerWorker(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      cooperativeId: _selectedCoop,
      primaryCategory: _selectedCategory,
      skills: ['$_selectedCategory Specialist', 'Emergency Repair'],
      experienceYears: _experienceYears,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go(AppRoutes.verificationPending);
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final coops = repo.allCooperatives;

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.evergreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Worker Membership Application',
          style: AppTypography.headlineSmall(color: AppColors.darkEmerald),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.celadon),
              boxShadow: [
                BoxShadow(
                  color: AppColors.evergreen.withOpacity(0.04),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.celadon,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'TIER 1 INTAKE APPLICATION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkEmerald,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cooperative Member-Owner',
                    style: AppTypography.headlineMedium(
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Work with dignity, transparent community rates, and 100% democratic dividend.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Full Name'),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Karthik Selvam',
                      prefixIcon: Icon(Icons.person_outline,
                          size: 20, color: AppColors.seaGreen),
                    ),
                    validator: (v) => v!.isEmpty ? 'Name required' : null,
                  ),
                  const SizedBox(height: 14),

                  _buildLabel('Phone Number'),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: '+91 98840 00000',
                      prefixIcon: Icon(Icons.phone_outlined,
                          size: 20, color: AppColors.seaGreen),
                    ),
                  ),
                  const SizedBox(height: 14),

                  _buildLabel('Target Cooperative Guild'),
                  DropdownButtonFormField<String>(
                    value: _selectedCoop,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_city,
                          size: 20, color: AppColors.seaGreen),
                    ),
                    items: coops
                        .map((c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(
                                c.name,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCoop = v!),
                  ),
                  const SizedBox(height: 14),

                  _buildLabel('Primary Trade / Skill'),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.handyman,
                          size: 20, color: AppColors.seaGreen),
                    ),
                    items: _categories
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c,
                                  style: const TextStyle(fontSize: 14)),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v!),
                  ),
                  const SizedBox(height: 14),

                  _buildLabel('Years of Professional Experience: $_experienceYears yrs'),
                  Slider(
                    value: _experienceYears.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    activeColor: AppColors.seaGreen,
                    inactiveColor: AppColors.celadon,
                    onChanged: (v) =>
                        setState(() => _experienceYears = v.toInt()),
                  ),
                  const SizedBox(height: 14),

                  _buildLabel('Upload Verification Documents'),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2FBF6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.celadon),
                    ),
                    child: Column(
                      children: [
                        _uploadDocRow(
                          title: 'Government ID (Aadhaar / Voter ID)',
                          isUploaded: _hasUploadedId,
                          onToggle: () =>
                              setState(() => _hasUploadedId = !_hasUploadedId),
                        ),
                        const Divider(height: 14, color: AppColors.celadon),
                        _uploadDocRow(
                          title: 'Trade License or Skill Certificate',
                          isUploaded: _hasUploadedCert,
                          onToggle: () => setState(
                              () => _hasUploadedCert = !_hasUploadedCert),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  CustomButton(
                    text: 'Submit Application for Review',
                    isLoading: _isLoading,
                    trailingIcon: Icons.arrow_forward,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _uploadDocRow({
    required String title,
    required bool isUploaded,
    required VoidCallback onToggle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              isUploaded ? Icons.check_circle : Icons.upload_file,
              size: 18,
              color: isUploaded ? AppColors.seaGreen : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.evergreen,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: onToggle,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
          ),
          child: Text(
            isUploaded ? 'Attached' : 'Upload',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isUploaded ? AppColors.seaGreen : AppColors.darkEmerald,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.evergreen,
        ),
      ),
    );
  }
}
