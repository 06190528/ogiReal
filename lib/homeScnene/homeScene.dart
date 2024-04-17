import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/data/intialize.dart';

class HomeScene extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    initialize(ref, context);
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
          backgroundColor: themeColor,
          title: Text(
            '大喜 Real',
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
        child: Container(
          color: themeColor,
          height: height * 0.1,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround, // アイコン間のスペースを均等に分布
            children: [
              IconButton(
                icon: Icon(Icons.home, color: themeTextColor),
                onPressed: () {
                  // ホームボタンの処理
                  print('Home pressed');
                },
              ),
              // IconButton(
              //   icon: Icon(Icons.search, color: themeTextColor),
              //   onPressed: () {
              //     // 検索ボタンの処理
              //     print('Search pressed');
              //   },
              // ),
              IconButton(
                icon: Icon(Icons.add_box, color: themeTextColor),
                onPressed: () {
                  // 投稿ボタンの処理
                  print('Add post pressed');
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: themeTextColor),
                onPressed: () {
                  // ユーザー設定ボタンの処理
                  print('User settings pressed');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
