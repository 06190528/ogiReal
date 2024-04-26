import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';

part 'userData.freezed.dart';

@freezed
class UserData with _$UserData {
  const factory UserData(
      {required String? id,
      required String? name,
      required Image? icon,
      required List<String> userPostsCardIds,
      required List<Follow> follows,
      required List<AbstractUserData> followers,
      required List<String> goodCardIds}) = _UserData;
}

UserData convertMapToUserData(String userId, Map<String, dynamic> data) {
  return UserData(
    id: data['id'],
    name: data['name'],
    icon: data['icon'],
    userPostsCardIds: List<String>.from(data['userPostsCardIds'] ?? []),
    follows: [], // データに応じて適切に変換
    followers: [], // データに応じて適切に変換
    goodCardIds: [],
  );
}

Map<String, dynamic> convertUserDataToMap(UserData userData) {
  return {
    'id': userData.id,
    'name': userData.name,
    'icon': userData.icon,
    'userPostsCardIds': userData.userPostsCardIds,
    'follows': userData.follows,
    'followers': userData.followers,
    'goodCardsIds': userData.goodCardIds,
  };
}
