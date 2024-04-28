import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/post/post.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/otherUserInfoScnene/otherUserInfoScnene.dart';
import 'package:ogireal_app/postScene.dart/postScneneProvider.dart';

final textControllerStateProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());

class OgiriCard extends ConsumerWidget {
  final double? cardWidth;
  final double? cardHeight;
  final String? cardId;
  final Function(Post post, bool isLiked)? pushCardGoodButtonCallback;

  OgiriCard({
    super.key,
    required this.cardWidth,
    required this.cardHeight,
    required this.cardId,
    required this.pushCardGoodButtonCallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool posting = cardId == null;
    Post post =
        posting ? defaultPost : ref.watch(targetPostProvider(cardId ?? '0'));
    final answer = posting ? '' : post.answer;
    final userData = ref.read(userDataProvider);
    final isLiked = userData.goodCardIds.contains(post.cardId);
    final textState = ref.read(postProvider);
    final theme = ref.watch(nowThemeProvider);
    final textController = ref.watch(textControllerStateProvider);
    final width = cardWidth ?? 0;
    final height = cardHeight ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      textController.text = answer ?? "";
    });

    return Card(
      color: Colors.white,
      // elevation: 4.0,
      child: SizedBox(
        width: width,
        height: height,
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
                height: height * 0.5,
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
                          fontSize: height * 0.5 * 0.3,
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
                          fontSize: height * 0.5 * 0.2,
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
                Spacer(), // ユーザー名を右端に押し出すために使用
                GestureDetector(
                  onTap: () async {
                    //コールバックで読んで
                    if (posting) return;
                    final otherUserData = await getTargetUserData(post.userId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OtherUserInfoScene(otherUserData: otherUserData),
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
