import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Mock para FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Mock para User
class MockUser extends Mock implements User {}

// Mock para UserMetadata
class MockUserMetadata extends Mock implements UserMetadata {}

// Mock para UserCredential
class MockUserCredential extends Mock implements UserCredential {}

// Mock para FirebaseFirestore
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// Mock para CollectionReference
class MockCollectionReference<T> extends Mock implements CollectionReference<T> {}

// Mock para DocumentReference
class MockDocumentReference<T> extends Mock implements DocumentReference<T> {}

// Mock para DocumentSnapshot
class MockDocumentSnapshot<T> extends Mock implements DocumentSnapshot<T> {}

// Mock para QuerySnapshot
class MockQuerySnapshot<T> extends Mock implements QuerySnapshot<T> {}

// Mock para QueryDocumentSnapshot
class MockQueryDocumentSnapshot<T> extends Mock implements QueryDocumentSnapshot<T> {}

// Mock para FirebaseAuthException
class MockFirebaseAuthException extends Mock implements FirebaseAuthException {}
