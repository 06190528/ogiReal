import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';

final countdownTimerProvider =
    StateNotifierProvider<CountdownTimerNotifier, int>((ref) {
  return CountdownTimerNotifier();
});

class CountdownTimerNotifier extends StateNotifier<int> {
  CountdownTimerNotifier() : super(300); // 300 seconds for 5 minutes

  Timer? _timer;

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state > 0) {
        state--;
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
