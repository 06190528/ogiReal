import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/scene/homeScene/homeSceneProvider.dart';
import 'package:ogireal_app/scene/userInfoScene/userInfoSceneProvider.dart';
import 'package:ogireal_app/widget/commonButtomAppBarWidget.dart';
import 'package:ogireal_app/widget/ogiriCardWidget.dart';
import 'package:ogireal_app/widget/rectangleButtonWidget.dart';

class HomeScene extends ConsumerWidget {
  static const String routeName = '/home';

  const HomeScene({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool _wentEdge = false;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final toolBarHeight = height * 0.08;
    homeSceneInitializeData(context, ref);
    final nowShowPostCardIds = ref.watch(nowShowPostCardIdsProvider);
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        toolbarHeight: toolBarHeight,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: width * 0.08), // 左端の余白とバランスを取るために追加
                Center(
                  child: Text(
                    '大喜Real.',
                    style: TextStyle(
                      color: themeTextColor,
                      fontSize: toolBarHeight * 0.4,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: themeTextColor,
                    size: toolBarHeight * 0.3,
                  ),
                  onPressed: () {
                    showCalendarDialog(context);
                  },
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // ボタン間の間隔を均等にする
              children: [
                for (var sortType in sortTypes)
                  RectangleButtonWidget(
                      text: sortType,
                      width: width * 0.3,
                      height: toolBarHeight * 0.4,
                      onPressed: () {
                        if (_wentEdge) sortNowShowPostCardIds(ref, sortType);
                      },
                      buttonStyle: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(themeTextColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.0),
                          ),
                        ),
                      ),
                      textStyle: TextStyle(
                          color: themeColor,
                          fontSize: adjustFontSize(sortType, width * 0.2,
                              toolBarHeight * 0.4 * 0.8, 10))),
              ],
            ),
            SizedBox(height: height * 0.01),
          ],
        ),
      ),
      body: Center(
        child: nowShowPostCardIds.isNotEmpty
            ? LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                  double cardWidth = (width * 0.8) / crossAxisCount;
                  return GridView.builder(
                    itemCount: nowShowPostCardIds.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      String cardId = nowShowPostCardIds[index];
                      if (index == nowShowPostCardIds.length - 1)
                        _wentEdge = true;
                      return FutureBuilder(
                        future: FirebaseFunction()
                            .setTargetPostFromFirebase(ref, cardId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return OgiriCard(
                              cardWidth: cardWidth,
                              cardId: cardId,
                              pushCardGoodButtonCallback: (post, isLiked) {
                                if (post.userId ==
                                    ref.read(userDataProvider).id) {
                                  return;
                                }
                                pushCardGoodButton(
                                    ref, post, isLiked, width, height, context);
                              },
                            );
                          } else {
                            return Container(
                              width: cardWidth,
                              height: cardWidth * 0.6,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      );
                    },
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
      bottomNavigationBar: CommonBottomAppBar(
        ref: ref,
        height: height * 0.4,
      ),
    );
  }
}
