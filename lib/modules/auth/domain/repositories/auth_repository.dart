import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity> createUserWithEmailAndPassword(String email, String password, String displayName);
  Future<void> signOut();
  Future<void> updateProfile({String? displayName, String? photoURL});
  Future<void> deleteAccount();
  Stream<UserEntity?> get authStateChanges;
}
