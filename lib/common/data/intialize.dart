import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:intl/intl.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/widget/settingWidget.dart';

Future<void> initialize(WidgetRef ref, BuildContext context) async {
  try {
    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyyMMdd').format(now);
    final String userId = await UserDataService().getUserId();
    print('User ID: $userId');
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
    getTodayUsersPostsAndTheme(ref, todayDate);
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
    print("Subscribed to topic: allUsers");
  } catch (e) {
    print("Error subscribing to topic: $e");
  }

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> getTodayUsersPostsAndTheme(WidgetRef ref, String date) async {
  //firebaseからテーマとusersPostsとる
  DocumentSnapshot themeDoc =
      await FirebaseFirestore.instance.collection('themes').doc(date).get();
  DocumentSnapshot usersPostsDoc =
      await FirebaseFirestore.instance.collection('usersPosts').doc(date).get();

  if (themeDoc.exists) {
    String theme = themeDoc['theme'];
    ref.read(nowThemeProvider.notifier).state = theme;

    if (usersPostsDoc.exists && usersPostsDoc.data() != null) {
      print('Users posts data: ${usersPostsDoc.data()}');
      Map<String, dynamic> postsData =
          usersPostsDoc.data() as Map<String, dynamic>;
      List<Post> usersPosts = postsData.entries.map((entry) {
        return Post.fromSnapshot(entry.value as DocumentSnapshot);
      }).toList();
      ref.read(usersPostsProvider.notifier).state = usersPosts;
    }
  }
}
