import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/postScene.dart/postScneneProvider.dart';

void navigateAndRemoveUntil(
    BuildContext context, Widget targetPage, String targetRouteName) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => targetPage),
    (Route<dynamic> route) => route.settings.name == targetRouteName,
  );
}

bool canGoNextScene(WidgetRef ref) {
  bool canGo = false;
  final userData = ref.read(userDataProvider);
  final theme = ref.read(nowThemeProvider);
  final usersPosts = ref.read(usersPostCardIdsMapProvider);
  final usersPostCardIdsMap = ref.read(usersPostCardIdsMapProvider);
  if (userData != defaultUserData &&
      theme != 'default' &&
      usersPosts.isNotEmpty &&
      usersPostCardIdsMap.isNotEmpty) {
    canGo = true;
  }

  return canGo;
}

Future<void> setTargetUserAllPosts(UserData userData, WidgetRef ref) async {
  print('setTargetUserAllPosts');
  final userId = ref.read(userDataProvider).id;
  final List<String> userPostsCardIds = userData.userPostsCardIds;
  List<String> setCardIds = [];
  Map<String, List<String>> usersPostCardIdsMap =
      ref.read(usersPostCardIdsMapProvider); // 現在の状態を読み取る
  Map<String, List<String>> addNewUsersPostCardIdsMap = {};

  if (userId == null) return;
  if (usersPostCardIdsMap[userId] != null) {
    if (usersPostCardIdsMap[userId]!.isNotEmpty) return;
  }

  for (var userPostCardId in userPostsCardIds) {
    if (ref.read(targetPostProvider(userPostCardId)) != defaultPost ||
        await setTargetPostProviderFromFirebase(ref, userPostCardId)) {
      //ここ怪しい
      setCardIds.add(userPostCardId);
    }
  }
  addNewUsersPostCardIdsMap.addAll({
    userId: setCardIds,
  });

  setUsersPostCardIdsMapProvider(ref, addNewUsersPostCardIdsMap);
}

void setUsersPostCardIdsMapProvider(
    WidgetRef ref, Map<String, List<String>> addNewUsersPostCardIdsMap) {
  Map<String, List<String>> currentMap = Map<String, List<String>>.from(
      ref.read(usersPostCardIdsMapProvider.state).state);
  currentMap.addAll(addNewUsersPostCardIdsMap);
  ref.read(usersPostCardIdsMapProvider.notifier).state = currentMap;
}
