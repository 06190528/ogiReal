import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  blockedUserIds: [],
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

final nowShowPostCardIdsProvider = StateProvider<List<String>>((ref) {
  return [];
});

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

bool comeForegroundNotification = false;
