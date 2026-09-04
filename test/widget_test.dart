import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cooperative_gig_services/main.dart';
import 'package:cooperative_gig_services/shared/data/repository.dart';
import 'package:cooperative_gig_services/shared/models/booking_model.dart';
import 'package:cooperative_gig_services/shared/models/user_model.dart';

void main() {
  group('Cooperative Services Unit & Integration Tests', () {
    test('Repository initializes with seeded mock users and cooperatives', () {
      final repo = PlatformRepository();
      expect(repo.allUsers.isNotEmpty, true);
      expect(repo.allCooperatives.isNotEmpty, true);
      expect(repo.allWorkers.isNotEmpty, true);
      expect(repo.allBookings.isNotEmpty, true);
      expect(repo.currentUser.role, UserRole.customer);
    });

    test('Worker state machine advances through all 5 sequential steps', () {
      final repo = PlatformRepository();
      final initialBooking = repo.allBookings.first;

      // 1. Requested -> Accepted
      final b1 = repo.updateBookingStatus(initialBooking.id, BookingStatus.accepted);
      expect(b1.status, BookingStatus.accepted);

      // 2. Accepted -> On The Way
      final b2 = repo.updateBookingStatus(initialBooking.id, BookingStatus.onTheWay);
      expect(b2.status, BookingStatus.onTheWay);

      // 3. On The Way -> Arrived
      final b3 = repo.updateBookingStatus(initialBooking.id, BookingStatus.arrived);
      expect(b3.status, BookingStatus.arrived);

      // 4. Arrived -> In Progress
      final b4 = repo.updateBookingStatus(initialBooking.id, BookingStatus.inProgress);
      expect(b4.status, BookingStatus.inProgress);

      // 5. In Progress -> Completed
      final b5 = repo.updateBookingStatus(initialBooking.id, BookingStatus.completed);
      expect(b5.status, BookingStatus.completed);
      expect(b5.paymentStatus, 'paid');
    });

    test('Cooperative Admin verification flips candidate status to active', () {
      final repo = PlatformRepository();

      // Find pending applicant Karthik
      final pendingApplicant = repo.allUsers.firstWhere(
        (u) => u.status == UserStatus.pending,
      );
      expect(pendingApplicant.status, UserStatus.pending);

      // Admin approves application
      repo.verifyWorkerApplication(
        workerUid: pendingApplicant.uid,
        approve: true,
      );

      final verifiedUser = repo.allUsers.firstWhere(
        (u) => u.uid == pendingApplicant.uid,
      );
      expect(verifiedUser.status, UserStatus.active);
    });

    testWidgets('App renders LoginScreen with Cooperative branding and controls',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: CooperativeServicesApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify app title and welcome back text
      expect(find.text('Cooperative Services'), findsWidgets);
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });
  });
}
