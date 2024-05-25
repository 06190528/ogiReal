import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/widget/toastWidget.dart';

class SettingAbstractWidget extends ConsumerStatefulWidget {
  final String title;
  final String explanation;
  final String kind;

  SettingAbstractWidget({
    Key? key,
    required this.title,
    required this.explanation,
    required this.kind,
  }) : super(key: key);

  @override
  _SettingAbstractWidgetState createState() => _SettingAbstractWidgetState();
}

class _SettingAbstractWidgetState extends ConsumerState<SettingAbstractWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: themeTextColor, size: height * 0.03),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title,
            style: TextStyle(color: themeTextColor, fontSize: height * 0.02)),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: themeTextColor, size: height * 0.03),
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                await UserDataService().saveUserDataToFirebase(
                  ref,
                  widget.kind,
                  _controller.text,
                );
                Navigator.of(context).pop();
              } else {
                ToastWidget.showToast('ユーザー名を入力して下さい', width, height, context);
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: themeColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              style: TextStyle(color: themeTextColor),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: themeTextColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: themeTextColor),
                ),
                hintStyle: TextStyle(color: themeTextColor.withOpacity(0.6)),
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(
              widget.explanation,
              style: TextStyle(color: themeTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
