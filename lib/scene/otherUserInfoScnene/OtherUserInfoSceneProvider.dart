import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/data/userData/userData.dart';
import 'package:ogireal_app/widget/dialog/configureDialogWidget.dart';

class OtherUserInfoSceneProvider {
  void showHamburgerBottomSheet(
      BuildContext context, WidgetRef ref, UserData otherUserData) {
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
                    'ユーザをブロック',
                    style:
                        TextStyle(color: Colors.white, fontSize: width * 0.03),
                  ),
                  onTap: () {
                    ConfigureDialogWidget.showConfigureDialog(
                      context: context,
                      text: 'このユーザをブロックしますか？',
                      onConfirm: () async {
                        UserDataService().saveUserDataToFirebase(
                            ref, 'blockedUserIds', otherUserData.id);
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
}
