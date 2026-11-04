import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/shared/services/disposable.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _soundMuteKey = "settings.audio.muted";

abstract class IAudioService implements IDisposable {
  ValueNotifier<bool> get muted;

  Future<void> toggleMute();

  /// Возвращает плеер звука из пула (null — звук выключен или ошибка).
  /// Плеер переиспользуется, освобождать его не нужно; остановить — [stopSfx].
  Future<AudioPlayer?> playSfx(GameSfx source, {double volume = 1});

  void stopSfx(AudioPlayer player);

  /// [fromStart] — всегда с начала трека (рестарт игры). Без него тот же
  /// трек не перезапускается: играющий продолжает играть, на паузе — продолжается.
  Future<void> playBgm(
    GameMusics source, {
    double volume = 0.9,
    bool fromStart = false,
  });

  Future<void> pauseBgm();

  Future<void> resumeBgm();

  /// Полностью выгружает звуки мини-игры: останавливает игровую музыку,
  /// освобождает все плееры эффектов и очищает кэш FlameAudio.
  Future<void> releaseGameAudio();
}

class AudioServiceImpl implements IAudioService {
  final SharedPreferences _preferences;
  final Future<void> _bgmInitialization;

  GameMusics? _currentBgm;

  // Все команды фоновой музыки — строго по очереди. На медленных телефонах
  // (Samsung A5 2016) play/pause/stop занимают заметное время, и без очереди
  // запросы накладывались: старый play заканчивался позже нового и включал
  // не тот трек, а пауза приходила раньше, чем трек начинал играть.
  Future<void> _bgmTail = Future.value();
  int _bgmPlayRequest = 0; // номер последнего запроса play — старые пропускаем

  // приложение видно; если свёрнуто — музыку не играем
  bool _appVisible = true;
  bool _resumeOnShow = false;
  late final AppLifecycleListener _lifecycle;

  Future<void> _runBgm(Future<void> Function() op) {
    final result = _bgmTail.then((_) => op());
    _bgmTail = result.then(
      (_) {},
      onError: (Object e) {
        debugPrint('Audio bgm op error: $e');
      },
    );
    return result.catchError((Object _) {});
  }

  // Пул плееров на каждый звук. FlameAudio.play создавал новый плеер в режиме
  // SoundPool на каждое воспроизведение, а SoundPool не сообщает об окончании —
  // плееры копились, и через минуту стрельбы звук начинал лагать.
  final Map<GameSfx, _SfxPool> _pools = {};
  static const int _maxPlayersPerSfx = 4;
  static final AudioContext _sfxContext = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  // музыка, которая не относится к флаговым мини-играм
  static const _menuMusics = {
    GameMusics.main,
    GameMusics.continents,
    GameMusics.fastMode,
    GameMusics.flagGamesMenu,
    GameMusics.african,
    GameMusics.american,
    GameMusics.asian,
    GameMusics.latina,
    GameMusics.european,
    GameMusics.oceania,
  };

  @override
  late final ValueNotifier<bool> muted;

  bool get isMuted => muted.value;

  AudioServiceImpl(this._preferences, {bool initialMuted = false})
    : _bgmInitialization = FlameAudio.bgm.initialize() {
    muted = ValueNotifier(_preferences.getBool(_soundMuteKey) ?? initialMuted);
    _lifecycle = AppLifecycleListener(onHide: _onAppHide, onShow: _onAppShow);
  }

  void _onAppHide() {
    _appVisible = false;
    _runBgm(() async {
      await _bgmInitialization;
      if (FlameAudio.bgm.audioPlayer.state == PlayerState.playing) {
        _resumeOnShow = true;
        await FlameAudio.bgm.pause();
      }
    });
  }

  void _onAppShow() {
    _appVisible = true;
    _runBgm(() async {
      if (!_resumeOnShow) return;
      _resumeOnShow = false;
      if (!isMuted && _currentBgm != null) await FlameAudio.bgm.resume();
    });
  }

  // трек запустился, пока приложение свёрнуто (медленный телефон) — на паузу
  Future<void> _pauseIfHidden() async {
    if (_appVisible) return;
    if (FlameAudio.bgm.audioPlayer.state == PlayerState.playing) {
      _resumeOnShow = true;
      await FlameAudio.bgm.pause();
    }
  }

