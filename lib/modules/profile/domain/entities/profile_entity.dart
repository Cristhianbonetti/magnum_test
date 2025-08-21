import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final int? age;
  final List<String> interests;
  final int postsCount;
  final String? bio;
  final DateTime? updatedAt;

  const ProfileEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    this.createdAt,
    this.lastLoginAt,
    this.age,
    this.interests = const [],
    this.postsCount = 0,
    this.bio,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoURL,
        createdAt,
        lastLoginAt,
        age,
        interests,
        postsCount,
        bio,
        updatedAt,
      ];
}
