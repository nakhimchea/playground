import 'dart:async';

import 'package:flutter/foundation.dart';

/// This class used to perform run thread delay
class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  cancel() {
    _timer?.cancel();
  }
}
