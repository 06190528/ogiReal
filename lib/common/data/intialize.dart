import 'dart:async';
import 'dart:io' as io;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/main.dart';
import 'package:ogireal_app/widget/settingWidget.dart';

Future<void> initialize(WidgetRef ref, BuildContext context) async {
  try {
    final String userId = await UserDataService().getUserId();
    if (ref.read(userDataProvider) != defaultUserData) {
      return;
    }
    UserData? userData =
        await UserDataService().fetchUserDataFromFirebase(userId);
    if (userData != null) {
      ref.read(userDataProvider.notifier).state = userData;
    } else {
      userData = ref.read(userDataProvider);
      ref.read(userDataProvider.notifier).state =
          ref.read(userDataProvider).copyWith(id: userId);
      UserDataService().saveUserDataToFirebase(ref, 'id', userId);
      if (userData != null && userData.name == null) {
        showDialog(
            context: context,
            builder: (context) {
              return SettingAbstractWidget(
                title: 'ユーザー名の登録',
                explanation: 'ユーザー名を入力してください',
                kind: 'name',
              );
            });
      }
    }
    initializeMessaging();
  } catch (e) {
    print('Error fetching user data initialize: $e');
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  main();
}

Future<void> initializeMessaging() async {
  print('initializeMessaging');
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final String? fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $fcmToken");

  // プラットフォームがAndroidかつWebではない場合、Google Play Servicesのチェック
  if (!kIsWeb && io.Platform.isAndroid) {
    final GooglePlayServicesAvailability availability =
        await GoogleApiAvailability.instance
            .checkGooglePlayServicesAvailability();
    if (availability != GooglePlayServicesAvailability.success) {
      return;
    }
  }

  // 通知の許可をユーザーに求める
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  // 通知の許可状態を確認
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  // 特定のトピックを購読
  try {
    await messaging.subscribeToTopic("allUsers");
    print("Subscribed to topic allUsers");
  } catch (e) {
    print("Error subscribing to topic: $e");
  }

  // フォアグランドで通知を受け取ったときの処理
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Got a message whilst in the foreground!");
    print("Message data: ${message.data}");

    if (message.notification != null) {
      print(
          "Message also contained a notification: ${message.notification!.title}, ${message.notification!.body}");
    }
    print('onMessage');

    // ここにフォアグランドで受信したときに実行したい処理を書く
    handleForegroundNotification(message);
  });

  // バックグラウンドメッセージハンドラーを設定
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> handleForegroundNotification(
  RemoteMessage message,
) async {
  // restartApp(); // アRプリをリスタートする
  print('handleForegroundNotification');
}
