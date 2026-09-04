import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/worker_model.dart';
import '../models/customer_model.dart';
import '../models/booking_model.dart';
import '../models/cooperative_model.dart';
import '../models/service_model.dart';
import '../models/review_model.dart';
import 'mock_database.dart';

class PlatformRepository with ChangeNotifier {
  final List<AppUser> _users = List.from(MockDatabase.users);
  final List<CustomerProfile> _customers = List.from(MockDatabase.customers);
  final List<WorkerProfile> _workers = List.from(MockDatabase.workers);
  final List<Cooperative> _cooperatives = List.from(MockDatabase.cooperatives);
  final List<ServiceItem> _services = List.from(MockDatabase.services);
  final List<Booking> _bookings = List.from(MockDatabase.bookings);
  final List<CustomWorkRequest> _customRequests =
      List.from(MockDatabase.customRequests);
  final List<Review> _reviews = List.from(MockDatabase.reviews);
  final List<DisputeItem> _disputes = List.from(MockDatabase.disputes);
  final List<AuditLog> _auditLogs = List.from(MockDatabase.auditLogs);
  final ForecastData _forecast = MockDatabase.aiForecast;

  // Active Session
  bool _isLoggedIn = false;
  AppUser _currentUser = MockDatabase.users[0]; // defaults to Divya (Customer)

  bool get isLoggedIn => _isLoggedIn;
  AppUser get currentUser => _currentUser;
  List<AppUser> get allUsers => List.unmodifiable(_users);
  List<CustomerProfile> get allCustomers => List.unmodifiable(_customers);
  List<WorkerProfile> get allWorkers => List.unmodifiable(_workers);
  List<Cooperative> get allCooperatives => List.unmodifiable(_cooperatives);
  List<ServiceItem> get allServices => List.unmodifiable(_services);
  List<Booking> get allBookings => List.unmodifiable(_bookings);
  List<CustomWorkRequest> get allCustomRequests =>
      List.unmodifiable(_customRequests);
  List<Review> get allReviews => List.unmodifiable(_reviews);
  List<DisputeItem> get allDisputes => List.unmodifiable(_disputes);
  List<AuditLog> get allAuditLogs => List.unmodifiable(_auditLogs);
  ForecastData get forecast => _forecast;

  CustomerProfile get currentCustomerProfile {
    return _customers.firstWhere(
      (c) => c.uid == _currentUser.uid,
      orElse: () => _customers.first,
    );
  }

  final Map<String, String> _userPasswords = {
    'divya@customer.coop': 'password123',
    'ravi@worker.coop': 'password123',
    'priya@worker.coop': 'password123',
    'karthik@worker.coop': 'password123',
    'admin@coop.org': 'password123',
    'superadmin@coop.org': 'password123',
  };

  void storeUserPassword(String email, String password) {
    _userPasswords[email.trim().toLowerCase()] = password.trim();
  }

  // Strict Login handler with credential verification
  AppUser login({required String emailOrPhone, String? password}) {
    final input = emailOrPhone.trim().toLowerCase();
    if (input.isEmpty) {
      throw 'Please enter your registered email address or mobile number.';
    }
    if (password == null || password.trim().isEmpty) {
      throw 'Please enter your account password.';
    }

    // Find registered user by exact email or phone number
    final cleanPhone = input.replaceAll(RegExp(r'\s+'), '');
    final matchedIndex = _users.indexWhere(
      (u) =>
          u.email.toLowerCase() == input ||
          u.phone.replaceAll(RegExp(r'\s+'), '') == cleanPhone ||
          u.phone.replaceAll(RegExp(r'[\s\+]'), '') == cleanPhone.replaceAll('+', ''),
    );

    if (matchedIndex < 0) {
      throw 'No account registered with "$emailOrPhone". Please verify your credentials or Create an Account.';
    }

    final matched = _users[matchedIndex];

    // Verify Password against stored credential
    final storedPass = _userPasswords[matched.email.toLowerCase()];
    if (storedPass != null && storedPass != password.trim()) {
      throw 'Incorrect password for ${matched.email}. Please try again.';
    }

    _currentUser = matched;
    _isLoggedIn = true;
    notifyListeners();
    return matched;
  }

  // Logout handler
  void logout() {
    _isLoggedIn = false;
    _currentUser = _users[0];
    notifyListeners();
  }

  // Switch Active User / Role (for testing & login)
  void switchUser(String uid) {
    final found = _users.firstWhere(
      (u) => u.uid == uid,
      orElse: () => _currentUser,
    );
    _currentUser = found;
    _isLoggedIn = true;
    notifyListeners();
  }

  void setCurrentUser(AppUser user) {
    _currentUser = user;
    _isLoggedIn = true;
    final index = _users.indexWhere((u) => u.uid == user.uid);
    if (index >= 0) {
      _users[index] = user;
    } else {
      _users.add(user);
    }
    notifyListeners();
  }

