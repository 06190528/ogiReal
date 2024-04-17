import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
