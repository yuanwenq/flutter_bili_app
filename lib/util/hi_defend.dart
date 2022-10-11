import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HiDefend {
  run(Widget app) {
    // 框架异常
    FlutterError.onError = (FlutterErrorDetails details) async {
      // 环境判断，走上报逻辑
      if (kReleaseMode) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      } else {
        // 开发期间，走 Console 抛出
        FlutterError.dumpErrorToConsole(details);
      }
    };

    runZonedGuarded(() {
      runApp(app);
    }, (error, stack) => _reportError(error, stack));
  }

  /// 通过接口上报异常
  _reportError(Object error, StackTrace stack) {
    print("kReleaseMode: $kReleaseMode");
    print("catch error: $error");
  }
}
