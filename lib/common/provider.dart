import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';

final userDataProvider = StateProvider<UserData>((ref) {
  return UserData(
    id: null,
    name: null,
    icon: null,
    posts: [],
    follows: [],
    followers: [],
  );
});

final nowThemeProvider = StateProvider<String>((ref) {
  return 'default';
});

final usersPostsProvider = StateProvider<List<Post>>((ref) {
  return [];
});
