import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/post/post.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/common/logic.dart';
import 'package:ogireal_app/common/provider.dart';

final countdownTimerProvider =
    StateNotifierProvider<CountdownTimerNotifier, int>((ref) {
  return CountdownTimerNotifier();
});

final postProvider = StateProvider<Post>((ref) {
  return defaultPost;
});

final todayUserCanPostCountProvider = StateProvider<int>((ref) {
  return 0;
});

final themesProvider = StateProvider.family<String, String>((ref, date) {
  return 'default';
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

  final selectedDateString = getSelectedDateString(ref);
  final String cardId = selectedDateString +
      '_' +
      DateFormat('HHmmss').format(DateTime.now()) +
      "_" + // スラッシュをアンダースコアに置き換えました
      userId;

  Post updatedPost = post.copyWith(
    userName: userName,
    userId: userId,
    date: selectedDateString,
    theme: ref.read(themesProvider(selectedDateString)),
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
    await FirebaseFunction().setUsersPostCardIdToFIrebaseDateUserPostCardIds(
        ref, cardId, globalDateString);
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

Future<void> setTodayUserCanPostCount(WidgetRef ref) async {
  final UserData userData = ref.read(userDataProvider);
  final List<String> userPostCardIds = userData.userPostsCardIds;
  String selectedDayString = getSelectedDateString(ref);

  bool didPostInLimit = false;
  int todayUserPostedCount = 0;

  await Future.forEach(userPostCardIds, (String cardId) async {
    final parts = cardId.split('_');
    final cardDate = parts[0];
    if (cardDate == selectedDayString) {
      final timeStr = parts[1];
      final formattedTime =
          "${timeStr.substring(0, 2)}:${timeStr.substring(2, 4)}:${timeStr.substring(4, 6)}";
      final cardDateTime = DateTime.parse('$cardDate $formattedTime');
      final startDateTime = DateTime.parse(globalStartAt.toString());
      final endDateTime = DateTime.parse(globalEndAt.toString());
      if (startDateTime.isBefore(cardDateTime) &&
          cardDateTime.isBefore(endDateTime)) {
        didPostInLimit = true;
      }
      todayUserPostedCount++;
    }
  });

  if (!didPostInLimit) {
    ref.read(todayUserCanPostCountProvider.state).state =
        1 - todayUserPostedCount;
  } else {
    ref.read(todayUserCanPostCountProvider.state).state =
        3 - todayUserPostedCount;
  }
}
