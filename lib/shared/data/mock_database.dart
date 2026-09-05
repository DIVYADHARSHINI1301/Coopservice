import '../models/booking_model.dart';
import '../models/cooperative_model.dart';
import '../models/customer_model.dart';
import '../models/review_model.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';
import '../models/worker_model.dart';

class MockDatabase {
  static final List<AppUser> users = [
    // Customer
    AppUser(
      uid: 'cust_divya',
      email: 'divya@customer.coop',
      name: 'Divya Dharshini',
      phone: '+91 98401 54321',
      role: UserRole.customer,
      status: UserStatus.active,
      languages: const ['English', 'Tamil'],
      cooperativeId: 'coop_anna_nagar',
      cooperativeName: 'Anna Nagar Local Cluster',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    // Cooperative Admin
    AppUser(
      uid: 'admin_sundaram',
      email: 'admin@coop.org',
      name: 'M. Sundaram',
      phone: '+91 98410 77665',
      role: UserRole.cooperativeAdmin,
      status: UserStatus.active,
      languages: const ['English', 'Tamil'],
      cooperativeId: 'coop_anna_nagar',
      cooperativeName: 'Anna Nagar Local Cluster',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    // Super Admin / Platform Admin
    AppUser(
      uid: 'superadmin_master',
      email: 'superadmin@coop.org',
      name: 'Platform Super Admin',
      phone: '+91 44 2833 4455',
      role: UserRole.superAdmin,
      status: UserStatus.active,
      languages: const ['English', 'Tamil'],
      cooperativeId: null,
      cooperativeName: 'Tamil Nadu State Federation',
      createdAt: DateTime.now().subtract(const Duration(days: 500)),
    ),
  ];

  static CustomerProfile customerProfile = CustomerProfile(
    uid: 'cust_divya',
    name: 'Divya Dharshini',
    email: 'divya@customer.coop',
    phone: '+91 98401 54321',
    savedAddresses: const [
      SavedAddress(
        id: 'addr_home',
        label: 'Home',
        address: 'Plot 42, 2nd Avenue, Anna Nagar East, Chennai - 600102',
        lat: 13.0850,
        lng: 80.2101,
        isDefault: true,
      ),
      SavedAddress(
        id: 'addr_office',
        label: 'Work / Studio',
        address: '88, Nelson Manickam Road, Aminjikarai, Chennai - 600029',
        lat: 13.0720,
        lng: 80.2180,
        isDefault: false,
      ),
    ],
    savedCooperativeIds: const ['coop_anna_nagar', 'coop_adyar'],
    myRegularWorkerIds: const {},
    recurringPlans: [],
    inquiries: [],
    impactStats: const CustomerImpactStats(
      workersSupported: 0,
      cooperativesEngaged: 0,
      totalJobsCompleted: 0,
      totalWorkerEarningsDirected: 0.0,
      totalCooperativeFundGenerated: 0.0,
    ),
    preferredLanguage: 'English',
    notificationsEnabled: true,
    loyaltyBookingsCount: 0,
  );

  static final List<CustomerProfile> customers = [customerProfile];

  static final List<WorkerProfile> workers = [];

  static final List<Cooperative> cooperatives = [
    Cooperative(
      id: 'coop_anna_nagar',
      name: 'Anna Nagar Electrical & Trades Co-op',
      nameTamil: 'அண்ணா நகர் மின் & தொழில்நுட்ப சங்கம்',
      region: 'Chennai North-West (Zone 5)',
      registrationNumber: 'COOP-TN-CHE-042',
      status: 'active',
      verificationStatus: 'verified',
      description:
          'A democratically owned cluster of 54 certified neighborhood technicians serving Anna Nagar, Kilpauk, Shenoy Nagar, and Mogappair with 100% fair-pay guarantee.',
      address: 'Plot 12, 2nd Avenue, Anna Nagar East, Chennai - 600102',
      phone: '+91 44 2621 8890',
      email: 'annanagar@cooperative.org',
      establishedYear: 2022,
      adminIds: ['admin_sundaram'],
      adminNames: ['M. Sundaram'],
      workerCount: 54,
      activeWorkerCount: 38,
      availableTodayCount: 14,
      serviceAreaRadiusKm: 15.0,
      completedJobsCount: 3420,
      rating: 4.86,
      ratingCount: 428,
      revenueThisMonth: 612000.0,
      serviceCategories: [
        'Electrician',
        'Plumber',
        'AC & Appliance',
        'Carpenter',
        'Painter',
        'Cleaner'
      ],
      skills: [
        'Residential Wiring',
        'Solar Inverter Installation',
        'Pipeline Leak Detection',
        'HVAC Repair',
        'Modular Carpentry',
        '3-Phase Industrial Panels'
      ],
      skillAvailability: const {
        'Electrician': ShiftAvailability(morning: 6, afternoon: 5, evening: 3),
        'Plumber': ShiftAvailability(morning: 4, afternoon: 3, evening: 2),
        'AC & Appliance': ShiftAvailability(morning: 3, afternoon: 3, evening: 1),
        'Carpenter': ShiftAvailability(morning: 2, afternoon: 2, evening: 0),
        'Cleaner': ShiftAvailability(morning: 5, afternoon: 4, evening: 2),
      },
      stories: [
        const CooperativeStory(
          id: 'story_1',
          title: 'Monsoon Flood Relief Wiring Drive',
          description:
              'Over 40 guild electricians inspected and restored grounded electrical sub-panels across 320 homes free of markup during November floods.',
          imageUrl:
              'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600',
          workersImpacted: 42,
          date: 'Nov 2025',
        ),
        const CooperativeStory(
          id: 'story_2',
          title: 'Women in Trades Apprenticeship',
          description:
              'Guild sponsored 12 female technicians through government ITI certifications with tool stipend grants.',
          imageUrl:
              'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=600',
          workersImpacted: 12,
          date: 'March 2026',
        ),
      ],
      financialLedger: const CooperativeFinancialLedger(
        totalBookingVolume: 612000.0,
        workerDirectPayouts: 520200.0, // 85%
        cooperativeWelfareFund: 73440.0, // 12%
        platformSupportFees: 18360.0, // 3%
        reserveFunds: 145000.0,
      ),
      coverUrl:
          'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=800',
      logoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      createdAt: DateTime.now().subtract(const Duration(days: 420)),
    ),
    Cooperative(
      id: 'coop_adyar',
      name: 'Adyar Trades & Homecare Co-op',
      nameTamil: 'அடையார் தொழில்நுட்ப & வீட்டுச்சேவை சங்கம்',
      region: 'Chennai South (Zone 13)',
      registrationNumber: 'COOP-TN-CHE-078',
      status: 'active',
      verificationStatus: 'verified',
      description:
          'South Chennai multi-trade cooperative covering Adyar, Besant Nagar, Thiruvanmiyur, and Velachery. Known for plumbing and deep cleaning excellence.',
      address: '28, LB Road, Adyar, Chennai - 600020',
      phone: '+91 44 2441 5522',
      email: 'adyar@cooperative.org',
      establishedYear: 2021,
      adminIds: ['admin_geetha'],
      adminNames: ['Geetha Swaminathan'],
      workerCount: 42,
      activeWorkerCount: 30,
      availableTodayCount: 11,
      serviceAreaRadiusKm: 14.0,
      completedJobsCount: 2890,
      rating: 4.82,
      ratingCount: 310,
      revenueThisMonth: 540000.0,
      serviceCategories: [
        'Plumber',
        'Cleaner',
        'Electrician',
        'Painter',
        'Appliance Repair'
      ],
      skills: [
        'Acoustic Leak Detection',
        'Sanitary Overhauls',
        'Waterproofing',
        'EV Charger Installation',
        'Deep Home Scrub'
      ],
      skillAvailability: const {
        'Plumber': ShiftAvailability(morning: 4, afternoon: 4, evening: 2),
        'Cleaner': ShiftAvailability(morning: 5, afternoon: 3, evening: 1),
        'Electrician': ShiftAvailability(morning: 3, afternoon: 2, evening: 2),
        'Painter': ShiftAvailability(morning: 2, afternoon: 2, evening: 1),
      },
      stories: [
        const CooperativeStory(
          id: 'story_3',
          title: 'Coastal Water Quality Initiative',
          description:
              'Overhead tank disinfection drive across 120 residential apartments completed by Adyar guild technicians.',
          imageUrl:
              'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=600',
          workersImpacted: 24,
          date: 'June 2026',
        ),
      ],
      financialLedger: const CooperativeFinancialLedger(
        totalBookingVolume: 540000.0,
        workerDirectPayouts: 459000.0,
        cooperativeWelfareFund: 64800.0,
        platformSupportFees: 16200.0,
        reserveFunds: 98000.0,
      ),
      coverUrl:
          'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800',
      logoUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
      createdAt: DateTime.now().subtract(const Duration(days: 310)),
    ),
    Cooperative(
      id: 'coop_coimbatore',
      name: 'Coimbatore West Workers Society',
      nameTamil: 'கோவை மேற்கு தொழிலாளர் சங்கம்',
      region: 'Coimbatore Industrial Belt',
      registrationNumber: 'COOP-TN-CBE-091',
      status: 'active',
      verificationStatus: 'verified',
      description:
          'Industrial and residential multi-trade cooperative based in RS Puram and Gandhipuram. Expert 3-phase technicians and modular carpenters.',
      address: '74, DB Road, RS Puram, Coimbatore - 641002',
      phone: '+91 422 254 3311',
      email: 'coimbatore@cooperative.org',
      establishedYear: 2023,
      adminIds: ['admin_rajan'],
      adminNames: ['Rajan V'],
      workerCount: 38,
      activeWorkerCount: 26,
      availableTodayCount: 8,
      serviceAreaRadiusKm: 20.0,
      completedJobsCount: 1940,
      rating: 4.79,
      ratingCount: 215,
      revenueThisMonth: 410000.0,
      serviceCategories: ['Electrician', 'Carpenter', 'AC & Appliance', 'Driver'],
      skills: ['3-Phase Wiring', 'Modular Carpentry', 'Motor Overhaul'],
      financialLedger: const CooperativeFinancialLedger(
        totalBookingVolume: 410000.0,
        workerDirectPayouts: 348500.0,
        cooperativeWelfareFund: 49200.0,
        platformSupportFees: 12300.0,
        reserveFunds: 72000.0,
      ),
      coverUrl:
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
      logoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
    ),
  ];

  static final List<ServiceItem> services = [
    const ServiceItem(
      id: 'srv_electrician',
      name: 'Electrician',
      nameTamil: 'மின் பணியாளர்',
      iconName: 'bolt',
      description:
          'Wiring, switches, circuit breakers, fans, lights & emergency repair',
      basePrice: 350.0,
      subcategories: [
        'Fan & Light Fitting',
        'Switchboard & Socket Repair',
        'MCB Tripping Diagnostic',
        'Full House Re-wiring',
        'Inverter & UPS Setup',
        'EV Charger Installation'
      ],
      isPopular: true,
      activeWorkerCount: 18,
    ),
    const ServiceItem(
      id: 'srv_plumber',
      name: 'Plumber',
      nameTamil: 'குழாய் பணியாளர்',
      iconName: 'plumbing',
      description:
          'Pipes, taps, motor pumps, blockages, leakages & sanitary fittings',
      basePrice: 380.0,
      subcategories: [
        'Tap & Valve Replacement',
        'Water Motor & Pump Repair',
        'Drainage Clearing',
        'Bathroom Fitting Installation',
        'Overhead Tank Cleaning',
        'Acoustic Leak Detection'
      ],
      isPopular: true,
      activeWorkerCount: 14,
    ),
    const ServiceItem(
      id: 'srv_carpenter',
      name: 'Carpenter',
      nameTamil: 'தச்சர்',
      iconName: 'carpenter',
      description: 'Furniture repair, modular fittings, doors, locks & woodcraft',
      basePrice: 400.0,
      subcategories: [
        'Door Lock & Latch Fixing',
        'Furniture Assembly & Repair',
        'Modular Kitchen Fitting',
        'Custom Shelving & Cupboard',
        'Window Mesh & Frame'
      ],
      isPopular: false,
      activeWorkerCount: 10,
    ),
    const ServiceItem(
      id: 'srv_technician',
      name: 'AC & Appliance',
      nameTamil: 'குளிர்சாதன தொழில்நுட்ப வல்லுநர்',
      iconName: 'hvac',
      description: 'AC gas refill, jet service, washing machine & fridge repair',
      basePrice: 550.0,
      subcategories: [
        'AC Foam Jet Cleaning',
        'Gas Leak & Refill',
        'Washing Machine Repair',
        'Refrigerator Cooling Fix',
        'Microwave & Oven Repair'
      ],
      isPopular: true,
      activeWorkerCount: 15,
    ),
  ];

  static final List<Booking> bookings = [];

  static final List<CustomWorkRequest> customRequests = [];

  static final List<Review> reviews = [];

  static final List<DisputeItem> disputes = [
    DisputeItem(
      id: 'DISP-801',
      bookingId: 'BK-77102',
      customerId: 'cust_raghav',
      customerName: 'Raghavan S',
      workerOrCoopName: 'Anna Nagar Local Cluster',
      reason: 'Part replacement pricing question regarding original manufacturer capacitor.',
      disputedAmount: 450.0,
      status: 'open',
      resolutionNotes: null,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    DisputeItem(
      id: 'DISP-792',
      bookingId: 'BK-76340',
      customerId: 'cust_geetha',
      customerName: 'Geetha Swaminathan',
      workerOrCoopName: 'Adyar Trades & Homecare Co-op',
      reason: 'Technician arrived 40 mins past slot due to rainfall waterlogging.',
      disputedAmount: 0.0,
      status: 'resolved',
      resolutionNotes:
          'Cooperative issued ₹150 goodwill service voucher; customer satisfied with quality of final repair.',
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ];

  static final List<AuditLog> auditLogs = [
    AuditLog(
      id: 'log_001',
      actorId: 'admin_sundaram',
      actorName: 'M. Sundaram',
      actorRole: 'cooperative_admin',
      action: 'APPROVE_WORKER_APPLICATION',
      targetId: 'worker_priya',
      targetType: 'WorkerProfile',
      before: 'status: pending, certs_verified: false',
      after: 'status: active, certs_verified: true',
      timestamp: DateTime.now().subtract(const Duration(days: 14)),
    ),
    AuditLog(
      id: 'log_002',
      actorId: 'superadmin_master',
      actorName: 'Platform Super Admin',
      actorRole: 'super_admin',
      action: 'CREATE_COOPERATIVE',
      targetId: 'coop_anna_nagar',
      targetType: 'Cooperative',
      before: 'null',
      after: 'name: Anna Nagar Local Cluster, status: active',
      timestamp: DateTime.now().subtract(const Duration(days: 420)),
    ),
    AuditLog(
      id: 'log_003',
      actorId: 'admin_sundaram',
      actorName: 'M. Sundaram',
      actorRole: 'cooperative_admin',
      action: 'UPDATE_SERVICE_BASE_PRICE',
      targetId: 'srv_electrician',
      targetType: 'ServiceItem',
      before: 'basePrice: 300.0',
      after: 'basePrice: 350.0',
      timestamp: DateTime.now().subtract(const Duration(days: 45)),
    ),
  ];

  static final ForecastData aiForecast = ForecastData(
    date: 'September 2026',
    categoryDemands: [
      const CategoryDemand(
        category: 'Electrician',
        currentDemand: 420,
        predictedDemand: 580,
        percentageChange: 38.1,
        recommendedAction:
            'Increase active evening shift coverage in Anna Nagar & T. Nagar',
      ),
      const CategoryDemand(
        category: 'Plumber',
        currentDemand: 310,
        predictedDemand: 390,
        percentageChange: 25.8,
        recommendedAction:
            'Onboard 4 additional plumbing technicians for monsoon readiness',
      ),
      const CategoryDemand(
        category: 'AC & Appliance',
        currentDemand: 280,
        predictedDemand: 410,
        percentageChange: 46.4,
        recommendedAction: 'Stock cooperative bulk refrigerant and capacitors',
      ),
      const CategoryDemand(
        category: 'Carpenter',
        currentDemand: 190,
        predictedDemand: 220,
        percentageChange: 15.7,
        recommendedAction: 'Standard weekend surge allocation',
      ),
    ],
    highDemandAreas: [
      'Anna Nagar North (Zone 4) — High Peak 6:00 PM - 9:30 PM',
      'T. Nagar Commercial & Residential Belt — High Surge 11:00 AM - 3:00 PM',
      'Adyar & Besant Nagar Coastal Corridor — High AC & Leakage requests',
      'Velachery Tech Corridor — Weekend Deep Cleaning Surge'
    ],
    aiRecommendations: [
      '⚡ High demand expected in Chennai North 6:00 PM - 9:00 PM: Alert Anna Nagar Co-op to schedule 6 standby electricians.',
      '💧 Monsoon pipeline maintenance spike anticipated next week: Pre-allocate emergency plumber cluster.',
      '🏆 Worker utilization at 84% in Anna Nagar: Initiate expedited verification queue review for pending Tier-1 intake applicants.'
    ],
  );
}
