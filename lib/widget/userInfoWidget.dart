import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/common/logic.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/userInfoScene/userInfoSceneProvider.dart';
import 'package:ogireal_app/widget/ogiriCardWidget.dart';

class UserInfoWidget extends ConsumerWidget {
  final double width;
  final double height;
  final UserData userData;

  UserInfoWidget(
      {required this.width, required this.height, required this.userData});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = userData.name ?? 'Anonymous';
    final List<String> usersPostCardIds =
        ref.watch(usersPostCardIdsMapProvider)[userData.id] ?? [];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await setTargetUserAllPosts(userData, ref);
      print('usersPostCardIds: $usersPostCardIds');
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
                fontSize: adjustFontSize(userName, height * 0.08 * 2, 20),
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
          child: ListView.builder(
            itemCount: usersPostCardIds.length,
            itemBuilder: (context, index) {
              return Container(
                  margin: EdgeInsets.only(
                      bottom: height * 0.01,
                      left: width * 0.05,
                      right: width * 0.05),
                  child: OgiriCard(
                    cardWidth: width * 0.8,
                    cardHeight: width * 0.8 * 0.6,
                    cardId: usersPostCardIds[index],
                    pushCardGoodButtonCallback:
                        null, // Implement callback if needed
                  ));
            },
          ),
        ),
      ],
    );
  }
}
