import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/common/logic.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/scene/homeScene/homeSceneProvider.dart';
import 'package:ogireal_app/widget/dialog/configureDialogWidget.dart';
import 'package:ogireal_app/widget/ogiriCardWidget.dart';

double adjustFontSize(
    String text, double width, double height, double minSize) {
  double textLength = text.length.toDouble();
  double fontSize = math.min(height, width / textLength) * 0.9;

  // 計算されたフォントサイズが最小サイズより小さくならないようにする
  return math.max(fontSize, minSize);
}

void showHamburgerBottomSheet(BuildContext context, WidgetRef ref) {
  final width = MediaQuery.of(context).size.width;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: themeColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0), // 下に隙間を作るためのパディング
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text(
                  'ユーザーデータの削除',
                  style: TextStyle(color: Colors.white, fontSize: width * 0.03),
                ),
                onTap: () {
                  ConfigureDialogWidget.showConfigureDialog(
                    context: context,
                    text: 'ユーザーデータを削除しますか？\n削除したデータは復元できません。',
                    onConfirm: () async {
                      await FirebaseFunction().deleteUserDataAndUserPosts(ref);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> setTargetUserAllPosts(UserData userData, WidgetRef ref,
    double width, double height, BuildContext context) async {
  final userId = ref.read(userDataProvider).id;
  final List<String> userPostsCardIds = userData.userPostsCardIds;
  Map<String, List<String>> usersPostCardIdsMap =
      ref.read(usersPostCardIdsMapProvider); // 現在の状態を読み取る

  if (userId == null) return;
  if (usersPostCardIdsMap[userId] != null) {
    if (usersPostCardIdsMap[userId]!.isNotEmpty) return;
  }

  for (var userPostCardId in userPostsCardIds) {
    if (ref.read(targetPostProvider(userPostCardId)) != defaultOgiriCard ||
        await FirebaseFunction().setTargetPostFromFirebase(
          ref,
          userPostCardId,
        )) {
      //ここれがあるかないかでクラッシュする
      await setUsersPostCardIdToMapProvider(ref, userPostCardId, userId);
    }
  }
}