  // Sign In With Google Simulation
  AppUser signInWithGoogle({UserRole defaultRole = UserRole.customer}) {
    final googleEmail = 'divya.google@gmail.com';
    final existingIndex = _users.indexWhere(
      (u) => u.email.toLowerCase() == googleEmail,
    );

    AppUser user;
    if (existingIndex >= 0) {
      user = _users[existingIndex];
    } else {
      user = AppUser(
        uid: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
        role: defaultRole,
        status: UserStatus.active,
        name: 'Divya Dharshini',
        email: googleEmail,
        phone: '+91 98401 54321',
        photoUrl:
            'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
        createdAt: DateTime.now(),
      );
      _users.add(user);
      _customers.add(CustomerProfile(
        uid: user.uid,
        name: user.name,
        email: user.email,
        phone: user.phone,
      ));
    }

    _currentUser = user;
    _isLoggedIn = true;
    notifyListeners();
    return user;
  }

  // Unified Registration for all 4 Roles
  AppUser registerUnifiedUser({
    required String name,
    required String email,
    required String phone,
    required UserRole role,
    required String password,
    String? addressOrRegion,
    String? primaryCategory,
    List<String>? skills,
    int? experienceYears,
    String? cooperativeId,
    String? cooperativeName,
    String? registrationNumber,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    String assignedUid;

    // Securely register credentials
    _userPasswords[email.trim().toLowerCase()] = password.trim();

    switch (role) {
      case UserRole.customer:
        assignedUid = 'cust_$timestamp';
        final newUser = AppUser(
          uid: assignedUid,
          role: UserRole.customer,
          status: UserStatus.active,
          name: name,
          email: email,
          phone: phone,
          createdAt: DateTime.now(),
        );
        _users.add(newUser);
        _customers.add(CustomerProfile(
          uid: assignedUid,
          name: name,
          email: email,
          phone: phone,
          savedAddresses: addressOrRegion != null && addressOrRegion.isNotEmpty
              ? [
                  SavedAddress(
                    id: 'addr_1',
                    label: 'Primary Address',
                    address: addressOrRegion,
                    lat: 13.0827,
                    lng: 80.2707,
                    isDefault: true,
                  ),
                ]
              : const [],
        ));
        _currentUser = newUser;
        _isLoggedIn = true;
        _logAudit('USER_REGISTRATION_CUSTOMER', assignedUid, 'AppUser',
            'Customer: $name');
        notifyListeners();
        return newUser;

      case UserRole.worker:
        assignedUid = 'worker_$timestamp';
        final coop = _cooperatives.firstWhere(
          (c) => c.id == cooperativeId,
          orElse: () => _cooperatives.first,
        );
        final newUser = AppUser(
          uid: assignedUid,
          role: UserRole.worker,
          status: UserStatus.active,
          name: name,
          email: email,
          phone: phone,
          cooperativeId: coop.id,
          cooperativeName: coop.name,
          createdAt: DateTime.now(),
        );
        _users.add(newUser);
        _workers.add(WorkerProfile(
          uid: assignedUid,
          name: name,
          photoUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
          cooperativeId: coop.id,
          cooperativeName: coop.name,
          primaryCategory: primaryCategory ?? 'Electrician',
          skills: skills ??
              [primaryCategory ?? 'Electrician', 'General Maintenance'],
          experienceYears: experienceYears ?? 3,
          online: true,
          hourlyRate: 350.0,
          serviceAreas: [addressOrRegion ?? 'Anna Nagar', 'Chennai'],
          distanceDisplay: '1.5 km away',
          availabilityDisplay: 'Available now',
        ));
        _currentUser = newUser;
        _isLoggedIn = true;
        _logAudit('USER_REGISTRATION_WORKER', assignedUid, 'WorkerProfile',
            'Worker: $name, Cat: $primaryCategory');
        notifyListeners();
        return newUser;

      case UserRole.cooperativeAdmin:
        assignedUid = 'admin_$timestamp';
        final newCoopId = 'coop_$timestamp';
        final coopName = cooperativeName ?? '$name Co-op Society';
        final newAdmin = AppUser(
          uid: assignedUid,
          role: UserRole.cooperativeAdmin,
          status: UserStatus.active,
          name: name,
          email: email,
          phone: phone,
          cooperativeId: newCoopId,
          cooperativeName: coopName,
          createdAt: DateTime.now(),
        );
        _users.add(newAdmin);
        _cooperatives.add(Cooperative(
          id: newCoopId,
          name: coopName,
          region: addressOrRegion ?? 'Chennai District',
          registrationNumber: registrationNumber ?? 'COOP-TN-REG-$timestamp',
          status: 'active',
          verificationStatus: 'verified',
          adminIds: [assignedUid],
          adminNames: [name],
          workerCount: 1,
          activeWorkerCount: 1,
          availableTodayCount: 1,
          serviceAreaRadiusKm: 15.0,
          completedJobsCount: 0,
          rating: 5.0,
          revenueThisMonth: 0.0,
          serviceCategories: [primaryCategory ?? 'Electrician', 'Plumber'],
          createdAt: DateTime.now(),
        ));
        _currentUser = newAdmin;
        _isLoggedIn = true;
        _logAudit('USER_REGISTRATION_COOP_ADMIN', assignedUid, 'Cooperative',
            'Coop: $coopName');
        notifyListeners();
        return newAdmin;

      case UserRole.superAdmin:
        assignedUid = 'superadmin_$timestamp';
        final newSuper = AppUser(
          uid: assignedUid,
          role: UserRole.superAdmin,
          status: UserStatus.active,
          name: name,
          email: email,
          phone: phone,
          createdAt: DateTime.now(),
        );
        _users.add(newSuper);
        _currentUser = newSuper;
        _isLoggedIn = true;
        _logAudit('USER_REGISTRATION_SUPER_ADMIN', assignedUid, 'AppUser',
            'Super Admin: $name');
        notifyListeners();
        return newSuper;
    }
  }

  void _logAudit(
      String action, String targetId, String targetType, String after) {
    _auditLogs.insert(
      0,
      AuditLog(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        actorId: _currentUser.uid,
        actorName: _currentUser.name,
        actorRole: _currentUser.role.toDbString(),
        action: action,
        targetId: targetId,
        targetType: targetType,
        before: 'null',
        after: after,
        timestamp: DateTime.now(),
      ),
    );
  }

  // Register New Customer
  AppUser registerCustomer({
    required String name,
    required String email,
    required String phone,
  }) {
    final newUser = AppUser(
      uid: 'cust_${DateTime.now().millisecondsSinceEpoch}',
      role: UserRole.customer,
      status: UserStatus.active,
      name: name,
      email: email,
      phone: phone,
      createdAt: DateTime.now(),
    );
    _users.add(newUser);
    _customers.add(CustomerProfile(
      uid: newUser.uid,
      name: name,
      email: email,
      phone: phone,
    ));
    _currentUser = newUser;
    notifyListeners();
    return newUser;
  }

  // Register New Worker (Status = pending)
  AppUser registerWorker({
    required String name,
    required String email,
    required String phone,
    required String cooperativeId,
    required String primaryCategory,
    required List<String> skills,
    required int experienceYears,
  }) {
    final coop = _cooperatives.firstWhere(
      (c) => c.id == cooperativeId,
      orElse: () => _cooperatives.first,
    );

    final newUser = AppUser(
      uid: 'worker_${DateTime.now().millisecondsSinceEpoch}',
      role: UserRole.worker,
      status: UserStatus.pending,
      name: name,
      email: email,
      phone: phone,
      cooperativeId: cooperativeId,
      cooperativeName: coop.name,
      createdAt: DateTime.now(),
    );
    _users.add(newUser);

    final newWorker = WorkerProfile(
      uid: newUser.uid,
      name: name,
      photoUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      cooperativeId: cooperativeId,
      cooperativeName: coop.name,
      primaryCategory: primaryCategory,
      skills: skills,
      experienceYears: experienceYears,
      online: false,
      certifications: [
        WorkerCertification(
          id: 'cert_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Trade Certification & Identity Proof',
          fileUrl: 'https://docs.coop/certs/app_doc.pdf',
          verified: false,
        ),
      ],
      distanceDisplay: '2.5 km away',
      availabilityDisplay: 'Pending Verification',
    );
    _workers.add(newWorker);
    _currentUser = newUser;
    notifyListeners();
    return newUser;
  }

  // Register New Cooperative Society
  Cooperative registerCooperativeSociety({
    required String name,
    required String region,
    required String registrationNumber,
    required String coordinatorName,
    required String coordinatorEmail,
    required String coordinatorPhone,
    required List<String> serviceCategories,
  }) {
    final newCoopId = 'coop_${DateTime.now().millisecondsSinceEpoch}';
    final adminId = 'admin_${DateTime.now().millisecondsSinceEpoch}';

    final newAdmin = AppUser(
      uid: adminId,
      role: UserRole.cooperativeAdmin,
      status: UserStatus.active,
      name: coordinatorName,
      email: coordinatorEmail,
      phone: coordinatorPhone,
      cooperativeId: newCoopId,
      cooperativeName: name,
      createdAt: DateTime.now(),
    );
    _users.add(newAdmin);

    final newCoop = Cooperative(
      id: newCoopId,
      name: name,
      region: region,
      registrationNumber: registrationNumber,
      status: 'active',
      verificationStatus: 'verified',
      adminIds: [adminId],
      adminNames: [coordinatorName],
      workerCount: 1,
      activeWorkerCount: 1,
      availableTodayCount: 1,
      serviceAreaRadiusKm: 15.0,
      completedJobsCount: 0,
      rating: 5.0,
      revenueThisMonth: 0.0,
      serviceCategories: serviceCategories,
      createdAt: DateTime.now(),
    );
    _cooperatives.add(newCoop);

    _auditLogs.insert(
      0,
      AuditLog(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        actorId: adminId,
        actorName: coordinatorName,
        actorRole: 'cooperative_admin',
        action: 'REGISTER_COOPERATIVE_SOCIETY',
        targetId: newCoopId,
        targetType: 'Cooperative',
        before: 'null',
        after: 'name: $name, reg: $registrationNumber',
        timestamp: DateTime.now(),
      ),
    );

    _currentUser = newAdmin;
    notifyListeners();
    return newCoop;
  }

  // Customer Toggle Saved Cooperative
  void toggleSaveCooperative(String coopId) {
    final cIndex = _customers.indexWhere((c) => c.uid == _currentUser.uid);
    if (cIndex >= 0) {
      final saved = List<String>.from(_customers[cIndex].savedCooperativeIds);
      if (saved.contains(coopId)) {
        saved.remove(coopId);
      } else {
        saved.add(coopId);
      }
      _customers[cIndex] =
          _customers[cIndex].copyWith(savedCooperativeIds: saved);
      notifyListeners();
    }
  }

  // Worker Actions
  void toggleWorkerOnline(String workerUid, bool isOnline) {
    final index = _workers.indexWhere((w) => w.uid == workerUid);
    if (index >= 0) {
      _workers[index] = _workers[index].copyWith(online: isOnline);
      notifyListeners();
    }
  }

  void updateWorkerSchedule(
      String workerUid, List<DayScheduleSlot> newSchedule) {
    final index = _workers.indexWhere((w) => w.uid == workerUid);
    if (index >= 0) {
      _workers[index] = _workers[index].copyWith(weeklySchedule: newSchedule);
      notifyListeners();
    }
  }

  void submitWorkerLeave({
    required String workerUid,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) {
    final index = _workers.indexWhere((w) => w.uid == workerUid);
    if (index >= 0) {
      final leaves =
          List<WorkerLeaveRequest>.from(_workers[index].leaveRequests)
            ..add(WorkerLeaveRequest(
              id: 'leave_${DateTime.now().millisecondsSinceEpoch}',
              startDate: startDate,
              endDate: endDate,
              reason: reason,
              status: 'approved',
            ));
      _workers[index] = _workers[index].copyWith(leaveRequests: leaves);
      notifyListeners();
    }
  }

  void updateWorkerSkills(String workerUid, List<String> skills) {
    final index = _workers.indexWhere((w) => w.uid == workerUid);
    if (index >= 0) {
      _workers[index] = _workers[index].copyWith(skills: skills);
      notifyListeners();
    }
  }

  void updateWorkerServiceAreas(String workerUid, List<String> areas) {
    final index = _workers.indexWhere((w) => w.uid == workerUid);
    if (index >= 0) {
      _workers[index] = _workers[index].copyWith(serviceAreas: areas);
      notifyListeners();
    }
  }

  void updateWorkerProfileDetails(
    String workerUid, {
    String? name,
    double? hourlyRate,
    int? experienceYears,
    String? primaryCategory,
    String? bio,
  }) {
    final index = _workers.indexWhere((w) => w.uid == workerUid);
    if (index >= 0) {
      _workers[index] = _workers[index].copyWith(
        name: name ?? _workers[index].name,
        hourlyRate: hourlyRate ?? _workers[index].hourlyRate,
        experienceYears: experienceYears ?? _workers[index].experienceYears,
        primaryCategory: primaryCategory ?? _workers[index].primaryCategory,
        bio: bio ?? _workers[index].bio,
      );
      final uIdx = _users.indexWhere((u) => u.uid == workerUid);
      if (uIdx >= 0 && name != null) {
        _users[uIdx] = _users[uIdx].copyWith(name: name);
        if (_currentUser.uid == workerUid) {
          _currentUser = _users[uIdx];
        }
      }
      notifyListeners();
    }
  }

  void addWorkerCertification(String workerUid, String certName) {
    final index = _workers.indexWhere((w) => w.uid == workerUid);
    if (index >= 0) {
      final certs = List<WorkerCertification>.from(_workers[index].certifications)
        ..add(WorkerCertification(
          id: 'cert_${DateTime.now().millisecondsSinceEpoch}',
          name: certName,
          fileUrl: 'https://docs.coop/certs/verified.pdf',
          verified: true,
          expiry: DateTime.now().add(const Duration(days: 730)),
        ));
      _workers[index] = _workers[index].copyWith(certifications: certs);
      notifyListeners();
    }
  }

  void uploadWorkProof(String bookingId, String photoUrl) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index >= 0) {
      final photos = List<String>.from(_bookings[index].workProofPhotos)
        ..add(photoUrl);
      _bookings[index] = _bookings[index].copyWith(workProofPhotos: photos);
      notifyListeners();
    }
  }

