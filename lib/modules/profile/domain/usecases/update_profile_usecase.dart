import '../../../shared/core/utils/either.dart';
import '../../../shared/core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileParams {
  final String uid;
  final Map<String, dynamic> updates;
  
  const UpdateProfileParams({
    required this.uid,
    required this.updates,
  });
}

class UpdateProfileUsecase {
  final ProfileRepository repository;
  
  const UpdateProfileUsecase(this.repository);
  
  Future<Either<Failure, bool>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(params.uid, params.updates);
  }
}
