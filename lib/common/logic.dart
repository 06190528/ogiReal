import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/scene/homeScene/homeSceneProvider.dart';

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
  if (userData != defaultUserData && loadingUserPosts == false) {
    canGo = true;
  }
  // print('userData: $userData');
  // print('loadingUserPosts: $loadingUserPosts');
  // print('canGo: $canGo');
  return canGo;
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

// フォアグラウンド通知状態を定期的にチェックする関数
Future<void> checkForegroundNotificationPeriodically(
    WidgetRef ref, BuildContext context) async {
  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (Common.comeForegroundNotification) {
      Navigator.of(context).pushNamed('/post');
      await GlobalData().initializeTodayDate(); // グローバルデータの初期化
      ref.read(selectedDateProvider.state).state = globalDate;
      await FirebaseFunction()
          .getDateUserPostCardIdsFromFirebase(ref, globalDateString);
      await setNowShowPostsCardIds(ref, globalDateString, false);
      Common.comeForegroundNotification = false; // 遷移後にフラグをリセット
    }
  });
}

String getSelectedDateString(WidgetRef ref) {
  final DateTime selectedDate = ref.read(selectedDateProvider);
  final String selectedDateString = DateFormat('yyyyMMdd').format(selectedDate);
  return selectedDateString;
}
