import '../../../shared/core/utils/logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  
  AuthRepositoryImpl(this._remoteDataSource);
  
  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges;
  }
  
  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) async {
    try {
      AppLogger.info('Login attempt for: $email');
      
      final user = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      
      AppLogger.info('Login successful for: $email');
      return user;
    } catch (e) {
      AppLogger.error('Login failed: $e');
      rethrow;
    }
  }
  
  @override
  Future<UserEntity> createUserWithEmailAndPassword(String email, String password, String displayName) async {
    try {
      AppLogger.info('Registration attempt for: $email');
      
      final user = await _remoteDataSource.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      
      AppLogger.info('Registration successful for: $email');
      return user;
    } catch (e) {
      AppLogger.error('Registration failed: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      AppLogger.info('Logout attempt');
      
      await _remoteDataSource.logout();
      
      AppLogger.info('Logout successful');
    } catch (e) {
      AppLogger.error('Logout failed: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      AppLogger.info('Profile update attempt');
      
      await _remoteDataSource.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
      
      AppLogger.info('Profile updated successfully');
    } catch (e) {
      AppLogger.error('Profile update failed: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> deleteAccount() async {
    try {
      AppLogger.info('Account deletion attempt');
      
      await _remoteDataSource.deleteAccount();
      
      AppLogger.info('Account deleted successfully');
    } catch (e) {
      AppLogger.error('Account deletion failed: $e');
      rethrow;
    }
  }
  
  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = _remoteDataSource.currentUser;
      return user;
    } catch (e) {
      AppLogger.error('Failed to get current user: $e');
      return null;
    }
  }
}
