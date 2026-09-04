import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';

class CooperativeRegisterScreen extends ConsumerStatefulWidget {
  const CooperativeRegisterScreen({super.key});

  @override
  ConsumerState<CooperativeRegisterScreen> createState() =>
      _CooperativeRegisterScreenState();
}

class _CooperativeRegisterScreenState
    extends ConsumerState<CooperativeRegisterScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  final _societyNameController = TextEditingController();
  final _regNumberController = TextEditingController();
  final _regionController = TextEditingController(text: 'Chennai Central');
  final _coordinatorNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final List<String> _availableCategories = [
    'Electrician',
    'Plumber',
    'AC & Appliance',
    'Carpenter',
    'Cleaner',
    'Painter',
    'Driver',
  ];

  final List<String> _selectedCategories = [
    'Electrician',
    'Plumber',
  ];

  @override
  void dispose() {
    _societyNameController.dispose();
    _regNumberController.dispose();
    _regionController.dispose();
    _coordinatorNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'Register Cooperative Guild',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        elevation: 0,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep += 1);
          } else {
            _submitRegistration();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          } else {
            context.pop();
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.seaGreen,
                      foregroundColor: AppColors.white,
                    ),
                    child: Text(
                      _currentStep == 2
                          ? 'Complete Guild Registration'
                          : 'Next Step',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Society Info'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: _buildStep1SocietyInfo(),
          ),
          Step(
            title: const Text('Coordinator'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: _buildStep2Coordinator(),
          ),
          Step(
            title: const Text('Trades & Scope'),
            isActive: _currentStep >= 2,
            state: _currentStep == 2 ? StepState.editing : StepState.indexed,
            content: _buildStep3Trades(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1SocietyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cooperative Society Name',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.darkEmerald),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _societyNameController,
          decoration: const InputDecoration(
            hintText: 'e.g. T. Nagar Artisans & Trades Guild',
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Government Registration Number',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.darkEmerald),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _regNumberController,
          decoration: const InputDecoration(
            hintText: 'e.g. COOP-TN-CHE-055',
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Cluster Region / Jurisdiction',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.darkEmerald),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _regionController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.location_city, color: AppColors.seaGreen),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2Coordinator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lead Coordinator Name',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.darkEmerald),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _coordinatorNameController,
          decoration: const InputDecoration(
            hintText: 'e.g. K. Ramanathan',
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Coordinator Official Email',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.darkEmerald),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'coordinator@tnagar.coop',
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Coordinator Mobile / WhatsApp',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.darkEmerald),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(
            hintText: '+91 98400 98765',
          ),
        ),
      ],
    );
  }

  Widget _buildStep3Trades() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Trade Categories Covered by Guild',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.darkEmerald),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableCategories.map((cat) {
            final isSelected = _selectedCategories.contains(cat);
            return FilterChip(
              label: Text(cat),
              selected: isSelected,
              selectedColor: AppColors.seaGreen,
              checkmarkColor: AppColors.white,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.white : AppColors.evergreen,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(cat);
                  } else {
                    _selectedCategories.remove(cat);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.frostedMint.withOpacity(0.6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.celadon),
          ),
          child: const Row(
            children: [
              Icon(Icons.diversity_3, color: AppColors.seaGreen, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'By registering, your cooperative commits to the 0% platform extraction rule and transparent fair wage distribution.',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.darkEmerald,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submitRegistration() {
    final name = _societyNameController.text.isEmpty
        ? 'T. Nagar Artisans Co-op'
        : _societyNameController.text;
    final reg = _regNumberController.text.isEmpty
        ? 'COOP-TN-CHE-088'
        : _regNumberController.text;
    final coordName = _coordinatorNameController.text.isEmpty
        ? 'K. Ramanathan'
        : _coordinatorNameController.text;
    final email = _emailController.text.isEmpty
        ? 'coordinator@tnagar.coop'
        : _emailController.text;
    final phone = _phoneController.text.isEmpty
        ? '+91 98400 98765'
        : _phoneController.text;

    final repo = ref.read(platformRepositoryProvider);
    repo.registerCooperativeSociety(
      name: name,
      region: _regionController.text,
      registrationNumber: reg,
      coordinatorName: coordName,
      coordinatorEmail: email,
      coordinatorPhone: phone,
      serviceCategories: _selectedCategories,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cooperative Society "$name" registered successfully!'),
        backgroundColor: AppColors.seaGreen,
      ),
    );

    context.go(AppRoutes.coopDashboard);
  }
}
