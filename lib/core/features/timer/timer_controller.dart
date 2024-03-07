import 'dart:async';

class PeriodicTimer {
  Stream<int>? _timer;
  StreamSubscription<int>? _subscription;
  StreamController<int>? _tickStream;

  final Duration tickDuration;

  PeriodicTimer({
    this.tickDuration = const Duration(seconds: 1),
  });

  Stream<int> start(int secondsFrom) {
    if (_timer != null) {
      _timer = null;
    }

    if (_tickStream != null) {
      _tickStream!.close();
      _tickStream = null;
    }

    if (_subscription != null) {
      _subscription!.cancel();

      _subscription = null;
    }

    _tickStream = StreamController.broadcast();
    int initialValue = secondsFrom;

    _timer = Stream.periodic(tickDuration, (x) => x).takeWhile(
      (_) => initialValue > 0,
    );

    _subscription = _timer?.listen((_) {
      initialValue -= 1;
      _tickStream?.add(initialValue);

      if (initialValue <= 0) {
        _tickStream?.close();
        _tickStream = null;
        _subscription?.cancel();
        _subscription = null;
        _timer = null;
      }
    });

    return _tickStream!.stream;
  }

  void pause() {
    if (!(_subscription?.isPaused ?? true)) {
      _subscription?.pause();
    }
  }

  void resumePause() {
    if ((_subscription?.isPaused ?? false)) {
      _subscription?.resume();
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _tickStream?.close();
    _tickStream = null;
    _timer = null;
  }
}
