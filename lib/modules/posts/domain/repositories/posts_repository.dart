import '../../../shared/core/utils/either.dart';
import '../../../shared/core/errors/failures.dart';
import '../entities/post_entity.dart';

abstract class PostsRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts({
    int? page,
    int? limit,
    bool refresh = false,
  });
  
  Future<Either<Failure, PostEntity>> getPostById(int id);
  
  Future<Either<Failure, List<PostEntity>>> getPostsByUser(int userId);
  
  Future<Either<Failure, int>> getPostsCount();
}
