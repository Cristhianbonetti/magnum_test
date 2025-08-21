import '../../../shared/core/utils/either.dart';
import '../../../shared/core/errors/failures.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity?>> getProfile(String uid);
  
  Future<Either<Failure, bool>> saveProfile(ProfileEntity profile);
  
  Future<Either<Failure, bool>> updateProfile(String uid, Map<String, dynamic> updates);
  
  Future<Either<Failure, bool>> createInitialProfile(ProfileEntity profile);
  
  Future<Either<Failure, bool>> updatePostsCount(String uid, int postsCount);
  
  Future<Either<Failure, List<ProfileEntity>>> getAllProfiles();
}
