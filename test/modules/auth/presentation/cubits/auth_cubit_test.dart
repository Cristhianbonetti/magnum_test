import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../mocks/entity_mocks.dart';
import '../../../../../lib/modules/auth/domain/usecases/login_usecase.dart';
import '../../../../../lib/modules/auth/domain/usecases/register_usecase.dart';
import '../../../../../lib/modules/auth/domain/usecases/logout_usecase.dart';
import '../../../../../lib/modules/auth/presentation/cubits/auth_cubit.dart';
import '../../../../../lib/modules/auth/presentation/cubits/auth_cubit.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}
class MockRegisterUsecase extends Mock implements RegisterUsecase {}
class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late AuthCubit authCubit;
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockUserEntity mockUserEntity;

  setUpAll(() {
    registerFallbackValue(const RegisterParams(
      email: 'test@example.com',
      password: 'password123',
      displayName: 'Test User',
    ));
  });

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockRegisterUsecase = MockRegisterUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockUserEntity = MockUserEntity();
    
    authCubit = AuthCubit(
      loginUsecase: mockLoginUsecase,
      registerUsecase: mockRegisterUsecase,
      logoutUsecase: mockLogoutUsecase,
    );
    

  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    test('initial state should be AuthInitial', () {
      expect(authCubit.state, isA<AuthInitial>());
    });

    group('login', () {
      const email = 'test@example.com';
      const password = 'password123';

      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when login is successful',
        build: () {
          when(() => mockLoginUsecase(email, password))
              .thenAnswer((_) async => mockUserEntity);
          return authCubit;
        },
        act: (cubit) => cubit.login(email: email, password: password),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthAuthenticated>(),
        ],
        verify: (_) {
          verify(() => mockLoginUsecase(email, password)).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, AuthError] when login fails',
        build: () {
          when(() => mockLoginUsecase(email, password))
              .thenThrow(Exception('Login failed'));
          return authCubit;
        },
        act: (cubit) => cubit.login(email: email, password: password),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>(),
        ],
        verify: (_) {
          verify(() => mockLoginUsecase(email, password)).called(1);
        },
      );
    });

    group('register', () {
      const email = 'new@example.com';
      const password = 'password123';
      const displayName = 'New User';

      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when registration is successful',
        build: () {
          when(() => mockRegisterUsecase(any())).thenAnswer((_) async => mockUserEntity);
          return authCubit;
        },
        act: (cubit) => cubit.register(
          email: email,
          password: password,
          displayName: displayName,
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthAuthenticated>(),
        ],
        verify: (_) {
          verify(() => mockRegisterUsecase(any())).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, AuthError] when registration fails',
        build: () {
          when(() => mockRegisterUsecase(any())).thenThrow(Exception('Registration failed'));
          return authCubit;
        },
        act: (cubit) => cubit.register(
          email: email,
          password: password,
          displayName: displayName,
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>(),
        ],
        verify: (_) {
          verify(() => mockRegisterUsecase(any())).called(1);
        },
      );
    });

    group('logout', () {
      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, AuthUnauthenticated] when logout is successful',
        build: () {
          when(() => mockLogoutUsecase()).thenAnswer((_) async {});
          return authCubit;
        },
        act: (cubit) => cubit.logout(),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthUnauthenticated>(),
        ],
        verify: (_) {
          verify(() => mockLogoutUsecase()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, AuthError] when logout fails',
        build: () {
          when(() => mockLogoutUsecase()).thenThrow(Exception('Logout failed'));
          return authCubit;
        },
        act: (cubit) => cubit.logout(),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>(),
        ],
        verify: (_) {
          verify(() => mockLogoutUsecase()).called(1);
        },
      );
    });

    group('setAuthenticatedUser', () {
      test('should emit AuthAuthenticated with user', () {
        // Act
        authCubit.setAuthenticatedUser(mockUserEntity);

        // Assert
        expect(authCubit.state, isA<AuthAuthenticated>());
        expect((authCubit.state as AuthAuthenticated).user, equals(mockUserEntity));
      });
    });

    group('clearError', () {
      test('should emit AuthUnauthenticated when clearing error state', () {
        // Arrange
        authCubit.emit(AuthError('Test error'));
        expect(authCubit.state, isA<AuthError>());

        // Act
        authCubit.clearError();

        // Assert
        expect(authCubit.state, isA<AuthUnauthenticated>());
      });
    });
  });
}
