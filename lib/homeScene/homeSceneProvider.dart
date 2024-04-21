import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/post/post.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/widget/ogiriCardWidget.dart';

final ogiriCardsProvider = StateProvider<List<OgiriCard>>((ref) => []);

void pushCardGoodButton(WidgetRef ref, Post post, bool isLiked) {
  ref.read(heartToggleProvider(post.cardId).notifier).state = !isLiked;
  UserData userData = ref.read(userDataProvider);
  List<String> goodCardIds = List<String>.from(userData.goodCardIds);
  if (isLiked) {
    goodCardIds.remove(post.cardId);
  } else {
    goodCardIds.add(post.cardId);
  }
  //userDataにcardIdを追加(自分のデータ)
  UserDataService().saveUserDataToFirebase(ref, 'goodCardIds', goodCardIds);
  //usersPostsのgoodをインクリメント（みんなのデータ）
  changeTargetUserCardGood(ref, post, isLiked);
  //押したuserのuserDataのPostのgoodをインクリメント（他人のデータ）
  changeTargetUserPostGood(ref, post, isLiked);
}
