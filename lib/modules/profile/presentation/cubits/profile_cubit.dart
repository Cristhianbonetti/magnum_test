import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared/core/utils/logger.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/save_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

// Estados
abstract class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  
  const ProfileLoaded(this.profile);
  
  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;
  
  const ProfileError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class ProfileSaved extends ProfileState {
  final ProfileEntity profile;
  
  const ProfileSaved(this.profile);
  
  @override
  List<Object?> get props => [profile];
}

class ProfileUpdated extends ProfileState {
  final ProfileEntity profile;
  
  const ProfileUpdated(this.profile);
  
  @override
  List<Object?> get props => [profile];
}

// Cubit
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUsecase _getProfileUsecase;
  final SaveProfileUsecase _saveProfileUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  
  ProfileCubit({
    required GetProfileUsecase getProfileUsecase,
    required SaveProfileUsecase saveProfileUsecase,
    required UpdateProfileUsecase updateProfileUsecase,
  }) : _getProfileUsecase = getProfileUsecase,
       _saveProfileUsecase = saveProfileUsecase,
       _updateProfileUsecase = updateProfileUsecase,
       super(ProfileInitial());
  
  /// Carregar perfil do usuário
  Future<void> loadProfile(String uid) async {
    try {
      AppLogger.info('Loading profile for user: $uid');
      emit(ProfileLoading());
      
      final result = await _getProfileUsecase(GetProfileParams(uid));
      
              result.fold(
          (failure) {
            AppLogger.error('Failed to load profile: ${failure.message}');
            emit(ProfileError(failure.message));
          },
          (profile) {
            if (profile != null) {
              AppLogger.info('Profile loaded successfully for user: $uid');
              emit(ProfileLoaded(profile));
            } else {
              AppLogger.info('Profile not found for user: $uid');
              emit(ProfileError('Profile not found'));
            }
          },
        );
      } catch (e) {
        AppLogger.error('Error loading profile: $e');
        emit(ProfileError(e.toString()));
      }
  }
  
  /// Salvar perfil
  Future<void> saveProfile(ProfileEntity profile) async {
    try {
      AppLogger.info('Saving profile for user: ${profile.uid}');
      emit(ProfileLoading());
      
      final result = await _saveProfileUsecase(SaveProfileParams(profile));
      
      result.fold(
        (failure) {
          AppLogger.error('Failed to save profile: ${failure.message}');
          emit(ProfileError(failure.message));
        },
        (success) {
          if (success) {
            AppLogger.info('Profile saved successfully for user: ${profile.uid}');
            emit(ProfileSaved(profile));
          } else {
            AppLogger.error('Failed to save profile');
            emit(ProfileError('Failed to save profile'));
          }
        },
      );
    } catch (e) {
      AppLogger.error('Error saving profile: $e');
      emit(ProfileError(e.toString()));
    }
  }
  
  /// Atualizar perfil
  Future<void> updateProfile(String uid, Map<String, dynamic> updates) async {
    try {
      AppLogger.info('Updating profile for user: $uid');
      emit(ProfileLoading());
      
      final result = await _updateProfileUsecase(UpdateProfileParams(
        uid: uid,
        updates: updates,
      ));
      
      result.fold(
        (failure) {
          AppLogger.error('Failed to update profile: ${failure.message}');
          emit(ProfileError(failure.message));
        },
        (success) {
          if (success) {
            AppLogger.info('Profile updated successfully for user: $uid');
            // Recarregar o perfil para refletir as mudanças
            loadProfile(uid);
          } else {
            AppLogger.error('Failed to update profile');
            emit(ProfileError('Failed to update profile'));
          }
        },
      );
    } catch (e) {
      AppLogger.error('Error updating profile: $e');
      emit(ProfileError(e.toString()));
    }
  }
  
  /// Atualizar idade
  Future<void> updateAge(String uid, int age) async {
    await updateProfile(uid, {'age': age});
  }
  
  /// Atualizar interesses
  Future<void> updateInterests(String uid, List<String> interests) async {
    await updateProfile(uid, {'interests': interests});
  }
  
  /// Atualizar bio
  Future<void> updateBio(String uid, String bio) async {
    await updateProfile(uid, {'bio': bio});
  }
  
  /// Limpar estado
  void clearProfile() {
    AppLogger.info('Clearing profile state');
    emit(ProfileInitial());
  }
}
