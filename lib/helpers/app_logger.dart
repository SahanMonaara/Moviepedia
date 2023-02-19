import 'package:flutter/cupertino.dart';

/// It's a simple class that allows you to print out different types of logs

class Log {
  static const bool _isShowDebug = true;
  static const bool _isInfoShow = true;
  static const bool _isWarnShow = true;
  static const bool _isErrShow = true;

  static void debug(String log) {
    if (_isShowDebug) {
      debugPrint("[DEBUG]: $log");
    }
  }

  static void info(String msg) {
    if (_isInfoShow) {
      debugPrint("\x1b[33m[INFO] $msg\x1b[0m");
    }
  }

  static void warn(String msg) {
    if (_isWarnShow) {
      debugPrint("[WARN] $msg");
    }
  }

  static void err(String msg) {
    if (_isErrShow) {
      debugPrint("\x1b[31m[ERR] $msg\x1b[0m");
    }
  }
}
