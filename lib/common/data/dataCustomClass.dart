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
  late final String todayDate;

  factory GlobalData() {
    return _instance;
  }

  GlobalData._internal();

  Future<void> initializeTodayDate() async {
    var todayDateDoc = await FirebaseFirestore.instance
        .collection('todayDate')
        .doc('todayDate')
        .get();
    todayDate = todayDateDoc.data()?['todayDate'] as String;
  }
}

String get globalDate => GlobalData().todayDate;
