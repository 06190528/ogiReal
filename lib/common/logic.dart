import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/provider.dart';

void navigateAndRemoveUntil(
    BuildContext context, Widget targetPage, String targetRouteName) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => targetPage),
    (Route<dynamic> route) => route.settings.name == targetRouteName,
  );
}

bool canGoNextScene(WidgetRef ref) {
  bool canGo = false;
  final userData = ref.read(userDataProvider);
  final theme = ref.read(nowThemeProvider);
  final usersPosts = ref.read(usersPostsProvider);
  if (userData != defaultUserData && theme != 'default' && usersPosts != []) {
    canGo = true;
  }

  return canGo;
}
