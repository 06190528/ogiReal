import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/post/post.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/widget/settingWidget.dart';

Future<void> initialize(WidgetRef ref, BuildContext context) async {
  try {
    final String userId = await UserDataService().getUserId();
    if (ref.read(userDataProvider) != defaultUserData) {
      return;
    }
    UserData? userData =
        await UserDataService().fetchUserDataFromFireBase(userId);
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
    await getTodayUsersPostsAndTheme(ref, globalDate);
  } catch (e) {
    print('Error fetching user data: $e');
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> initializeMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  if (!kIsWeb && io.Platform.isAndroid) {
    final GooglePlayServicesAvailability availability =
        await GoogleApiAvailability.instance
            .checkGooglePlayServicesAvailability();

    if (availability != GooglePlayServicesAvailability.success) {
      return;
    }
  }

  // Request permission for push notifications
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  // Subscribe to topic
  try {
    await messaging.subscribeToTopic("allUsers");
  } catch (e) {
    print("Error subscribing to topic: $e");
  }

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> getTodayUsersPostsAndTheme(WidgetRef ref, String date) async {
  try {
    print('Fetching today\'s users posts and theme');
    DocumentSnapshot dateDocRef = await FirebaseFirestore.instance
        .collection('dateData')
        .doc(globalDate)
        .get();

    if (dateDocRef.exists && dateDocRef.data() != null) {
      Map<String, dynamic> data = dateDocRef.data() as Map<String, dynamic>;

      // テーマの取得と設定
      String theme =
          data['theme'] as String? ?? 'デフォルトテーマ'; // nullの場合はデフォルトテーマを使用
      ref.read(nowThemeProvider.notifier).state = theme;

      // 投稿リストの取得と設定
      if (data.containsKey('usersPosts')) {
        List<dynamic> postsList = data['usersPosts'] as List<dynamic>;
        List<Post> usersPosts = postsList.map((postData) {
          return Post.fromJson(postData as Map<String, dynamic>);
        }).toList();
        ref.read(usersPostsProvider.notifier).state = usersPosts;
      } else {
        ref.read(usersPostsProvider.notifier).state = [];
      }
    } else {
      print('Date data or theme data is not available.');
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
}
