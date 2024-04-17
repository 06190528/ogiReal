import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';

part 'userData.freezed.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String? id,
    required String? name,
    required Image? icon,
    required List<Post> posts,
    required List<Follow> follows,
    required List<AbstractUserData> followers,
  }) = _UserData;
}

UserData convertMapToUserData(String userId, Map<String, dynamic> data) {
  return UserData(
    id: data['id'],
    name: data['name'],
    icon: data['icon'],
    posts: [], // データに応じて適切に変換
    follows: [], // データに応じて適切に変換
    followers: [], // データに応じて適切に変換
  );
}

Map<String, dynamic> convertUserDataToMap(UserData userData) {
  return {
    'id': userData.id,
    'name': userData.name,
    'icon': userData.icon,
    'posts': userData.posts,
    'follows': userData.follows,
    'followers': userData.followers,
  };
}
