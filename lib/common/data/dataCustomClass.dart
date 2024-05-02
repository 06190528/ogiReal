import 'package:intl/intl.dart'; // 日付の解析に必要
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ogireal_app/common/data/post/post.dart';

class Follow extends AbstractUserData {
  Follow({
    required String id,
    required String name,
    required Image icon,
    required this.todayPost,
  }) : super(id: id, name: name, icon: icon);

  Post todayPost;
}

class AbstractUserData {
  AbstractUserData({
    this.id,
    this.name,
    this.icon,
  });

  String? id;
  String? name;
  Image? icon;
}

class GlobalData {
  static final GlobalData _instance = GlobalData._internal();

  String todayDate; // late finalを削除し、デフォルト値を設定するかnull許容型にする
  DateTime startAt;
  DateTime endAt;

  factory GlobalData() {
    return _instance;
  }

  GlobalData._internal()
      : todayDate = '', // デフォルトの値を設定
        startAt = DateTime.now(), // デフォルトの値を設定
        endAt = DateTime.now(); // デフォルトの値を設定

  Future<void> initializeTodayDate() async {
    var todayDateDoc = await FirebaseFirestore.instance
        .collection('todayDate')
        .doc('todayDate')
        .get();

    // 文字列をDateTimeに変換
    todayDate = todayDateDoc.data()?['todayDate'] as String;
    DateTime startAt1 =
        DateFormat("HH:mm").parse(todayDateDoc.data()?['start_at'] as String);
    DateTime endAt1 =
        DateFormat("HH:mm").parse(todayDateDoc.data()?['end_at'] as String);

    // 現在の日付を使って時刻のみのDateTimeに日付情報を追加
    DateTime now = DateTime.now();
    startAt =
        DateTime(now.year, now.month, now.day, startAt1.hour, startAt1.minute);
    endAt = DateTime(now.year, now.month, now.day, endAt1.hour, endAt1.minute);
  }
}

String get globalDate => GlobalData().todayDate;
DateTime get globalStartAt => GlobalData().startAt;
DateTime get globalEndAt => GlobalData().endAt;
