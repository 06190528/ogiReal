import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/postScene.dart/postScneneProvider.dart';
import 'package:ogireal_app/widget/commonButtomAppBarWidget.dart';
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
    final secondsLeft = ref.watch(countdownTimerProvider);
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
          backgroundColor: themeColor,
          title: Column(
            children: [
              const Text(
                '新規投稿',
                style: TextStyle(
                  color: themeTextColor,
                ),
              ),
              Text('Time left: ${secondsLeft} seconds',
                  style: TextStyle(
                    color: themeTextColor,
                  )),
            ],
          )),
      body: Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // コンテンツを上に寄せる
          children: [
            OgiriCard(
              cardHeight: height * 0.2,
              cardWidth: width * 0.8,
              answer: null,
              post: null,
            ),
            Spacer(), // OgiriCard とボタンの間にスペースを追加
            RectangleButtonWidget(
              text: '投稿',
              width: width * 0.8, // ボタンの幅を調整
              height: height * 0.04, // ボタンの高さを調整
              onPressed: () {
                if (ref.read(textControllerStateProvider).text.isEmpty) {
                  ToastWidget.showToast(
                      'テキストを入力してください', width, height, context);
                  return;
                }
                ConfigureDialogWidget.showConfigureDialog(
                  context: context,
                  text: "本当に投稿しますか？",
                  onConfirm: () {
                    createAndSavePostCardToFirebase(ref);
                    ref.read(textControllerStateProvider).text = '';
                    ToastWidget.showToast('投稿が完了しました', width, height, context);
                  },
                  onCancel: () {
                    ToastWidget.showToast(
                        '投稿をキャンセルしました', width, height, context);
                  },
                );
              },
            ),
          ],
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
