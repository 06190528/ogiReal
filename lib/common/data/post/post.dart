import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required String userId,
    required String userName,
    required String date,
    required String answer,
    required String theme,
    required int goodCount,
    required String cardId,
  }) = _Post;

  // Freezed による自動生成メソッドを使用
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
