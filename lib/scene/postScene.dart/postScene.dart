import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/logic.dart';
import 'package:ogireal_app/scene/postScene.dart/postScneneProvider.dart';
import 'package:ogireal_app/widget/commonButtomAppBarWidget.dart';
import 'package:ogireal_app/widget/countDownAppBarWidget.dart';
import 'package:ogireal_app/widget/dialog/configureDialogWidget.dart';
import 'package:ogireal_app/widget/ogiriCardWidget.dart';
import 'package:ogireal_app/widget/rectangleButtonWidget.dart';
import 'package:ogireal_app/widget/toastWidget.dart';

class PostScene extends ConsumerWidget {
  static const String routeName = '/post';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final userTodayCanPostCount = ref.watch(todayUserCanPostCountProvider);
    checkForegroundNotificationPeriodically(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await setCountDownToProvider(ref);
      setTodayUserCanPostCount(ref);
    });
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: themeColor,
        appBar: AppBar(
          backgroundColor: themeColor,
          title: CountDownAppBarWidget(),
        ),
        body: Container(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // コンテンツを上に寄せる
            children: [
              OgiriCard(
                cardWidth: width * 0.8,
                cardId: null,
                pushCardGoodButtonCallback: null,
              ),
              Spacer(), // OgiriCard とボタンの間にスペースを追加
              RectangleButtonWidget(
                  text: '投稿（残り $userTodayCanPostCount 回）',
                  width: width * 0.8, // ボタンの幅を調整
                  height: height * 0.04, // ボタンの高さを調整
                  onPressed: () {
                    if (ref.read(textControllerStateProvider).text.isEmpty ||
                        userTodayCanPostCount == 0) {
                      String toastText = 'テキストを入力してください';
                      if (userTodayCanPostCount <= 0) {
                        toastText = '本日の投稿回数が上限に達しました';
                      }
                      ToastWidget.showToast(toastText, width, height, context);
                      return;
                    }
                    ConfigureDialogWidget.showConfigureDialog(
                      context: context,
                      text: "本当に投稿しますか？",
                      onConfirm: () {
                        setTodayUserCanPostCount(ref);
                        createAndSavePostCardToFirebase(ref);
                        ref.read(textControllerStateProvider).text = '';
                        ToastWidget.showToast(
                            '投稿が完了しました', width, height, context);
                      },
                      onCancel: () {
                        ToastWidget.showToast(
                            '投稿をキャンセルしました', width, height, context);
                      },
                    );
                  },
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // ボタンの背景色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // 角丸の半径を設定
                    ),
                  ),
                  textStyle: TextStyle(
                    color: themeTextColor, // テキストの色
                    fontSize: height * 0.02, // フォントサイズを高さに基づいて適切に設定
                  )),
            ],
          ),
        ),
        bottomNavigationBar: CommonBottomAppBar(
          ref: ref,
          height: height * 0.8,
        ),
      ),
    );
  }
}
