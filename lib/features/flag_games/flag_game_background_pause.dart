import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Пауза игры, пока приложение свёрнуто. Игра реализует [onAppHidden] /
/// [onAppShown]: останавливает свой цикл (тикер/таймер) и свои плееры звука,
/// а при возвращении продолжает с того же места. Фоновую музыку (playBgm)
/// движок звука ставит на паузу сам.
mixin FlagGameBackgroundPause<T extends StatefulWidget> on State<T> {
  late final AppLifecycleListener _lifecycle;

  /// Приложение сейчас свёрнуто.
  bool appHidden = false;

  // плееры, которые играли в момент сворачивания — их и возобновим
  final List<AudioPlayer> _pausedPlayers = [];

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onHide: _hide, onShow: _show);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _hide() {
    if (appHidden) return;
    appHidden = true;
    debugPrint('[Pause] ${widget.runtimeType}: app hidden, game paused');
    onAppHidden();
  }

  void _show() {
    if (!appHidden) return;
    appHidden = false;
    debugPrint('[Pause] ${widget.runtimeType}: app shown, game resumed');
    onAppShown();
  }

  /// Остановить игровой цикл и звуки.
  void onAppHidden();

  /// Продолжить игровой цикл (сбросив отсчёт времени, чтобы не было скачка).
  void onAppShown();

  /// Поставить на паузу те из [players], что сейчас играют.
  void pausePlayingPlayers(Iterable<AudioPlayer?> players) {
    _pausedPlayers.clear();
    for (final p in players) {
      if (p != null && p.state == PlayerState.playing) {
        _pausedPlayers.add(p);
        p.pause().catchError((Object _) {});
      }
    }
  }

  /// Возобновить плееры, поставленные на паузу [pausePlayingPlayers].
  void resumePausedPlayers() {
    for (final p in _pausedPlayers) {
      p.resume().catchError((Object _) {});
    }
    _pausedPlayers.clear();
  }
}
