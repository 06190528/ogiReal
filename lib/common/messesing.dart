// import 'dart:async';
// import 'dart:io' as io;

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:google_api_availability/google_api_availability.dart';
// import 'package:ogireal_app/common/provider.dart';

// // Future<void> initializeNotifications() async {
// //   FirebaseMessaging messaging = FirebaseMessaging.instance;

// //   // プッシュ通知の許可を求める
// //   NotificationSettings settings = await messaging.requestPermission(
// //     alert: true,
// //     badge: true,
// //     sound: true,
// //     provisional: false,
// //   );

// //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
// //     print("User granted permission");
// //   } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
// //     print("User granted provisional permission");
// //   } else {
// //     print("User declined or has not accepted permission");
// //   }

// //   // ローカル通知の初期設定
// //   var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
// //   var initializationSettingsIOS = DarwinInitializationSettings(
// //     requestAlertPermission: false,
// //     requestBadgePermission: false,
// //     requestSoundPermission: false,
// //     onDidReceiveLocalNotification: onDidReceiveLocalNotification,
// //   );
// //   var initializationSettings = InitializationSettings(
// //     android: initializationSettingsAndroid,
// //     iOS: initializationSettingsIOS,
// //   );
// //   await flutterLocalNotificationsPlugin.initialize(
// //     initializationSettings,
// //     // onDidReceiveNotificationResponse: onSelectNotification,
// //   );

// //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //     handleForegroundNotification(message);
// //   });
// // }

// // void handleForegroundNotification(RemoteMessage message) async {
// //   RemoteNotification? notification = message.notification;
// //   AndroidNotification? android = message.notification?.android;
// //   print('handleForegroundNotification');
// //   print('notification: $notification');
// //   print('android: $android');

// //   if (notification != null
// //       // && android != null
// //       ) {
// //     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
// //         'your channel id', 'your channel name',
// //         importance: Importance.max, priority: Priority.high, showWhen: true);
// //     var platformChannelSpecifics =
// //         NotificationDetails(android: androidPlatformChannelSpecifics);
// //     print('通知を表示します');
// //     await flutterLocalNotificationsPlugin.show(notification.hashCode,
// //         notification.title, notification.body, platformChannelSpecifics);
// //   }
// //   comeForegroundNotification = true;
// //   print('comeForegroundNotification: $comeForegroundNotification');
// // }

// void onDidReceiveLocalNotification(
//     int id, String? title, String? body, String? payload) {
//   // Handle local notification
// }

// Future<void> onSelectNotification(String? payload) async {
//   // Handle selection of notification
// }

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

// Future<void> initializeMessaging() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   final String? fcmToken = await FirebaseMessaging.instance.getToken();
//   print("FCM Token: $fcmToken");

//   // プラットフォームがAndroidかつWebではない場合、Google Play Servicesのチェック
//   if (!kIsWeb && io.Platform.isAndroid) {
//     final GooglePlayServicesAvailability availability =
//         await GoogleApiAvailability.instance
//             .checkGooglePlayServicesAvailability();
//     if (availability != GooglePlayServicesAvailability.success) {
//       return;
//     }
//   }

//   // iOS と Android の通知の許可をユーザーに求める
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//     announcement: false, // iOS 13.0+ でアナウンスメントを許可
//     carPlay: false, // iOS 10.0+ でカープレイを許可
//     criticalAlert: false, // iOS 12.0+ でクリティカルアラートを許可 (特別な承認が必要)
//     provisional: false, // iOS 12.0+ でプロビジョナル通知を許可
//   );

//   // 通知の許可状態を確認
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('User granted permission');
//   } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//     print('User granted provisional permission');
//   } else {
//     print('User declined or has not accepted permission');
//   }

//   // 特定のトピックを購読
//   try {
//     await messaging.subscribeToTopic("allUsers");
//     print("Subscribed to topic allUsers");
//   } catch (e) {
//     print("Error subscribing to topic: $e");
//   }

//   // フォアグランドで通知を受け取ったときの処理
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('フォアグランドで通知を受け取りました');
//     handleForegroundNotification(message);
//   });

//   // バックグラウンドメッセージハンドラーを設定
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// }


// // // void initializeLocalNotification(
// // //     Function(int, String?, String?, String?)?
// // //         onDidReceiveLocalNotification) async {
// // //   print('initializeLocalNotification');

// // //   // Androidの通知設定
// // //   const AndroidInitializationSettings initializationSettingsAndroid =
// // //       AndroidInitializationSettings('assets/images/app_icon.jpg');

// // //   // iOSの初期設定
// // //   DarwinInitializationSettings initializationSettingsIOS =
// // //       DarwinInitializationSettings(
// // //     requestAlertPermission: true,
// // //     requestBadgePermission: true,
// // //     requestSoundPermission: true,
// // //     onDidReceiveLocalNotification: onDidReceiveLocalNotification, // 追加した関数を参照
// // //   );

// // //   final InitializationSettings initializationSettings = InitializationSettings(
// // //     android: initializationSettingsAndroid,
// // //     iOS: initializationSettingsIOS,
// // //   );

// // //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
// // // }
