import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared/core/utils/logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';


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
  
  
  String _getUserFriendlyMessage(String error) {
    // Erros de login
    if (error.contains('invalid-credential') || 
        error.contains('wrong-password') ||
        error.contains('user-not-found')) {
      return 'Email ou senha incorretos. Verifique suas credenciais e tente novamente.';
    }
    
    // Erros de email
    if (error.contains('invalid-email')) {
      return 'Formato de email inválido. Verifique se o email está correto.';
    }
    
    if (error.contains('email-already-in-use')) {
      return 'Este email já está sendo usado por outra conta.';
    }
    
    if (error.contains('user-disabled')) {
      return 'Esta conta foi desabilitada. Entre em contato com o suporte.';
    }
    
    // Erros de senha
    if (error.contains('weak-password')) {
      return 'A senha é muito fraca. Use uma senha com pelo menos 6 caracteres.';
    }
    
    // Erros de rede
    if (error.contains('network-request-failed') ||
        error.contains('network-error')) {
      return 'Erro de conexão. Verifique sua internet e tente novamente.';
    }
    
    if (error.contains('too-many-requests')) {
      return 'Muitas tentativas de login. Aguarde alguns minutos e tente novamente.';
    }
    
    // Erros de timeout
    if (error.contains('timeout') || error.contains('deadline-exceeded')) {
      return 'Tempo limite excedido. Verifique sua conexão e tente novamente.';
    }
    
    // Erro genérico para casos não mapeados
    return 'Ocorreu um erro inesperado. Tente novamente mais tarde.';
  }
  
  
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
      final userFriendlyMessage = _getUserFriendlyMessage(e.toString());
      emit(AuthError(userFriendlyMessage));
    }
  }
  
  
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
      final userFriendlyMessage = _getUserFriendlyMessage(e.toString());
      emit(AuthError(userFriendlyMessage));
    }
  }
  
  
  Future<void> logout() async {
    try {
      AppLogger.info('Logout attempt');
      emit(AuthLoading());
      
      await _logoutUsecase();
      
      AppLogger.info('Logout successful');
      emit(AuthUnauthenticated());
    } catch (e) {
      AppLogger.error('Logout error: $e');
      final userFriendlyMessage = _getUserFriendlyMessage(e.toString());
      emit(AuthError(userFriendlyMessage));
    }
  }
  
  
  void setAuthenticatedUser(UserEntity user) {
    emit(AuthAuthenticated(user));
  }
  
  
  void setUnauthenticated() {
    emit(AuthUnauthenticated());
  }
  
  
  void clearError() {
    if (state is AuthError) {
      emit(AuthUnauthenticated());
    }
  }
}
