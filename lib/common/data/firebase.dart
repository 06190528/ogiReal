import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/post/post.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/common/logic.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/scene/homeScene/homeSceneProvider.dart';
import 'package:ogireal_app/scene/postScene.dart/postScneneProvider.dart';
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

  Future<UserData?> fetchUserDataFromFirebase(String userId) async {
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
        case 'userPostsCardIds':
          ref.read(userDataProvider.notifier).state =
              userData.copyWith(userPostsCardIds: value);
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

Future<void> setThemeToProviderFromFirebase(WidgetRef ref) async {
  if (ref.read(nowThemeProvider) == 'default') {
    DocumentSnapshot themeDocRef = await FirebaseFirestore.instance
        .collection('theme')
        .doc(globalDate)
        .get();
    if (themeDocRef.exists && themeDocRef.data() != null) {
      Map<String, dynamic> data = themeDocRef.data() as Map<String, dynamic>;
      String theme = data['theme'] as String? ?? 'デフォルトテーマ';
      ref.read(nowThemeProvider.notifier).state = theme;
    } else {
      print('Date data or theme data is not available.');
    }
  }
}

//新しいusersPostCardIdsMapProviderを作成し同じでなければ代入して変更を通知
//firebaseから同じものは取らないようにする.
Future<void> getGlobalDateUsersPosts(WidgetRef ref, String globalDate) async {
  try {
    print('getGlobalDateUsersPosts');
    final List<String>? globalDateUsersPostsCardIdsMap =
        ref.read(usersPostCardIdsMapProvider)[globalDate];
    if (globalDateUsersPostsCardIdsMap == null) {
      loadingUserPosts = true;
      //まだ誰も投稿していない時の処理
      QuerySnapshot usersPostsQuery = await FirebaseFirestore.instance
          .collection('usersPosts')
          .where('date', isEqualTo: globalDate)
          .get();

      List<Post> usersPosts = usersPostsQuery.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      if (usersPosts.isNotEmpty) {
        print('usersPosts.isNotEmpty');
        for (int i = 0; i < usersPosts.length; i++) {
          final String cardId = usersPosts[i].cardId;
          if (await setTargetPostProviderFromFirebase(ref, cardId)) {
            await setUsersPostCardIdToMapProvider(ref, cardId, globalDate);
          }
        }
      }
      loadingUserPosts = false;
    }

    if (ref.read(usersPostCardIdsMapProvider)[globalDate] == null) {
      //まだ誰も投稿していない
      ref.read(usersPostCardIdsMapProvider.state).state[globalDate] = [];
      print('no usersPosts');
    }
    // 日付フィールドを使ってusersPostsコレクションからドキュメントを検索
  } catch (e) {
    print('Error fetching user data getTodayUsersPostsAndTheme: $e');
  }
}

//user'sPostsのtargetCardIdをのgoodCountを更新
Future<void> changeTargetCardGood(
    WidgetRef ref, Post targetUserPost, bool isLiked) async {
  String targetCardId = targetUserPost.cardId;
  final userId = ref.read(userDataProvider).id;
  if (userId == null) return;

  DocumentReference targetCardDocRef =
      FirebaseFirestore.instance.collection('usersPosts').doc(targetCardId);
  int incrementValue = isLiked ? -1 : 1;
  await targetCardDocRef
      .update({'goodCount': FieldValue.increment(incrementValue)});
}

//firebaseから大喜利カードを取ってくれる
Future<bool> setTargetPostProviderFromFirebase(
    WidgetRef ref, String cardId) async {
  if (ref.read(targetPostProvider(cardId)) != defaultPost) {
    return false;
  }
  ;
  final doc = await FirebaseFirestore.instance
      .collection('usersPosts')
      .doc(cardId)
      .get();
  if (!doc.exists) return false;
  final post = Post.fromJson(doc.data() as Map<String, dynamic>);
  ref.read(targetPostProvider(cardId).notifier).update((state) => post);
  return true;
}

Future<void> getTargetUserData(WidgetRef ref, String targetUserId) async {
  if (ref.read(otherUserDataProvider(targetUserId)) != defaultUserData) {
    return ref.read(otherUserDataProvider(targetUserId));
  }
  UserData targetUserData = defaultUserData;
  try {
    targetUserData =
        await UserDataService().fetchUserDataFromFirebase(targetUserId) ??
            defaultUserData;
    ref.read(otherUserDataProvider(targetUserId).notifier).state =
        targetUserData;
  } catch (e) {
    print('Error fetching target user data: $e');
  }
}


// Future<void> setUserCardIdToFIrebaseDateUserPostCardIds(DateTime date, String cardId) async {
//   final dateStr = date.toString();
//   final docRef = FirebaseFirestore.instance.collection('dateUserPostCardIds').doc(dateStr);
  
// }   