import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/firebase_options.dart';
import 'package:ogireal_app/homeScene/homeScene.dart';
import 'package:ogireal_app/otherUserInfoScnene/postScene.dart/postScene.dart';
import 'package:ogireal_app/userInfoScene/userInfoScene.dart';

void main() async {
  // debugPaintSizeEnabled = true; // UIのデバッグを有効にする
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GlobalData().initializeTodayDate(); // グローバルデータの初期化
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      initialRoute: HomeScene.routeName, // 初期ルートを指定
      routes: {
        HomeScene.routeName: (context) => HomeScene(), // ホーム画面
        PostScene.routeName: (context) => PostScene(), // 投稿画面
        UserInfoScene.routeName: (context) => UserInfoScene(), // ユーザー画面
      },
      // 'home' プロパティは 'initialRoute' と競合するため、ここではコメントアウトします
      // home: HomeScene(),
    );
  }
}
