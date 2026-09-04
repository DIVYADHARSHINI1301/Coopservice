import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

class AppLocalization {
  final Locale locale;
  AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization) ??
        AppLocalization(const Locale('en'));
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'Cooperative Services',
      'tagline': 'Trusted services. Fair work. Strong communities.',
      'welcomeBack': 'Welcome Back',
      'loginSub': 'Login to continue to your account',
      'emailOrPhone': 'Email or Phone Number',
      'password': 'Password',
      'forgotPassword': 'Forgot Password?',
      'login': 'Login',
      'dontHaveAccount': "Don't have an account?",
      'createAccount': 'Create Account',
      'continueAsCustomer': 'Continue as Customer',
      'bookServicesDesc': 'Book verified neighborhood services',
      'registerAsWorker': 'Register as Worker',
      'coopMember': 'Co-op Member',
      'provideServicesDesc': 'Provide services & earn cooperative wages',
      'registerAsCoop': 'Register a Cooperative Society',
      'registerAsCoopDesc': 'Register your trade guild or worker society',
      'verificationPending': 'Verification Pending',
      'verificationDesc':
          'Your application is being reviewed by your cooperative admin. This usually takes 1–2 business days.',
      'emergencyService': 'Emergency Service',
      'priority': 'PRIORITY',
      'standbyDesc': 'Member technicians on standby • < 20 min response',
      'serviceCategories': 'Service Categories',
      'seeAll': 'See All',
      'nearbyWorkers': 'Nearby Verified Workers',
      'localCooperatives': 'Local Cooperatives Near You',
      'onlineCount': 'online',
      'viewFullMap': 'View Full Map',
      'bookNow': 'Book Now',
      'bookCooperative': 'Book Cooperative Team',
      'hourBase': '/ hour base',
      'fairWorkTitle': 'Fair Work • Equal Ownership',
      'fairWorkDesc':
          '100% of service platform margins are reinvested into local worker health funds and tooling.',
      'home': 'Home',
      'explore': 'Explore',
      'bookings': 'Bookings',
      'impact': 'My Impact',
      'services': 'Services',
      'profile': 'Profile',
      'account': 'Account',
      'jobs': 'Jobs',
      'requests': 'Requests',
      'schedule': 'Schedule',
      'earnings': 'Earnings',
      'dashboard': 'Dashboard',
      'workers': 'Workers',
      'verification': 'Verification',
      'welfare': 'Welfare',
      'analytics': 'Analytics',
      'cooperatives': 'Cooperatives',
      'admins': 'Admins',
      'users': 'Users',
      'aiForecast': 'AI Forecast',
      'auditLogs': 'Audit Logs',
      'settings': 'Settings',
      'english': 'English',
      'tamil': 'தமிழ்',
      'myImpact': 'My Community Impact',
      'workersSupported': 'Workers Supported',
      'cooperativesEngaged': 'Co-ops Engaged',
      'jobsCompleted': 'Jobs Completed',
      'earningsDirected': 'Worker Earnings Generated',
      'customRequest': 'Custom Work Request',
      'customRequestDesc': 'Upload photos and get quotes from nearby guilds',
      'cooperativeProfile': 'Cooperative Profile',
      'about': 'About',
      'reviews': 'Reviews',
      'availability': 'Availability',
      'teamBooking': 'Team Booking',
      'disputes': 'Dispute Resolution',
      'serviceCatalog': 'Service Catalog',
      'approvals': 'Approvals',
    },
    'ta': {
      'appName': 'கூட்டுறவு சேவைகள்',
      'tagline': 'நம்பகமான சேவை. நியாயமான ஊதியம். வலிமையான சமூகம்.',
      'welcomeBack': 'மீண்டும் வருக',
      'loginSub': 'உங்கள் கணக்கில் உள்நுழையவும்',
      'emailOrPhone': 'மின்னஞ்சல் அல்லது தொலைபேசி எண்',
      'password': 'கடவுச்சொல்',
      'forgotPassword': 'கடவுச்சொல் மறந்துவிட்டதா?',
      'login': 'உள்நுழை',
      'dontHaveAccount': 'கணக்கு இல்லையா?',
      'createAccount': 'கணக்கை உருவாக்கவும்',
      'continueAsCustomer': 'வாடிக்கையாளராக தொடரவும்',
      'bookServicesDesc': 'சரிபார்க்கப்பட்ட உள்ளூர் சேவைகளை முன்பதிவு செய்யவும்',
      'registerAsWorker': 'பணியாளராக பதிவு செய்யவும்',
      'coopMember': 'கூட்டுறவு உறுப்பினர்',
      'provideServicesDesc': 'சேவைகளை வழங்கி நியாயமான வருவாய் ஈட்டவும்',
      'registerAsCoop': 'கூட்டுறவு சங்கத்தை பதிவு செய்யவும்',
      'registerAsCoopDesc': 'உங்கள் கைவினைஞர் அல்லது தொழிலாளர் சங்கத்தை பதிவு செய்யவும்',
      'verificationPending': 'சரிபார்ப்பு நிலுவையில் உள்ளது',
      'verificationDesc':
          'உங்கள் விண்ணப்பம் கூட்டுறவு நிர்வாகியால் சரிபார்க்கப்பட்டு வருகிறது. பொதுவாக 1–2 வேலை நாட்கள் ஆகும்.',
      'emergencyService': 'அவசர சேவை',
      'priority': 'முன்னுரிமை',
      'standbyDesc': 'உறுப்பினர் தொழில்நுட்ப வல்லுநர்கள் தயார் • < 20 நிமிடம்',
      'serviceCategories': 'சேவை பிரிவுகள்',
      'seeAll': 'அனைத்தையும் காண்க',
      'nearbyWorkers': 'அருகிலுள்ள சரிபார்க்கப்பட்ட பணியாளர்கள்',
      'localCooperatives': 'அருகிலுள்ள உள்ளூர் கூட்டுறவுகள்',
      'onlineCount': 'பணியாளர்கள் பணியில்',
      'viewFullMap': 'முழு வரைபடத்தை காண்க',
      'bookNow': 'முன்பதிவு செய்',
      'bookCooperative': 'கூட்டுறவு குழுவை முன்பதிவு செய்',
      'hourBase': '/ மணிநேர கட்டணம்',
      'fairWorkTitle': 'நியாயமான வேலை • சம உரிமை',
      'fairWorkDesc':
          'சேவை தளத்தின் 100% வருவாய் உள்ளூர் தொழிலாளர் நல நிதியில் முதலீடு செய்யப்படுகிறது.',
      'home': 'முகப்பு',
      'explore': 'ஆராய்க',
      'bookings': 'முன்பதிவுகள்',
      'impact': 'என் தாக்கம்',
      'services': 'சேவைகள்',
      'profile': 'சுயவிவரம்',
      'account': 'கணக்கு',
      'jobs': 'வேலைகள்',
      'requests': 'கோரிக்கைகள்',
      'schedule': 'அட்டவணை',
      'earnings': 'வருமானம்',
      'dashboard': 'டாஷ்போர்டு',
      'workers': 'பணியாளர்கள்',
      'verification': 'சரிபார்ப்பு',
      'welfare': 'நலத்திட்டம்',
      'analytics': 'பகுப்பாய்வு',
      'cooperatives': 'கூட்டுறவுகள்',
      'admins': 'நிர்வாகிகள்',
      'users': 'பயனர்கள்',
      'aiForecast': 'AI தேவை முன்கணிப்பு',
      'auditLogs': 'தணிக்கை பதிவுகள்',
      'settings': 'அமைப்புகள்',
      'english': 'English',
      'tamil': 'தமிழ்',
      'myImpact': 'சமூக தாக்கம்',
      'workersSupported': 'ஆதரிக்கப்பட்ட பணியாளர்கள்',
      'cooperativesEngaged': 'இணைந்த கூட்டுறவுகள்',
      'jobsCompleted': 'முடிக்கப்பட்ட வேலைகள்',
      'earningsDirected': 'தொழிலாளர்களுக்கு வழங்கப்பட்ட ஊதியம்',
      'customRequest': 'தனிப்பயன் வேலை கோரிக்கை',
      'customRequestDesc': 'புகைப்படங்களை பதிவேற்றி கூட்டுறவு மதிப்பீட்டைப் பெறுங்கள்',
      'cooperativeProfile': 'கூட்டுறவு சுயவிவரம்',
      'about': 'பற்றி',
      'reviews': 'மதிப்புரைகள்',
      'availability': 'கிடைக்கும் தன்மை',
      'teamBooking': 'குழு முன்பதிவு',
      'disputes': 'சர்ச்சை தீர்வு',
      'serviceCatalog': 'சேவை பட்டியல்',
      'approvals': 'ஒப்புதல்கள்',
    },
  };

  String tr(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ta'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async {
    return AppLocalization(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
