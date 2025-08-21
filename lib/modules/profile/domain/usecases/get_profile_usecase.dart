import '../../../shared/core/utils/either.dart';
import '../../../shared/core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileParams {
  final String uid;
  
  const GetProfileParams(this.uid);
}

class GetProfileUsecase {
  final ProfileRepository repository;
  
  const GetProfileUsecase(this.repository);
  
  Future<Either<Failure, ProfileEntity?>> call(GetProfileParams params) async {
    return await repository.getProfile(params.uid);
  }
}
