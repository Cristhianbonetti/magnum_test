import 'package:flutter/material.dart';
import '../modules/auth/presentation/pages/auth_page.dart';
import '../modules/auth/presentation/pages/auth_check_page.dart';
import '../modules/posts/presentation/pages/posts_page.dart';
import '../modules/profile/presentation/pages/profile_page.dart';
import '../modules/posts/presentation/pages/post_detail_page.dart';
import '../modules/posts/domain/entities/post_entity.dart';

class AppRouter {
  static const String home = '/';
  static const String auth = '/auth';
  static const String posts = '/posts';
  static const String profile = '/profile';
  static const String postDetail = '/post-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const AuthCheckPage(),
          settings: settings,
        );
      
      case auth:
        return MaterialPageRoute(
          builder: (_) => const AuthPage(),
          settings: settings,
        );
      
      case posts:
        return MaterialPageRoute(
          builder: (_) => const PostsPage(),
          settings: settings,
        );
      
      case profile:
        final userId = settings.arguments as String? ?? '1';
        return MaterialPageRoute(
          builder: (_) => ProfilePage(userId: userId),
          settings: settings,
        );
      
      case postDetail:
        final post = settings.arguments as PostEntity;
        return MaterialPageRoute(
          builder: (_) => PostDetailPage(post: post),
          settings: settings,
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Rota não encontrada'),
            ),
          ),
        );
    }
  }
}
