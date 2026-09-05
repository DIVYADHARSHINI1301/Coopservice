import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/worker_model.dart';
import '../../../shared/widgets/status_badge.dart';
import 'worker_welfare_screen.dart';

class WorkerSelfProfileScreen extends ConsumerStatefulWidget {
  const WorkerSelfProfileScreen({super.key});

  @override
  ConsumerState<WorkerSelfProfileScreen> createState() =>
      _WorkerSelfProfileScreenState();
}

class _WorkerSelfProfileScreenState
    extends ConsumerState<WorkerSelfProfileScreen> {
  final _authService = FirebaseAuthService();
  bool _soundAlerts = true;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final user = repo.currentUser;
    final worker = repo.getWorkerForUser(user);
    final coop = repo.allCooperatives.firstWhere(
      (c) => c.id == worker.cooperativeId,
      orElse: () => repo.allCooperatives.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'Artisan Profile & Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, size: 26),
            tooltip: 'Edit Profile Details',
            onPressed: () => _openEditProfileModal(context, repo, worker),
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 22),
            tooltip: 'Sign Out',
            onPressed: () => _handleSignOut(context, repo),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Profile Summary Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.celadon),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.evergreen.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundImage: NetworkImage(worker.photoUrl),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () => _showPhotoUpdateToast(context),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.seaGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt,
                                    size: 14, color: AppColors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              worker.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.evergreen,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${worker.primaryCategory} • ${worker.experienceYears} Yrs Exp',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkEmerald,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Base Rate: ₹${worker.hourlyRate.toStringAsFixed(0)}/hr',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.seaGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Edit button
                      OutlinedButton(
                        onPressed: () =>
                            _openEditProfileModal(context, repo, worker),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          side: const BorderSide(color: AppColors.celadon),
                        ),
                        child: const Text('Edit',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.seaGreen)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Rating and completed stats
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.frostedMint.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: AppColors.amberWarning, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${worker.rating} (${worker.ratingCount})',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Text('•',
                            style: TextStyle(color: AppColors.textSecondary)),
                        Text(
                          '${worker.completedJobsCount} Jobs Done',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkEmerald),
                        ),
                        const Text('•',
                            style: TextStyle(color: AppColors.textSecondary)),
                        const Text(
                          '100% On-Time',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.seaGreen),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Online Duty Switch
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: worker.online
                          ? const Color(0xFFDCF3E7)
                          : const Color(0xFFFDE8E8),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: worker.online
                            ? AppColors.seaGreen
                            : AppColors.redDestructive,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              worker.online
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: worker.online
                                  ? AppColors.seaGreen
                                  : AppColors.redDestructive,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              worker.online
                                  ? 'Duty Active (Ready for Jobs)'
                                  : 'Offline (Off Duty)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: worker.online
                                    ? AppColors.darkEmerald
                                    : AppColors.redDestructive,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: worker.online,
                          activeColor: AppColors.seaGreen,
                          onChanged: (val) {
                            repo.toggleWorkerOnline(worker.uid, val);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(val
                                    ? 'You are now ONLINE for bookings!'
                                    : 'You are now OFFLINE.'),
                                backgroundColor: val
                                    ? AppColors.seaGreen
                                    : AppColors.textSecondary,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. My Cooperative Guild Hub Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.pineTeal, AppColors.evergreen],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.evergreen.withOpacity(0.12),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MY HOME COOPERATIVE GUILD',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: AppColors.celadon,
                        ),
                      ),
                      Icon(Icons.shield, color: AppColors.mintLeaf, size: 18),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    worker.cooperativeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Coordinator: ${coop.adminNames.isNotEmpty ? coop.adminNames.first : "M. Sundaram"} • ${coop.phone}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.frostedMint,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.push(AppRoutes.cooperativeProfile,
                                extra: coop);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mintLeaf2,
                            foregroundColor: AppColors.evergreen,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('View Guild Hub & Ledger',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => _callCoordinator(context, coop),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.frostedMint,
                        ),
                        icon: const Icon(Icons.phone,
                            color: AppColors.darkEmerald, size: 18),
                        tooltip: 'Call Coordinator',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Verified Skills & Specializations Manager
            Container(
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
                      const Text(
                        'Verified Specializations & Skills',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Skill',
                            style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.seaGreen,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                        ),
                        onPressed: () =>
                            _openAddSkillModal(context, repo, worker),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: worker.skills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        backgroundColor: AppColors.frostedMint,
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () {
                          final updated = List<String>.from(worker.skills)
                            ..remove(skill);
                          repo.updateWorkerSkills(worker.uid, updated);
                        },
                        labelStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. Assigned Service Neighborhoods Manager
            Container(
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
                      const Text(
                        'Coverage Neighborhoods',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.add_location_alt, size: 16),
                        label: const Text('Add Area',
                            style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.seaGreen,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                        ),
                        onPressed: () =>
                            _openAddAreaModal(context, repo, worker),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: worker.serviceAreas.map((area) {
                      return Chip(
                        label: Text(area),
                        backgroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.celadon),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () {
                          final updated = List<String>.from(worker.serviceAreas)
                            ..remove(area);
                          repo.updateWorkerServiceAreas(worker.uid, updated);
                        },
                        labelStyle: const TextStyle(
                          fontSize: 11,
                          color: AppColors.evergreen,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 5. Direct Bank / UPI Payout Account Settings
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.account_balance,
                          color: AppColors.seaGreen, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Living Wage Payout Settlement',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Direct 85% worker wage settlement deposited daily into your verified bank / UPI.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2FBF6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.celadon),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('HDFC Bank •••• 4092',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                            Text('UPI: ravi.coop@okhdfcbank',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                        StatusBadge(
                          label: 'Active',
                          status: BadgeStatus.coopVerified,
                          fontSize: 9,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openBankConfigModal(context),
                      icon: const Icon(Icons.credit_card, size: 16),
                      label: const Text('Update Bank / UPI Account',
                          style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.seaGreen),
                        foregroundColor: AppColors.seaGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 6. National Health Shield & Welfare Hub Link
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.frostedMint,
                    child: Icon(Icons.health_and_safety,
                        color: AppColors.darkEmerald),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'National Co-op Health Shield',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        Text(
                          '₹5,00,000 active cover + Tool replacement fund',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right,
                        color: AppColors.seaGreen),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WorkerWelfareScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 7. General Preferences & Settings
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'App Preferences',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Sound Alerts for New Dispatch',
                        style: TextStyle(fontSize: 13)),
                    subtitle: const Text('Play chime when job is assigned',
                        style: TextStyle(fontSize: 11)),
                    value: _soundAlerts,
                    activeColor: AppColors.seaGreen,
                    onChanged: (v) => setState(() => _soundAlerts = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 8. Sign Out CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _handleSignOut(context, repo),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Sign Out of Worker Account',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDE8E8),
                  foregroundColor: AppColors.redDestructive,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Modals & Handlers
  void _openEditProfileModal(
      BuildContext context, PlatformRepository repo, WorkerProfile worker) {
    final nameCtrl = TextEditingController(text: worker.name);
    final rateCtrl =
        TextEditingController(text: worker.hourlyRate.toStringAsFixed(0));
    final expCtrl =
        TextEditingController(text: worker.experienceYears.toString());
    final bioCtrl = TextEditingController(text: worker.bio);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Profile & Hourly Rate',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald)),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person, color: AppColors.seaGreen),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: rateCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Hourly Rate (₹)',
                        prefixIcon:
                            Icon(Icons.currency_rupee, color: AppColors.seaGreen),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: expCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Experience (Yrs)',
                        prefixIcon:
                            Icon(Icons.timeline, color: AppColors.seaGreen),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bioCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Professional Bio & Standards',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final newRate = double.tryParse(rateCtrl.text) ?? worker.hourlyRate;
                    final newExp = int.tryParse(expCtrl.text) ?? worker.experienceYears;
                    repo.updateWorkerProfileDetails(
                      worker.uid,
                      name: nameCtrl.text.trim(),
                      hourlyRate: newRate,
                      experienceYears: newExp,
                      bio: bioCtrl.text.trim(),
                    );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                        backgroundColor: AppColors.seaGreen,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.seaGreen,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Save Changes',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAddSkillModal(
      BuildContext context, PlatformRepository repo, WorkerProfile worker) {
    final skillCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Specialization'),
        content: TextField(
          controller: skillCtrl,
          decoration: const InputDecoration(
            hintText: 'e.g. Solar PV Inverter & Grid Link',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (skillCtrl.text.trim().isNotEmpty) {
                final updated = List<String>.from(worker.skills)
                  ..add(skillCtrl.text.trim());
                repo.updateWorkerSkills(worker.uid, updated);
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.seaGreen),
            child: const Text('Add Skill',
                style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  void _openAddAreaModal(
      BuildContext context, PlatformRepository repo, WorkerProfile worker) {
    final areaCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Service Neighborhood'),
        content: TextField(
          controller: areaCtrl,
          decoration: const InputDecoration(
            hintText: 'e.g. T. Nagar, Shenoy Nagar',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (areaCtrl.text.trim().isNotEmpty) {
                final updated = List<String>.from(worker.serviceAreas)
                  ..add(areaCtrl.text.trim());
                repo.updateWorkerServiceAreas(worker.uid, updated);
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.seaGreen),
            child: const Text('Add Area',
                style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  void _openBankConfigModal(BuildContext context) {
    final bankCtrl = TextEditingController(text: 'HDFC Bank - Anna Nagar');
    final accCtrl = TextEditingController(text: '50100492819203');
    final ifscCtrl = TextEditingController(text: 'HDFC0001248');
    final upiCtrl = TextEditingController(text: 'ravi.coop@okhdfcbank');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Configure Settlement Account',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald)),
              const SizedBox(height: 14),
              TextField(
                controller: bankCtrl,
                decoration: const InputDecoration(labelText: 'Bank Name & Branch'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: accCtrl,
                decoration: const InputDecoration(labelText: 'Account Number'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ifscCtrl,
                decoration: const InputDecoration(labelText: 'IFSC Code'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: upiCtrl,
                decoration: const InputDecoration(labelText: 'UPI VPA Address'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settlement Account updated!'),
                        backgroundColor: AppColors.seaGreen,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.seaGreen,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Save Settlement Details',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _callCoordinator(BuildContext context, dynamic coop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling Guild Coordinator at ${coop.phone}...'),
        backgroundColor: AppColors.seaGreen,
      ),
    );
  }

  void _showPhotoUpdateToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera opened: Select new profile image from gallery'),
        backgroundColor: AppColors.seaGreen,
      ),
    );
  }

  void _handleSignOut(BuildContext context, PlatformRepository repo) async {
    await _authService.signOut(repo);
    if (!mounted) return;
    context.go(AppRoutes.login);
  }
}
