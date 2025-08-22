import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../shared/core/constants/app_constants.dart';
import '../../../shared/core/utils/logger.dart';
import '../models/post_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getPosts({
    int? page,
    int? limit,
    bool refresh = false,
  });
  
  Future<PostModel> getPostById(int id);
  
  Future<List<PostModel>> getPostsByUser(int userId);
  
  Future<int> getPostsCount();
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final http.Client client;
  
  PostsRemoteDataSourceImpl(this.client);
  
  @override
  Future<List<PostModel>> getPosts({
    int? page,
    int? limit,
    bool refresh = false,
  }) async {
    try {
      AppLogger.info('Fetching posts - Page: $page, Limit: $limit');
      
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.postsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> postsJson = json.decode(response.body);
        final posts = postsJson.map((json) => PostModel.fromJson(json)).toList();
        
        
        if (page != null && limit != null) {
          final startIndex = (page - 1) * limit;
          final endIndex = startIndex + limit;
          final paginatedPosts = posts.sublist(
            startIndex,
            endIndex > posts.length ? posts.length : endIndex,
          );
          
          AppLogger.info('Posts fetched successfully - ${paginatedPosts.length} posts');
          return paginatedPosts;
        }
        
        AppLogger.info('Posts fetched successfully - ${posts.length} posts');
        return posts;
      } else {
        AppLogger.error('Failed to fetch posts - Status: ${response.statusCode}');
        throw Exception('Failed to fetch posts');
      }
    } catch (e) {
      AppLogger.error('Error fetching posts: $e');
      rethrow;
    }
  }
  
  @override
  Future<PostModel> getPostById(int id) async {
    try {
      AppLogger.info('Fetching post with ID: $id');
      
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.postsEndpoint}/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final postJson = json.decode(response.body);
        final post = PostModel.fromJson(postJson);
        
        AppLogger.info('Post fetched successfully - ID: $id');
        return post;
      } else {
        AppLogger.error('Failed to fetch post - Status: ${response.statusCode}');
        throw Exception('Failed to fetch post');
      }
    } catch (e) {
      AppLogger.error('Error fetching post: $e');
      rethrow;
    }
  }
  
  @override
  Future<List<PostModel>> getPostsByUser(int userId) async {
    try {
      AppLogger.info('Fetching posts for user: $userId');
      
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.postsEndpoint}?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> postsJson = json.decode(response.body);
        final posts = postsJson.map((json) => PostModel.fromJson(json)).toList();
        
        AppLogger.info('User posts fetched successfully - ${posts.length} posts');
        return posts;
      } else {
        AppLogger.error('Failed to fetch user posts - Status: ${response.statusCode}');
        throw Exception('Failed to fetch user posts');
      }
    } catch (e) {
      AppLogger.error('Error fetching user posts: $e');
      rethrow;
    }
  }
  
  @override
  Future<int> getPostsCount() async {
    try {
      AppLogger.info('Fetching posts count');
      
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.postsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> postsJson = json.decode(response.body);
        final count = postsJson.length;
        
        AppLogger.info('Posts count fetched successfully - $count posts');
        return count;
      } else {
        AppLogger.error('Failed to fetch posts count - Status: ${response.statusCode}');
        throw Exception('Failed to fetch posts count');
      }
    } catch (e) {
      AppLogger.error('Error fetching posts count: $e');
      rethrow;
    }
  }
}
