import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/custom_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _authService = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();

  // Core Credentials
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // Role Selection
  UserRole _selectedRole = UserRole.customer;

  // Role-Specific Dynamic Fields
  final _addressOrRegionController = TextEditingController();
  final _coopNameController = TextEditingController();
  final _regNumberController = TextEditingController();
  String _selectedCategory = 'Electrician';
  int _experienceYears = 4;
  String _selectedCoopId = 'coop_anna_nagar';

  bool _obscurePassword = true;
  bool _agreedToBylaws = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressOrRegionController.dispose();
    _coopNameController.dispose();
    _regNumberController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToBylaws) {
      _showToast('Please agree to Democratic Cooperative Bylaws & Fair Wages.',
          isError: true);
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(platformRepositoryProvider);

      // Real Firebase Auth + Firestore + PlatformRepository registration
      final registeredUser = await _authService.registerUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        role: _selectedRole,
        password: _passwordController.text,
        repo: repo,
        addressOrRegion: _addressOrRegionController.text.trim(),
        primaryCategory: _selectedCategory,
        experienceYears: _experienceYears,
        cooperativeId: _selectedCoopId,
        cooperativeName: _coopNameController.text.trim().isNotEmpty
            ? _coopNameController.text.trim()
            : null,
        registrationNumber: _regNumberController.text.trim().isNotEmpty
            ? _regNumberController.text.trim()
            : null,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      _showToast(
          'Account created successfully as ${registeredUser.role.displayName}!');

      // Navigate to role-specific dashboard
      switch (registeredUser.role) {
        case UserRole.customer:
          context.go(AppRoutes.customerHome);
          break;
        case UserRole.worker:
          context.go(AppRoutes.workerHome);
          break;
        case UserRole.cooperativeAdmin:
          context.go(AppRoutes.coopDashboard);
          break;
        case UserRole.superAdmin:
          context.go(AppRoutes.superDashboard);
          break;
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showToast(e.toString(), isError: true);
    }
  }

  void _showToast(String message, {bool isError = false}) {
    final cleanMsg = message
        .replaceAll('Exception: ', '')
        .replaceAll('FirebaseAuthException: ', '');
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(cleanMsg,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor:
            isError ? AppColors.redDestructive : AppColors.seaGreen,
        duration: Duration(milliseconds: isError ? 3500 : 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final cooperatives = repo.allCooperatives;

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'Join Cooperative Ecosystem',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Info Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.pineTeal, AppColors.evergreen],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.evergreen.withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.how_to_reg,
                              color: AppColors.mintLeaf, size: 28),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Zero-Extraction Fair Registration',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Choose your role in our neighborhood guild. 85% directly to artisans.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.frostedMint,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Main Form Box
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.celadon),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.evergreen.withOpacity(0.04),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Role Selection Dropdown
                          const Text(
                            'Account Role in Ecosystem',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkEmerald,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppColors.frostedMint.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.seaGreen),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<UserRole>(
                                value: _selectedRole,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: AppColors.seaGreen),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedRole = val);
                                  }
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: UserRole.customer,
                                    child: Row(
                                      children: [
                                        Icon(Icons.person,
                                            size: 18,
                                            color: AppColors.seaGreen),
                                        SizedBox(width: 8),
                                        Text('Customer (Book & Rate Services)',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.evergreen)),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: UserRole.worker,
                                    child: Row(
                                      children: [
                                        Icon(Icons.handyman,
                                            size: 18,
                                            color: AppColors.seaGreen),
                                        SizedBox(width: 8),
                                        Text('Worker / Artisan (Provide Trades)',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.evergreen)),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: UserRole.cooperativeAdmin,
                                    child: Row(
                                      children: [
                                        Icon(Icons.account_balance,
                                            size: 18,
                                            color: AppColors.seaGreen),
                                        SizedBox(width: 8),
                                        Text('Cooperative Head (Manage Guild)',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.evergreen)),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: UserRole.superAdmin,
                                    child: Row(
                                      children: [
                                        Icon(Icons.shield,
                                            size: 18,
                                            color: AppColors.seaGreen),
                                        SizedBox(width: 8),
                                        Text('Platform Admin (Super Governance)',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.evergreen)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 2. Full Name
                          const Text(
                            'Full Name',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkEmerald,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: 'e.g. Divya Dharshini or Ravi Kumar',
                              prefixIcon: Icon(Icons.person_outline,
                                  color: AppColors.seaGreen),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Name is required'
                                : null,
                          ),
                          const SizedBox(height: 14),

                          // 3. Email Address
                          const Text(
                            'Email Address',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkEmerald,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'e.g. yourname@neighborhood.coop',
                              prefixIcon: Icon(Icons.alternate_email,
                                  color: AppColors.seaGreen),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!v.contains('@')) return 'Enter a valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // 4. Phone Number
                          const Text(
                            'Phone Number',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkEmerald,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: '+91 98401 54321',
                              prefixIcon: Icon(Icons.phone_outlined,
                                  color: AppColors.seaGreen),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Phone number required'
                                : null,
                          ),
                          const SizedBox(height: 14),

                          // 5. Contextual Dynamic Fields per Role
                          if (_selectedRole == UserRole.customer) ...[
                            const Text(
                              'Service Address / Locality',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkEmerald,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _addressOrRegionController,
                              decoration: const InputDecoration(
                                hintText:
                                    'e.g. Plot 42, 2nd Ave, Anna Nagar East',
                                prefixIcon: Icon(Icons.location_on_outlined,
                                    color: AppColors.seaGreen),
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],

                          if (_selectedRole == UserRole.worker) ...[
                            const Text(
                              'Primary Trade Category',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkEmerald,
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.build,
                                    color: AppColors.seaGreen),
                              ),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _selectedCategory = v);
                                }
                              },
                              items: const [
                                DropdownMenuItem(
                                    value: 'Electrician',
                                    child: Text('Electrician')),
                                DropdownMenuItem(
                                    value: 'Plumber',
                                    child: Text('Plumber')),
                                DropdownMenuItem(
                                    value: 'AC & Appliance',
                                    child: Text('AC & Appliance')),
                                DropdownMenuItem(
                                    value: 'Carpenter',
                                    child: Text('Carpenter')),
                                DropdownMenuItem(
                                    value: 'Painter',
                                    child: Text('Painter')),
                                DropdownMenuItem(
                                    value: 'Cleaner',
                                    child: Text('Cleaner')),
                              ],
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Home Cooperative Cluster',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkEmerald,
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _selectedCoopId,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.groups,
                                    color: AppColors.seaGreen),
                              ),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _selectedCoopId = v);
                                }
                              },
                              items: cooperatives.map((c) {
                                return DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 14),
                          ],

                          if (_selectedRole == UserRole.cooperativeAdmin) ...[
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
                              controller: _coopNameController,
                              decoration: const InputDecoration(
                                hintText:
                                    'e.g. Velachery Artisans Cooperative',
                                prefixIcon: Icon(Icons.business,
                                    color: AppColors.seaGreen),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Cooperative name required'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Government Registration ID',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkEmerald,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _regNumberController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. COOP-TN-CHE-099',
                                prefixIcon: Icon(Icons.badge_outlined,
                                    color: AppColors.seaGreen),
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],

                          if (_selectedRole == UserRole.superAdmin) ...[
                            const Text(
                              'State Oversight Authority / Department',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkEmerald,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _addressOrRegionController,
                              decoration: const InputDecoration(
                                hintText:
                                    'e.g. Tamil Nadu Cooperative Union (HQ)',
                                prefixIcon: Icon(Icons.shield_outlined,
                                    color: AppColors.seaGreen),
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],

                          // 6. Password
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkEmerald,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: const Icon(Icons.lock_outline,
                                  color: AppColors.seaGreen),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (v) => (v == null || v.length < 6)
                                ? 'Password must be at least 6 characters'
                                : null,
                          ),
                          const SizedBox(height: 14),

                          // 7. Bylaws Checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: _agreedToBylaws,
                                activeColor: AppColors.seaGreen,
                                onChanged: (v) =>
                                    setState(() => _agreedToBylaws = v ?? true),
                              ),
                              const Expanded(
                                child: Text(
                                  'I agree to Democratic Cooperative Bylaws, Fair Wage Charter & Zero-Extraction Pricing.',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                      height: 1.3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Register CTA
                          CustomButton(
                            text: 'Create Account & Continue',
                            isLoading: _isLoading,
                            trailingIcon: Icons.arrow_forward,
                            onPressed: _handleRegister,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Already have an account link
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.login),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: AppColors.seaGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
