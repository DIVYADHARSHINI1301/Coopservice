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
    // Worker (Active / Member)
    AppUser(
      uid: 'worker_ravi',
      email: 'ravi@worker.coop',
      name: 'Ravi Kumar',
      phone: '+91 98840 11223',
      role: UserRole.worker,
      status: UserStatus.active,
      languages: const ['Tamil', 'English'],
      cooperativeId: 'coop_anna_nagar',
      cooperativeName: 'Anna Nagar Local Cluster',
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
    ),
    // Worker (Pending Verification)
    AppUser(
      uid: 'worker_karthik_pending',
      email: 'karthik@worker.coop',
      name: 'Karthik Selvam',
      phone: '+91 94440 99881',
      role: UserRole.worker,
      status: UserStatus.pending,
      languages: const ['Tamil'],
      cooperativeId: 'coop_anna_nagar',
      cooperativeName: 'Anna Nagar Local Cluster',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
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
    myRegularWorkerIds: const {
      'Electrician': 'worker_ravi',
      'Plumber': 'worker_priya',
    },
    recurringPlans: [
      RecurringCarePlan(
        id: 'care_ac_01',
        title: 'Quarterly AC Filter & Jet Clean',
        serviceCategory: 'AC & Appliance',
        frequency: 'Quarterly',
        nextScheduledDate: DateTime.now().add(const Duration(days: 24)),
        estimatedCost: 480.0,
        discountPercent: 15,
        cooperativeId: 'coop_anna_nagar',
        cooperativeName: 'Anna Nagar Electrical & Trades Co-op',
      ),
      RecurringCarePlan(
        id: 'care_plumb_02',
        title: 'Bi-Annual Overhead Tank Disinfection',
        serviceCategory: 'Plumber',
        frequency: 'Bi-Annual',
        nextScheduledDate: DateTime.now().add(const Duration(days: 72)),
        estimatedCost: 650.0,
        discountPercent: 15,
        cooperativeId: 'coop_anna_nagar',
        cooperativeName: 'Anna Nagar Electrical & Trades Co-op',
      ),
    ],
    inquiries: [
      PreBookingInquiry(
        id: 'inq_101',
        customerId: 'cust_divya',
        cooperativeId: 'coop_anna_nagar',
        cooperativeName: 'Anna Nagar Electrical & Trades Co-op',
        serviceCategory: 'Electrician',
        question:
            'Do you support 3-phase EV home charger setup with separate earth pit testing?',
        coordinatorReply:
            'Yes! We have 4 certified industrial electricians in Anna Nagar equipped with earth resistance clamp meters and heavy-gauge wire crimpers.',
        status: 'replied',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        repliedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ],
    impactStats: const CustomerImpactStats(
      workersSupported: 8,
      cooperativesEngaged: 3,
      totalJobsCompleted: 14,
      totalWorkerEarningsDirected: 11400.0,
      totalCooperativeFundGenerated: 1620.0,
    ),
    preferredLanguage: 'English',
    notificationsEnabled: true,
    loyaltyBookingsCount: 6,
  );

  static final List<CustomerProfile> customers = [customerProfile];

  static final List<WorkerProfile> workers = [
    WorkerProfile(
      uid: 'worker_ravi',
      name: 'Ravi Kumar',
      photoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      cooperativeId: 'coop_anna_nagar',
      cooperativeName: 'Anna Nagar Local Cluster',
      primaryCategory: 'Electrician',
      skills: [
        'Fan & Light Fitting',
        'Switchboard Repair',
        'MCB Tripping Diagnostic',
        'Full House Re-wiring',
        'Inverter Setup',
        'EV Charger Installation'
      ],
      serviceAreas: ['Anna Nagar', 'Kilpauk', 'Shenoy Nagar', 'Aminjikarai', 'Mogappair'],
      experienceYears: 8,
      completedJobsCount: 184,
      certifications: [
        WorkerCertification(
          id: 'cert_1',
          name: 'Government ITI Grade A Wireman License',
          fileUrl: 'https://docs.coop/certs/ravi_wireman.pdf',
          verified: true,
          expiry: DateTime.now().add(const Duration(days: 700)),
        ),
        WorkerCertification(
          id: 'cert_2',
          name: 'National Cooperative Safety Standard 2026',
          fileUrl: 'https://docs.coop/certs/ravi_safety.pdf',
          verified: true,
          expiry: DateTime.now().add(const Duration(days: 360)),
        ),
      ],
      provenanceRecords: const [
        SkillProvenanceRecord(
          skillName: 'Residential & Commercial Wiring',
          issuingBody: 'National Skill Development Corp / ITI Guindy',
          verifiedByAdminName: 'M. Sundaram (Coordinator)',
          verificationDate: '12 Jan 2024',
          practicalScorePercent: 96,
          certificateNumber: 'ITI-TN-ELC-8921',
        ),
        SkillProvenanceRecord(
          skillName: 'Solar PV & Inverter Grid Connection',
          issuingBody: 'Tamil Nadu Energy Development Agency (TEDA)',
          verifiedByAdminName: 'Guild Technical Review Board',
          verificationDate: '08 Mar 2025',
          practicalScorePercent: 92,
          certificateNumber: 'TEDA-SOLAR-449',
        ),
      ],
      badges: ['Identity Verified', 'Skill Verified', 'Co-op Owner', 'Top Rated'],
      rating: 4.88,
      ratingCount: 126,
      serviceRadiusKm: 12.0,
      online: true,
      lat: 13.0880,
      lng: 80.2150,
      hourlyRate: 350.0,
      distanceDisplay: '1.8 km away',
      availabilityDisplay: 'Available in 25 mins',
      weeklySchedule: const [
        DayScheduleSlot(dayName: 'Mon', morning: true, afternoon: true, evening: true),
        DayScheduleSlot(dayName: 'Tue', morning: true, afternoon: true, evening: true),
        DayScheduleSlot(dayName: 'Wed', morning: true, afternoon: true, evening: true),
        DayScheduleSlot(dayName: 'Thu', morning: true, afternoon: true, evening: true),
        DayScheduleSlot(dayName: 'Fri', morning: true, afternoon: true, evening: true),
        DayScheduleSlot(dayName: 'Sat', morning: true, afternoon: true, evening: false),
        DayScheduleSlot(dayName: 'Sun', isOffDay: true, morning: false, afternoon: false, evening: false),
      ],
      earnings: const WorkerEarnings(
        today: 1450.0,
        week: 8750.0,
        month: 34200.0,
        total: 215400.0,
        cooperativeDividends: 18400.0,
        welfareFundAccrued: 5600.0,
      ),
      welfare: const WorkerWelfare(
        insuranceStatus: 'Active (National Co-op Shield)',
        benefits: [
          'Full Medical & Hospitalization Cover ₹5,00,000',
          'Cooperative Annual Dividend ₹18,400',
          'Emergency Tool Replacement Fund'
        ],
        training: [
          'Industrial 3-Phase Systems',
          'Smart Home Automation Protocols'
        ],
        healthFundContribution: 5600.0,
      ),
      bio:
          'Master Electrician with 8+ years experience. Specializing in safe, clean home wiring, breaker diagnostics, and emergency repair. 100% fair co-op member.',
    ),
    WorkerProfile(
      uid: 'worker_priya',
      name: 'Priya Sundaram',
      photoUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
      cooperativeId: 'coop_anna_nagar',
      cooperativeName: 'Anna Nagar Local Cluster',
      primaryCategory: 'Plumber',
      skills: [
        'Pipe Leak Detection',
        'Bathroom Fittings & Sanware',
        'Water Motor & Pump Repair',
        'Overhead Tank Cleaning',
        'Drainage Clearing'
      ],
      serviceAreas: ['Anna Nagar', 'Chetpet', 'Nungambakkam', 'Villivakkam'],
      experienceYears: 6,
      completedJobsCount: 128,
      certifications: [
        WorkerCertification(
          id: 'cert_3',
          name: 'Advanced Plumbing & Sanitary Certification',
          fileUrl: 'https://docs.coop/certs/priya_plumb.pdf',
          verified: true,
          expiry: DateTime.now().add(const Duration(days: 500)),
        ),
      ],
      provenanceRecords: const [
        SkillProvenanceRecord(
          skillName: 'High-Pressure Sanitary Piping',
          issuingBody: 'Indian Plumbing Association (IPA Chennai)',
          verifiedByAdminName: 'M. Sundaram (Coordinator)',
          verificationDate: '15 Sep 2024',
          practicalScorePercent: 95,
          certificateNumber: 'IPA-CHE-PLM-771',
        ),
      ],
      badges: ['Identity Verified', 'Skill Verified', 'Co-op Member'],
      rating: 4.92,
      ratingCount: 94,
      serviceRadiusKm: 10.0,
      online: true,
      lat: 13.0840,
      lng: 80.2180,
      hourlyRate: 380.0,
      distanceDisplay: '2.3 km away',
      availabilityDisplay: 'Available now',
      weeklySchedule: const [
        DayScheduleSlot(dayName: 'Mon', morning: true, afternoon: true, evening: true),
        DayScheduleSlot(dayName: 'Tue', morning: true, afternoon: true, evening: true),
        DayScheduleSlot(dayName: 'Wed', morning: true, afternoon: true, evening: true),
        DayScheduleSlot(dayName: 'Thu', morning: true, afternoon: true, evening: true),
        DayScheduleSlot(dayName: 'Fri', morning: true, afternoon: true, evening: true),
        DayScheduleSlot(dayName: 'Sat', morning: true, afternoon: true, evening: true),
        DayScheduleSlot(dayName: 'Sun', isOffDay: true, morning: false, afternoon: false, evening: false),
      ],
      earnings: const WorkerEarnings(
        today: 1140.0,
        week: 7600.0,
        month: 29800.0,
        total: 184000.0,
      ),
      welfare: const WorkerWelfare(
        insuranceStatus: 'Active',
        benefits: [
          'Health Shield ₹5,00,000',
          'Co-op Tool Grant',
          'Maternity & Family Fund'
        ],
      ),
      bio:
          'Specialist plumbing technician certified in residential pressure pipelines, non-invasive acoustic leak diagnostics, and sanitary installations.',
    ),
    WorkerProfile(
      uid: 'worker_mani',
      name: 'Manikandan V',
      photoUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      cooperativeId: 'coop_anna_nagar',
      cooperativeName: 'Anna Nagar Local Cluster',
      primaryCategory: 'Carpenter',
      skills: [
        'Modular Kitchen Repair',
        'Door Lock & Hinges Fixing',
        'Custom Wood Shelves',
        'Furniture Restoration'
      ],
      serviceAreas: ['Anna Nagar', 'Koyambedu', 'Arumbakkam'],
      experienceYears: 10,
      completedJobsCount: 210,
      badges: ['Identity Verified', 'Skill Verified', 'Master Craftsman'],
      rating: 4.75,
      ratingCount: 142,
      serviceRadiusKm: 8.0,
      online: false,
      lat: 13.0790,
      lng: 80.2050,
      hourlyRate: 400.0,
      distanceDisplay: '3.1 km away',
      availabilityDisplay: 'On leave today',
      bio:
          'Woodcraftsman with 10 years experience crafting teak and ply woodwork. Proud founding member of Anna Nagar Artisans Guild.',
    ),
    WorkerProfile(
      uid: 'worker_shiva',
      name: 'Shiva Kumar',
      photoUrl:
          'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=150',
      cooperativeId: 'coop_anna_nagar',
      cooperativeName: 'Anna Nagar Local Cluster',
      primaryCategory: 'AC & Appliance',
      skills: [
        'AC Foam Jet Cleaning',
        'Gas Leak & Refill',
        'Washing Machine Diagnostic',
        'Refrigerator Cooling Coil'
      ],
      serviceAreas: ['Anna Nagar', 'Kilpauk', 'Choolaimedu', 'T. Nagar'],
      experienceYears: 7,
      completedJobsCount: 165,
      badges: ['Identity Verified', 'Skill Verified', 'Co-op Owner'],
      rating: 4.85,
      ratingCount: 110,
      serviceRadiusKm: 15.0,
      online: true,
      lat: 13.0865,
      lng: 80.2130,
      hourlyRate: 500.0,
      distanceDisplay: '1.2 km away',
      availabilityDisplay: 'Available now',
      bio:
          'Certified HVAC technician specialized in inverter AC diagnostics, PCB soldering repairs, and eco-friendly gas recharging.',
    ),
  ];

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

  static final List<Booking> bookings = [
    // Active Booking 1: On The Way (Live Tracking Demo)
    Booking(
      id: 'BK-78921',
      customerId: 'cust_divya',
      customerName: 'Divya Dharshini',
      customerPhone: '+91 98401 54321',
      workerId: 'worker_ravi',
      workerName: 'Ravi Kumar',
      workerPhotoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      cooperativeId: 'coop_anna_nagar',
      cooperativeName: 'Anna Nagar Local Cluster',
      serviceCategory: 'Electrician',
      serviceSubtype: 'Switchboard & Socket Repair',
      status: BookingStatus.onTheWay,
      scheduledAt: DateTime.now().add(const Duration(minutes: 15)),
      location: const BookingLocation(
        address: 'Plot 42, 2nd Avenue, Anna Nagar East, Chennai - 600102',
        lat: 13.0850,
        lng: 80.2101,
      ),
      instructions:
          'Main hall 3-pin socket sparked when plugging in the iron. Please check grounding as well.',
      estimatedPrice: 350.0,
      finalPrice: 350.0,
      pricing: FairSplitPricing.calculate(350.0),
      paymentStatus: 'pending',
      paymentMethod: 'UPI on Completion',
      isEmergency: false,
      neighborhoodTrustCount: 18,
      createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),

    // Active Booking 2: Team Booking (Cooperative Multi-Worker Job)
    Booking(
      id: 'BK-79100',
      customerId: 'cust_divya',
      customerName: 'Divya Dharshini',
      customerPhone: '+91 98401 54321',
      workerId: 'coop_anna_nagar',
      workerName: 'Anna Nagar Co-op Team',
      workerPhotoUrl:
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=150',
      cooperativeId: 'coop_anna_nagar',
      cooperativeName: 'Anna Nagar Local Cluster',
      serviceCategory: 'Electrician',
      serviceSubtype: 'Full House Re-wiring & Phase Alignment',
      status: BookingStatus.accepted,
      scheduledAt: DateTime.now().add(const Duration(hours: 2)),
      location: const BookingLocation(
        address: 'Plot 42, 2nd Avenue, Anna Nagar East, Chennai - 600102',
        lat: 13.0850,
        lng: 80.2101,
      ),
      instructions:
          '3-bedroom apartment complete rewiring and new distribution board installation.',
      estimatedPrice: 2800.0,
      finalPrice: 2800.0,
      pricing: FairSplitPricing.calculate(2800.0),
      paymentStatus: 'pending',
      paymentMethod: 'Escrow Secured / Milestone',
      isEmergency: false,
      isTeamBooking: true,
      teamSize: 3,
      assignedWorkers: const [
        AssignedTeamWorker(
          workerId: 'worker_ravi',
          workerName: 'Ravi Kumar',
          role: 'Lead Electrician & Inspector',
          photoUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
          phone: '+91 98840 11223',
        ),
        AssignedTeamWorker(
          workerId: 'worker_karthik_pending',
          workerName: 'Karthik Selvam',
          role: 'Apprentice / Conduit Cable Specialist',
          photoUrl:
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
          phone: '+91 94440 99881',
        ),
        AssignedTeamWorker(
          workerId: 'worker_shiva',
          workerName: 'Shiva Kumar',
          role: 'Circuit Testing & Earthing Specialist',
          photoUrl:
              'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=150',
          phone: '+91 98410 33445',
        ),
      ],
      groupSplit: const GroupBookingSplit(
        groupCode: 'ANNA-APT-402',
        societyName: 'Greenwood Palms Apts',
        totalParticipants: 4,
        splitAmountPerMember: 700.0,
        paidMemberNames: ['Divya Dharshini (Organizer)', 'Senthil Kumar (Flat 3B)'],
        shareLink: 'coop.app/split/ANNA-APT-402',
      ),
      neighborhoodTrustCount: 24,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),

    // Active Booking 3: Emergency Dispatch
    Booking(
      id: 'BK-78905',
      customerId: 'cust_divya',
      customerName: 'Divya Dharshini',
      customerPhone: '+91 98401 54321',
      workerId: 'worker_priya',
      workerName: 'Priya Sundaram',
      workerPhotoUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
      cooperativeId: 'coop_anna_nagar',
      cooperativeName: 'Anna Nagar Local Cluster',
      serviceCategory: 'Plumber',
      serviceSubtype: 'Water Tank & Motor Repair',
      status: BookingStatus.requested,
      scheduledAt: DateTime.now().add(const Duration(hours: 3)),
      location: const BookingLocation(
        address: 'Plot 42, 2nd Avenue, Anna Nagar East, Chennai - 600102',
        lat: 13.0850,
        lng: 80.2101,
      ),
      instructions:
          'Overhead water tank auto-cutoff sensor is malfunctioning and overflowing.',
      estimatedPrice: 450.0,
      finalPrice: 450.0,
      pricing: FairSplitPricing.calculate(450.0),
      paymentStatus: 'pending',
      neighborhoodTrustCount: 16,
      createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 12)),
    ),

    // Completed Booking with Digital Job Card & 90-Day Warranty
    Booking(
      id: 'BK-78512',
      customerId: 'cust_divya',
      customerName: 'Divya Dharshini',
      customerPhone: '+91 98401 54321',
      workerId: 'worker_ravi',
      workerName: 'Ravi Kumar',
      workerPhotoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      cooperativeId: 'coop_anna_nagar',
      cooperativeName: 'Anna Nagar Local Cluster',
      serviceCategory: 'Electrician',
      serviceSubtype: 'Fan & Light Fitting',
      status: BookingStatus.completed,
      scheduledAt: DateTime.now().subtract(const Duration(days: 3)),
      location: const BookingLocation(
        address: 'Plot 42, 2nd Avenue, Anna Nagar East, Chennai - 600102',
        lat: 13.0850,
        lng: 80.2101,
      ),
      instructions: 'Install 2 new BLDC ceiling fans in bedrooms.',
      estimatedPrice: 600.0,
      finalPrice: 600.0,
      pricing: FairSplitPricing.calculate(600.0),
      paymentStatus: 'paid',
      ratingGiven: 5,
      professionalismRating: 5.0,
      qualityRating: 5.0,
      coordinationRating: 5.0,
      reviewComment:
          'Punctual, exceptionally neat wiring, and verified co-op rate. Highly recommended!',
      workProofPhotos: [
        'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400'
      ],
      jobCard: DigitalJobCard(
        jobCardId: 'JC-78512',
        beforePhotos: [
          'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=400'
        ],
        afterPhotos: [
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400'
        ],
        materialsUsed: [
          '2x Atomberg BLDC 1200mm Ceiling Fan (Client Supplied)',
          'Finolex 2.5sqmm copper drop cable 6m',
          'Heavy-duty expansion ceiling anchor'
        ],
        warrantyExpiryDate: DateTime.now().add(const Duration(days: 87)),
        isWarrantyActive: true,
        technicianSignature: 'Ravi Kumar (Certified Wireman #ITI-TN-8921)',
      ),
      neighborhoodTrustCount: 22,
      createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  static final List<CustomWorkRequest> customRequests = [
    CustomWorkRequest(
      id: 'CWR-101',
      customerId: 'cust_divya',
      title: 'Full Balcony Waterproofing & Planter Box Drainage',
      description:
          'Need specialized waterproofing coating for a 200 sqft terrace balcony with root-barrier membrane for planter boxes.',
      serviceCategory: 'Plumber',
      address: 'Plot 42, 2nd Avenue, Anna Nagar East, Chennai',
      budget: 3500.0,
      preferredDate: DateTime.now().add(const Duration(days: 2)),
      photoUrls: [
        'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=400'
      ],
      status: 'quotes_received',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static final List<Review> reviews = [
    Review(
      id: 'rev_1',
      bookingId: 'BK-78512',
      customerId: 'cust_divya',
      customerName: 'Divya Dharshini',
      workerId: 'worker_ravi',
      cooperativeId: 'coop_anna_nagar',
      rating: 5.0,
      professionalism: 5.0,
      serviceQuality: 5.0,
      coordination: 5.0,
      comment:
          'Ravi was prompt, thoroughly diagnosed the issue, and explained the cooperative dividend model. Super clean work!',
      tags: ['Punctual', 'Transparent Rate', 'Clean Finish', 'Co-op Certified'],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Review(
      id: 'rev_2',
      bookingId: 'BK-77402',
      customerId: 'cust_anand',
      customerName: 'Anand Ramaswamy',
      workerId: 'worker_ravi',
      cooperativeId: 'coop_anna_nagar',
      rating: 4.8,
      professionalism: 5.0,
      serviceQuality: 4.8,
      coordination: 4.7,
      comment:
          'Fixed my tripping MCB in 20 minutes. Excellent cooperative professional with fair pricing.',
      tags: ['Fast Response', 'Fair Pricing', 'Clean Finish'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Review(
      id: 'rev_3',
      bookingId: 'BK-76119',
      customerId: 'cust_meena',
      customerName: 'Meena Krishnan',
      workerId: 'worker_priya',
      cooperativeId: 'coop_anna_nagar',
      rating: 4.9,
      professionalism: 5.0,
      serviceQuality: 5.0,
      coordination: 4.8,
      comment:
          'Priya is an incredible plumber. Replaced the main pressure line cleanly without damaging wall tiles.',
      tags: ['Master Craftsperson', 'Punctual', 'Honest Quote'],
      createdAt: DateTime.now().subtract(const Duration(days: 16)),
    ),
  ];

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
