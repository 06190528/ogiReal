import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
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
    final usersPosts = ref.watch(usersPostsProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setAllUsersPosts(ref);
    });
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
        child: Container(
          width: width * 0.8,
          child: usersPosts.isNotEmpty
              ? ListView.builder(
                  itemCount: usersPosts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: height * 0.02),
                      child: OgiriCard(
                        cardWidth: width * 0.8,
                        cardHeight: height * 0.2,
                        index: index,
                        pushCardGoodButtonCallback: (post, isLiked, index) {
                          if (post == null || post.userId == userData.id) {
                            ToastWidget.showToast(
                                '自分の投稿にはいいねできません', width, height, context);
                            return;
                          }
                          pushCardGoodButton(ref, post!, isLiked, index ?? 0);
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
