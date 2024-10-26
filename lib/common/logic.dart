import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/scene/homeScene/homeSceneProvider.dart';
import 'package:rate_my_app/rate_my_app.dart';

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

//レビュー
Future<void> requestReview(BuildContext context) async {
  // RateMyAppインスタンスを指定された条件で初期化
  final RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 0, // アプリインストール後すぐにダイアログを表示する条件を満たす
    remindDays: 2, // 「後で」を選択した場合、2日後に再提示
    minLaunches: 0, // 起動回数に基づく条件を満たす（初回起動から表示可能）
    remindLaunches: 0, // 「後で」を選択した場合、次回起動時に再提示
  );

  await rateMyApp.init();

  if (rateMyApp.shouldOpenDialog) {
    // ignore: use_build_context_synchronously
    rateMyApp.showRateDialog(
      context,
      title: 'Rate this app',
      message:
          'If you like this app, please take a little bit of your time to review it!',
      rateButton: 'RATE',
      noButton: 'NO THANKS',
      laterButton: 'MAYBE LATER',
      listener: (button) {
        switch (button) {
          case RateMyAppDialogButton.rate:
            print('Clicked on "Rate"');
            break;
          case RateMyAppDialogButton.later:
            print('Clicked on "Later"');
            break;
          case RateMyAppDialogButton.no:
            print('Clicked on "No"');
            break;
        }
        return true;
      },
    );
  } else {
    print('e');
  }
}
