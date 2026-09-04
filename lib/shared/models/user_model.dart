enum UserRole {
  customer,
  worker,
  cooperativeAdmin,
  superAdmin;

  static UserRole fromString(String role) {
    switch (role) {
      case 'worker':
        return UserRole.worker;
      case 'cooperative_admin':
      case 'cooperativeAdmin':
        return UserRole.cooperativeAdmin;
      case 'super_admin':
      case 'superAdmin':
        return UserRole.superAdmin;
      case 'customer':
      default:
        return UserRole.customer;
    }
  }

  String toDbString() {
    switch (this) {
      case UserRole.worker:
        return 'worker';
      case UserRole.cooperativeAdmin:
        return 'cooperative_admin';
      case UserRole.superAdmin:
        return 'super_admin';
      case UserRole.customer:
        return 'customer';
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.worker:
        return 'Worker';
      case UserRole.cooperativeAdmin:
        return 'Cooperative Admin';
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.customer:
        return 'Customer';
    }
  }
}

enum UserStatus {
  active,
  pending,
  rejected,
  suspended;

  static UserStatus fromString(String status) {
    switch (status) {
      case 'pending':
        return UserStatus.pending;
      case 'rejected':
        return UserStatus.rejected;
      case 'suspended':
        return UserStatus.suspended;
      case 'active':
      default:
        return UserStatus.active;
    }
  }

  String toDbString() => name;
}

class AppUser {
  final String uid;
  final UserRole role;
  final UserStatus status;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final List<String> languages;
  final String? cooperativeId;
  final String? cooperativeName;
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.role,
    required this.status,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    this.languages = const ['English', 'Tamil'],
    this.cooperativeId,
    this.cooperativeName,
    required this.createdAt,
  });

  AppUser copyWith({
    String? uid,
    UserRole? role,
    UserStatus? status,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    List<String>? languages,
    String? cooperativeId,
    String? cooperativeName,
    DateTime? createdAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      role: role ?? this.role,
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      languages: languages ?? this.languages,
      cooperativeId: cooperativeId ?? this.cooperativeId,
      cooperativeName: cooperativeName ?? this.cooperativeName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'role': role.toDbString(),
      'status': status.toDbString(),
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'languages': languages,
      'cooperativeId': cooperativeId,
      'cooperativeName': cooperativeName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      role: UserRole.fromString(map['role'] ?? 'customer'),
      status: UserStatus.fromString(map['status'] ?? 'active'),
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoUrl: map['photoUrl'],
      languages: List<String>.from(map['languages'] ?? ['English', 'Tamil']),
      cooperativeId: map['cooperativeId'],
      cooperativeName: map['cooperativeName'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
