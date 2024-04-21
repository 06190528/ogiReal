import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ogireal_app/common/const.dart';

class RectangleButtonWidget extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback onPressed;

  RectangleButtonWidget({
    required this.text,
    required this.width,
    required this.height,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // ボタンの背景色
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // 角丸の半径を設定
          ),
        ),
        child: Center(
          // CenterウィジェットでTextを囲むことで中央配置を保証
          child: Text(
            text,
            style: TextStyle(
              color: themeTextColor, // テキストの色
              fontSize: height * 0.6, // フォントサイズを高さに基づいて適切に設定
            ),
            textAlign: TextAlign.center, // テキストを中央揃えに
          ),
        ),
      ),
    );
  }
}
