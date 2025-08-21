import '../../../shared/core/utils/either.dart';
import '../../../shared/core/errors/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetPostsParams {
  final int? page;
  final int? limit;
  final bool refresh;
  
  const GetPostsParams({
    this.page,
    this.limit,
    this.refresh = false,
  });
}

class GetPostsUsecase {
  final PostsRepository repository;
  
  const GetPostsUsecase(this.repository);
  
  Future<Either<Failure, List<PostEntity>>> call(GetPostsParams params) async {
    return await repository.getPosts(
      page: params.page,
      limit: params.limit,
      refresh: params.refresh,
    );
  }
}
