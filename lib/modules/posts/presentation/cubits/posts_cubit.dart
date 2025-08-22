import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared/core/utils/logger.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts_usecase.dart';

abstract class PostsState extends Equatable {
  const PostsState();
  
  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostEntity> posts;
  final bool hasReachedMax;
  final int currentPage;
  
  const PostsLoaded({
    required this.posts,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });
  
  PostsLoaded copyWith({
    List<PostEntity>? posts,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return PostsLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
  
  @override
  List<Object?> get props => [posts, hasReachedMax, currentPage];
}

class PostsError extends PostsState {
  final String message;
  
  const PostsError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class PostsCubit extends Cubit<PostsState> {
  final GetPostsUsecase _getPostsUsecase;
  
  PostsCubit({
    required GetPostsUsecase getPostsUsecase,
  }) : _getPostsUsecase = getPostsUsecase,
       super(PostsInitial());
  
  Future<void> loadPosts({bool refresh = false}) async {
    try {
      if (refresh) {
        AppLogger.info('Refreshing posts');
        emit(PostsLoading());
        
        final result = await _getPostsUsecase(const GetPostsParams(
          page: 1,
          limit: 10,
          refresh: true,
        ));
        
        result.fold(
          (failure) {
            AppLogger.error('Failed to refresh posts: ${failure.message}');
            emit(PostsError(failure.message));
          },
          (posts) {
            AppLogger.info('Posts refreshed successfully - ${posts.length} posts');
            emit(PostsLoaded(
              posts: posts,
              hasReachedMax: posts.length < 10,
              currentPage: 1,
            ));
          },
        );
      } else {
        if (state is PostsLoaded) {
          final currentState = state as PostsLoaded;
          
          if (currentState.hasReachedMax) {
            AppLogger.info('Already reached max posts');
            return;
          }
          
          AppLogger.info('Loading more posts - Page: ${currentState.currentPage + 1}');
          
          final result = await _getPostsUsecase(GetPostsParams(
            page: currentState.currentPage + 1,
            limit: 10,
            refresh: false,
          ));
          
          result.fold(
            (failure) {
              AppLogger.error('Failed to load more posts: ${failure.message}');
              emit(PostsError(failure.message));
            },
            (newPosts) {
              if (newPosts.isEmpty) {
                AppLogger.info('No more posts available');
                emit(currentState.copyWith(hasReachedMax: true));
              } else {
                AppLogger.info('More posts loaded successfully - ${newPosts.length} posts');
                final allPosts = [...currentState.posts, ...newPosts];
                emit(currentState.copyWith(
                  posts: allPosts,
                  hasReachedMax: newPosts.length < 10,
                  currentPage: currentState.currentPage + 1,
                ));
              }
            },
          );
        } else {
          AppLogger.info('Loading posts for the first time');
          emit(PostsLoading());
          
          final result = await _getPostsUsecase(const GetPostsParams(
            page: 1,
            limit: 10,
            refresh: false,
          ));
          
          result.fold(
            (failure) {
              AppLogger.error('Failed to load posts: ${failure.message}');
              emit(PostsError(failure.message));
            },
            (posts) {
              AppLogger.info('Posts loaded successfully - ${posts.length} posts');
              emit(PostsLoaded(
                posts: posts,
                hasReachedMax: posts.length < 10,
                currentPage: 1,
              ));
            },
          );
        }
      }
    } catch (e) {
      AppLogger.error('Error in loadPosts: $e');
      emit(PostsError(e.toString()));
    }
  }
  
  void clearPosts() {
    AppLogger.info('Clearing posts state');
    emit(PostsInitial());
  }
}
