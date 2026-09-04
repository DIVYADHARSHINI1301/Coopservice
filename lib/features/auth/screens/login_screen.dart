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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _authService = FirebaseAuthService();
  final _emailPhoneController =
      TextEditingController(text: 'divya@customer.coop');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _emailPhoneController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      _showToast('Please enter your email or mobile number', isError: true);
      return;
    }
    if (password.isEmpty) {
      _showToast('Please enter your password', isError: true);
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(platformRepositoryProvider);
      final user = await _authService.signInWithEmailPassword(
        email: email,
        password: password,
        repo: repo,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      _showToast('Welcome back, ${user.name} (${user.role.displayName})!');
      _routeByUser(context, user);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showToast(e.toString(), isError: true);
    }
  }

  void _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);

    try {
      final repo = ref.read(platformRepositoryProvider);
      final user = await _authService.signInWithGoogle(repo: repo);

      if (!mounted) return;
      setState(() => _isGoogleLoading = false);

      _showToast('Signed in with Google as ${user.name}!');
      _routeByUser(context, user);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isGoogleLoading = false);
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

  void _routeByUser(BuildContext context, AppUser user) {
    if (user.status == UserStatus.suspended) {
      context.go(AppRoutes.accountSuspended);
      return;
    }

    switch (user.role) {
      case UserRole.customer:
        context.go(AppRoutes.customerHome);
        break;
      case UserRole.worker:
        if (user.status == UserStatus.pending) {
          context.go(AppRoutes.verificationPending);
        } else if (user.status == UserStatus.rejected) {
          context.go(AppRoutes.applicationRejected);
        } else {
          context.go(AppRoutes.workerHome);
        }
        break;
      case UserRole.cooperativeAdmin:
        context.go(AppRoutes.coopDashboard);
        break;
      case UserRole.superAdmin:
        context.go(AppRoutes.superDashboard);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App Emblem & Shield
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.darkEmerald, AppColors.seaGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.seaGreen.withOpacity(0.3),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.diversity_3,
                      size: 38,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    loc.tr('appName'),
                    style: AppTypography.headlineMedium(
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Democratic Community Services • 100% Fair Wages',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Main Card Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.celadon),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.evergreen.withOpacity(0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        const Text(
                          'Account Sign In',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Enter your credentials or continue with Google',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email Field
                        const Text(
                          'Email Address / Member ID',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkEmerald,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _emailPhoneController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'e.g. divya@customer.coop',
                            prefixIcon: Icon(
                              Icons.alternate_email,
                              size: 20,
                              color: AppColors.seaGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkEmerald,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              size: 20,
                              color: AppColors.seaGreen,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                context.push(AppRoutes.forgotPassword),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.seaGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Primary Sign In CTA
                        CustomButton(
                          text: 'Sign In with Email',
                          isLoading: _isLoading,
                          trailingIcon: Icons.arrow_forward,
                          onPressed: _handleLogin,
                        ),
                        const SizedBox(height: 16),

                        // Divider
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: AppColors.celadon),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: AppColors.textSecondary.withOpacity(0.7),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: AppColors.celadon),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Real Google Sign-In Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed:
                                _isGoogleLoading ? null : _handleGoogleSignIn,
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppColors.celadon),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              backgroundColor: AppColors.white,
                            ),
                            child: _isGoogleLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.seaGreen,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEA4335),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'G',
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Sign in with Google',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.evergreen,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Demo Persona Quick-Switch
                        const Text(
                          'Test Persona Quick Fill:',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkEmerald,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _personaChip(
                                label: 'Customer',
                                email: 'divya@customer.coop',
                              ),
                              const SizedBox(width: 6),
                              _personaChip(
                                label: 'Worker',
                                email: 'ravi@worker.coop',
                              ),
                              const SizedBox(width: 6),
                              _personaChip(
                                label: 'Co-op Admin',
                                email: 'admin@coop.org',
                              ),
                              const SizedBox(width: 6),
                              _personaChip(
                                label: 'Super Admin',
                                email: 'superadmin@coop.org',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bottom Registration CTA Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.register),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                        ),
                        child: const Text(
                          'Create an Account',
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _personaChip({required String label, required String email}) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        _emailPhoneController.text = email;
        _passwordController.text = 'password123';
        _handleLogin();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.frostedMint,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.celadon),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.darkEmerald,
          ),
        ),
      ),
    );
  }
}
