import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/logic.dart';
import 'package:ogireal_app/homeScene/homeScene.dart';
import 'package:ogireal_app/otherUserInfoScnene/postScene.dart/postScene.dart';
import 'package:ogireal_app/userInfoScene/userInfoScene.dart';

class CommonBottomAppBar extends StatelessWidget {
  final WidgetRef ref;

  const CommonBottomAppBar({super.key, required this.ref});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final currentRouteName = ModalRoute.of(context)?.settings.name;

    return BottomAppBar(
      color: themeColor,
      child: Container(
        height: height * 0.1,
        color: themeColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: themeTextColor),
              onPressed: currentRouteName != HomeScene.routeName
                  ? () {
                      _navigateWithoutAnimation(
                          context, HomeScene.routeName, ref);
                    }
                  : null,
            ),
            IconButton(
              icon: Icon(Icons.add_box, color: themeTextColor),
              onPressed: currentRouteName != PostScene.routeName
                  ? () {
                      _navigateWithoutAnimation(
                          context, PostScene.routeName, ref);
                    }
                  : null,
            ),
            IconButton(
              icon: Icon(Icons.person, color: themeTextColor),
              onPressed: currentRouteName != UserInfoScene.routeName
                  ? () {
                      _navigateWithoutAnimation(
                          context, UserInfoScene.routeName, ref);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateWithoutAnimation(
      BuildContext context, String routeName, WidgetRef ref) {
    if (canGoNextScene(ref))
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => _getPage(routeName),
        transitionDuration: Duration.zero, // アニメーションの時間を0に設定
      ));
  }

  Widget _getPage(String routeName) {
    switch (routeName) {
      case HomeScene.routeName:
        return HomeScene();
      case PostScene.routeName:
        return PostScene();
      case UserInfoScene.routeName:
        return UserInfoScene();
      default:
        return HomeScene(); // デフォルトでホームシーンを返す
    }
  }
}
