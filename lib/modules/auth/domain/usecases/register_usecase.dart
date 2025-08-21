import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String email;
  final String password;
  final String? displayName;
  
  const RegisterParams({
    required this.email,
    required this.password,
    this.displayName,
  });
}

class RegisterUsecase {
  final AuthRepository repository;
  
  const RegisterUsecase(this.repository);
  
  Future<UserEntity> call(RegisterParams params) async {
    return await repository.createUserWithEmailAndPassword(
      params.email,
      params.password,
      params.displayName ?? '',
    );
  }
}

