import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/core/utils/logger.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  
  Future<UserModel> login({
    required String email,
    required String password,
  });
  
  Future<UserModel> register({
    required String email,
    required String password,
    String? displayName,
  });
  
  Future<void> logout();
  
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  });
  
  Future<void> deleteAccount();
  
  UserModel? get currentUser;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  
  AuthRemoteDataSourceImpl(this._firebaseAuth);
  
  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user != null) {
        AppLogger.info('Auth state changed: User logged in - ${user.email}');
        return UserModel.fromFirebaseUser(user);
      } else {
        AppLogger.info('Auth state changed: User logged out');
        return null;
      }
    });
  }
  
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Attempting login for email: $email');
      
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Login failed - user not found',
        );
      }
      
      AppLogger.info('Login successful for: $email');
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Login failed: ${e.message}');
      rethrow;
    }
  }
  
  @override
  Future<UserModel> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      AppLogger.info('Attempting registration for email: $email');
      
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'registration-failed',
          message: 'Registration failed - user not created',
        );
      }
      
      // Update display name if provided
      if (displayName != null) {
        await userCredential.user!.updateDisplayName(displayName);
      }
      
      AppLogger.info('Registration successful for: $email');
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Registration failed: ${e.message}');
      rethrow;
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      AppLogger.info('Attempting logout');
      await _firebaseAuth.signOut();
      AppLogger.info('Logout successful');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Logout failed: ${e.message}');
      rethrow;
    }
  }
  
  @override
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user logged in',
      );
    }
    
    try {
      AppLogger.info('Updating profile for: ${user.email}');
      
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }
      
      AppLogger.info('Profile updated successfully');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Profile update failed: ${e.message}');
      rethrow;
    }
  }
  
  @override
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user logged in',
      );
    }
    
    try {
      AppLogger.info('Attempting to delete account for: ${user.email}');
      await user.delete();
      AppLogger.info('Account deleted successfully');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Account deletion failed: ${e.message}');
      rethrow;
    }
  }
  
  @override
  UserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }
}

