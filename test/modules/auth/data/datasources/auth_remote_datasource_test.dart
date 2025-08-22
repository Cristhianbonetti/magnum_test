import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../mocks/firebase_mocks.dart';
import '../../../../../lib/modules/auth/data/datasources/auth_remote_datasource.dart';
import '../../../../../lib/modules/auth/data/models/user_model.dart';

void main() {
  late AuthRemoteDataSourceImpl authRemoteDataSource;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    
    authRemoteDataSource = AuthRemoteDataSourceImpl(mockFirebaseAuth);
    
    // Configurar mocks
    when(() => mockUser.uid).thenReturn('test-uid');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.displayName).thenReturn('Test User');
    when(() => mockUser.photoURL).thenReturn('https://example.com/photo.jpg');
    
    // Configurar metadata mock
    final mockMetadata = MockUserMetadata();
    when(() => mockMetadata.creationTime).thenReturn(DateTime(2024, 1, 1));
    when(() => mockMetadata.lastSignInTime).thenReturn(DateTime(2024, 1, 2));
    when(() => mockUser.metadata).thenReturn(mockMetadata);
    
    when(() => mockUserCredential.user).thenReturn(mockUser);
  });

  group('AuthRemoteDataSource', () {
    group('login', () {
      test('should return UserModel when login is successful', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await authRemoteDataSource.login(
          email: email,
          password: password,
        );

        // Assert
        expect(result, isA<UserModel>());
        expect(result.uid, equals('test-uid'));
        expect(result.email, equals('test@example.com'));
        expect(result.displayName, equals('Test User'));
        expect(result.photoURL, equals('https://example.com/photo.jpg'));
        
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
      });

      test('should throw FirebaseAuthException when login fails', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrong-password';
        const errorMessage = 'Invalid credentials';
        
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(FirebaseAuthException(
          code: 'user-not-found',
          message: errorMessage,
        ));

        // Act & Assert
        expect(
          () => authRemoteDataSource.login(email: email, password: password),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('register', () {
      test('should return UserModel when registration is successful', () async {
        // Arrange
        const email = 'new@example.com';
        const password = 'password123';
        const displayName = 'New User';
        
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockUserCredential);
        
        when(() => mockUser.updateDisplayName(displayName))
            .thenAnswer((_) async {});

        // Act
        final result = await authRemoteDataSource.register(
          email: email,
          password: password,
          displayName: displayName,
        );

        // Assert
        expect(result, isA<UserModel>());
        expect(result.uid, equals('test-uid'));
        expect(result.email, equals('test@example.com'));
        
        verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
        verify(() => mockUser.updateDisplayName(displayName)).called(1);
      });

      test('should throw FirebaseAuthException when registration fails', () async {
        // Arrange
        const email = 'invalid-email';
        const password = 'short';
        
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(FirebaseAuthException(
          code: 'invalid-email',
          message: 'Invalid email format',
        ));

        // Act & Assert
        expect(
          () => authRemoteDataSource.register(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('logout', () {
      test('should call signOut on FirebaseAuth', () async {
        // Arrange
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        // Act
        await authRemoteDataSource.logout();

        // Assert
        verify(() => mockFirebaseAuth.signOut()).called(1);
      });

      test('should throw FirebaseAuthException when logout fails', () async {
        // Arrange
        when(() => mockFirebaseAuth.signOut()).thenThrow(
          FirebaseAuthException(
            code: 'network-error',
            message: 'Network error',
          ),
        );

        // Act & Assert
        expect(
          () => authRemoteDataSource.logout(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('updateProfile', () {
      test('should update displayName and photoURL successfully', () async {
        // Arrange
        const displayName = 'Updated Name';
        const photoURL = 'https://example.com/new-photo.jpg';
        
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.updateDisplayName(displayName))
            .thenAnswer((_) async {});
        when(() => mockUser.updatePhotoURL(photoURL))
            .thenAnswer((_) async {});

        // Act
        await authRemoteDataSource.updateProfile(
          displayName: displayName,
          photoURL: photoURL,
        );

        // Assert
        verify(() => mockUser.updateDisplayName(displayName)).called(1);
        verify(() => mockUser.updatePhotoURL(photoURL)).called(1);
      });

      test('should throw FirebaseAuthException when no user is logged in', () async {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        // Act & Assert
        expect(
          () => authRemoteDataSource.updateProfile(
            displayName: 'New Name',
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('deleteAccount', () {
      test('should delete account successfully', () async {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.delete()).thenAnswer((_) async {});

        // Act
        await authRemoteDataSource.deleteAccount();

        // Assert
        verify(() => mockUser.delete()).called(1);
      });

      test('should throw FirebaseAuthException when no user is logged in', () async {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        // Act & Assert
        expect(
          () => authRemoteDataSource.deleteAccount(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('currentUser', () {
      test('should return UserModel when user is logged in', () {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        // Act
        final result = authRemoteDataSource.currentUser;

        // Assert
        expect(result, isA<UserModel>());
        expect(result?.uid, equals('test-uid'));
      });

      test('should return null when no user is logged in', () {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        final result = authRemoteDataSource.currentUser;

        // Assert
        expect(result, isNull);
      });
    });
  });
}
