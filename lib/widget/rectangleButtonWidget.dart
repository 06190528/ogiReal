import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RectangleButtonWidget extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback onPressed;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;

  RectangleButtonWidget({
    required this.text,
    required this.width,
    required this.height,
    required this.onPressed,
    this.buttonStyle, // nullableにすることで、必須ではないパラメータに
    this.textStyle, // デフォルト値を設定しない場合は null が許容されます
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle ??
            ElevatedButton.styleFrom(
              // デフォルトのスタイル設定をここに追加可能
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
        child: Center(
          child: Text(
            text,
            style: textStyle ??
                const TextStyle(
                  fontSize: 16, // デフォルトフォントサイズ
                  color: Colors.white, // デフォルトテキストカラー
                ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
