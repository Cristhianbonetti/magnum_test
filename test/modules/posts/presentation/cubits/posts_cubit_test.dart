import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../mocks/entity_mocks.dart';
import '../../../../../lib/modules/posts/domain/usecases/get_posts_usecase.dart';
import '../../../../../lib/modules/posts/presentation/cubits/posts_cubit.dart';
import '../../../../../lib/modules/shared/core/utils/either.dart';
import '../../../../../lib/modules/shared/core/errors/failures.dart';
import '../../../../../lib/modules/posts/presentation/cubits/posts_cubit.dart';

class MockGetPostsUsecase extends Mock implements GetPostsUsecase {}

void main() {
  late PostsCubit postsCubit;
  late MockGetPostsUsecase mockGetPostsUsecase;
  late MockPostEntity mockPostEntity;

  setUpAll(() {
    registerFallbackValue(const GetPostsParams());
  });

  setUp(() {
    mockGetPostsUsecase = MockGetPostsUsecase();
    mockPostEntity = MockPostEntity();
    
    postsCubit = PostsCubit(getPostsUsecase: mockGetPostsUsecase);
  });

  tearDown(() {
    postsCubit.close();
  });

  group('PostsCubit', () {
    test('initial state should be PostsInitial', () {
      expect(postsCubit.state, isA<PostsInitial>());
    });

    group('loadPosts', () {
      blocTest<PostsCubit, PostsState>(
        'should emit [PostsLoading, PostsLoaded] when loading posts for the first time is successful',
        build: () {
          when(() => mockGetPostsUsecase(const GetPostsParams(
            page: 1,
            limit: 10,
            refresh: false,
          ))).thenAnswer((_) async => Right([mockPostEntity]));
          return postsCubit;
        },
        act: (cubit) => cubit.loadPosts(),
        expect: () => [
          isA<PostsLoading>(),
          isA<PostsLoaded>(),
        ],
        verify: (_) {
          verify(() => mockGetPostsUsecase(const GetPostsParams(
            page: 1,
            limit: 10,
            refresh: false,
          ))).called(1);
        },
      );

      blocTest<PostsCubit, PostsState>(
        'should emit [PostsLoading, PostsLoaded] when refreshing posts is successful',
        build: () {
          when(() => mockGetPostsUsecase(const GetPostsParams(
            page: 1,
            limit: 10,
            refresh: true,
          ))).thenAnswer((_) async => Right([mockPostEntity]));
          return postsCubit;
        },
        act: (cubit) => cubit.loadPosts(refresh: true),
        expect: () => [
          isA<PostsLoading>(),
          isA<PostsLoaded>(),
        ],
        verify: (_) {
          verify(() => mockGetPostsUsecase(const GetPostsParams(
            page: 1,
            limit: 10,
            refresh: true,
          ))).called(1);
        },
      );

      blocTest<PostsCubit, PostsState>(
        'should emit [PostsLoading, PostsError] when loading posts fails',
        build: () {
          when(() => mockGetPostsUsecase(const GetPostsParams(
            page: 1,
            limit: 10,
            refresh: false,
          ))).thenThrow(Exception('Failed to load posts'));
          return postsCubit;
        },
        act: (cubit) => cubit.loadPosts(),
        expect: () => [
          isA<PostsLoading>(),
          isA<PostsError>(),
        ],
        verify: (_) {
          verify(() => mockGetPostsUsecase(const GetPostsParams(
            page: 1,
            limit: 10,
            refresh: false,
          ))).called(1);
        },
      );
    });

    group('loadMorePosts via loadPosts', () {
      blocTest<PostsCubit, PostsState>(
        'should load more posts successfully when not at max',
        build: () {
          // Setup initial state with posts
          postsCubit.emit(PostsLoaded(
            posts: [mockPostEntity],
            currentPage: 1,
            hasReachedMax: false,
          ));
          
          when(() => mockGetPostsUsecase(any())).thenAnswer((_) async => Right([mockPostEntity]));
          return postsCubit;
        },
        act: (cubit) => cubit.loadPosts(),
        expect: () => [
          isA<PostsLoaded>(),
        ],
        verify: (_) {
          verify(() => mockGetPostsUsecase(any())).called(1);
        },
      );

      blocTest<PostsCubit, PostsState>(
        'should not load more posts when already at max',
        build: () {
          postsCubit.emit(PostsLoaded(
            posts: [mockPostEntity],
            currentPage: 1,
            hasReachedMax: true,
          ));
          return postsCubit;
        },
        act: (cubit) => cubit.loadPosts(),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockGetPostsUsecase(any()));
        },
      );

      blocTest<PostsCubit, PostsState>(
        'should emit PostsError when loading more posts fails',
        build: () {
          postsCubit.emit(PostsLoaded(
            posts: [mockPostEntity],
            currentPage: 1,
            hasReachedMax: false,
          ));
          
          when(() => mockGetPostsUsecase(any())).thenThrow(Exception('Failed to load more posts'));
          return postsCubit;
        },
        act: (cubit) => cubit.loadPosts(),
        expect: () => [
          isA<PostsError>(),
        ],
        verify: (_) {
          verify(() => mockGetPostsUsecase(any())).called(1);
        },
      );
    });

    group('clearPosts', () {
      test('should emit PostsInitial when clearing posts', () {
        // Arrange
        postsCubit.emit(PostsLoaded(
          posts: [mockPostEntity],
          currentPage: 1,
          hasReachedMax: false,
        ));
        expect(postsCubit.state, isA<PostsLoaded>());

        // Act
        postsCubit.clearPosts();

        // Assert
        expect(postsCubit.state, isA<PostsInitial>());
      });
    });
  });
}
