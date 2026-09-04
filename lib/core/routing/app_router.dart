import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/account_suspended_screen.dart';
import '../../features/auth/screens/application_rejected_screen.dart';
import '../../features/auth/screens/cooperative_register_screen.dart';
import '../../features/auth/screens/customer_register_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/role_choice_screen.dart';
import '../../features/auth/screens/verification_pending_screen.dart';
import '../../features/auth/screens/worker_register_screen.dart';
import '../../features/coop_admin/screens/coop_admin_shell_screen.dart';
import '../../features/coop_admin/screens/coop_analytics_screen.dart';
import '../../features/coop_admin/screens/coop_bookings_screen.dart';
import '../../features/coop_admin/screens/coop_job_assignment_screen.dart';
import '../../features/coop_admin/screens/coop_profile_edit_screen.dart';
import '../../features/coop_admin/screens/coop_verification_queue_screen.dart';
import '../../features/coop_admin/screens/coop_workers_screen.dart';
import '../../features/customer/screens/active_booking_tracking_screen.dart';
import '../../features/customer/screens/book_cooperative_flow_screen.dart';
import '../../features/customer/screens/booking_flow_screen.dart';
import '../../features/customer/screens/cooperative_profile_screen.dart';
import '../../features/customer/screens/custom_work_request_screen.dart';
import '../../features/customer/screens/customer_bookings_screen.dart';
import '../../features/customer/screens/customer_impact_screen.dart';
import '../../features/customer/screens/customer_profile_screen.dart';
import '../../features/customer/screens/customer_services_screen.dart';
import '../../features/customer/screens/customer_shell_screen.dart';
import '../../features/customer/screens/group_booking_screen.dart';
import '../../features/customer/screens/rating_review_screen.dart';
import '../../features/customer/screens/recurring_care_screen.dart';
import '../../features/customer/screens/service_vault_screen.dart';
import '../../features/customer/screens/worker_discovery_screen.dart';
import '../../features/customer/screens/worker_profile_screen.dart';
import '../../features/super_admin/screens/super_admin_shell_screen.dart';
import '../../features/super_admin/screens/super_admins_screen.dart';
import '../../features/super_admin/screens/super_ai_forecast_screen.dart';
import '../../features/super_admin/screens/super_audit_logs_screen.dart';
import '../../features/super_admin/screens/super_cooperatives_screen.dart';
import '../../features/super_admin/screens/super_disputes_screen.dart';
import '../../features/super_admin/screens/super_services_catalog_screen.dart';
import '../../features/super_admin/screens/super_worker_approvals_screen.dart';
import '../../features/worker/screens/worker_earnings_screen.dart';
import '../../features/worker/screens/worker_job_detail_screen.dart';
import '../../features/worker/screens/worker_jobs_screen.dart';
import '../../features/worker/screens/worker_requests_screen.dart';
import '../../features/worker/screens/worker_schedule_screen.dart';
import '../../features/worker/screens/worker_self_profile_screen.dart';
import '../../features/worker/screens/worker_shell_screen.dart';
import '../../features/worker/screens/worker_skills_screen.dart';
import '../../features/worker/screens/worker_welfare_screen.dart';
import '../../shared/data/repository.dart';
import '../../shared/models/booking_model.dart';
import '../../shared/models/cooperative_model.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/worker_model.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final repo = ref.read(platformRepositoryProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: repo,
    redirect: (context, state) {
      final user = repo.currentUser;
      final isLoggedIn = repo.isLoggedIn;
      final path = state.matchedLocation;

      final isAuthRoute = path == AppRoutes.login ||
          path == AppRoutes.register ||
          path == AppRoutes.roleChoice ||
          path == AppRoutes.customerRegister ||
          path == AppRoutes.workerRegister ||
          path == AppRoutes.coopRegister ||
          path == AppRoutes.forgotPassword;

      // If user is not logged in
      if (!isLoggedIn) {
        return isAuthRoute ? null : AppRoutes.login;
      }

      // If user IS logged in and is currently on the login or registration page
      if (path == AppRoutes.login ||
          path == AppRoutes.register ||
          path == AppRoutes.roleChoice) {
        if (user.status == UserStatus.suspended) {
          return AppRoutes.accountSuspended;
        }

        switch (user.role) {
          case UserRole.customer:
            return AppRoutes.customerHome;
          case UserRole.worker:
            if (user.status == UserStatus.pending) {
              return AppRoutes.verificationPending;
            } else if (user.status == UserStatus.rejected) {
              return AppRoutes.applicationRejected;
            } else {
              return AppRoutes.workerHome;
            }
          case UserRole.cooperativeAdmin:
            return AppRoutes.coopDashboard;
          case UserRole.superAdmin:
            return AppRoutes.superDashboard;
        }
      }

      // If logged in user is suspended
      if (user.status == UserStatus.suspended &&
          path != AppRoutes.accountSuspended) {
        return AppRoutes.accountSuspended;
      }

      // If logged in worker is pending/rejected
      if (user.role == UserRole.worker) {
        if (user.status == UserStatus.pending &&
            path != AppRoutes.verificationPending) {
          return AppRoutes.verificationPending;
        }
        if (user.status == UserStatus.rejected &&
            path != AppRoutes.applicationRejected) {
          return AppRoutes.applicationRejected;
        }
      }

      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleChoice,
        builder: (context, state) => const RoleChoiceScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerRegister,
        builder: (context, state) => const CustomerRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.workerRegister,
        builder: (context, state) => const WorkerRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.coopRegister,
        builder: (context, state) => const CooperativeRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.verificationPending,
        builder: (context, state) => const VerificationPendingScreen(),
      ),
      GoRoute(
        path: AppRoutes.applicationRejected,
        builder: (context, state) => const ApplicationRejectedScreen(),
      ),
      GoRoute(
        path: AppRoutes.accountSuspended,
        builder: (context, state) => const AccountSuspendedScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Customer Routes
      GoRoute(
        path: AppRoutes.customerHome,
        builder: (context, state) => const CustomerShellScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerServices,
        builder: (context, state) => const CustomerServicesScreen(),
      ),
      GoRoute(
        path: AppRoutes.workerDiscovery,
        builder: (context, state) => const WorkerDiscoveryScreen(),
      ),
      GoRoute(
        path: AppRoutes.workerProfile,
        builder: (context, state) {
          final worker = state.extra as WorkerProfile? ??
              ref.read(platformRepositoryProvider).allWorkers.first;
          return WorkerProfileScreen(worker: worker);
        },
      ),
      GoRoute(
        path: AppRoutes.cooperativeProfile,
        builder: (context, state) {
          final coop = state.extra as Cooperative? ??
              ref.read(platformRepositoryProvider).allCooperatives.first;
          return CooperativeProfileScreen(cooperative: coop);
        },
      ),
      GoRoute(
        path: AppRoutes.bookingFlow,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final worker = extra['worker'] as WorkerProfile? ??
              ref.read(platformRepositoryProvider).allWorkers.first;
          final isEmergency = extra['isEmergency'] as bool? ?? false;
          return BookingFlowScreen(
              worker: worker, isEmergency: isEmergency);
        },
      ),
      GoRoute(
        path: AppRoutes.bookCooperative,
        builder: (context, state) {
          final coop = state.extra as Cooperative? ??
              ref.read(platformRepositoryProvider).allCooperatives.first;
          return BookCooperativeFlowScreen(cooperative: coop);
        },
      ),
      GoRoute(
        path: AppRoutes.customWorkRequest,
        builder: (context, state) => const CustomWorkRequestScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerBookings,
        builder: (context, state) => const CustomerBookingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.activeBookingTracking,
        builder: (context, state) {
          final booking = state.extra as Booking? ??
              ref.read(platformRepositoryProvider).allBookings.first;
          return ActiveBookingTrackingScreen(booking: booking);
        },
      ),
      GoRoute(
        path: AppRoutes.ratingReview,
        builder: (context, state) {
          final booking = state.extra as Booking? ??
              ref.read(platformRepositoryProvider).allBookings.first;
          return RatingReviewScreen(booking: booking);
        },
      ),
      GoRoute(
        path: AppRoutes.customerImpact,
        builder: (context, state) => const CustomerImpactScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerProfile,
        builder: (context, state) => const CustomerProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerVault,
        builder: (context, state) => const ServiceVaultScreen(),
      ),
      GoRoute(
        path: AppRoutes.groupBooking,
        builder: (context, state) => const GroupBookingScreen(),
      ),
      GoRoute(
        path: AppRoutes.recurringCare,
        builder: (context, state) => const RecurringCareScreen(),
      ),

      // Worker Routes
      GoRoute(
        path: AppRoutes.workerHome,
        builder: (context, state) => const WorkerShellScreen(),
      ),
      GoRoute(
        path: AppRoutes.workerJobs,
        builder: (context, state) => const WorkerJobsScreen(),
      ),
      GoRoute(
        path: AppRoutes.workerJobDetail,
        builder: (context, state) {
          final booking = state.extra as Booking? ??
              ref.read(platformRepositoryProvider).allBookings.first;
          return WorkerJobDetailScreen(booking: booking);
        },
      ),
      GoRoute(
        path: AppRoutes.workerRequests,
        builder: (context, state) => const WorkerRequestsScreen(),
      ),
      GoRoute(
        path: AppRoutes.workerSchedule,
        builder: (context, state) => const WorkerScheduleScreen(),
      ),
      GoRoute(
        path: AppRoutes.workerEarnings,
        builder: (context, state) => const WorkerEarningsScreen(),
      ),
      GoRoute(
        path: AppRoutes.workerSkills,
        builder: (context, state) => const WorkerSkillsScreen(),
      ),
      GoRoute(
        path: AppRoutes.workerWelfare,
        builder: (context, state) => const WorkerWelfareScreen(),
      ),
      GoRoute(
        path: AppRoutes.workerSelfProfile,
        builder: (context, state) => const WorkerSelfProfileScreen(),
      ),

      // Cooperative Admin Routes
      GoRoute(
        path: AppRoutes.coopDashboard,
        builder: (context, state) => const CoopAdminShellScreen(),
      ),
      GoRoute(
        path: AppRoutes.coopWorkers,
        builder: (context, state) => const CoopWorkersScreen(),
      ),
      GoRoute(
        path: AppRoutes.coopVerification,
        builder: (context, state) => const CoopVerificationQueueScreen(),
      ),
      GoRoute(
        path: AppRoutes.coopBookings,
        builder: (context, state) => const CoopBookingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.coopJobAssignment,
        builder: (context, state) {
          final booking = state.extra as Booking? ??
              ref.read(platformRepositoryProvider).allBookings.first;
          return CoopJobAssignmentScreen(booking: booking);
        },
      ),
      GoRoute(
        path: AppRoutes.coopAnalytics,
        builder: (context, state) => const CoopAnalyticsScreen(),
      ),
      GoRoute(
        path: AppRoutes.coopProfileEdit,
        builder: (context, state) => const CoopProfileEditScreen(),
      ),

      // Super Admin Routes
      GoRoute(
        path: AppRoutes.superDashboard,
        builder: (context, state) => const SuperAdminShellScreen(),
      ),
      GoRoute(
        path: AppRoutes.superCooperatives,
        builder: (context, state) => const SuperCooperativesScreen(),
      ),
      GoRoute(
        path: AppRoutes.superAdmins,
        builder: (context, state) => const SuperAdminsScreen(),
      ),
      GoRoute(
        path: AppRoutes.superApprovals,
        builder: (context, state) => const SuperWorkerApprovalsScreen(),
      ),
      GoRoute(
        path: AppRoutes.superDisputes,
        builder: (context, state) => const SuperDisputesScreen(),
      ),
      GoRoute(
        path: AppRoutes.superCatalog,
        builder: (context, state) => const SuperServicesCatalogScreen(),
      ),
      GoRoute(
        path: AppRoutes.superAiForecast,
        builder: (context, state) => const SuperAiForecastScreen(),
      ),
      GoRoute(
        path: AppRoutes.superAuditLogs,
        builder: (context, state) => const SuperAuditLogsScreen(),
      ),
    ],
  );
});
