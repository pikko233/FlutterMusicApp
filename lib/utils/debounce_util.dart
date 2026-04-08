import 'dart:async';

import 'package:flutter/foundation.dart';

class DebounceUtil {
  Timer? _timer;

  void debounce(VoidCallback fun, {int milliseconds = 500}) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), fun);
  }

  void dispose() {
    _timer?.cancel();
  }
}
