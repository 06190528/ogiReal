import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/post/post.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/common/provider.dart';

final countdownTimerProvider =
    StateNotifierProvider<CountdownTimerNotifier, int>((ref) {
  return CountdownTimerNotifier();
});

final postProvider = StateProvider<Post>((ref) {
  return defaultPost;
});

const defaultPost = Post(
  userName: '',
  userId: '',
  date: '',
  answer: '',
  theme: '',
  good: 0,
  cardId: '',
);

class CountdownTimerNotifier extends StateNotifier<int> {
  CountdownTimerNotifier() : super(300); // 300 seconds for 5 minutes

  Timer? _timer;

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state > 0) {
        state--;
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

Future<void> savePostCardToFirebase(WidgetRef ref) async {
  final Post post = ref.read(postProvider);
  final UserData userData = ref.read(userDataProvider);
  final String? userId = userData.id;
  final String? userName = userData.name;

  if (userId == null || userName == null) {
    print('投稿できませんでした');
    return;
  }

  // 現在の日時からカード ID を生成
  final String cardId =
      DateFormat('yyyyMMddHHmmss').format(DateTime.now()) + userId;

  final updatedPost = post.copyWith(
    userName: userName,
    userId: userId,
    date: globalDate,
    theme: ref.read(nowThemeProvider),
    good: 0,
    cardId: cardId, // カード ID を設定
  );

  ref.read(postProvider.state).state = updatedPost;

  // 'dateData' コレクション内の 'globalDate' ドキュメントを取得
  DocumentSnapshot dateDocRef = await FirebaseFirestore.instance
      .collection('dateData')
      .doc(globalDate)
      .get();

  if (!dateDocRef.exists) {
    print('指定された日付のデータが存在しません。');
    return;
  }

  // usersPostsリストを更新
  await FirebaseFirestore.instance
      .collection('dateData')
      .doc(globalDate)
      .update({
    'usersPosts': FieldValue.arrayUnion([updatedPost.toJson()])
  });

  // users コレクションにも投稿データを更新
  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'posts': FieldValue.arrayUnion([updatedPost.toJson()])
  });
}
