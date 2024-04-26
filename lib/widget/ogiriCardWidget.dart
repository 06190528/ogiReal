import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/data/post/post.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/homeScene/homeSceneProvider.dart';
import 'package:ogireal_app/postScene.dart/postScneneProvider.dart';

final textControllerStateProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());
final targetCardProvider =
    StateProvider.family<Post, String>((ref, id) => defaultPost);

class OgiriCard extends ConsumerWidget {
  final double? cardWidth;
  final double? cardHeight;
  final String? answer;
  final Post? post;

  OgiriCard({
    super.key,
    required this.cardWidth,
    required this.cardHeight,
    required this.answer,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.read(userDataProvider).id;
    final targetCard = ref.watch(targetCardProvider(post?.cardId ?? ''));
    final userData = ref.read(userDataProvider);
    final isLiked = userData.goodCardIds.contains(post?.cardId ?? '');
    final textState = ref.read(postProvider);
    final theme = ref.watch(nowThemeProvider);
    final textController = ref.watch(textControllerStateProvider);
    final bool posting = answer == null;
    final width = cardWidth ?? 0;
    final height = cardHeight ?? 0;
    final String userName = ref.read(userDataProvider).name ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      textController.text = answer ?? "";
    });

    return Card(
      color: Colors.white,
      elevation: 4.0,
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
                      if (posting) return;
                      if (post == null) return;
                      pushCardGoodButton(ref, post!, isLiked);
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
                width: width * 0.6,
                height: height * 0.4,
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
                          fontSize: height * 0.07,
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
                        answer ?? "no answer", // デフォルトテキストを表示
                        textAlign: TextAlign.center, // Text ウィジェットのテキストも中央揃えに
                        style: TextStyle(
                          fontSize: height * 0.07,
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
                  '×${post?.goodCount ?? 0}',
                  style: TextStyle(
                    fontSize: height * 0.07,
                    color: Colors.black,
                  ),
                ),
                Spacer(), // ユーザー名を右端に押し出すために使用
                GestureDetector(
                  onTap: () {
                    print("tapped");
                  },
                  child: Text(
                    post?.userName ?? userName, // ユーザー名表示、null の場合は "Anonymous"
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
