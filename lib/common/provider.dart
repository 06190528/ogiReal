import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/data/post/post.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/scene/postScene.dart/postScneneProvider.dart';

const defaultUserData = UserData(
  id: null,
  name: null,
  icon: null,
  userPostsCardIds: [],
  follows: [],
  followers: [],
  goodCardIds: [],
);
final userDataProvider = StateProvider<UserData>((ref) {
  return defaultUserData;
});

final nowThemeProvider = StateProvider<String>((ref) {
  return 'default';
});

final usersPostCardIdsMapProvider =
    StateProvider<Map<String, List<String>>>((ref) {
  return {};
}); //これはfirebaseから取得した全てのPostのcardIdのみを格納する

final targetPostProvider = StateProvider.family<Post, String>((ref, carId) {
  return defaultPost;
}); //usersPostsMapProviderを使ってPostを取得する

final otherUserDataProvider =
    StateProvider.family<UserData, String>((ref, userId) {
  return defaultUserData;
});
