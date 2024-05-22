import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EulaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        '利用規約',
        style: TextStyle(fontSize: width * 0.05),
      )),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '「不適切なコンテンツや不正行為は一切許容されません。\n不適切な行為が発見された場合、当社はアカウントの削除やその他の適切な措置を講じる権利を有します。」',
                  style: TextStyle(fontSize: width * 0.03),
                ),
              ),
            ),
            Center(
              child: Container(
                height: height * 0.1,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('acceptedEula', true);
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text(
                    '同意する',
                    style: TextStyle(fontSize: height * 0.03),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
