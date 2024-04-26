import 'package:flutter/material.dart';

class ToastWidget {
  static void showToast(
      String message, double width, double height, BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: height * 0.2,
        left: width * 0.2,
        right: width * 0.2,
        child: Material(
          color: Color.fromARGB(0, 255, 255, 255),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(221, 255, 255, 255),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width * 0.05,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );

    // トーストを表示
    overlay.insert(overlayEntry);

    // 3秒後にトーストを消す
    Future.delayed(Duration(seconds: 1)).then((value) => overlayEntry.remove());
  }
}
