import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/post/post.dart';
import 'package:ogireal_app/common/logic.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/widget/ogiriCardWidget.dart';

final ogiriCardsProvider = StateProvider<List<OgiriCard>>((ref) => []);
final nowSelectSortTypeProvider = StateProvider<String>((ref) => sortTypes[0]);
final selectedDayProvider = StateProvider<DateTime?>((ref) {
  return null;
});
bool loadingUserPosts = false;

void pushCardGoodButton(WidgetRef ref, Post post, bool isLiked) {
  final userData = ref.read(userDataProvider);
  final goodCardIds = List<String>.from(userData.goodCardIds);
  var targetCardGoodCount = post.goodCount;
  if (userData.id == null) return;

  if (isLiked && goodCardIds.contains(post.cardId)) {
    goodCardIds.remove(post.cardId);
    targetCardGoodCount--;
  } else if (!isLiked && !goodCardIds.contains(post.cardId)) {
    goodCardIds.add(post.cardId);
    targetCardGoodCount++;
  }
  ref.read(targetPostProvider(post.cardId).notifier).state =
      post.copyWith(goodCount: targetCardGoodCount);
  UserDataService().saveUserDataToFirebase(ref, 'goodCardIds', goodCardIds);
  FirebaseFunction().changeTargetCardGood(ref, post, isLiked);
}

Future<void> sortNowShowPostCardIds(WidgetRef ref, String SortType) async {
  //コピーする
  List<String>? nowShowPostCardIds =
      List<String>.from(ref.read(nowShowPostCardIdsProvider));
  if (nowShowPostCardIds == null) return;
  switch (SortType) {
    case '新着':
      nowShowPostCardIds.sort((a, b) => b.compareTo(a));
      ref.read(nowShowPostCardIdsProvider.state).state = nowShowPostCardIds;
      break;
    case 'ランキング':
      List<Post> posts = [];
      for (String cardId in nowShowPostCardIds) {
        Post post = ref.read(targetPostProvider(cardId));
        posts.add(post);
      }
      posts.sort((a, b) => b.goodCount.compareTo(a.goodCount));
      List<String> sortedCardIds = posts.map((post) => post.cardId).toList();
      nowShowPostCardIds = sortedCardIds;
    default:
      nowShowPostCardIds.sort((a, b) => b.compareTo(a));
      break;
  }
  ref.read(nowShowPostCardIdsProvider.state).state = nowShowPostCardIds;
}

Future<void> setNowShowPostsCardIds(WidgetRef ref, String key) async {
  // if (ref.read(nowShowPostCardIdsProvider) != []) return;
  final userData = ref.read(userDataProvider);
  final blockedUserIds = userData.blockedUserIds;
  final globalDateUsersPostCardIds =
      ref.watch(usersPostCardIdsMapProvider)[key];
  List<String> nowShowPostsCardIds = [];
  if (globalDateUsersPostCardIds == null) return;
  for (String cardId in globalDateUsersPostCardIds) {
    String userId = cardId.split('_')[2];
    if (!blockedUserIds.contains(userId)) {
      nowShowPostsCardIds.add(cardId);
    }
  }
  ref.read(nowShowPostCardIdsProvider.state).state = nowShowPostsCardIds;
}

void changeSelectedDay(WidgetRef ref, DateTime selectedDay) async {
  ref.read(nowSelectSortTypeProvider.state).state = sortTypes[0];
  await getSpecificDateUsersPosts(ref, selectedDay.toString());
  await sortNowShowPostCardIds(ref, sortTypes[0]);
}
