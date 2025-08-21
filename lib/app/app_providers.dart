import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../modules/auth/presentation/cubits/auth_cubit.dart';
import '../modules/auth/data/repositories/auth_repository_impl.dart';
import '../modules/auth/data/datasources/auth_remote_datasource.dart';
import '../modules/auth/domain/repositories/auth_repository.dart';
import '../modules/auth/domain/usecases/login_usecase.dart';
import '../modules/auth/domain/usecases/register_usecase.dart';
import '../modules/auth/domain/usecases/logout_usecase.dart';
import '../modules/posts/presentation/cubits/posts_cubit.dart';
import '../modules/posts/data/repositories/posts_repository_impl.dart';
import '../modules/posts/data/datasources/posts_remote_datasource.dart';
import '../modules/posts/domain/repositories/posts_repository.dart';
import '../modules/posts/domain/usecases/get_posts_usecase.dart';
import '../modules/auth/data/models/user_model.dart';
import '../modules/profile/presentation/cubits/profile_cubit.dart';
import '../modules/profile/data/repositories/profile_repository_impl.dart';
import '../modules/profile/data/datasources/profile_remote_datasource.dart';
import '../modules/profile/domain/repositories/profile_repository.dart';
import '../modules/profile/domain/usecases/get_profile_usecase.dart';
import '../modules/profile/domain/usecases/save_profile_usecase.dart';
import '../modules/profile/domain/usecases/update_profile_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Firebase Auth
        Provider<FirebaseAuth>(
          create: (_) => FirebaseAuth.instance,
        ),
        
        // Auth DataSources
        Provider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSourceImpl(
            context.read<FirebaseAuth>(),
          ),
        ),
        
        // Auth Repositories
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            context.read<AuthRemoteDataSource>(),
          ),
        ),
        
        // Auth Use Cases
        Provider<LoginUsecase>(
          create: (context) => LoginUsecase(
            context.read<AuthRepository>(),
          ),
        ),
        Provider<RegisterUsecase>(
          create: (context) => RegisterUsecase(
            context.read<AuthRepository>(),
          ),
        ),
        Provider<LogoutUsecase>(
          create: (context) => LogoutUsecase(
            context.read<AuthRepository>(),
          ),
        ),
        
        // Auth Cubit (Global)
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(
            loginUsecase: context.read<LoginUsecase>(),
            registerUsecase: context.read<RegisterUsecase>(),
            logoutUsecase: context.read<LogoutUsecase>(),
          ),
        ),
        
        // HTTP Client
        Provider<http.Client>(
          create: (_) => http.Client(),
        ),
        
        // Posts DataSources
        Provider<PostsRemoteDataSource>(
          create: (context) => PostsRemoteDataSourceImpl(
            context.read<http.Client>(),
          ),
        ),
        
        // Posts Repositories
        Provider<PostsRepository>(
          create: (context) => PostsRepositoryImpl(
            context.read<PostsRemoteDataSource>(),
          ),
        ),
        
        // Posts Use Cases
        Provider<GetPostsUsecase>(
          create: (context) => GetPostsUsecase(
            context.read<PostsRepository>(),
          ),
        ),
        
        // Posts Cubit
        BlocProvider<PostsCubit>(
          create: (context) => PostsCubit(
            getPostsUsecase: context.read<GetPostsUsecase>(),
          ),
        ),
        
        // Firebase Firestore
        Provider<FirebaseFirestore>(
          create: (_) => FirebaseFirestore.instance,
        ),
        
        // Profile DataSources
        Provider<ProfileRemoteDataSource>(
          create: (context) => ProfileRemoteDataSourceImpl(
            context.read<FirebaseFirestore>(),
          ),
        ),
        
        // Profile Repositories
        Provider<ProfileRepository>(
          create: (context) => ProfileRepositoryImpl(
            context.read<ProfileRemoteDataSource>(),
          ),
        ),
        
        // Profile Use Cases
        Provider<GetProfileUsecase>(
          create: (context) => GetProfileUsecase(
            context.read<ProfileRepository>(),
          ),
        ),
        Provider<SaveProfileUsecase>(
          create: (context) => SaveProfileUsecase(
            context.read<ProfileRepository>(),
          ),
        ),
        Provider<UpdateProfileUsecase>(
          create: (context) => UpdateProfileUsecase(
            context.read<ProfileRepository>(),
          ),
        ),
        
        // Profile Cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            getProfileUsecase: context.read<GetProfileUsecase>(),
            saveProfileUsecase: context.read<SaveProfileUsecase>(),
            updateProfileUsecase: context.read<UpdateProfileUsecase>(),
          ),
        ),
      ],
      child: AuthStateListener(child: child),
    );
  }
}

class AuthStateListener extends StatefulWidget {
  final Widget child;

  const AuthStateListener({
    super.key,
    required this.child,
  });

  @override
  State<AuthStateListener> createState() => _AuthStateListenerState();
}

class _AuthStateListenerState extends State<AuthStateListener> {
  @override
  void initState() {
    super.initState();
    // Verificar estado de autenticação quando o app inicia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authCubit = context.read<AuthCubit>();
      final firebaseAuth = context.read<FirebaseAuth>();
      
      // Listener para mudanças no estado de autenticação
      firebaseAuth.authStateChanges().listen((user) {
                 if (user != null) {
           // Usuário está logado, definir como autenticado
           authCubit.setAuthenticatedUser(UserModel(
             uid: user.uid,
             email: user.email ?? '',
             displayName: user.displayName,
             photoURL: user.photoURL,
             createdAt: DateTime.now(), // Campo obrigatório
             lastLoginAt: DateTime.now(), // Campo obrigatório
           ));
         } else {
          // Usuário não está logado
          authCubit.setUnauthenticated();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
