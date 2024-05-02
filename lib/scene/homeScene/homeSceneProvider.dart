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
  changeTargetCardGood(ref, post, isLiked);
}

Future<void> sortGlobalDateUsersPostCardIds(
    WidgetRef ref, String SortType) async {
  List<String>? globalDateUsersPostCardIds =
      ref.watch(usersPostCardIdsMapProvider)[globalDate];
  if (globalDateUsersPostCardIds == null) return;
  switch (SortType) {
    case '新着':
      globalDateUsersPostCardIds.sort((a, b) => b.compareTo(a));
      ref.read(usersPostCardIdsMapProvider.notifier).state[globalDate] =
          globalDateUsersPostCardIds;
      break;
    case 'ランキング':
      List<Post> posts = [];
      for (String cardId in globalDateUsersPostCardIds) {
        Post post = ref.read(targetPostProvider(cardId));
        posts.add(post);
      }
      posts.sort((a, b) => b.goodCount.compareTo(a.goodCount));
      List<String> sortedCardIds = posts.map((post) => post.cardId).toList();
      globalDateUsersPostCardIds = sortedCardIds;
    default:
      globalDateUsersPostCardIds.sort((a, b) => b.compareTo(a));
      break;
  }
  updateUsersPostCardIds(ref, globalDateUsersPostCardIds);
}
