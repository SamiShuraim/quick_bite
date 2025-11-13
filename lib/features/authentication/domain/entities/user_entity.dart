/// User Entity
/// Domain entity representing a user
library;

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String role;
  final bool isEmailVerified;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.role,
    required this.isEmailVerified,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phone,
        role,
        isEmailVerified,
        createdAt,
      ];

  /// Copy with method
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? role,
    bool? isEmailVerified,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

