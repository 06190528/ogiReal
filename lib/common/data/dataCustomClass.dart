import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Follow extends AbstractUserData {
  Follow({
    required String id,
    required String name,
    required Image icon,
    required this.todayPost,
  }) : super(id: id, name: name, icon: icon);

  Post todayPost;
}

class Post {
  Post({
    required this.date,
    required this.answer,
    required this.theme,
    required this.good,
  });

  String date;
  String answer;
  String theme;
  int good;

  // FirebaseのDocumentSnapshotからPostオブジェクトを作成するファクトリコンストラクタ
  factory Post.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Post(
      date: data['date'] as String,
      answer: data['answer'] as String,
      theme: data['theme'] as String,
      good: data['good'] as int,
    );
  }
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
