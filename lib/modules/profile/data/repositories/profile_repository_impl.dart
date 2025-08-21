import '../../../shared/core/utils/either.dart';
import '../../../shared/core/errors/failures.dart';
import '../../../shared/core/utils/logger.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  
  ProfileRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<Either<Failure, ProfileEntity?>> getProfile(String uid) async {
    try {
      AppLogger.info('Getting profile for user: $uid');
      
      final profile = await _remoteDataSource.getProfile(uid);
      
      if (profile != null) {
        AppLogger.info('Profile retrieved successfully for user: $uid');
        return Right(profile);
      } else {
        AppLogger.info('Profile not found for user: $uid');
        return const Right(null);
      }
    } catch (e) {
      AppLogger.error('Error getting profile: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> saveProfile(ProfileEntity profile) async {
    try {
      AppLogger.info('Saving profile for user: ${profile.uid}');
      
      final success = await _remoteDataSource.saveProfile(profile as dynamic);
      
      if (success) {
        AppLogger.info('Profile saved successfully for user: ${profile.uid}');
        return const Right(true);
      } else {
        AppLogger.error('Failed to save profile for user: ${profile.uid}');
        return Left(ServerFailure('Failed to save profile'));
      }
    } catch (e) {
      AppLogger.error('Error saving profile: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> updateProfile(String uid, Map<String, dynamic> updates) async {
    try {
      AppLogger.info('Updating profile for user: $uid');
      
      final success = await _remoteDataSource.updateProfile(uid, updates);
      
      if (success) {
        AppLogger.info('Profile updated successfully for user: $uid');
        return const Right(true);
      } else {
        AppLogger.error('Failed to update profile for user: $uid');
        return Left(ServerFailure('Failed to update profile'));
      }
    } catch (e) {
      AppLogger.error('Error updating profile: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> createInitialProfile(ProfileEntity profile) async {
    try {
      AppLogger.info('Creating initial profile for user: ${profile.uid}');
      
      final success = await _remoteDataSource.createInitialProfile(profile as dynamic);
      
      if (success) {
        AppLogger.info('Initial profile created successfully for user: ${profile.uid}');
        return const Right(true);
      } else {
        AppLogger.error('Failed to create initial profile for user: ${profile.uid}');
        return Left(ServerFailure('Failed to create initial profile'));
      }
    } catch (e) {
      AppLogger.error('Error creating initial profile: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> updatePostsCount(String uid, int postsCount) async {
    try {
      AppLogger.info('Updating posts count for user: $uid - Count: $postsCount');
      
      final success = await _remoteDataSource.updatePostsCount(uid, postsCount);
      
      if (success) {
        AppLogger.info('Posts count updated successfully for user: $uid');
        return const Right(true);
      } else {
        AppLogger.error('Failed to update posts count for user: $uid');
        return Left(ServerFailure('Failed to update posts count'));
      }
    } catch (e) {
      AppLogger.error('Error updating posts count: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<ProfileEntity>>> getAllProfiles() async {
    try {
      AppLogger.info('Getting all profiles');
      
      final profiles = await _remoteDataSource.getAllProfiles();
      
      AppLogger.info('All profiles retrieved successfully - ${profiles.length} profiles');
      return Right(profiles);
    } catch (e) {
      AppLogger.error('Error getting all profiles: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
