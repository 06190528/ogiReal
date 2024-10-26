import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/logic.dart';
import 'package:ogireal_app/scene/homeScene/homeScene.dart';
import 'package:ogireal_app/scene/postScene.dart/postScene.dart';
import 'package:ogireal_app/scene/userInfoScene/userInfoScene.dart';

class CommonBottomAppBar extends StatelessWidget {
  final WidgetRef ref;
  final double height;

  const CommonBottomAppBar(
      {super.key, required this.ref, required this.height});

  @override
  Widget build(BuildContext context) {
    final currentRouteName = ModalRoute.of(context)?.settings.name;
    final bottomAppBarHeight = height * 0.05; // ここで高さを調整
    double iconSize = bottomAppBarHeight * 0.8; // アイコンのサイズを調整
    double buttonSize = bottomAppBarHeight; // ボタンのサイズを調整
    return BottomAppBar(
      color: themeColor,
      child: SizedBox(
        height: bottomAppBarHeight, // BottomAppBarの高さを設定
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: themeTextColor,
                size: iconSize,
              ),
              onPressed: currentRouteName != HomeScene.routeName
                  ? () {
                      _navigateWithoutAnimation(
                          context, HomeScene.routeName, ref);
                    }
                  : null,
              iconSize: iconSize,
              constraints: BoxConstraints(
                minWidth: buttonSize,
                minHeight: buttonSize,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_box, color: themeTextColor, size: iconSize),
              onPressed: currentRouteName != PostScene.routeName
                  ? () {
                      _navigateWithoutAnimation(
                          context, PostScene.routeName, ref);
                    }
                  : null,
              iconSize: iconSize,
              constraints: BoxConstraints(
                minWidth: buttonSize,
                minHeight: buttonSize,
              ),
            ),
            IconButton(
              icon: Icon(Icons.person, color: themeTextColor, size: iconSize),
              onPressed: currentRouteName != UserInfoScene.routeName
                  ? () {
                      _navigateWithoutAnimation(
                          context, UserInfoScene.routeName, ref);
                    }
                  : null,
              iconSize: iconSize,
              constraints: BoxConstraints(
                minWidth: buttonSize,
                minHeight: buttonSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateWithoutAnimation(
      BuildContext context, String routeName, WidgetRef ref) {
    if (canGoNextScene(ref)) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => _getPage(routeName),
        transitionDuration: Duration.zero, // アニメーションの時間を0に設定
      ));
    }
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
