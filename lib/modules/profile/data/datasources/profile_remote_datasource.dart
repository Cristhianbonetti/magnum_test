import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/core/constants/app_constants.dart';
import '../../../shared/core/utils/logger.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel?> getProfile(String uid);
  
  Future<bool> saveProfile(ProfileModel profile);
  
  Future<bool> updateProfile(String uid, Map<String, dynamic> updates);
  
  Future<bool> createInitialProfile(ProfileModel profile);
  
  Future<bool> updatePostsCount(String uid, int postsCount);
  
  Future<List<ProfileModel>> getAllProfiles();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  
  ProfileRemoteDataSourceImpl(this._firestore);
  
  @override
  Future<ProfileModel?> getProfile(String uid) async {
    try {
      AppLogger.info('Getting profile for user: $uid');
      
      final doc = await _firestore.collection(AppConstants.usersCollection).doc(uid).get();
      
      if (doc.exists) {
        final data = doc.data()!;
        final profile = ProfileModel.fromMap(data);
        
        AppLogger.info('Profile found for user: $uid');
        return profile;
      } else {
        AppLogger.info('Profile not found for user: $uid');
        return null;
      }
    } catch (e) {
      AppLogger.error('Error getting profile: $e');
      rethrow;
    }
  }
  
  @override
  Future<bool> saveProfile(ProfileModel profile) async {
    try {
      AppLogger.info('Saving profile for user: ${profile.uid}');
      
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(profile.uid)
          .set(profile.toMap(), SetOptions(merge: true));
      
      AppLogger.info('Profile saved successfully for user: ${profile.uid}');
      return true;
    } catch (e) {
      AppLogger.error('Error saving profile: $e');
      return false;
    }
  }
  
  @override
  Future<bool> updateProfile(String uid, Map<String, dynamic> updates) async {
    try {
      AppLogger.info('Updating profile for user: $uid');
      
      updates['updatedAt'] = DateTime.now().millisecondsSinceEpoch;
      
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update(updates);
      
      AppLogger.info('Profile updated successfully for user: $uid');
      return true;
    } catch (e) {
      AppLogger.error('Error updating profile: $e');
      return false;
    }
  }
  
  @override
  Future<bool> createInitialProfile(ProfileModel profile) async {
    try {
      AppLogger.info('Creating initial profile for user: ${profile.uid}');
      
      final initialProfile = profile.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        age: null,
        interests: [],
        postsCount: 0,
        bio: null,
      );
      
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(profile.uid)
          .set(initialProfile.toMap());
      
      AppLogger.info('Initial profile created successfully for user: ${profile.uid}');
      return true;
    } catch (e) {
      AppLogger.error('Error creating initial profile: $e');
      return false;
    }
  }
  
  @override
  Future<bool> updatePostsCount(String uid, int postsCount) async {
    try {
      AppLogger.info('Updating posts count for user: $uid - Count: $postsCount');
      
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update({
        'postsCount': postsCount,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
      
      AppLogger.info('Posts count updated successfully for user: $uid');
      return true;
    } catch (e) {
      AppLogger.error('Error updating posts count: $e');
      return false;
    }
  }
  
  @override
  Future<List<ProfileModel>> getAllProfiles() async {
    try {
      AppLogger.info('Getting all profiles');
      
      final querySnapshot = await _firestore.collection(AppConstants.usersCollection).get();
      final profiles = querySnapshot.docs
          .map((doc) => ProfileModel.fromMap(doc.data()))
          .toList();
      
      AppLogger.info('All profiles retrieved successfully - ${profiles.length} profiles');
      return profiles;
    } catch (e) {
      AppLogger.error('Error getting all profiles: $e');
      return [];
    }
  }
}
