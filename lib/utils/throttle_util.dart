import 'dart:async';

import 'package:flutter/services.dart';

class ThrottleUtil {
  Timer? _timer;

  void throttle(VoidCallback func, {int duration = 200}) {
    if (_timer != null) return;
    _timer = Timer(Duration(milliseconds: duration), () {
      _timer = null;
      func();
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