  @override
  Future<void> playBgm(
    GameMusics source, {
    double volume = 0.9,
    bool fromStart = false,
  }) {
    final request = ++_bgmPlayRequest;
    return _runBgm(() async {
      // пока ждали очереди, пришёл более новый запрос — этот уже не нужен
      if (request != _bgmPlayRequest) return;
      await _bgmInitialization;
      final player = FlameAudio.bgm.audioPlayer;
      if (!fromStart && _currentBgm == source) {
        // тот же трек уже играет (вернулись из пазла к уровням) — не трогаем
        if (FlameAudio.bgm.isPlaying && player.state == PlayerState.playing) {
          return;
        }
        // тот же трек на паузе — продолжаем с того же места
        if (player.state == PlayerState.paused) {
          if (!isMuted && _appVisible) await FlameAudio.bgm.resume();
          return;
        }
      }
      _currentBgm = source;
      await FlameAudio.bgm.play(source.file, volume: volume);
      if (isMuted) {
        await FlameAudio.bgm.pause();
      }
      await _pauseIfHidden();
    });
  }

  @override
  Future<void> pauseBgm() {
    // пауза отменяет ещё не начатые запросы play
    _bgmPlayRequest++;
    return _runBgm(() async {
      await _bgmInitialization;
      if (_currentBgm == null) return;
      _resumeOnShow = false;
      await FlameAudio.bgm.pause();
    });
  }

  @override
  Future<void> resumeBgm() {
    return _runBgm(() async {
      await _bgmInitialization;
      if (_currentBgm == null || isMuted || !_appVisible) return;
      await FlameAudio.bgm.resume();
    });
  }

  @override
  Future<AudioPlayer?> playSfx(GameSfx source, {double volume = 1}) async {
    if (isMuted) {
      return null;
    }

    final normalizedVolume = volume.clamp(0.0, 1.0);
    final pool = _pools.putIfAbsent(source, () => _SfxPool(source.file));
    try {
      return await pool.run(() async {
        AudioPlayer? player;
        for (final p in pool.players) {
          if (p.state != PlayerState.playing) {
            player = p;
            break;
          }
        }
        if (player == null && pool.players.length < _maxPlayersPerSfx) {
          player = await _createSfxPlayer(source.file);
          pool.players.add(player);
        }
        if (player == null) {
          // все заняты — перезапускаем самый старый
          player = pool.players[pool.steal++ % pool.players.length];
          await player.stop();
        }
        await player.setVolume(normalizedVolume);
        await player.resume();
        return player;
      });
    } catch (e) {
      debugPrint('Audio playSfx error: $e');
      return null;
    }
  }

  Future<AudioPlayer> _createSfxPlayer(String file) async {
    final player = AudioPlayer()..audioCache = FlameAudio.audioCache;
    await player.setAudioContext(_sfxContext);
    await player.setPlayerMode(PlayerMode.mediaPlayer);
    // stop: после окончания плеер остаётся с загруженным звуком и в начале трека
    await player.setReleaseMode(ReleaseMode.stop);
    await player.setSource(AssetSource(file));
    return player;
  }

  @override
  void stopSfx(AudioPlayer player) {
    player.stop().catchError((Object e) {
      debugPrint('Audio stopSfx error: $e');
    });
  }

  @override
  Future<void> releaseGameAudio() async {
    final pools = List.of(_pools.values);
    _pools.clear();
    for (final pool in pools) {
      for (final player in pool.players) {
        player.dispose().catchError((Object e) {
          debugPrint('Audio sfx dispose error: $e');
        });
      }
    }

    await _runBgm(() async {
      final bgm = _currentBgm;
      if (bgm != null && !_menuMusics.contains(bgm)) {
        await _bgmInitialization;
        await FlameAudio.bgm.stop();
        _currentBgm = null;
      }

      // чистим кэш, кроме файла текущей музыки меню: старый MediaPlayer
      // (Android 6–7) при resume может заново открыть удалённый файл — и молчит
      final keep = _currentBgm?.file;
      final cache = FlameAudio.audioCache;
      for (final file in List.of(cache.loadedFiles.keys)) {
        if (file == keep) continue;
        try {
          await cache.clear(file);
        } catch (e) {
          debugPrint('Audio releaseGameAudio cache error: $e');
        }
      }
    });
  }

  @override
  Future<void> toggleMute() async {
    muted.value = !isMuted;
    await _preferences.setBool(_soundMuteKey, isMuted);

    if (_currentBgm == null) {
      return;
    }

    if (isMuted) {
      await pauseBgm();
    } else {
      await resumeBgm();
    }
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    muted.dispose();
  }
}

class _SfxPool {
  _SfxPool(this.file);

  final String file;
  final List<AudioPlayer> players = [];
  int steal = 0;
  Future<void> _tail = Future.value();

  // операции с пулом по очереди, чтобы параллельные вызовы не создали лишних плееров
  Future<T> run<T>(Future<T> Function() action) {
    final result = _tail.then((_) => action());
    _tail = result.then((_) {}, onError: (Object _) {});
    return result;
  }
}
