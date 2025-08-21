class AppConstants {
  // API
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String usersEndpoint = '/users';
  static const String postsEndpoint = '/posts';
  static const String commentsEndpoint = '/comments';
  
  // Firebase
  static const String usersCollection = 'users';
  static const String profilesCollection = 'profiles';
  
  // Pagination
  static const int postsPerPage = 10;
  static const int maxPostsLimit = 100;
  
  // Cache
  static const Duration cacheExpiration = Duration(minutes: 30);
  
  // Routes
  static const String authRoute = '/auth';
  static const String postsRoute = '/posts';
  static const String postDetailRoute = '/posts/detail';
  static const String profileRoute = '/profile';
  
  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration authTimeout = Duration(seconds: 15);
}

