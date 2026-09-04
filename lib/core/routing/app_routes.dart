class AppRoutes {
  AppRoutes._();

  // Auth routes
  static const login = '/login';
  static const register = '/register';
  static const roleChoice = '/role-choice';
  static const customerRegister = '/register-customer';
  static const workerRegister = '/register-worker';
  static const coopRegister = '/register-coop';
  static const verificationPending = '/verification-pending';
  static const applicationRejected = '/application-rejected';
  static const accountSuspended = '/account-suspended';
  static const forgotPassword = '/forgot-password';

  // Customer routes
  static const customerHome = '/customer/home';
  static const customerServices = '/customer/services';
  static const workerDiscovery = '/customer/discovery';
  static const workerProfile = '/customer/worker-profile';
  static const cooperativeProfile = '/customer/cooperative-profile';
  static const bookingFlow = '/customer/book';
  static const bookCooperative = '/customer/book-cooperative';
  static const customWorkRequest = '/customer/custom-work-request';
  static const customerBookings = '/customer/bookings';
  static const activeBookingTracking = '/customer/tracking';
  static const ratingReview = '/customer/rate';
  static const customerImpact = '/customer/impact';
  static const customerProfile = '/customer/profile';
  static const customerVault = '/customer/vault';
  static const groupBooking = '/customer/group-booking';
  static const recurringCare = '/customer/care-plans';

  // Worker routes
  static const workerHome = '/worker/home';
  static const workerJobs = '/worker/jobs';
  static const workerJobDetail = '/worker/job-detail';
  static const workerRequests = '/worker/requests';
  static const workerSchedule = '/worker/schedule';
  static const workerEarnings = '/worker/earnings';
  static const workerSkills = '/worker/skills';
  static const workerWelfare = '/worker/welfare';
  static const workerSelfProfile = '/worker/profile';

  // Cooperative Admin routes
  static const coopDashboard = '/coop-admin/dashboard';
  static const coopWorkers = '/coop-admin/workers';
  static const coopVerification = '/coop-admin/verification';
  static const coopBookings = '/coop-admin/bookings';
  static const coopJobAssignment = '/coop-admin/job-assignment';
  static const coopServices = '/coop-admin/services';
  static const coopWelfare = '/coop-admin/welfare';
  static const coopAnalytics = '/coop-admin/analytics';
  static const coopProfileEdit = '/coop-admin/profile-edit';

  // Super Admin routes
  static const superDashboard = '/super-admin/dashboard';
  static const superCooperatives = '/super-admin/cooperatives';
  static const superAdmins = '/super-admin/admins';
  static const superApprovals = '/super-admin/approvals';
  static const superDisputes = '/super-admin/disputes';
  static const superCatalog = '/super-admin/catalog';
  static const superUsers = '/super-admin/users';
  static const superServices = '/super-admin/services';
  static const superAnalytics = '/super-admin/analytics';
  static const superAiForecast = '/super-admin/ai-forecast';
  static const superAuditLogs = '/super-admin/audit-logs';
  static const superSettings = '/super-admin/settings';
}
