import 'package:flutter/material.dart';

class ConfigureDialogWidget {
  static void showConfigureDialog({
    required BuildContext context,
    required String text,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('確認'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
                onCancel?.call(); // オプショナル: onCancel が提供されていれば呼び出す
              },
              child: Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
                onConfirm(); // 必須: onConfirm コールバックを実行
              },
              child: Text('はい'),
            ),
          ],
        );
      },
    );
  }
}
