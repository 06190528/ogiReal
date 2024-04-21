import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/widget/commonButtomAppBarWidget.dart';

class UserInfoScene extends ConsumerWidget {
  static const String routeName = '/userInfo';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
          backgroundColor: themeColor,
          title: Text(
            'ユーザ情報',
            style: TextStyle(
              color: themeTextColor,
            ),
          )),
      //このボディーから　riverpod　を使ってデータを取得する
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                  title: Text(
                'Item #$index',
                style: TextStyle(color: themeTextColor),
              )),
              childCount: 30, // アイテムの数を設定
            ),
          ),
        ],
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
