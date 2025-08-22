import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.uid,
    required super.email,
    super.displayName,
    super.photoURL,
    super.createdAt,
    super.lastLoginAt,
    super.age,
    super.interests = const [],
    super.postsCount = 0,
    super.bio,
    super.updatedAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      createdAt: map['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      lastLoginAt: map['lastLoginAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLoginAt'])
          : null,
      age: map['age'],
      interests: List<String>.from(map['interests'] ?? []),
      postsCount: map['postsCount'] ?? 0,
      bio: map['bio'],
      updatedAt: map['updatedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'lastLoginAt': lastLoginAt?.millisecondsSinceEpoch,
      'age': age,
      'interests': interests,
      'postsCount': postsCount,
      'bio': bio,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  ProfileModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    int? age,
    List<String>? interests,
    int? postsCount,
    String? bio,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      age: age ?? this.age,
      interests: interests ?? this.interests,
      postsCount: postsCount ?? this.postsCount,
      bio: bio ?? this.bio,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ProfileModel.initial({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
  }) {
    return ProfileModel(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      age: null,
      interests: [],
      postsCount: 0,
      bio: null,
      updatedAt: DateTime.now(),
    );
  }
}
