import '../../../shared/core/utils/either.dart';
import '../../../shared/core/errors/failures.dart';
import '../../../shared/core/utils/logger.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_remote_datasource.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource _remoteDataSource;
  
  PostsRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<Either<Failure, List<PostEntity>>> getPosts({
    int? page,
    int? limit,
    bool refresh = false,
  }) async {
    try {
      AppLogger.info('Getting posts - Page: $page, Limit: $limit');
      
      final posts = await _remoteDataSource.getPosts(
        page: page,
        limit: limit,
        refresh: refresh,
      );
      
      AppLogger.info('Posts retrieved successfully - ${posts.length} posts');
      return Right(posts);
    } catch (e) {
      AppLogger.error('Error getting posts: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, PostEntity>> getPostById(int id) async {
    try {
      AppLogger.info('Getting post by ID: $id');
      
      final post = await _remoteDataSource.getPostById(id);
      
      AppLogger.info('Post retrieved successfully - ID: $id');
      return Right(post);
    } catch (e) {
      AppLogger.error('Error getting post by ID: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<PostEntity>>> getPostsByUser(int userId) async {
    try {
      AppLogger.info('Getting posts for user: $userId');
      
      final posts = await _remoteDataSource.getPostsByUser(userId);
      
      AppLogger.info('User posts retrieved successfully - ${posts.length} posts');
      return Right(posts);
    } catch (e) {
      AppLogger.error('Error getting user posts: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, int>> getPostsCount() async {
    try {
      AppLogger.info('Getting posts count');
      
      final count = await _remoteDataSource.getPostsCount();
      
      AppLogger.info('Posts count retrieved successfully - $count posts');
      return Right(count);
    } catch (e) {
      AppLogger.error('Error getting posts count: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
