import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/scene/homeScene/homeSceneProvider.dart';
import 'package:ogireal_app/scene/postScene.dart/postScneneProvider.dart';

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
  if (userData != defaultUserData &&
      theme != 'default' &&
      loadingUserPosts == false) {
    //usersPosts設定されているkeyのvalueがあるかどうか確認しないとあかん
    canGo = true;
  }
  print('userData: $userData');
  print('theme: $theme');
  print('loadingUserPosts: $loadingUserPosts');
  print('canGo: $canGo');
  return canGo;
}

Future<void> setTargetUserAllPosts(UserData userData, WidgetRef ref) async {
  final userId = ref.read(userDataProvider).id;
  final List<String> userPostsCardIds = userData.userPostsCardIds;
  Map<String, List<String>> usersPostCardIdsMap =
      ref.read(usersPostCardIdsMapProvider); // 現在の状態を読み取る

  if (userId == null) return;
  if (usersPostCardIdsMap[userId] != null) {
    if (usersPostCardIdsMap[userId]!.isNotEmpty) return;
  }

  for (var userPostCardId in userPostsCardIds) {
    if (ref.read(targetPostProvider(userPostCardId)) != defaultPost ||
        await setTargetPostProviderFromFirebase(ref, userPostCardId)) {
      //ここれがあるかないかでクラッシュする
      await setUsersPostCardIdToMapProvider(ref, userPostCardId, userId);
    }
  }
  await Future.delayed(Duration(seconds: 5));
}

Future<void> setUsersPostCardIdToMapProvider(
    WidgetRef ref, String cardId, String key) async {
  Map<String, List<String>> currentMap = Map<String, List<String>>.from(
      ref.read(usersPostCardIdsMapProvider.state).state);
  if (currentMap[key] != null) {
    if (currentMap[key]!.contains(cardId)) return;
  }
  currentMap.update(key, (value) => value..add(cardId),
      ifAbsent: () => [cardId]);
  ref.read(usersPostCardIdsMapProvider.notifier).state = currentMap;
}

void updateUsersPostCardIds(WidgetRef ref, List<String> newCardIds) {
  Map<String, List<String>> currentMap =
      Map.from(ref.read(usersPostCardIdsMapProvider));
  currentMap[globalDate] = newCardIds;
  ref.read(usersPostCardIdsMapProvider.notifier).state = currentMap;
}
