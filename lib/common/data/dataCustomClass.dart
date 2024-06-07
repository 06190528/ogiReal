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

  DateTime todayDate;
  DateTime startAt;
  DateTime endAt;
  String globalDateStringFromFirebase;

  factory GlobalData() {
    return _instance;
  }

  GlobalData._internal()
      : todayDate = DateTime.now(),
        startAt = DateTime.now(),
        endAt = DateTime.now(),
        globalDateStringFromFirebase =
            DateFormat('yyyyMMdd').format(DateTime.now());

  Future<void> initializeTodayDate() async {
    var todayDateDoc = await FirebaseFirestore.instance
        .collection('todayDate')
        .doc('todayDate')
        .get();

    if (todayDateDoc.exists) {
      // Firestoreから取得したデータをDateTimeに変換
      globalDateStringFromFirebase =
          todayDateDoc.data()?['todayDate'] as String;
      if (globalDateStringFromFirebase != null) {
        try {
          DateTime parsedTodayDate =
              DateFormat('yyyyMMdd').parse(globalDateStringFromFirebase);
          todayDate = DateTime(
              parsedTodayDate.year, parsedTodayDate.month, parsedTodayDate.day);
        } catch (e) {
          print('Error parsing todayDate: $e');
        }
      }
      String? startAtString = todayDateDoc.data()?['start_at'] as String?;
      if (startAtString != null) {
        try {
          DateTime startAt1 = DateFormat('HH:mm').parse(startAtString);
          DateTime now = DateTime.now();
          startAt = DateTime(
              now.year, now.month, now.day, startAt1.hour, startAt1.minute);
        } catch (e) {
          print('Error parsing startAt: $e');
        }
      }

      String? endAtString = todayDateDoc.data()?['end_at'] as String?;
      if (endAtString != null) {
        try {
          DateTime endAt1 = DateFormat('HH:mm').parse(endAtString);
          DateTime now = DateTime.now();
          endAt = DateTime(
              now.year, now.month, now.day, endAt1.hour, endAt1.minute);
        } catch (e) {
          print('Error parsing endAt: $e');
        }
      }
    } else {
      print('Document does not exist');
    }
  }
}

// globalDateをDateTime型として取得するためのゲッター
String get globalDateString => GlobalData().globalDateStringFromFirebase;
DateTime get globalDate => GlobalData().todayDate;
DateTime get globalStartAt => GlobalData().startAt;
DateTime get globalEndAt => GlobalData().endAt;
