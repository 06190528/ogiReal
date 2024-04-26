import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/data/post/post.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';

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

final usersPostsProvider = StateProvider<List<Post>>((ref) {
  return [];
});
