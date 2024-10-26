import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:flutter/widgets.dart';

class Common {
  static bool comeForegroundNotification = false;

  static Size screenSize = const Size(0, 0);
}

final adLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

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

final usersPostCardIdsMapProvider =
    StateProvider<Map<String, List<String>>>((ref) {
  return {};
}); //これはfirebaseから取得した全てのPostのcardIdのみを格納する

final otherUserDataProvider =
    StateProvider.family<UserData, String>((ref, userId) {
  return defaultUserData;
});

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return globalDate;
});
