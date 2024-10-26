import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/logic.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/scene/abstractScene.dart';
import 'package:ogireal_app/scene/otherUserInfoScnene/OtherUserInfoSceneProvider.dart';
import 'package:ogireal_app/widget/userInfoWidget.dart';

class OtherUserInfoScene extends ConsumerWidget {
  static const String routeName = '/userInfo';
  final String userId;

  OtherUserInfoScene({required this.userId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    checkForegroundNotificationPeriodically(ref, context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final otherUserData = ref.watch(otherUserDataProvider(userId));
    return AbstractScene(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(
          'ユーザ情報',
          style: TextStyle(
            color: themeTextColor,
            fontSize: height * 0.025,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeTextColor,
            size: height * 0.03, // サイズを調整
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: themeTextColor,
              size: height * 0.03, // サイズを調整
            ),
            onPressed: () {
              OtherUserInfoSceneProvider()
                  .showHamburgerBottomSheet(context, ref, otherUserData);
            },
          ),
        ],
      ),
      body: UserInfoWidget(
        width: width,
        height: height,
        userData: otherUserData,
      ),
    );
  }
}
