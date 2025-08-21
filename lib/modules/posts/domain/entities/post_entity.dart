import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String body;
  final String? userAvatar;
  final String? userName;
  final String? userEmail;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.userAvatar,
    this.userName,
    this.userEmail,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        body,
        userAvatar,
        userName,
        userEmail,
      ];
}
