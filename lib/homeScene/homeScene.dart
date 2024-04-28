import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/intialize.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/homeScene/homeSceneProvider.dart';
import 'package:ogireal_app/widget/commonButtomAppBarWidget.dart';
import 'package:ogireal_app/widget/ogiriCardWidget.dart';
import 'package:ogireal_app/widget/toastWidget.dart';

class HomeScene extends ConsumerWidget {
  static const String routeName = '/home';

  const HomeScene({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    initialize(ref, context);
    final userData = ref.watch(userDataProvider);
    final globalDateUsersPostCardIds =
        ref.watch(usersPostCardIdsMapProvider)[globalDate];
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    getGlobalDateUsersPostsAndTheme(ref, globalDate);
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(
          '大喜Real.',
          style: TextStyle(color: themeTextColor, fontSize: height * 0.025),
        ),
      ),
      body: Center(
        child: globalDateUsersPostCardIds != null &&
                globalDateUsersPostCardIds.isNotEmpty
            ? ListView.builder(
                itemCount: globalDateUsersPostCardIds.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(
                        bottom: height * 0.01,
                        left: width * 0.05,
                        right: width * 0.05),
                    child: OgiriCard(
                      cardWidth: width * 0.8,
                      cardHeight: width * 0.8 * 0.6,
                      cardId: globalDateUsersPostCardIds[index],
                      pushCardGoodButtonCallback: (
                        post,
                        isLiked,
                      ) {
                        if (post.userId == userData.id) {
                          ToastWidget.showToast(
                              '自分の投稿にはいいねできません', width, height, context);
                          return;
                        }
                        pushCardGoodButton(ref, post, isLiked);
                      },
                    ),
                  );
                },
              )
            : Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  '本日の投稿はまだありません。',
                  style: TextStyle(
                    fontSize: height * 0.03,
                    color: themeTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: themeColor,
        child: CommonBottomAppBar(
          ref: ref,
        ),
      ),
    );
  }
}
