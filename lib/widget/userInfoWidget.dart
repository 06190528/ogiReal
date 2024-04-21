import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/provider.dart'; // あなたのプロバイダー設定をインポート

class UserInfoWidget extends ConsumerWidget {
  final WidgetRef ref;

  UserInfoWidget({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);

    return Column(
      children: [
        SizedBox(height: 20),
        CircleAvatar(
          // backgroundImage: NetworkImage(userData.icon ?? 'default_icon_url'),
          radius: 50,
        ),
        SizedBox(height: 8),
        Text(
          userData.name ?? 'Anonymous',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(3, (index) {
              return Card(
                child: Center(
                  child: Text('Post ${index + 1}'),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
