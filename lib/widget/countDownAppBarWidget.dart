import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/scene/postScene.dart/postScneneProvider.dart';

class CountDownAppBarWidget extends ConsumerWidget {
  const CountDownAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final secondsLeft = ref.watch(countdownTimerProvider);
    final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsLeft % 60).toString().padLeft(2, '0');
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Text(
          '新規投稿',
          style: TextStyle(
            color: themeTextColor,
            fontSize: height * 0.03,
          ),
        ),
        if (secondsLeft > 0)
          Text(
            '残り時間 $minutes:$seconds',
            style: TextStyle(
              color: themeTextColor,
              fontSize: height * 0.02,
            ),
          ),
      ],
    );
  }
}
