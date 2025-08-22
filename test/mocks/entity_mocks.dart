import 'package:mocktail/mocktail.dart';
import '../../lib/modules/auth/domain/entities/user_entity.dart';
import '../../lib/modules/posts/domain/entities/post_entity.dart';
import '../../lib/modules/profile/domain/entities/profile_entity.dart';

// Mock para UserEntity
class MockUserEntity extends Mock implements UserEntity {}

// Mock para PostEntity
class MockPostEntity extends Mock implements PostEntity {}

// Mock para ProfileEntity
class MockProfileEntity extends Mock implements ProfileEntity {}
