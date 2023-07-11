import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

final adb = AdbController._();

class AdbController {
  AdbController._();

  late Size screenSize;

  Future init() async {
    screenSize = await getScreenSize();
  }

  /// Simulate a single tap at ([x], [y]).
  Future tap(double x, double y) {
    return Process.run('adb', ['shell', 'input', 'tap', '$x', '$y']);
  }

  /// Long press at ([x], [y]) for [duration], default 1 second.
  Future longPress(
    double x,
    double y, [
    Duration duration = const Duration(seconds: 1),
  ]) {
    return swipe(0, 0, origin: Offset(x, y), duration: duration);
  }

  /// Swipe [dx] and [dy] units from [origin], completed in [duration] time.
  /// Default origin is screen center, default duration is 300 millisecond.
  Future swipe(
    double dx,
    double dy, {
    Offset? origin,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    origin ??= Offset(screenSize.width / 2, screenSize.height / 2);
    return Process.run('adb', [
      'shell',
      'input',
      'swipe',
      '${origin.dx}',
      '${origin.dy}',
      '${origin.dx + dx}',
      '${origin.dy + dy}',
      '${duration.inMilliseconds}',
    ]);
  }

  /// Click on the physical "back button".
  Future back() {
    return Process.run('adb', ['shell', 'input', 'keyevent', '4']);
  }

  /// Get the device screen dimension.
  Future<Size> getScreenSize() async {
    final ProcessResult results = await Process.run(
      'adb',
      ['shell', 'wm', 'size'],
    );
    final String msg = results.stdout.trim(); // e.g. "Physical size: 1080x1920"
    final rep = RegExp(r'^.+: (\d+)x(\d+)$');
    final match = rep.allMatches(msg).single;
    final width = double.parse(match.group(1)!);
    final height = double.parse(match.group(2)!);
    return Size(width, height);
  }

  /// Take a screenshot and return the bytes.
  Future<Uint8List> screenshot() async {
    final ProcessResult results = await Process.run(
      'adb',
      ['shell', 'screencap -p'],
      stdoutEncoding: null,
    );
    return results.stdout;
  }
}
