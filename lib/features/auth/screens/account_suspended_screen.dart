import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/widgets/custom_button.dart';

class AccountSuspendedScreen extends ConsumerWidget {
  const AccountSuspendedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.redDestructive.withOpacity(0.08),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.redDestructive.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.block,
                      color: AppColors.redDestructive,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Account Suspended',
                    style: AppTypography.headlineMedium(
                      color: AppColors.redDestructive,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This account has been temporarily suspended by the cooperative administration due to a safety review or policy verification.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Contact Co-op Ethics Committee',
                    icon: Icons.support_agent,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Appeal ticket raised with Co-op board.'),
                          backgroundColor: AppColors.seaGreen,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      ref.read(platformRepositoryProvider).switchUser('cust_divya');
                      context.go(AppRoutes.login);
                    },
                    child: const Text('Back to Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.evergreen,
        elevation: 0,
        title: Text(
          'Reset Password',
          style: AppTypography.headlineSmall(color: AppColors.darkEmerald),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.celadon),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_sent) ...[
                  Text(
                    'Forgot Password?',
                    style: AppTypography.headlineMedium(
                        color: AppColors.darkEmerald),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enter your registered email address or mobile number to receive a secure password reset link.',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Email or Mobile',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.evergreen),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. you@neighborhood.coop',
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Send Reset Link',
                    onPressed: () {
                      setState(() => _sent = true);
                    },
                  ),
                ] else ...[
                  const Center(
                    child: Icon(Icons.mark_email_read,
                        size: 60, color: AppColors.seaGreen),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Check Your Inbox',
                      style: AppTypography.headlineMedium(
                          color: AppColors.darkEmerald),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We have dispatched a password reset link to your email. Click the link in the message to set a new password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Return to Login',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
