import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import '../../../../mocks/http_mocks.dart';
import '../../../../../lib/modules/posts/data/datasources/posts_remote_datasource.dart';
import '../../../../../lib/modules/posts/data/models/post_model.dart';

void main() {
  late PostsRemoteDataSourceImpl postsRemoteDataSource;
  late MockHttpClient mockHttpClient;
  late MockHttpResponse mockHttpResponse;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockHttpResponse = MockHttpResponse();
    
    postsRemoteDataSource = PostsRemoteDataSourceImpl(mockHttpClient);
  });

  group('PostsRemoteDataSource', () {
    group('getPosts', () {
      test('should return list of posts when HTTP call is successful', () async {
        // Arrange
        const responseBody = '''
        [
          {
            "id": 1,
            "title": "Test Post 1",
            "body": "Test content 1",
            "userId": 1
          },
          {
            "id": 2,
            "title": "Test Post 2",
            "body": "Test content 2",
            "userId": 2
          }
        ]
        ''';
        
        final fakeResponse = FakeHttpResponse(statusCode: 200, body: responseBody);
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => fakeResponse);

        // Act
        final result = await postsRemoteDataSource.getPosts();

        // Assert
        expect(result, isA<List<PostModel>>());
        expect(result.length, equals(2));
        expect(result[0].title, equals('Test Post 1'));
        expect(result[1].title, equals('Test Post 2'));
        
        verify(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).called(1);
      });

      test('should return paginated posts when page and limit are provided', () async {
        // Arrange
        const responseBody = '''
        [
          {
            "id": 1,
            "title": "Test Post 1",
            "body": "Test content 1",
            "userId": 1
          }
        ]
        ''';
        
        final fakeResponse = FakeHttpResponse(statusCode: 200, body: responseBody);
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => fakeResponse);

        // Act
        final result = await postsRemoteDataSource.getPosts(page: 1, limit: 1);

        // Assert
        expect(result, isA<List<PostModel>>());
        expect(result.length, equals(1));
        expect(result[0].title, equals('Test Post 1'));
      });

      test('should throw exception when HTTP call fails', () async {
        // Arrange
        final fakeResponse = FakeHttpResponse(statusCode: 500, body: 'Internal Server Error');
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => fakeResponse);

        // Act & Assert
        expect(
          () => postsRemoteDataSource.getPosts(),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when network error occurs', () async {
        // Arrange
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => postsRemoteDataSource.getPosts(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getPostById', () {
      test('should return post when HTTP call is successful', () async {
        // Arrange
        const responseBody = '''
        {
          "id": 1,
          "title": "Test Post",
          "body": "Test content",
          "userId": 1
        }
        ''';
        
        final fakeResponse = FakeHttpResponse(statusCode: 200, body: responseBody);
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => fakeResponse);

        // Act
        final result = await postsRemoteDataSource.getPostById(1);

        // Assert
        expect(result, isA<PostModel>());
        expect(result.id, equals(1));
        expect(result.title, equals('Test Post'));
        expect(result.body, equals('Test content'));
        
        verify(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).called(1);
      });

      test('should throw exception when post not found', () async {
        // Arrange
        final fakeResponse = FakeHttpResponse(statusCode: 404, body: 'Post not found');
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => fakeResponse);

        // Act & Assert
        expect(
          () => postsRemoteDataSource.getPostById(999),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getPostsByUser', () {
            test('should return user posts when HTTP call is successful', () async {
        // Arrange
        const responseBody = '''
        [
          {
            "id": 1,
            "title": "User Post 1",
            "body": "User content 1",
            "userId": 1
          }
        ]
        ''';
        
        final fakeResponse = FakeHttpResponse(statusCode: 200, body: responseBody);
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => fakeResponse);

        // Act
        final result = await postsRemoteDataSource.getPostsByUser(1);

        // Assert
        expect(result, isA<List<PostModel>>());
        expect(result.length, equals(1));
        expect(result[0].userId, equals(1));
        
        verify(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).called(1);
      });
    });

    group('getPostsCount', () {
      test('should return posts count when HTTP call is successful', () async {
        // Arrange
        const responseBody = '''
        [
          {"id": 1, "title": "Post 1"},
          {"id": 2, "title": "Post 2"},
          {"id": 3, "title": "Post 3"}
        ]
        ''';
        
        final fakeResponse = FakeHttpResponse(statusCode: 200, body: responseBody);
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => fakeResponse);

        // Act
        final result = await postsRemoteDataSource.getPostsCount();

        // Assert
        expect(result, equals(3));
        
        verify(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).called(1);
      });
    });
  });
}
