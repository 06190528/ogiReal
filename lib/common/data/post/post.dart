import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
  const Post._(); // プライベートコンストラクタを追加

  @JsonSerializable(explicitToJson: true) // JSONシリアライズの設定を追加
  const factory Post({
    required String userId,
    required String userName,
    required String date,
    required String answer,
    required String theme,
    required int good,
    required String cardId,
  }) = _Post;

  factory Post.fromSnapshot(DocumentSnapshot snapshot) =>
      Post.fromJson(snapshot.data() as Map<String, dynamic>);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
