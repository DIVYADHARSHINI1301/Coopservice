import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/customer_model.dart';
import '../../../shared/models/user_model.dart';

class CustomerProfileScreen extends ConsumerStatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  ConsumerState<CustomerProfileScreen> createState() =>
      _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends ConsumerState<CustomerProfileScreen> {
  final _authService = FirebaseAuthService();
  bool _pushNotificationsEnabled = true;

  // 1. Edit Profile Dialog
  void _showEditProfileDialog(BuildContext context, AppUser user) {
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone);
    final emailController = TextEditingController(text: user.email);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Customer Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.evergreen,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Full Name',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: AppColors.seaGreen),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 12),
                const Text('Phone Number',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone, color: AppColors.seaGreen),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Please enter your contact number'
                      : null,
                ),
                const SizedBox(height: 12),
                const Text('Email Address',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email, color: AppColors.seaGreen),
                  ),
                  validator: (val) => val == null || !val.contains('@')
                      ? 'Please enter a valid email'
                      : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        ref.read(platformRepositoryProvider).updateCustomerProfile(
                              name: nameController.text.trim(),
                              phone: phoneController.text.trim(),
                              email: emailController.text.trim(),
                            );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile updated successfully!'),
                            backgroundColor: AppColors.seaGreen,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.seaGreen,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save Changes',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 2. Saved Addresses Management Sheet
  void _showSavedAddressesSheet(BuildContext context, CustomerProfile customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Saved Addresses & Locations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (customer.savedAddresses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('No saved addresses yet.'),
                    )
                  else
                    ...customer.savedAddresses.map((addr) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: addr.isDefault
                              ? AppColors.frostedMint.withOpacity(0.5)
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: addr.isDefault
                                ? AppColors.seaGreen
                                : AppColors.celadon,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              addr.label.toLowerCase().contains('home')
                                  ? Icons.home
                                  : Icons.apartment,
                              color: AppColors.darkEmerald,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        addr.label,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppColors.evergreen,
                                        ),
                                      ),
                                      if (addr.isDefault) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: AppColors.seaGreen,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'Default',
                                            style: TextStyle(
                                                fontSize: 9, color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    addr.address,
                                    style: const TextStyle(
                                        fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: AppColors.redDestructive, size: 20),
                              onPressed: () {
                                ref
                                    .read(platformRepositoryProvider)
                                    .deleteCustomerAddress(addr.id);
                                Navigator.pop(ctx);
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showAddAddressDialog(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Address'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.seaGreen,
                      foregroundColor: AppColors.white,
                      minimumSize: const Size(double.infinity, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Add Address Dialog
  void _showAddAddressDialog(BuildContext context) {
    final labelController = TextEditingController(text: 'Home');
    final addressController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Add New Address'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: labelController,
                decoration: const InputDecoration(labelText: 'Label (e.g. Home, Office, Flat 3B)'),
                validator: (val) => val == null || val.isEmpty ? 'Label required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: addressController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Full Street Address & Landmark'),
                validator: (val) => val == null || val.isEmpty ? 'Address required' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                ref.read(platformRepositoryProvider).addCustomerAddress(
                      SavedAddress(
                        id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
                        label: labelController.text.trim(),
                        address: addressController.text.trim(),
                        lat: 13.0850,
                        lng: 80.2101,
                        isDefault: false,
                      ),
                    );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New address saved!'),
                    backgroundColor: AppColors.seaGreen,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.seaGreen,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Save Address'),
          ),
        ],
      ),
    );
  }

  // 3. Saved / Regular Workers Sheet
  void _showSavedWorkersSheet(BuildContext context, PlatformRepository repo, CustomerProfile customer) {
    final regulars = repo.allWorkers
        .where((w) => customer.myRegularWorkerIds.containsValue(w.uid))
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Regular Guild Technicians',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.evergreen,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (regulars.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text('No regular workers pinned yet. Pin workers from their profile!'),
                ),
              )
            else
              ...regulars.map((w) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.celadon),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(w.photoUrl),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('${w.primaryCategory} • ★ ${w.rating}',
                                style: const TextStyle(fontSize: 12, color: AppColors.darkEmerald)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.push(
                            AppRoutes.bookingFlow,
                            extra: {'worker': w, 'isEmergency': false},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.seaGreen,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Book', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  // 4. Payment Methods Sheet
  void _showPaymentMethodsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cooperative Payment Methods',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.evergreen,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _paymentOptionTile(
              icon: Icons.qr_code,
              title: 'UPI Instant Pay (Google Pay / PhonePe / Paytm)',
              subtitle: 'Pay directly to guild escrow upon job completion',
              isDefault: true,
            ),
            _paymentOptionTile(
              icon: Icons.payments_outlined,
              title: 'Cash on Completion',
              subtitle: 'Direct settlement with certified guild technician',
              isDefault: false,
            ),
            _paymentOptionTile(
              icon: Icons.shield_outlined,
              title: 'Cooperative Warranty Escrow',
              subtitle: '100% money-back guarantee for 90 days',
              isDefault: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDefault,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDefault ? AppColors.frostedMint.withOpacity(0.5) : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDefault ? AppColors.seaGreen : AppColors.celadon),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.seaGreen, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (isDefault) const Icon(Icons.check_circle, color: AppColors.seaGreen),
        ],
      ),
    );
  }

  // 5. Notifications Sheet
  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notifications & Updates',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.evergreen,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _notifItem(
              title: 'Technician Assigned (#BK-84920)',
              body: 'Ravi Kumar (Master Electrician) is on the way to Anna Nagar.',
              time: '12 mins ago',
              isUnread: true,
            ),
            _notifItem(
              title: '90-Day Guild Warranty Active',
              body: 'Warranty card issued for AC servicing at Plot 42.',
              time: '2 hours ago',
              isUnread: false,
            ),
            _notifItem(
              title: 'Quarterly Cooperative Dividend',
              body: 'Anna Nagar Guild reported ₹15,62,000 member earnings.',
              time: '1 day ago',
              isUnread: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _notifItem({
    required String title,
    required String body,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnread ? AppColors.frostedMint.withOpacity(0.4) : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(time, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(body, style: const TextStyle(fontSize: 12, color: AppColors.evergreen)),
        ],
      ),
    );
  }

  // 6. Help & Support Sheet
  void _showHelpSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cooperative Guild Support',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.evergreen,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.frostedMint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone, color: AppColors.seaGreen),
              ),
              title: const Text('Call Guild Coordinator', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('+91 98401 54321 • Direct local dispatch support'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Connecting to Anna Nagar Guild Coordinator (+91 98401 54321)...'),
                    backgroundColor: AppColors.seaGreen,
                  ),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chat, color: Color(0xFF16A34A)),
              ),
              title: const Text('WhatsApp Helpdesk', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Quick chat & job estimate inquiries'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening WhatsApp Guild Helpdesk...'),
                    backgroundColor: AppColors.seaGreen,
                  ),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.gavel, color: Color(0xFFD97706)),
              ),
              title: const Text('Raise Quality Ticket / Dispute', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Reviewed democratically by cooperative committee'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Quality Guarantee Ticket form...'),
                    backgroundColor: AppColors.seaGreen,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 7. Cooperative Bylaws Modal
  void _showBylawsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Democratic Cooperative Charter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.evergreen,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _bylawPoint('1. Zero Platform Commission', '100% of fair customer booking revenue is retained by local technicians and cooperative clusters.'),
            _bylawPoint('2. 90-Day Guild Warranty', 'Every completed gig is backed by cooperative guarantee with free follow-up inspection.'),
            _bylawPoint('3. Equal Democratic Voice', 'Artisans and patrons elect local cluster coordinators with transparent audit logs.'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.seaGreen,
                  foregroundColor: AppColors.white,
                ),
                child: const Text('Understood'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bylawPoint(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.darkEmerald)),
          const SizedBox(height: 2),
          Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.25)),
        ],
      ),
    );
  }

  // 8. Logout Confirmation
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out of your Cooperative Services account?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final repo = ref.read(platformRepositoryProvider);
              await _authService.signOut(repo);
              if (!mounted) return;
              context.go(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redDestructive,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final user = repo.currentUser;
    final customer = repo.currentCustomerProfile;
    final locale = ref.watch(localeProvider);
    final loc = AppLocalization.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF9),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: Text(
          loc.tr('profile'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Header Card with Edit Action
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.celadon),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.evergreen.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.frostedMint,
                    child: Text(
                      user.name.isNotEmpty ? user.name.substring(0, 1) : 'C',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkEmerald,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          user.phone,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.seaGreen),
                    tooltip: 'Edit Profile',
                    onPressed: () => _showEditProfileDialog(context, user),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Differentiators Group: Service Vault, Society Split, Care Plans
            _profileTileGroup([
              _tile(
                icon: Icons.folder_special,
                title: 'Home Service Vault & Job Cards',
                subtitle: 'Permanent service records & 90-day warranty',
                onTap: () => context.push(AppRoutes.customerVault),
              ),
              _tile(
                icon: Icons.apartment,
                title: 'Society & Multi-Flat Bookings',
                subtitle: 'Split community repairs with neighbors',
                onTap: () => context.push(AppRoutes.groupBooking),
              ),
              _tile(
                icon: Icons.autorenew,
                title: 'Recurring Guild Care Plans',
                subtitle: 'Quarterly AC, drain & tank maintenance',
                onTap: () => context.push(AppRoutes.recurringCare),
              ),
            ]),
            const SizedBox(height: 14),

            // Account & Preferences
            _profileTileGroup([
              _tile(
                icon: Icons.location_on_outlined,
                title: 'Saved Addresses',
                subtitle: customer.savedAddresses.isNotEmpty
                    ? '${customer.savedAddresses.first.label}: ${customer.savedAddresses.first.address}'
                    : 'Manage delivery addresses',
                onTap: () => _showSavedAddressesSheet(context, customer),
              ),
              _tile(
                icon: Icons.star_border,
                title: 'My Regular Guild Technicians',
                subtitle: '${customer.myRegularWorkerIds.length} Pinned technicians',
                onTap: () => _showSavedWorkersSheet(context, repo, customer),
              ),
              _tile(
                icon: Icons.language,
                title: 'Language / மொழி',
                subtitle: locale.languageCode == 'en' ? 'English' : 'தமிழ்',
                trailing: Switch(
                  value: locale.languageCode == 'ta',
                  activeColor: AppColors.seaGreen,
                  onChanged: (val) {
                    ref.read(localeProvider.notifier).state =
                        Locale(val ? 'ta' : 'en');
                  },
                ),
                onTap: () {
                  ref.read(localeProvider.notifier).state =
                      Locale(locale.languageCode == 'en' ? 'ta' : 'en');
                },
              ),
              _tile(
                icon: Icons.notifications_none,
                title: 'Push Notifications',
                subtitle: 'Live updates on technician status',
                trailing: Switch(
                  value: _pushNotificationsEnabled,
                  activeColor: AppColors.seaGreen,
                  onChanged: (val) {
                    setState(() => _pushNotificationsEnabled = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Notifications ${val ? "Enabled" : "Disabled"}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                onTap: () => _showNotificationsSheet(context),
              ),
            ]),
            const SizedBox(height: 14),

            // Payments, Help & Bylaws
            _profileTileGroup([
              _tile(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Payment Methods & Escrow',
                subtitle: 'UPI, Cash on completion, Warranty protection',
                onTap: () => _showPaymentMethodsSheet(context),
              ),
              _tile(
                icon: Icons.help_outline,
                title: 'Help & Support Desk',
                subtitle: 'Call coordinator or chat on WhatsApp',
                onTap: () => _showHelpSheet(context),
              ),
              _tile(
                icon: Icons.policy_outlined,
                title: 'Democratic Governance & Bylaws',
                subtitle: '0% Platform Extraction & Equity Charter',
                onTap: () => _showBylawsSheet(context),
              ),
            ]),
            const SizedBox(height: 16),

            // Logout Button
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.celadon),
              ),
              tileColor: AppColors.white,
              leading: const Icon(Icons.logout, color: AppColors.redDestructive),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.redDestructive,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => _showLogoutDialog(context),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _profileTileGroup(List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.celadon),
        boxShadow: [
          BoxShadow(
            color: AppColors.evergreen.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: tiles,
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.seaGreen),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.evergreen,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
