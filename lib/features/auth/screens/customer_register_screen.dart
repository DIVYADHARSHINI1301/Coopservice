import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/widgets/custom_button.dart';

class CustomerRegisterScreen extends ConsumerStatefulWidget {
  const CustomerRegisterScreen({super.key});

  @override
  ConsumerState<CustomerRegisterScreen> createState() =>
      _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState
    extends ConsumerState<CustomerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Divya Dharshini');
  final _emailController = TextEditingController(text: 'divya@chennai.coop');
  final _phoneController = TextEditingController(text: '+91 98401 54321');
  final _passwordController = TextEditingController(text: 'password123');
  bool _agreeTerms = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || !_agreeTerms) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final repo = ref.read(platformRepositoryProvider);
    repo.registerCustomer(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go(AppRoutes.customerHome);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization.of(context);

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
          'Customer Registration',
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
                  Text(
                    'Join Cooperative Services',
                    style: AppTypography.headlineMedium(
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Fair prices, verified technicians, community dividend.',
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
                      hintText: 'e.g. Divya Dharshini',
                      prefixIcon: Icon(Icons.person_outline,
                          size: 20, color: AppColors.seaGreen),
                    ),
                    validator: (v) => v!.isEmpty ? 'Please enter name' : null,
                  ),
                  const SizedBox(height: 14),

                  _buildLabel('Email Address'),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'e.g. divya@gmail.com',
                      prefixIcon: Icon(Icons.email_outlined,
                          size: 20, color: AppColors.seaGreen),
                    ),
                    validator: (v) =>
                        v!.contains('@') ? null : 'Valid email required',
                  ),
                  const SizedBox(height: 14),

                  _buildLabel('Phone Number'),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: '+91 98400 00000',
                      prefixIcon: Icon(Icons.phone_outlined,
                          size: 20, color: AppColors.seaGreen),
                    ),
                    validator: (v) => v!.length < 10 ? 'Enter valid phone' : null,
                  ),
                  const SizedBox(height: 14),

                  _buildLabel('Create Password'),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: Icon(Icons.lock_outline,
                          size: 20, color: AppColors.seaGreen),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Checkbox(
                        value: _agreeTerms,
                        activeColor: AppColors.seaGreen,
                        onChanged: (v) => setState(() => _agreeTerms = v!),
                      ),
                      const Expanded(
                        child: Text(
                          'I agree to Cooperative Community Bylaws & Fair Price Charter',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.evergreen),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  CustomButton(
                    text: 'Complete Registration',
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
