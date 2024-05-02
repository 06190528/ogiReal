import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/firebase.dart';
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
  goodCount: 0,
  cardId: '',
);

class CountdownTimerNotifier extends StateNotifier<int> {
  CountdownTimerNotifier() : super(300);

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

  void setCountdown(int inSeconds) {
    state = inSeconds;
    if (inSeconds > 0) {
      startTimer();
    } else {
      stopTimer();
    }
  }
}

Future<void> createAndSavePostCardToFirebase(WidgetRef ref) async {
  final Post post = ref.read(postProvider);
  final UserData userData = ref.read(userDataProvider);
  final String? userId = userData.id;
  final String? userName = userData.name;

  if (userId == null || userName == null) {
    print('必要なユーザー情報がありません');
    return;
  }

  final String cardId = globalDate +
      '_' +
      DateFormat('HHmmss').format(DateTime.now()) +
      "_" + // スラッシュをアンダースコアに置き換えました
      userId;

  Post updatedPost = post.copyWith(
    userName: userName,
    userId: userId,
    date: globalDate,
    theme: ref.read(nowThemeProvider),
    goodCount: 0,
    cardId: cardId,
  );

  ref.read(postProvider.state).state = updatedPost;

  List<String> userPostsCardIds = List<String>.from(userData.userPostsCardIds);
  userPostsCardIds.add(cardId);
  await UserDataService()
      .saveUserDataToFirebase(ref, 'userPostsCardIds', userPostsCardIds);

  try {
    await FirebaseFirestore.instance
        .collection('usersPosts')
        .doc(cardId)
        .set(updatedPost.toJson());
  } catch (e) {
    print('投稿エラー: $e');
  }
}

Future<void> setCountDownToProvider(WidgetRef ref) async {
  DateTime now = DateTime.now();

  // 現在時刻が指定された時間範囲内にあるかどうかを判定します。
  if (now.isAfter(globalStartAt) && now.isBefore(globalEndAt)) {
    Duration remaining = globalEndAt.difference(now);
    ref.read(countdownTimerProvider.notifier).setCountdown(remaining.inSeconds);
  } else {
    ref.read(countdownTimerProvider.notifier).setCountdown(0);
  }
}
