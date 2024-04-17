import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/data/firebase.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title, style: TextStyle(color: themeTextColor)),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: themeTextColor),
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                await UserDataService().saveUserDataToFirebase(
                  ref,
                  widget.kind,
                  _controller.text,
                );
                Navigator.of(context).pop();
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
            SizedBox(height: 20),
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
