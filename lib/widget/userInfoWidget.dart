import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/scene/homeScene/homeSceneProvider.dart';
import 'package:ogireal_app/scene/userInfoScene/userInfoSceneProvider.dart';
import 'package:ogireal_app/widget/ogiriCardWidget.dart';

class UserInfoWidget extends ConsumerWidget {
  final double width;
  final double height;
  final UserData userData;

  const UserInfoWidget(
      {super.key,
      required this.width,
      required this.height,
      required this.userData});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = userData.name ?? 'Anonymous';
    final List<String> usersPostCardIds =
        ref.watch(usersPostCardIdsMapProvider)[userData.id] ?? [];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (userData.id == ref.read(userDataProvider).id) {
        await setTargetUserAllPosts(
            userData, ref, width, height, context); //こいつさえいなければクラッシュしない
      }
    });

    return Column(
      children: [
        SizedBox(height: height * 0.02),
        CircleAvatar(
          radius: height * 0.08,
          backgroundColor: Colors.blue,
          child: FittedBox(
            fit: BoxFit.scaleDown, // 内容をボックスに収める
            child: Text(
              userName,
              style: TextStyle(
                fontSize: adjustFontSize(
                    userName, height * 0.08 * 2, height * 0.08 * 2, 10),
                color: Colors.white, // テキストの色
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1, // テキストは1行で表示
              overflow: TextOverflow.ellipsis, // はみ出たテキストを省略記号で表現
            ),
          ),
        ),
        SizedBox(height: height * 0.02),
        Text(
          userData.name ?? 'Anonymous',
          style: TextStyle(
              fontSize: height * 0.03,
              fontWeight: FontWeight.bold,
              color: themeTextColor),
        ),
        SizedBox(height: height * 0.02),
        Expanded(
          child: Center(
            child: usersPostCardIds.isNotEmpty
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                      double cardWidth = (width * 0.8) / crossAxisCount;
                      return GridView.builder(
                        itemCount: usersPostCardIds.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          String cardId = usersPostCardIds[index];
                          if (index == usersPostCardIds.length - 1) {
                            return FutureBuilder(
                              future: FirebaseFunction()
                                  .setTargetPostFromFirebase(ref, cardId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return OgiriCard(
                                    cardWidth: cardWidth,
                                    cardId: cardId,
                                    pushCardGoodButtonCallback:
                                        (post, isLiked) {
                                      if (post.userId ==
                                          ref.read(userDataProvider).id) {
                                        return;
                                      }
                                      pushCardGoodButton(ref, post, isLiked,
                                          width, height, context);
                                    },
                                  );
                                } else {
                                  return Container(
                                    width: cardWidth,
                                    height: cardWidth * 0.6,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              },
                            );
                          }
                        },
                      );
                    },
                  )
                : Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      '投稿はまだありません。',
                      style: TextStyle(
                        fontSize: height * 0.03,
                        color: themeTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