  // Bookings State Machine
  Booking updateBookingStatus(String bookingId, BookingStatus newStatus) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index >= 0) {
      final updated = _bookings[index].copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
        paymentStatus: newStatus == BookingStatus.completed
            ? 'paid'
            : _bookings[index].paymentStatus,
      );
      _bookings[index] = updated;

      // Log action
      _auditLogs.insert(
        0,
        AuditLog(
          id: 'log_${DateTime.now().millisecondsSinceEpoch}',
          actorId: _currentUser.uid,
          actorName: _currentUser.name,
          actorRole: _currentUser.role.toDbString(),
          action: 'UPDATE_BOOKING_STATUS_${newStatus.name.toUpperCase()}',
          targetId: bookingId,
          targetType: 'Booking',
          before: 'status: ${_bookings[index].status.name}',
          after: 'status: ${newStatus.name}',
          timestamp: DateTime.now(),
        ),
      );

      notifyListeners();
      return updated;
    }
    throw Exception('Booking not found');
  }

  // Customer creates an individual worker booking
  Booking createBooking({
    required WorkerProfile worker,
    required String serviceSubtype,
    required DateTime scheduledAt,
    required BookingLocation location,
    required String instructions,
    required double price,
    bool isEmergency = false,
  }) {
    final newBooking = Booking(
      id: 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      customerId: _currentUser.uid,
      customerName: _currentUser.name,
      customerPhone: _currentUser.phone,
      workerId: worker.uid,
      workerName: worker.name,
      workerPhotoUrl: worker.photoUrl,
      cooperativeId: worker.cooperativeId,
      cooperativeName: worker.cooperativeName,
      serviceCategory: worker.primaryCategory,
      serviceSubtype: serviceSubtype,
      status: BookingStatus.requested,
      scheduledAt: scheduledAt,
      location: location,
      instructions: instructions,
      estimatedPrice: price,
      finalPrice: price,
      pricing: FairSplitPricing.calculate(price),
      isEmergency: isEmergency,
      isTeamBooking: false,
      teamSize: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _bookings.insert(0, newBooking);
    notifyListeners();
    return newBooking;
  }

  // Customer creates a Cooperative Team Booking
  Booking createCooperativeTeamBooking({
    required Cooperative cooperative,
    required String serviceCategory,
    required String serviceSubtype,
    required int teamSize,
    required DateTime scheduledAt,
    required BookingLocation location,
    required String instructions,
    required double price,
  }) {
    final newBooking = Booking(
      id: 'BK-TEAM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      customerId: _currentUser.uid,
      customerName: _currentUser.name,
      customerPhone: _currentUser.phone,
      workerId: cooperative.id,
      workerName: '${cooperative.name} (Team of $teamSize)',
      workerPhotoUrl: cooperative.coverUrl,
      cooperativeId: cooperative.id,
      cooperativeName: cooperative.name,
      serviceCategory: serviceCategory,
      serviceSubtype: serviceSubtype,
      status: BookingStatus.accepted,
      scheduledAt: scheduledAt,
      location: location,
      instructions: instructions,
      estimatedPrice: price,
      finalPrice: price,
      pricing: FairSplitPricing.calculate(price),
      isTeamBooking: true,
      teamSize: teamSize,
      assignedWorkers: [
        AssignedTeamWorker(
          workerId: 'worker_ravi',
          workerName: 'Ravi Kumar',
          role: 'Lead Master Technician',
          photoUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
          phone: '+91 98840 11223',
        ),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _bookings.insert(0, newBooking);
    notifyListeners();
    return newBooking;
  }

  // Submit Custom Work Request
  CustomWorkRequest submitCustomWorkRequest({
    required String title,
    required String description,
    required String serviceCategory,
    required String address,
    double? budget,
    required DateTime preferredDate,
    List<String> photos = const [],
  }) {
    final req = CustomWorkRequest(
      id: 'CWR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      customerId: _currentUser.uid,
      title: title,
      description: description,
      serviceCategory: serviceCategory,
      address: address,
      budget: budget,
      preferredDate: preferredDate,
      photoUrls: photos,
      createdAt: DateTime.now(),
    );
    _customRequests.insert(0, req);
    notifyListeners();
    return req;
  }

  // Submit Multi-dimensional Rating & Review
  void submitReview({
    required String bookingId,
    required String workerId,
    String? cooperativeId,
    required double rating,
    double professionalism = 5.0,
    double serviceQuality = 5.0,
    double coordination = 5.0,
    required String comment,
    required List<String> tags,
  }) {
    final newReview = Review(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      bookingId: bookingId,
      customerId: _currentUser.uid,
      customerName: _currentUser.name,
      workerId: workerId,
      cooperativeId: cooperativeId,
      rating: rating,
      professionalism: professionalism,
      serviceQuality: serviceQuality,
      coordination: coordination,
      comment: comment,
      tags: tags,
      createdAt: DateTime.now(),
    );
    _reviews.insert(0, newReview);

    // Update booking rating
    final bIndex = _bookings.indexWhere((b) => b.id == bookingId);
    if (bIndex >= 0) {
      _bookings[bIndex] = _bookings[bIndex].copyWith(
        ratingGiven: rating.toInt(),
        professionalismRating: professionalism,
        qualityRating: serviceQuality,
        coordinationRating: coordination,
        reviewComment: comment,
      );
    }
    notifyListeners();
  }

  // Cooperative Admin: Assign Workers to Team Booking
  void assignWorkersToBooking(
      String bookingId, List<AssignedTeamWorker> assigned) {
    final bIndex = _bookings.indexWhere((b) => b.id == bookingId);
    if (bIndex >= 0) {
      _bookings[bIndex] =
          _bookings[bIndex].copyWith(assignedWorkers: assigned);
      notifyListeners();
    }
  }

  // Cooperative Admin: Update Cooperative Profile
  void updateCooperativeProfile(Cooperative updatedCoop) {
    final cIndex = _cooperatives.indexWhere((c) => c.id == updatedCoop.id);
    if (cIndex >= 0) {
      _cooperatives[cIndex] = updatedCoop;
      notifyListeners();
    }
  }

  // Cooperative Admin Actions: Verify Worker
  void verifyWorkerApplication({
    required String workerUid,
    required bool approve,
    String? rejectionReason,
  }) {
    final userIndex = _users.indexWhere((u) => u.uid == workerUid);
    final workerIndex = _workers.indexWhere((w) => w.uid == workerUid);

    if (userIndex >= 0) {
      _users[userIndex] = _users[userIndex].copyWith(
        status: approve ? UserStatus.active : UserStatus.rejected,
      );
    }

    if (workerIndex >= 0 && approve) {
      final updatedCerts = _workers[workerIndex]
          .certifications
          .map((c) => WorkerCertification(
                id: c.id,
                name: c.name,
                fileUrl: c.fileUrl,
                verified: true,
                expiry:
                    c.expiry ?? DateTime.now().add(const Duration(days: 365)),
              ))
          .toList();

      _workers[workerIndex] = _workers[workerIndex].copyWith(
        online: true,
        certifications: updatedCerts,
        badges: [
          'Identity Verified',
          'Skill Verified',
          'Co-op Member',
          'Certified'
        ],
        availabilityDisplay: 'Available Now',
      );
    }

    // Audit Log
    _auditLogs.insert(
      0,
      AuditLog(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        actorId: _currentUser.uid,
        actorName: _currentUser.name,
        actorRole: _currentUser.role.toDbString(),
        action: approve
            ? 'APPROVE_WORKER_VERIFICATION'
            : 'REJECT_WORKER_VERIFICATION',
        targetId: workerUid,
        targetType: 'WorkerProfile',
        before: 'status: pending',
        after: approve
            ? 'status: active'
            : 'status: rejected (Reason: $rejectionReason)',
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  // Super Admin: Resolve Dispute
  void resolveDispute(String disputeId, String resolutionNotes) {
    final dIndex = _disputes.indexWhere((d) => d.id == disputeId);
    if (dIndex >= 0) {
      _disputes[dIndex] = _disputes[dIndex].copyWith(
        status: 'resolved',
        resolutionNotes: resolutionNotes,
      );
      notifyListeners();
    }
  }

  // Super Admin: Add/Update Service
  void saveServiceItem(ServiceItem service) {
    final sIndex = _services.indexWhere((s) => s.id == service.id);
    if (sIndex >= 0) {
      _services[sIndex] = service;
    } else {
      _services.add(service);
    }
    notifyListeners();
  }

  // Super Admin: Create Cooperative
  Cooperative createCooperative({
    required String name,
    required String region,
    required String regNumber,
  }) {
    final newCoop = Cooperative(
      id: 'coop_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      region: region,
      registrationNumber: regNumber,
      status: 'active',
      adminIds: [],
      adminNames: [],
      workerCount: 0,
      activeWorkerCount: 0,
      availableTodayCount: 0,
      completedJobsCount: 0,
      rating: 5.0,
      revenueThisMonth: 0,
      createdAt: DateTime.now(),
    );
    _cooperatives.add(newCoop);

    _auditLogs.insert(
      0,
      AuditLog(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        actorId: _currentUser.uid,
        actorName: _currentUser.name,
        actorRole: _currentUser.role.toDbString(),
        action: 'CREATE_COOPERATIVE',
        targetId: newCoop.id,
        targetType: 'Cooperative',
        before: 'null',
        after: 'name: $name, reg: $regNumber',
        timestamp: DateTime.now(),
      ),
    );

    notifyListeners();
    return newCoop;
  }

  // Super Admin: Create Admin
  AppUser createCoopAdmin({
    required String name,
    required String email,
    required String phone,
    required String cooperativeId,
  }) {
    final coop = _cooperatives.firstWhere(
      (c) => c.id == cooperativeId,
      orElse: () => _cooperatives.first,
    );

    final newAdmin = AppUser(
      uid: 'admin_${DateTime.now().millisecondsSinceEpoch}',
      role: UserRole.cooperativeAdmin,
      status: UserStatus.active,
      name: name,
      email: email,
      phone: phone,
      cooperativeId: cooperativeId,
      cooperativeName: coop.name,
      createdAt: DateTime.now(),
    );
    _users.add(newAdmin);

    final cIndex = _cooperatives.indexWhere((c) => c.id == cooperativeId);
    if (cIndex >= 0) {
      final updatedAdminIds = List<String>.from(_cooperatives[cIndex].adminIds)
        ..add(newAdmin.uid);
      final updatedAdminNames =
          List<String>.from(_cooperatives[cIndex].adminNames)..add(name);
      _cooperatives[cIndex] = _cooperatives[cIndex].copyWith(
        adminIds: updatedAdminIds,
        adminNames: updatedAdminNames,
      );
    }

    _auditLogs.insert(
      0,
      AuditLog(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        actorId: _currentUser.uid,
        actorName: _currentUser.name,
        actorRole: _currentUser.role.toDbString(),
        action: 'CREATE_COOPERATIVE_ADMIN',
        targetId: newAdmin.uid,
        targetType: 'AppUser',
        before: 'null',
        after: 'role: cooperative_admin, coop: ${coop.name}',
        timestamp: DateTime.now(),
      ),
    );

    notifyListeners();
    return newAdmin;
  }

  void _updateCurrentCustomer(CustomerProfile Function(CustomerProfile) updater) {
    final idx = _customers.indexWhere((c) => c.uid == _currentUser.uid);
    if (idx >= 0) {
      _customers[idx] = updater(_customers[idx]);
    } else if (_customers.isNotEmpty) {
      _customers[0] = updater(_customers[0]);
    }
    notifyListeners();
  }

  // Customer: Pin / Unpin "My Regulars" Worker
  void pinRegularWorker(String category, String workerUid) {
    _updateCurrentCustomer((prof) {
      final updatedRegulars = Map<String, String>.from(prof.myRegularWorkerIds);
      updatedRegulars[category] = workerUid;
      return prof.copyWith(myRegularWorkerIds: updatedRegulars);
    });
  }

  void unpinRegularWorker(String category) {
    _updateCurrentCustomer((prof) {
      final updatedRegulars = Map<String, String>.from(prof.myRegularWorkerIds);
      updatedRegulars.remove(category);
      return prof.copyWith(myRegularWorkerIds: updatedRegulars);
    });
  }

  // Customer: Raise Zero-Fee Re-Visit Guarantee Request
  void raiseRevisitRequest({
    required String bookingId,
    required String issueDescription,
    List<String> photos = const [],
  }) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index >= 0) {
      final b = _bookings[index];
      final newRevisit = RevisitRequest(
        id: 'REV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        bookingId: bookingId,
        issueDescription: issueDescription,
        photoUrls: photos,
        status: 'submitted',
        requestedAt: DateTime.now(),
      );

      final currentJobCard = b.jobCard ??
          DigitalJobCard(
            jobCardId: 'JC-$bookingId',
            warrantyExpiryDate: DateTime.now().add(const Duration(days: 90)),
          );

      final updatedJobCard = currentJobCard.copyWith(
        revisitRequests: List<RevisitRequest>.from(currentJobCard.revisitRequests)
          ..add(newRevisit),
      );

      _bookings[index] = b.copyWith(jobCard: updatedJobCard);

      _auditLogs.insert(
        0,
        AuditLog(
          id: 'log_${DateTime.now().millisecondsSinceEpoch}',
          actorId: _currentUser.uid,
          actorName: _currentUser.name,
          actorRole: _currentUser.role.toDbString(),
          action: 'WARRANTY_REVISIT_REQUESTED',
          targetId: bookingId,
          targetType: 'Booking',
          before: 'status: ${b.status.name}',
          after: 'revisit_id: ${newRevisit.id}',
          timestamp: DateTime.now(),
        ),
      );

      notifyListeners();
    }
  }

  // Customer: Create Group / Society Booking Split
  Booking createGroupSocietyBooking({
    required Cooperative cooperative,
    required String serviceCategory,
    required String serviceSubtype,
    required String societyName,
    required int totalParticipants,
    required DateTime scheduledAt,
    required BookingLocation location,
    required String instructions,
    required double price,
  }) {
    final groupCode =
        'GRP-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final splitAmt = (price / totalParticipants).roundToDouble();

    final newBooking = Booking(
      id: 'BK-GRP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      customerId: _currentUser.uid,
      customerName: _currentUser.name,
      customerPhone: _currentUser.phone,
      workerId: cooperative.id,
      workerName: '${cooperative.name} (Society Team)',
      workerPhotoUrl: cooperative.coverUrl,
      cooperativeId: cooperative.id,
      cooperativeName: cooperative.name,
      serviceCategory: serviceCategory,
      serviceSubtype: serviceSubtype,
      status: BookingStatus.accepted,
      scheduledAt: scheduledAt,
      location: location,
      instructions: instructions,
      estimatedPrice: price,
      finalPrice: price,
      pricing: FairSplitPricing.calculate(price),
      isTeamBooking: true,
      teamSize: 2,
      assignedWorkers: [
        AssignedTeamWorker(
          workerId: 'worker_ravi',
          workerName: 'Ravi Kumar',
          role: 'Lead Master Technician',
          photoUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
          phone: '+91 98840 11223',
        ),
      ],
      groupSplit: GroupBookingSplit(
        groupCode: groupCode,
        societyName: societyName,
        totalParticipants: totalParticipants,
        splitAmountPerMember: splitAmt,
        paidMemberNames: ['${_currentUser.name} (Organizer)'],
        shareLink: 'coop.app/split/$groupCode',
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _bookings.insert(0, newBooking);
    notifyListeners();
    return newBooking;
  }

  // Customer: Send Pre-Booking Coordinator Inquiry
  void sendPreBookingInquiry({
    required String cooperativeId,
    required String cooperativeName,
    required String serviceCategory,
    required String question,
  }) {
    final newInquiry = PreBookingInquiry(
      id: 'inq_${DateTime.now().millisecondsSinceEpoch}',
      customerId: _currentUser.uid,
      cooperativeId: cooperativeId,
      cooperativeName: cooperativeName,
      serviceCategory: serviceCategory,
      question: question,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    _updateCurrentCustomer((prof) {
      final updated = List<PreBookingInquiry>.from(prof.inquiries)
        ..insert(0, newInquiry);
      return prof.copyWith(inquiries: updated);
    });
  }

  // Cooperative Admin: Reply to Pre-Booking Inquiry
  void replyToInquiry({
    required String inquiryId,
    required String reply,
  }) {
    _updateCurrentCustomer((prof) {
      final inquiries = List<PreBookingInquiry>.from(prof.inquiries);
      final idx = inquiries.indexWhere((i) => i.id == inquiryId);
      if (idx >= 0) {
        inquiries[idx] = PreBookingInquiry(
          id: inquiries[idx].id,
          customerId: inquiries[idx].customerId,
          cooperativeId: inquiries[idx].cooperativeId,
          cooperativeName: inquiries[idx].cooperativeName,
          serviceCategory: inquiries[idx].serviceCategory,
          question: inquiries[idx].question,
          coordinatorReply: reply,
          status: 'replied',
          createdAt: inquiries[idx].createdAt,
          repliedAt: DateTime.now(),
        );
      }
      return prof.copyWith(inquiries: inquiries);
    });
  }

  // Customer: Recurring Care Plan Subscriptions
  void subscribeCarePlan(RecurringCarePlan plan) {
    _updateCurrentCustomer((prof) {
      final updated = List<RecurringCarePlan>.from(prof.recurringPlans)
        ..add(plan);
      return prof.copyWith(recurringPlans: updated);
    });
  }

  void toggleCarePlan(String planId) {
    _updateCurrentCustomer((prof) {
      final plans = List<RecurringCarePlan>.from(prof.recurringPlans);
      final idx = plans.indexWhere((p) => p.id == planId);
      if (idx >= 0) {
        plans[idx] = plans[idx].copyWith(isActive: !plans[idx].isActive);
      }
      return prof.copyWith(recurringPlans: plans);
    });
  }

  void skipNextCareCycle(String planId) {
    _updateCurrentCustomer((prof) {
      final plans = List<RecurringCarePlan>.from(prof.recurringPlans);
      final idx = plans.indexWhere((p) => p.id == planId);
      if (idx >= 0) {
        final currentNext = plans[idx].nextScheduledDate;
        final newNext = plans[idx].frequency == 'Monthly'
            ? currentNext.add(const Duration(days: 30))
            : (plans[idx].frequency == 'Quarterly'
                ? currentNext.add(const Duration(days: 90))
                : currentNext.add(const Duration(days: 180)));
        plans[idx] = plans[idx].copyWith(nextScheduledDate: newNext);
      }
      return prof.copyWith(recurringPlans: plans);
    });
  }
}

// Global Repository Provider
final platformRepositoryProvider =
    ChangeNotifierProvider<PlatformRepository>((ref) {
  return PlatformRepository();
});
