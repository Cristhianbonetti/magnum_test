import '../../../shared/core/utils/either.dart';
import '../../../shared/core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class SaveProfileParams {
  final ProfileEntity profile;
  
  const SaveProfileParams(this.profile);
}

class SaveProfileUsecase {
  final ProfileRepository repository;
  
  const SaveProfileUsecase(this.repository);
  
  Future<Either<Failure, bool>> call(SaveProfileParams params) async {
    return await repository.saveProfile(params.profile);
  }
}
