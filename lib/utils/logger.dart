import 'dart:developer' as dev;

abstract class Logger {
  static const _name = 'navatech';

  static void info(String message) {
    dev.log(
      message,
      name: _name,
    );
  }

  static void warn(String message) {
    dev.log(
      message,
      name: _name,
    );
  }

  static void error(String message) {
    dev.log(
      message,
      stackTrace: StackTrace.current,
      name: _name,
    );
  }
}
