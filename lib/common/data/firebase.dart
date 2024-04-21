import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ogireal_app/common/data/post/post.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataService {
  String generateUniqueUserID() {
    var random = Random();
    int randomNumber = random.nextInt(1000); // 例: 0から999まで
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
    String uniqueUserID = "${formattedDate}${randomNumber}";
    return uniqueUserID;
  }

  Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId == null) {
      userId = generateUniqueUserID();
      await prefs.setString('user_id', userId);
    }
    return userId;
  }

  Future<UserData?> fetchUserDataFromFireBase(String userId) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return convertMapToUserData(userId, data);
    } else {
      return null;
    }
  }

  Future<void> saveUserDataToFirebase(
      WidgetRef ref, String kind, var value) async {
    UserData? userData = ref.read(userDataProvider);
    if (userData != null) {
      switch (kind) {
        case 'id':
          ref.read(userDataProvider.notifier).state =
              userData.copyWith(id: value);
          break;
        case 'name':
          ref.read(userDataProvider.notifier).state =
              userData.copyWith(name: value);
          break;
        case 'icon':
          ref.read(userDataProvider.notifier).state =
              userData.copyWith(icon: value);
          break;
        case 'posts':
          ref.read(userDataProvider.notifier).state =
              userData.copyWith(posts: value);
          break;
        case 'follows':
          ref.read(userDataProvider.notifier).state =
              userData.copyWith(follows: value);
          break;
        case 'followers':
          ref.read(userDataProvider.notifier).state =
              userData.copyWith(followers: value);
          break;
        case 'goodCardIds':
          ref.read(userDataProvider.notifier).state =
              userData.copyWith(goodCardIds: value);
          break;
      }
      final Map<String, dynamic> data =
          convertUserDataToMap(ref.read(userDataProvider));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(ref.read(userDataProvider).id)
          .set(data); // 既存のデータにマージ
    }
  }
}

//dateDataこコレクションのusersPostsフィールドの中のcardIdを探して自分goodの変更を保存しにいく
Future<void> changeTargetUserCardGood(
    WidgetRef ref, Post targetUserPost, bool isLiked) async {
  String date = targetUserPost.date;
  DocumentReference dateDocRef =
      FirebaseFirestore.instance.collection('dateData').doc(date);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot dateDocSnapshot = await transaction.get(dateDocRef);

    if (dateDocSnapshot.exists && dateDocSnapshot.data() != null) {
      List<dynamic> usersPosts = dateDocSnapshot['usersPosts'];
      // 特定のcardIdを持つPostを見つける
      int postIndex = usersPosts
          .indexWhere((post) => post['cardId'] == targetUserPost.cardId);

      if (postIndex != -1) {
        Map<String, dynamic> postToUpdate = usersPosts[postIndex];
        int changeGood = isLiked ? -1 : 1;
        postToUpdate['good'] = (postToUpdate['good'] as int) + changeGood;
        usersPosts[postIndex] = postToUpdate;
        transaction.update(dateDocRef, {'usersPosts': usersPosts});
      }
    }
  });
}

//usersコレクションのtargetUserIdドキュメントのpostsフィールドの中のcardIdを探して自分goodの変更を保存しにいく
Future<void> changeTargetUserPostGood(
    WidgetRef ref, Post targetUserPost, bool isLiked) async {
  String targetUserId = targetUserPost.userId;
  DocumentReference targetUserDocRef =
      FirebaseFirestore.instance.collection('users').doc(targetUserId);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot targetUserDocSnapshot =
        await transaction.get(targetUserDocRef);

    if (targetUserDocSnapshot.exists && targetUserDocSnapshot.data() != null) {
      List<dynamic> posts = targetUserDocSnapshot['posts'];
      // 特定のcardIdを持つPostを見つける
      int postIndex =
          posts.indexWhere((post) => post['cardId'] == targetUserPost.cardId);

      if (postIndex != -1) {
        Map<String, dynamic> postToUpdate = posts[postIndex];
        int changeGood = isLiked ? -1 : 1;
        postToUpdate['good'] = (postToUpdate['good'] as int) + changeGood;
        posts[postIndex] = postToUpdate;
        transaction.update(targetUserDocRef, {'posts': posts});
      }
    }
  });
}
