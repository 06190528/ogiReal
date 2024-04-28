import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/post/post.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/widget/ogiriCardWidget.dart';

final ogiriCardsProvider = StateProvider<List<OgiriCard>>((ref) => []);

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
