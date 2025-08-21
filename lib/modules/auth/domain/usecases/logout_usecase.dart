import '../repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;
  
  const LogoutUsecase(this.repository);
  
  Future<void> call() async {
    await repository.signOut();
  }
}

