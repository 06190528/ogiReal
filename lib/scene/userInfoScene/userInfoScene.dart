import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/logic.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/widget/commonButtomAppBarWidget.dart';
import 'package:ogireal_app/widget/userInfoWidget.dart';

class UserInfoScene extends ConsumerWidget {
  static const String routeName = '/userInfo';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final userData = ref.watch(userDataProvider);
    checkForegroundNotificationPeriodically(context);
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
          backgroundColor: themeColor,
          title: Text(
            'ユーザ情報',
            style: TextStyle(
              color: themeTextColor,
              fontSize: height * 0.025,
            ),
          )),
      body: UserInfoWidget(
        width: width,
        height: height,
        userData: userData,
      ),
      bottomNavigationBar: CommonBottomAppBar(
        ref: ref,
        height: height * 0.8,
      ),
    );
  }
}
