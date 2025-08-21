import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared/core/utils/logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

// Estados
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  
  const AuthAuthenticated(this.user);
  
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  const AuthError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final LogoutUsecase _logoutUsecase;
  
  AuthCubit({
    required LoginUsecase loginUsecase,
    required RegisterUsecase registerUsecase,
    required LogoutUsecase logoutUsecase,
  }) : _loginUsecase = loginUsecase,
       _registerUsecase = registerUsecase,
       _logoutUsecase = logoutUsecase,
       super(AuthInitial());
  
  /// Login do usuário
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Login attempt for: $email');
      emit(AuthLoading());
      
      final user = await _loginUsecase(email, password);
      
      AppLogger.info('Login successful for: $email');
      emit(AuthAuthenticated(user));
    } catch (e) {
      AppLogger.error('Login error: $e');
      emit(AuthError(e.toString()));
    }
  }
  
  /// Registro do usuário
  Future<void> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      AppLogger.info('Registration attempt for: $email');
      emit(AuthLoading());
      
      final user = await _registerUsecase(RegisterParams(
        email: email,
        password: password,
        displayName: displayName,
      ));
      
      AppLogger.info('Registration successful for: $email');
      emit(AuthAuthenticated(user));
    } catch (e) {
      AppLogger.error('Registration error: $e');
      emit(AuthError(e.toString()));
    }
  }
  
  /// Logout do usuário
  Future<void> logout() async {
    try {
      AppLogger.info('Logout attempt');
      emit(AuthLoading());
      
      await _logoutUsecase();
      
      AppLogger.info('Logout successful');
      emit(AuthUnauthenticated());
    } catch (e) {
      AppLogger.error('Logout error: $e');
      emit(AuthError(e.toString()));
    }
  }
  
  /// Definir usuário autenticado (para stream de auth state)
  void setAuthenticatedUser(UserEntity user) {
    emit(AuthAuthenticated(user));
  }
  
  /// Definir usuário não autenticado
  void setUnauthenticated() {
    emit(AuthUnauthenticated());
  }
  
  /// Limpar estado de erro
  void clearError() {
    if (state is AuthError) {
      emit(AuthUnauthenticated());
    }
  }
}
