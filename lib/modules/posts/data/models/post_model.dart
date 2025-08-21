import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
    super.userAvatar,
    super.userName,
    super.userEmail,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  factory PostModel.fromJsonWithUser(
    Map<String, dynamic> postJson,
    Map<String, dynamic> userJson,
  ) {
    return PostModel(
      id: postJson['id'] ?? 0,
      userId: postJson['userId'] ?? 0,
      title: postJson['title'] ?? '',
      body: postJson['body'] ?? '',
      userName: userJson['name'] ?? '',
      userEmail: userJson['email'] ?? '',
      userAvatar: 'https://via.placeholder.com/150?text=${userJson['name']?[0] ?? 'U'}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'userName': userName,
      'userEmail': userEmail,
      'userAvatar': userAvatar,
    };
  }

  PostModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    String? userAvatar,
    String? userName,
    String? userEmail,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      userAvatar: userAvatar ?? this.userAvatar,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}
