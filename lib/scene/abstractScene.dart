import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/const.dart';
import 'package:ogireal_app/common/logic.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/widget/commonButtomAppBarWidget.dart';

class AbstractScene extends ConsumerWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;

  const AbstractScene({
    super.key,
    required this.appBar,
    required this.body,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    checkForegroundNotificationPeriodically(ref, context);
    final adLoading = ref.watch(adLoadingProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: themeColor,
      appBar: appBar,
      body: Stack(
        children: [
          body,
          if (adLoading)
            Positioned.fill(
              child: Container(
                color: Colors
                    .black54, // Optional: Add a semi-transparent background
                child: Center(
                  child: SizedBox(
                    width: width * 0.2, // ここで幅を指定
                    height: width * 0.2, // ここで高さを指定
                    child: CircularProgressIndicator(
                      strokeWidth: width * 0.2 * 0.05, // ここで線の太さを指定
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CommonBottomAppBar(
        ref: ref,
        height: height,
      ),
    );
  }
}
