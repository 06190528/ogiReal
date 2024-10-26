import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/post/post.dart';
import 'package:ogireal_app/common/logic.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/scene/homeScene/homeSceneProvider.dart';
import 'package:ogireal_app/scene/otherUserInfoScnene/OtherUserInfoScene.dart';
import 'package:ogireal_app/scene/postScene.dart/postScneneProvider.dart';
import 'package:ogireal_app/widget/dialog/configureDialogWidget.dart';
import 'package:ogireal_app/widget/toastWidget.dart';

final textControllerStateProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());

final defaultOgiriCard = OgiriCard(
  cardWidth: 0,
  cardId: null,
  pushCardGoodButtonCallback: null,
);

class OgiriCard extends ConsumerWidget {
  double? cardWidth;
  final String? cardId;
  final Function(Post post, bool isLiked)? pushCardGoodButtonCallback;

  OgiriCard({
    super.key,
    required this.cardWidth,
    required this.cardId,
    required this.pushCardGoodButtonCallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool posting = cardId == null;
    final width = cardWidth ?? 0;
    final height = width * 0.6;
    Post post =
        cardId == null ? defaultPost : ref.watch(targetPostProvider(cardId!));

    String answer = post.answer;
    final userData = ref.read(userDataProvider);
    final isLiked = userData.goodCardIds.contains(post.cardId);
    final textState = ref.read(postProvider);
    String theme = post.theme;
    final textController = ref.watch(textControllerStateProvider);
    if (posting) {
      answer = '';
      String _selectedDateString = getSelectedDateString(ref);
      theme = ref.watch(themesProvider(_selectedDateString));
    }

    return SizedBox(
      width: width,
      height: height,
      child: Card(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.9,
              height: height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      elevation: 0,
                      child: Container(
                        padding: EdgeInsets.all(height * 0.01),
                        child: Text(
                          'お題',
                          style: TextStyle(
                            fontSize: height * 0.07,
                            color: themeTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      theme,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: height * 0.07,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: height * 0.12,
                    ),
                    onPressed: () {
                      pushCardGoodButtonCallback?.call(post, isLiked);
                    },
                  ),
                ],
              ),
            ),
            Card(
              color: const Color.fromARGB(255, 201, 200, 200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Container(
                width: width * 0.7,
                height: height * 0.45,
                padding: EdgeInsets.all(height * 0.01),
                alignment: Alignment.center, // 子ウィジェットを中央に揃える
                child: posting
                    ? TextField(
                        controller: textController,
                        expands: false, // テキストフィールドが高さを動的に拡張しない
                        maxLines: null, // 複数行の入力を許可
                        textAlign: TextAlign.center, // テキストフィールド内のテキストを中央揃えに設定
                        onChanged: (value) {
                          ref.read(postProvider.state).state =
                              textState.copyWith(answer: value);
                        },
                        style: TextStyle(
                          fontSize: height * 0.08,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none, // 枠線を非表示にする
                          hintText: "回答を書いて下さい...", // ヒントテキスト
                          hintStyle: TextStyle(
                            fontSize: height * 0.07, // ヒントテキストのサイズ
                            color: Colors.grey[500], // ヒントテキストの色
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: width * 0.05), // テキストの両端に空間を追加
                        ),
                      )
                    : Text(
                        answer,
                        textAlign: TextAlign.center, // Text ウィジェットのテキストも中央揃えに
                        style: TextStyle(
                          fontSize: height * 0.08,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: width * 0.05),
                Icon(Icons.favorite, size: height * 0.1, color: Colors.red),
                SizedBox(width: width * 0.01),
                Text(
                  '× ${post.goodCount}',
                  style: TextStyle(
                    fontSize: height * 0.07,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: width * 0.05),
                IconButton(
                  iconSize: height * 0.08,
                  icon: const Icon(
                    Icons.report_problem,
                  ),
                  onPressed: () {
                    if (posting) return;
                    ConfigureDialogWidget.showConfigureDialog(
                      context: context,
                      text: 'この投稿を通報しますか？',
                      onConfirm: () async {
                        ToastWidget.showToast(
                            '通報しました。\nご協力ありがとうございます', width, height, context);
                      },
                    );
                  },
                ),
                const Spacer(), // ユーザー名を右端に押し出すために使用
                GestureDetector(
                  onTap: () async {
                    //コールバックで読んで
                    if (posting) return;
                    await FirebaseFunction()
                        .getTargetUserData(ref, post.userId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OtherUserInfoScene(userId: post.userId),
                      ),
                    );
                  },
                  child: Text(
                    post.userName,
                    style: TextStyle(
                      fontSize: height * 0.07,
                      color: Colors.blue, // ユーザー名の色を青に設定
                      decoration: TextDecoration.underline, // 下線をつける
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.05,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
