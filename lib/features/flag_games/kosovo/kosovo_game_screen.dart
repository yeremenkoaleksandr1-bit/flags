import 'dart:async';
import 'dart:math' as math;

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flags/features/flag_games/flag_game_viewport.dart';
import 'package:flags/features/flag_games/flag_game_background_pause.dart';
import 'package:flags/features/flag_games/flag_game_tap_hint.dart';
import 'package:flags/features/flag_games/flag_game_ads.dart';
import 'package:flags/features/flag_games/flag_game_vibration.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/uikit/components/buttons/actions/back_button.dart';

const String _p = 'assets/images/flag_games/kosovo/';

// ── Background stars (idle positions) ────────────────────────────────────────
const _kStarPositions = [
  (0.36, 0.18),
  (0.31, 0.24),
  (0.43, 0.13),
  (0.5, 0.13),
  (0.57, 0.18),
  (0.63, 0.25),
];
const double _kStarW = 45.0;
const double _kStarH = 45.0;
const double _kStarEndScale = 0.65;

// Island
const double _kIslandL = 0.23;
const double _kIslandT = 0.3;
const double _kIslandW = 0.52;
const double _kIslandH = 0.52;

// Размер кнопки назад (Positioned top:8, left:8, ~44px)
const double _kBtnSize = 44.0;
const double _kBtnMargin = 8.0;
// Отступ после кнопки до первой звезды
const double _kStarRowGap = 8.0;
// Расстояние между звёздами (по оси x, px)
const double _kStarSpacing = 4.0;

// ── Stand ─────────────────────────────────────────────────────────────────────
const double _kStandL = 0.42;
const double _kStandT = 0.48;
const double _kStandW = 0.15;
const double _kStandH = 0.15;

// ── Canon ─────────────────────────────────────────────────────────────────────
const double _kCanonW = 0.11;
const double _kCanonH = 0.11;

// ── Pivot point (rotation center, as fraction of screen) ─────────────────────
const double _kPivotX = 0.49;
const double _kPivotY = 0.55;

// ── Rotation speed ────────────────────────────────────────────────────────────
const double _kCanonMaxSpeed = 3.0;

// ── Projectile ────────────────────────────────────────────────────────────────
const double _kBulletSpeed = 600.0; // px/s
const double _kBulletSpinRate = 8.0; // rad/s
const double _kBulletSize = 30.0; // px, размер летящей звезды

// смещение точки вылета вдоль оси пушки (px): + = дальше от pivot, - = ближе
const double _kBulletOffsetAlong = 40.0;
// радиус хитбокса летящей звезды (px)
const double _kBulletHitR = 10.0;
const bool _kShowBulletHitbox = false; // показывать хитбокс

// ── Recoil ────────────────────────────────────────────────────────────────────
const double _kRecoilDistance = 14.0; // px, максимальный откат назад
const double _kRecoilKickDuration = 0.08; // s, фаза отдачи
const double _kRecoilReturnDuration = 0.35; // s, фаза возврата

// ── Shot cooldown ─────────────────────────────────────────────────────────────
const int _kShotCooldownMs = 1000;

// ── Wave config ───────────────────────────────────────────────────────────────
class _WaveCfg {
  final int boats;
  final int stars;
  final bool allSides;
  final int spawnIntervalMs;
  final double zigzagFrac;
  final double zigzagFreq; // Гц, переопределяет _kZigzagFreq если > 0
  final double
  zigzagAmplitude; // рад, переопределяет _kZigzagAmplitude если > 0
  const _WaveCfg({
    required this.boats,
    required this.stars,
    this.allSides = true,
    this.spawnIntervalMs = 9000,
    this.zigzagFrac = 0.0,
    this.zigzagFreq = 0.0,
    this.zigzagAmplitude = 0.0,
  });
}

const _kWaves = [
  _WaveCfg(
    boats: 4,
    stars: 6,
    allSides: false,
    spawnIntervalMs: 9000,
  ), // волна 1
  _WaveCfg(
    boats: 5,
    stars: 6,
    allSides: true,
    spawnIntervalMs: 7000,
  ), // волна 2
  _WaveCfg(
    boats: 6,
    stars: 7,
    allSides: true,
    spawnIntervalMs: 5000,
  ), // волна 3
  _WaveCfg(
    boats: 6,
    stars: 7,
    allSides: true,
    spawnIntervalMs: 3000,
  ), // волна 4
  _WaveCfg(
    boats: 6,
    stars: 7,
    allSides: true,
    spawnIntervalMs: 3000,
    zigzagFrac: 0.5,
  ), // волна 5
  _WaveCfg(
    boats: 8,
    stars: 8,
    allSides: true,
    spawnIntervalMs: 3000,
    zigzagFrac: 0.5,
    zigzagFreq: 0.02,
    zigzagAmplitude: 1.1,
  ), // волна 6
];

// ── Бесконечные волны после списка _kWaves ────────────────────────────────────
// Каждая следующая волна: +_kEndlessBoatsStep лодок и +1 снаряд. Лодок прибавляется
// больше, чем снарядов, — разницу покрывают снаряды, выпадающие из лодок.
const int _kEndlessBoatsStep = 2;
const int _kEndlessSpawnStepMs =
    250; // спавн с каждой волной чаще на столько мс
const int _kEndlessSpawnMinMs = 1000; // но не чаще чем раз в столько мс
const double _kAmmoDropFlyDur =
    0.7; // сколько летит выпавший снаряд к счётчику (сек)

_WaveCfg _waveConfig(int wave) {
  if (wave < _kWaves.length) return _kWaves[wave];
  final last = _kWaves.last;
  final n = wave - _kWaves.length + 1; // 1 для 7-й волны
  return _WaveCfg(
    boats: last.boats + n * _kEndlessBoatsStep,
    stars: last.stars + n,
    allSides: true,
    spawnIntervalMs: math.max(
      _kEndlessSpawnMinMs,
      last.spawnIntervalMs - n * _kEndlessSpawnStepMs,
    ),
    zigzagFrac: last.zigzagFrac,
    zigzagFreq: last.zigzagFreq,
    zigzagAmplitude: last.zigzagAmplitude,
  );
}

class _AmmoDrop {
  final Offset from; // px
  double t = 0;
  _AmmoDrop(this.from);
}

// параметры зигзага
const double _kZigzagFreq = 0.1; // Гц, частота виляния
const double _kZigzagAmplitude = 1.5; // рад, максимальное отклонение от курса

// ── Звук ──────────────────────────────────────────────────────────────────────
const double _kSeaVolume = 0.5; // фон моря (зациклен, с начала игры)
const double _kMusicVolume = 0.6; // фоновая музыка kosovo_music (с начала игры)
const double _kSpinVolume = 0.7; // вращение пушки (зациклено, пока крутится)
const double _kShotVolume = 1.0;
const double _kReloadVolume = 1.0;
const double _kExplodeVolume = 1.0;
const Duration _kReloadSoundDelay = Duration(
  milliseconds: 300,
); // перезарядка после выстрела

// ── Enemy boat ────────────────────────────────────────────────────────────────
const double _kBoatSize = 90.0; // px
const double _kBoatSpeedMin = 20.0; // px/s
const double _kBoatSpeedMax = 30.0; // px/s
const double _kHitW = 80.0; // ширина хитбокса (px, вдоль оси лодки)
const double _kHitH = 35.0; // высота хитбокса (px, поперёк оси лодки)
// расстояние от центра острова при котором лодка останавливается (доля экрана)
const double _kIslandReachFrac = 0.24;
// расстояние от которого начинается замедление (должно быть > _kIslandReachFrac)
const double _kIslandDecelFrac = 0.28;
const double _kBoatDockTime = 2.0; // s, выдержка перед взрывом у острова
const double _kBlinkFreq = 5.0; // Hz, частота мигания красного оттенка

// ── Explosion ─────────────────────────────────────────────────────────────────
const double _kExplosionDuration = 0.9; // s
const double _kExplosionMaxRadius = 100.0; // px

// ── Debris particles ──────────────────────────────────────────────────────────
const int _kDebrisCount = 12; // кол-во частиц на взрыв
const double _kDebrisSpeedMin = 80.0; // px/s
const double _kDebrisSpeedMax = 220.0; // px/s
const double _kDebrisDuration = 1.0; // s, время жизни частицы
const double _kDebrisSizeMin = 4.0; // px
const double _kDebrisSizeMax = 9.0; // px

// ── Controls layout ───────────────────────────────────────────────────────────
// Ползунок поворота
const double _kSliderLeft = 55.0; // отступ слева (px)
const double _kSliderBottom = 34.0; // отступ снизу (px)
const double _kSliderWidth = 250.0; // ширина (px)

// Кнопка огня
const double _kFireRight = 75.0; // отступ справа (px)
const double _kFireBottom = 56.0; // отступ снизу (px)
const double _kFireSize = 100.0; // диаметр (px)
const double _kFireIconSize = 56.0; // размер иконки (px)

// Задержка появления кнопок после начала интро
const Duration _kControlsFadeDelay = Duration(milliseconds: 400);
const Duration _kControlsFadeDuration = Duration(milliseconds: 400);

const Duration _kIntroDuration = Duration(milliseconds: 800);

const int _kTrailLength = 15; // количество точек следа
const double _kTrailSpacing = 7.0; // минимальное расстояние между точками (px)

class _Projectile {
  Offset pos;
  final Offset vel;
  double rot;
  final List<Offset> trail = [];

  _Projectile({required this.pos, required this.vel, this.rot = 0.0});
}

class _Boat {
  Offset pos;
  Offset vel;
  double angle;
  bool docked = false;
  double dockedT = 0.0;
  final bool zigzag;
  final double zigzagPhase;
  final double zigzagFreq;
  final double zigzagAmplitude;
  double zigzagT = 0.0;

  _Boat({
    required this.pos,
    required this.vel,
    required this.angle,
    this.zigzag = false,
    this.zigzagPhase = 0.0,
    this.zigzagFreq = 0.0,
    this.zigzagAmplitude = 0.0,
  });

  Offset get center => pos + Offset(_kBoatSize / 2, _kBoatSize / 2);
}

class _Explosion {
  final Offset center;
  double t;
  final double radiusMult; // 1.0 = normal, >1 = damage explosion

  _Explosion({required this.center, this.t = 0.0, this.radiusMult = 1.0});
}

class _Debris {
  Offset pos;
  Offset vel; // px/s, vy increases over time (gravity)
  double t; // 0..1 lifetime progress
  final double size;

  _Debris({
    required this.pos,
    required this.vel,
    required this.size,
    this.t = 0.0,
  });
}

@RoutePage()
class KosovoGameScreen extends StatefulWidget implements AutoRouteWrapper {
  // игра строится на «экране Pixel 10» и масштабируется под реальный экран
  @override
  Widget wrappedRoute(BuildContext context) =>
      FlagGameViewport(background: const Color(0xFF0049A9), child: this);

  const KosovoGameScreen({super.key});

  @override
  State<KosovoGameScreen> createState() => _KosovoGameScreenState();
}

class _KosovoGameScreenState extends State<KosovoGameScreen>
    with TickerProviderStateMixin, FlagGameBackgroundPause<KosovoGameScreen> {
  late final AnimationController _introCtrl;
  late final Animation<double> _introAnim;

  late final AnimationController _controlsCtrl;
  late final Animation<double> _controlsAnim;

  late final AnimationController _waveAnnCtrl;
  int _announcingWave = -1;

  late final AnimationController _smokeCtrl;
  late final AnimationController _smokeFadeCtrl;
  late final AnimationController _scorchFadeCtrl;
  static const int _kSmokeFrames = 30;
  // положение и размер дыма (доля экрана)
  static const double _kSmokeL = 0.17;
  static const double _kSmokeT = 0.06;
  static const double _kSmokeW = 0.65;
  static const double _kSmokeH =
      0.55; // волна которую объявляем прямо сейчас (-1 = нет)

  bool _introStarted = false;

  double _canonAngle = 0.0;
  double _stickValue = 0.0;

  late final IAudioCubit _audio;
  AudioPlayer? _seaPlayer;
  AudioPlayer? _spinPlayer;
  bool _spinPlaying = false;
  late final Ticker _ticker;
  Duration _lastTickTime = Duration.zero;

  // ── Пауза, пока приложение свёрнуто ──
  bool _tickerWasActive = false;

  @override
  void onAppHidden() {
    _tickerWasActive = _ticker.isActive;
    if (_tickerWasActive) _ticker.stop();
    pausePlayingPlayers([_seaPlayer, _spinPlayer]);
  }

  @override
  void onAppShown() {
    if (_tickerWasActive && mounted) {
      // новый отсчёт времени — первый кадр после возврата без скачка
      _lastTickTime = Duration.zero;
      _ticker.start();
    }
    resumePausedPlayers();
  }

  int _starsLeft = 6;
  final List<_Projectile> _projectiles = [];

  bool _recoilActive = false;
  double _recoilT = 0.0;
  bool _cooldownActive = false;
  Timer? _cooldownTimer;

  final List<_Boat> _boats = [];
  final List<_Explosion> _explosions = [];
  final List<_Debris> _debris = [];
  final List<Offset> _scorches = [];
  Timer? _spawnTimer;
  final math.Random _rng = math.Random();

  int _playerHp = 0; // 0=full, 1=damage1, 2=damage2, 3=dead
  bool _gameOver = false;
  bool _showGameOver = false;

  // ── Coin drop ─────────────────────────────────────────────────────────────
  static const double _kCoinChance = 0.10;
  static const int _kCoinMin = 10;
  static const int _kCoinMax = 50;
  bool _coinAnimPlaying = false;

  int _wave = 0;
  int _boatsSpawned = 0;
  int _boatsDefeated = 0;
  int _bestWave = 0; // лучший результат (номер волны, 1-based)

  _WaveCfg get _waveCfg => _waveConfig(_wave);

  // Выпадающие снаряды (только в бесконечных волнах): сколько ещё должно
  // выпасть в этой волне, чтобы снарядов хватило на все лодки
  int _dropsLeft = 0;
  final List<_AmmoDrop> _ammoDrops = [];

  int _dropsForWave(int wave) {
    if (wave < _kWaves.length) return 0;
    final cfg = _waveConfig(wave);
    return math.max(0, cfg.boats - cfg.stars);
  }

  // шанс = оставшиеся выпадения / оставшиеся лодки (включая эту), поэтому
  // к концу волны выпадут все нужные снаряды — последние лодки гарантированно
  void _maybeDropAmmo(Offset at) {
    if (_dropsLeft <= 0) return;
    final boatsLeft = _waveCfg.boats - _boatsDefeated + 1;
    if (boatsLeft <= _dropsLeft || _rng.nextDouble() < _dropsLeft / boatsLeft) {
      _dropsLeft--;
      _ammoDrops.add(_AmmoDrop(at));
    }
  }

  DateTime? _lastShotTime;

  Size _screenSize = Size.zero;

  @override
  static const _kBestWaveKey = 'kosovo_best_wave';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (int i = 0; i < _kSmokeFrames; i++) {
      final name = 'smoke${i.toString().padLeft(2, '0')}.png';
      precacheImage(
        AssetImage('assets/images/flag_games/kosovo/smoke/$name'),
        context,
      );
    }
  }

  Future<void> _loadBestWave() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => _bestWave = prefs.getInt(_kBestWaveKey) ?? 0);
  }

  Future<void> _saveBestWave(int wave) async {
    if (wave <= _bestWave) return;
    _bestWave = wave;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kBestWaveKey, wave);
  }

  @override
  void initState() {
    super.initState();
    _loadBestWave();
    _introCtrl = AnimationController(vsync: this, duration: _kIntroDuration);
    _introAnim = CurvedAnimation(parent: _introCtrl, curve: Curves.easeInOut);

    _controlsCtrl = AnimationController(
      vsync: this,
      duration: _kControlsFadeDuration,
    );
    _controlsAnim = CurvedAnimation(
      parent: _controlsCtrl,
      curve: Curves.easeIn,
    );

    _waveAnnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2300),
    );

    _smokeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _smokeFadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scorchFadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _ticker = createTicker(_tick)..start();
    _audio = context.read<IAudioCubit>();
    _initSounds();
  }

  static const _kGameSounds = [
    GameSfx.canonShoot,
    GameSfx.canonReload,
    GameSfx.boatExplode,
    GameSfx.boatExplode2,
    GameSfx.boatExplode3,
  ];

  static final AudioContext _kMixContext = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  static const _kExplodeSounds = [
    GameSfx.boatExplode,
    GameSfx.boatExplode2,
    GameSfx.boatExplode3,
  ];

  Future<AudioPlayer> _createLoopPlayer(GameSfx sfx, double volume) async {
    final p = AudioPlayer()..audioCache = FlameAudio.audioCache;
    // mixWithOthers: иначе каждый плеер забирает аудиофокус, и Android
    // ставит на паузу остальные (море замолкало при вращении пушки)
    await p.setAudioContext(_kMixContext);
    await p.setPlayerMode(PlayerMode.mediaPlayer);
    await p.setReleaseMode(ReleaseMode.loop);
    await p.setVolume(volume);
    await p.setSource(AssetSource(sfx.file));
    return p;
  }

  Future<void> _initSounds() async {
    await FlameAudio.audioCache.loadAll([
      ..._kGameSounds.map((s) => s.file),
      GameSfx.kosovoSea.file,
      GameSfx.canonSpin.file,
    ]);
    if (!mounted || _audio.state.muted) return;
    // прогрев пулов, чтобы первый выстрел/взрыв не запаздывал
    for (final sfx in _kGameSounds) {
      _audio.playSfx(sfx, volume: 0);
    }
    try {
      final sea = await _createLoopPlayer(GameSfx.kosovoSea, _kSeaVolume);
      final spin = await _createLoopPlayer(GameSfx.canonSpin, _kSpinVolume);
      if (!mounted) {
        sea.dispose();
        spin.dispose();
        return;
      }
      _seaPlayer = sea;
      _spinPlayer = spin;
      // море — только после старта игры; если тап был раньше загрузки, включаем здесь
      if (_introStarted) await sea.resume();
      _updateSpinSound();
    } catch (e) {
      debugPrint('Kosovo loop sound error: $e');
    }
  }

  // вращение звучит, пока джойстик отклонён и игра идёт;
  // в платформу ходим только при смене состояния
  void _updateSpinSound() {
    final p = _spinPlayer;
    if (p == null) return;
    final shouldPlay = _stickValue != 0.0 && !_gameOver;
    if (shouldPlay == _spinPlaying) return;
    _spinPlaying = shouldPlay;
    (shouldPlay ? p.resume() : p.pause()).catchError((Object _) {});
  }

  void _playExplosion() {
    _audio.playSfx(
      _kExplodeSounds[_rng.nextInt(_kExplodeSounds.length)],
      volume: _kExplodeVolume,
    );
  }

  void _tick(Duration elapsed) {
    final dt = _lastTickTime == Duration.zero
        ? 0.0
        : (elapsed - _lastTickTime).inMicroseconds / 1e6;
    _lastTickTime = elapsed;

    final needsRebuild =
        _stickValue != 0.0 ||
        _projectiles.isNotEmpty ||
        _recoilActive ||
        _boats.isNotEmpty ||
        _explosions.isNotEmpty ||
        _debris.isNotEmpty ||
        _ammoDrops.isNotEmpty;
    if (!needsRebuild) return;

    setState(() {
      // always update explosions and debris so they finish playing after game over
      final sw = _screenSize.width;
      final sh = _screenSize.height;

      for (final e in _explosions) {
        e.t = (e.t + dt / _kExplosionDuration).clamp(0.0, 1.0);
      }
      _explosions.removeWhere((e) => e.t >= 1.0);

      // выпавшие снаряды летят к счётчику и зачисляются по прилёту
      for (final d in _ammoDrops) {
        d.t += dt / _kAmmoDropFlyDur;
      }
      final arrived = _ammoDrops.where((d) => d.t >= 1.0).length;
      if (arrived > 0) {
        _ammoDrops.removeWhere((d) => d.t >= 1.0);
        _starsLeft = math.min(_starsLeft + arrived, _waveCfg.stars);
      }

      for (final d in _debris) {
        d.pos += d.vel * dt;
        d.t = (d.t + dt / _kDebrisDuration).clamp(0.0, 1.0);
      }
      _debris.removeWhere((d) => d.t >= 1.0);

      // move boats + smooth deceleration near island (runs even after game over)
      final islandCenter = Offset(
        sw * (_kIslandL + _kIslandW / 2),
        sh * (_kIslandT + _kIslandH / 2),
      );
      final reachR = math.min(sw, sh) * _kIslandReachFrac;
      final decelR = math.min(sw, sh) * _kIslandDecelFrac;
      for (final b in _boats) {
        if (b.docked) continue;
        // зигзаг: осциллируем угол вокруг прямого курса к острову
        if (b.zigzag) {
          b.zigzagT += dt;
          final toIsland = islandCenter - b.center;
          final baseAngle = math.atan2(toIsland.dy, toIsland.dx);
          final osc =
              math.sin(b.zigzagT * b.zigzagFreq * math.pi * 2 + b.zigzagPhase) *
              b.zigzagAmplitude;
          final spd = b.vel.distance;
          final newAngle = baseAngle + osc;
          b.vel = Offset(math.cos(newAngle) * spd, math.sin(newAngle) * spd);
          b.angle = newAngle;
        }
        final dist = (b.center - islandCenter).distance;
        final factor = dist < decelR
            ? ((dist - reachR) / (decelR - reachR)).clamp(0.05, 1.0)
            : 1.0;
        b.pos += b.vel * dt * factor;
        if ((b.center - islandCenter).distance <= reachR) {
          b.docked = true;
          b.vel = Offset.zero;
        }
      }

      // boat-to-boat separation (soft push)
      const double _kBoatSepRadius = _kBoatSize * 0.85;
      for (int i = 0; i < _boats.length; i++) {
        for (int j = i + 1; j < _boats.length; j++) {
          final a = _boats[i];
          final b = _boats[j];
          final delta = a.center - b.center;
          final dist = delta.distance;
          if (dist < _kBoatSepRadius && dist > 0.01) {
            final push = (delta / dist) * (_kBoatSepRadius - dist) * 0.5;
            if (!a.docked) a.pos += push;
            if (!b.docked) b.pos -= push;
            // после толчка: мягко корректируем направление к острову
            void _reorient(_Boat boat) {
              if (boat.docked) return;
              final spd = boat.vel.distance;
              if (spd < 0.01) return;
              final toIsland = islandCenter - boat.center;
              final tLen = toIsland.distance;
              if (tLen < 0.01) return;
              final toDir = toIsland / tLen;
              final curDir = boat.vel / spd;
              const blend = 0.12;
              final newDir = curDir * (1.0 - blend) + toDir * blend;
              final nLen = newDir.distance;
              if (nLen < 0.01) return;
              boat.vel = (newDir / nLen) * spd;
              boat.angle = math.atan2(boat.vel.dy, boat.vel.dx);
            }

            _reorient(a);
            _reorient(b);
          }
        }
      }

      if (_gameOver) return;

      if (_stickValue != 0.0) {
        final speedMult = 1.0 - _playerHp * 0.3; // -30% за каждый урон
        _canonAngle += _stickValue * _kCanonMaxSpeed * speedMult * dt;
      }

      if (_recoilActive) {
        _recoilT += dt;
        if (_recoilT >= _kRecoilKickDuration + _kRecoilReturnDuration) {
          _recoilActive = false;
          _recoilT = 0.0;
        }
      }

      // move projectiles + update trail
      for (final p in _projectiles) {
        p.pos += p.vel * dt;
        p.rot += _kBulletSpinRate * dt;
        final center = p.pos + Offset(_kBulletSize / 2, _kBulletSize / 2);
        if (p.trail.isEmpty ||
            (p.trail.last - center).distance >= _kTrailSpacing) {
          p.trail.add(center);
          if (p.trail.length > _kTrailLength) p.trail.removeAt(0);
        }
      }

      // docking countdown + explosion (gameplay only)
      final dockedToExplode = <_Boat>[];
      for (final b in _boats) {
        if (!b.docked) continue;
        b.dockedT += dt;
        if (b.dockedT >= _kBoatDockTime) dockedToExplode.add(b);
      }
      for (final b in dockedToExplode) {
        _boats.remove(b);
        _scorches.add(b.center);
        _explosions.add(_Explosion(center: b.center, radiusMult: 1.8));
        _playExplosion();
        for (int i = 0; i < _kDebrisCount; i++) {
          final a = _rng.nextDouble() * math.pi * 2;
          final speed =
              _kDebrisSpeedMin +
              _rng.nextDouble() * (_kDebrisSpeedMax - _kDebrisSpeedMin);
          final size =
              _kDebrisSizeMin +
              _rng.nextDouble() * (_kDebrisSizeMax - _kDebrisSizeMin);
          _debris.add(
            _Debris(
              pos: b.center - Offset(size / 2, size / 2),
              vel: Offset(math.cos(a) * speed, math.sin(a) * speed),
              size: size,
            ),
          );
        }
        _playerHp++;
        _boatsDefeated++;
        if (_playerHp >= 3) {
          _gameOver = true;
          flagGameVibrate(context, 'Kosovo', 'lose');
          flagGameLossAd(context, 'Kosovo', isStillLost: () => _gameOver);
          _updateSpinSound();
          _audio.pauseBgm();
          _spawnTimer?.cancel();
          _saveBestWave(_wave + 1);
          _smokeCtrl.repeat();
          _smokeFadeCtrl.forward();
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) setState(() => _showGameOver = true);
          });
        }
      }
      if (!_gameOver &&
          _boatsDefeated >= _waveCfg.boats &&
          _boatsSpawned >= _waveCfg.boats) {
        _advanceWave();
      }

      // collision: projectile circle vs rotated boat hitbox (expanded by bullet radius)
      final hitBoats = <_Boat>{};
      final hitProjectiles = <_Projectile>{};
      const halfW = _kHitW / 2 + _kBulletHitR;
      const halfH = _kHitH / 2 + _kBulletHitR;
      for (final p in _projectiles) {
        final pc = p.pos + Offset(_kBulletSize / 2, _kBulletSize / 2);
        for (final b in _boats) {
          if (hitBoats.contains(b)) continue;
          final bc = b.center;
          final d = pc - bc;
          final cos = math.cos(-b.angle);
          final sin = math.sin(-b.angle);
          final lx = d.dx * cos - d.dy * sin;
          final ly = d.dx * sin + d.dy * cos;
          if (lx.abs() < halfW && ly.abs() < halfH) {
            hitBoats.add(b);
            hitProjectiles.add(p);
            _explosions.add(_Explosion(center: bc));
            _playExplosion();
            for (int i = 0; i < _kDebrisCount; i++) {
              final angle = _rng.nextDouble() * math.pi * 2;
              final speed =
                  _kDebrisSpeedMin +
                  _rng.nextDouble() * (_kDebrisSpeedMax - _kDebrisSpeedMin);
              final size =
                  _kDebrisSizeMin +
                  _rng.nextDouble() * (_kDebrisSizeMax - _kDebrisSizeMin);
              _debris.add(
                _Debris(
                  pos: bc - Offset(size / 2, size / 2),
                  vel: Offset(math.cos(angle) * speed, math.sin(angle) * speed),
                  size: size,
                ),
              );
            }
          }
        }
      }
      _boats.removeWhere(hitBoats.contains);
      _projectiles.removeWhere(hitProjectiles.contains);
      for (final b in hitBoats) {
        _boatsDefeated++;
        _maybeDropAmmo(b.center);
        if (!_coinAnimPlaying && _rng.nextDouble() < _kCoinChance) {
          _triggerCoinDrop(b.center);
        }
      }
      // переход к следующей волне когда все лодки волны уничтожены

      // remove off-screen projectiles
      _projectiles.removeWhere(
        (p) =>
            p.pos.dx < -_kBulletSize ||
            p.pos.dx > sw + _kBulletSize ||
            p.pos.dy < -_kBulletSize ||
            p.pos.dy > sh + _kBulletSize,
      );

      // remove off-screen boats (went past center and out)
      _boats.removeWhere(
        (b) =>
            b.pos.dx < -_kBoatSize * 2 ||
            b.pos.dx > sw + _kBoatSize * 2 ||
            b.pos.dy < -_kBoatSize * 2 ||
            b.pos.dy > sh + _kBoatSize * 2,
      );
    });
  }

  void _restart() {
    _spawnTimer?.cancel();
    _cooldownTimer?.cancel();
    setState(() {
      _introStarted = false;
      _lastTickTime = Duration.zero;
      _canonAngle = 0.0;
      _stickValue = 0.0;
      _starsLeft = 6;
      _projectiles.clear();
      _boats.clear();
      _explosions.clear();
      _debris.clear();
      _scorches.clear();
      _recoilActive = false;
      _recoilT = 0.0;
      _cooldownActive = false;
      _lastShotTime = null;
      _playerHp = 0;
      _gameOver = false;
      // следующий старт (тап) запустит музыку с начала трека
      _musicStarted = false;
      _showGameOver = false;
      _coinAnimPlaying = false;
      _wave = 0;
      _boatsSpawned = 0;
      _boatsDefeated = 0;
      _starsLeft = _kWaves[0].stars;
      _announcingWave = -1;
      _dropsLeft = 0;
      _ammoDrops.clear();
    });
    _introCtrl.reset();
    _controlsCtrl.reset();
    _smokeCtrl.stop();
    _smokeCtrl.reset();
    _smokeFadeCtrl.reset();
    _scorchFadeCtrl.reset();
    _updateSpinSound();
  }

  void _triggerCoinDrop(Offset center) {
    if (_coinAnimPlaying) return;
    _coinAnimPlaying = true;
    final amount = _kCoinMin + _rng.nextInt(_kCoinMax - _kCoinMin + 1);
    if (amount > 15) context.read<IAudioCubit>().playSfx(GameSfx.money);
    context.read<GamePreferencesCubit>().addMoney(amount);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final layer = UiMoneyLayer.find();
      layer.setDisplayConfig(
        const MoneyDisplayConfig(
          paddingRight: 8,
          pillHeight: 24,
          pillTop: 3,
          iconHeight: 34,
          iconOffsetTop: -5,
          iconOffsetLeft: -5,
          fontSize: 18,
          strokeWidth: 3,
          paddingLeft: 28,
          paddingRight2: 10,
          paddingTop: 2,
        ),
      );
      await layer.show();
      await layer.addMoneys(() => FlagGameViewport.toScreen(context, center), amount.clamp(1, 50));
      await Future.delayed(const Duration(milliseconds: 600));
      await layer.hide();
      if (mounted) setState(() => _coinAnimPlaying = false);
    });
  }

  String get _canonSprite {
    if (_playerHp >= 3) return '${_p}kosovo_canon_destr.png';
    if (_playerHp >= 2) return '${_p}kosovo_canon_damage2.png';
    if (_playerHp >= 1) return '${_p}kosovo_canon_damage1.png';
    return '${_p}kosovo_canon.png';
  }

  String get _standSprite {
    if (_playerHp >= 3) return '${_p}kosovo_stand_destr.png';
    if (_playerHp >= 2) return '${_p}kosovo_stand_damage2.png';
    if (_playerHp >= 1) return '${_p}kosovo_stand_damage1.png';
    return '${_p}kosovo_stand.png';
  }

  double get _recoilOffset {
    if (!_recoilActive) return 0.0;
    final total = _kRecoilKickDuration + _kRecoilReturnDuration;
    final t = (_recoilT / total).clamp(0.0, 1.0);
    final kickFrac = _kRecoilKickDuration / total;
    if (t < kickFrac) {
      return _kRecoilDistance * (t / kickFrac);
    } else {
      return _kRecoilDistance * (1.0 - (t - kickFrac) / (1.0 - kickFrac));
    }
  }

  void _fireCanon() {
    if (!_introStarted || _introCtrl.value < 0.99) return;
    if (_starsLeft <= 0) return;
    final now = DateTime.now();
    if (_lastShotTime != null &&
        now.difference(_lastShotTime!).inMilliseconds < _kShotCooldownMs)
      return;

    final sw = _screenSize.width;
    final sh = _screenSize.height;
    final pivotX = sw * _kPivotX;
    final pivotY = sh * _kPivotY;

    // cannon points right at angle=0
    final dx = math.cos(_canonAngle);
    final dy = math.sin(_canonAngle);

    final originX = pivotX + dx * _kBulletOffsetAlong;
    final originY = pivotY + dy * _kBulletOffsetAlong;

    _lastShotTime = now;
    _cooldownActive = true;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer(Duration(milliseconds: _kShotCooldownMs), () {
      if (mounted) setState(() => _cooldownActive = false);
    });
    _audio.playSfx(GameSfx.canonShoot, volume: _kShotVolume);
    if (_starsLeft > 1) {
      // перезарядка — только если после этого выстрела ещё остались снаряды
      Future.delayed(_kReloadSoundDelay, () {
        if (mounted)
          _audio.playSfx(GameSfx.canonReload, volume: _kReloadVolume);
      });
    }
    setState(() {
      _starsLeft--;
      _recoilActive = true;
      _recoilT = 0.0;
      _projectiles.add(
        _Projectile(
          pos: Offset(originX - _kBulletSize / 2, originY - _kBulletSize / 2),
          vel: Offset(dx * _kBulletSpeed, dy * _kBulletSpeed),
        ),
      );
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _cooldownTimer?.cancel();
    _spawnTimer?.cancel();
    _introCtrl.dispose();
    _controlsCtrl.dispose();
    _waveAnnCtrl.dispose();
    _smokeCtrl.dispose();
    _smokeFadeCtrl.dispose();
    _scorchFadeCtrl.dispose();
    _seaPlayer?.dispose();
    _spinPlayer?.dispose();
    super.dispose();
  }

  void _spawnBoat() {
    // пока приложение свёрнуто, лодки не появляются (таймер спавна в фоне идёт)
    if (_screenSize == Size.zero || _gameOver || appHidden) return;
    final cfg = _waveCfg;
    if (_boatsSpawned >= cfg.boats) return; // лимит волны

    final sw = _screenSize.width;
    final sh = _screenSize.height;
    final cx = sw / 2;
    final cy = sh / 2;

    // волна 1: только правая сторона; остальные: все 4 стороны
    final side = cfg.allSides ? _rng.nextInt(4) : 1;
    double bx, by;
    switch (side) {
      case 0:
        bx = _rng.nextDouble() * sw;
        by = -_kBoatSize;
        break;
      case 1:
        bx = sw;
        by = _rng.nextDouble() * sh;
        break;
      case 2:
        bx = _rng.nextDouble() * sw;
        by = sh;
        break;
      default:
        bx = -_kBoatSize;
        by = _rng.nextDouble() * sh;
        break;
    }

    final bcx = bx + _kBoatSize / 2;
    final bcy = by + _kBoatSize / 2;
    final dx = cx - bcx;
    final dy = cy - bcy;
    final len = math.sqrt(dx * dx + dy * dy);
    final speed =
        _kBoatSpeedMin + _rng.nextDouble() * (_kBoatSpeedMax - _kBoatSpeedMin);
    final angle = math.atan2(dy, dx);

    final isZigzag = _rng.nextDouble() < cfg.zigzagFrac;
    setState(() {
      _boats.add(
        _Boat(
          pos: Offset(bx, by),
          vel: Offset(dx / len * speed, dy / len * speed),
          angle: angle,
          zigzag: isZigzag,
          zigzagPhase: _rng.nextDouble() * math.pi * 2,
          zigzagFreq: cfg.zigzagFreq > 0 ? cfg.zigzagFreq : _kZigzagFreq,
          zigzagAmplitude: cfg.zigzagAmplitude > 0
              ? cfg.zigzagAmplitude
              : _kZigzagAmplitude,
        ),
      );
      _boatsSpawned++;
    });
  }

  void _advanceWave() {
    _saveBestWave(_wave + 1);
    _wave++;
    _boatsSpawned = 0;
    _boatsDefeated = 0;
    _starsLeft = _waveCfg.stars;
    _dropsLeft = _dropsForWave(_wave);
    _ammoDrops.clear();
    _playerHp = 0;
    _spawnTimer?.cancel();
    // плавно убираем пятна, потом показываем анонс волны
    _scorchFadeCtrl.forward(from: 0).then((_) {
      if (mounted) setState(() => _scorches.clear());
      _scorchFadeCtrl.reset();
      _announceWave(_wave);
    });
  }

  void _announceWave(int waveIndex) {
    setState(() => _announcingWave = waveIndex);
    _waveAnnCtrl.forward(from: 0).then((_) {
      if (!mounted) return;
      setState(() => _announcingWave = -1);
      // после анонса сразу спавним первую лодку, потом по таймеру
      _spawnBoat();
      _spawnTimer = Timer.periodic(
        Duration(milliseconds: _waveCfg.spawnIntervalMs),
        (_) => _spawnBoat(),
      );
    });
  }

  bool _musicStarted = false;

  void _onTap() {
    if (_introStarted) return;
    _introStarted = true;
    // музыка запускается один раз и играет и после рестартов;
    // при выходе в список флагов её останавливает releaseGameAudio
    if (!_musicStarted) {
      _musicStarted = true;
      _audio.playBgm(GameMusics.kosovo, volume: _kMusicVolume, fromStart: true);
      _seaPlayer?.resume();
    }
    _starsLeft = _waveCfg.stars;
    _introCtrl.forward();
    Future.delayed(_kControlsFadeDelay, () {
      if (mounted) _controlsCtrl.forward();
    });
    // анонс первой волны — таймер спавна запустится после анонса
    Future.delayed(_kIntroDuration, () {
      if (mounted) _announceWave(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;
    _screenSize = size;

    final pivotX = sw * _kPivotX;
    final pivotY = sh * _kPivotY;
    final canonW = sw * _kCanonW;
    final canonH = sh * _kCanonH;

    // Целевые позиции звёзд: ряд(ы) сразу после кнопки назад
    final starW = _kStarW * _kStarEndScale;
    final starH = _kStarH * _kStarEndScale;
    final rowStartX = _kBtnMargin + _kBtnSize + _kStarRowGap;
    final rowTopY = _kBtnMargin + (_kBtnSize - starH) / 2;
    const int maxPerRow = 7;
    final totalStars = _waveCfg.stars;
    final starTargets = List.generate(totalStars, (i) {
      final row = i ~/ maxPerRow;
      final col = i % maxPerRow;
      return (
        (rowStartX + col * (starW + _kStarSpacing)) / sw,
        (rowTopY + row * (starH + 4)) / sh,
      );
    });

    return GestureDetector(
      onTapUp: (_) => _onTap(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0049A9),
        body: AnimatedBuilder(
          animation: _introAnim,
          builder: (context, _) {
            final t = _introAnim.value;
            return Stack(
              children: [
                // Island
                Positioned(
                  left: sw * _kIslandL,
                  top: sh * _kIslandT,
                  width: sw * _kIslandW,
                  height: sh * _kIslandH,
                  child: Image.asset(
                    '${_p}kosovo_island.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // Enemy boats
                for (final boat in _boats) ...[
                  Positioned(
                    left: boat.pos.dx,
                    top: boat.pos.dy,
                    width: _kBoatSize,
                    height: _kBoatSize,
                    child: Transform.rotate(
                      angle: boat.angle,
                      child: boat.docked
                          ? ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.red.withOpacity(
                                  (math
                                              .sin(
                                                boat.dockedT *
                                                    math.pi *
                                                    2 *
                                                    _kBlinkFreq,
                                              )
                                              .abs() *
                                          0.75)
                                      .clamp(0.0, 1.0),
                                ),
                                BlendMode.srcATop,
                              ),
                              child: Image.asset(
                                '${_p}enemy_boat.png',
                                fit: BoxFit.contain,
                              ),
                            )
                          : Image.asset(
                              '${_p}enemy_boat.png',
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ],

                // Scorch marks (permanent dark spots from boat explosions)
                if (_scorches.isNotEmpty)
                  AnimatedBuilder(
                    animation: _scorchFadeCtrl,
                    builder: (_, __) => Stack(
                      children: [
                        for (final sc in _scorches)
                          Positioned(
                            left: sc.dx - 44,
                            top: sc.dy - 44,
                            width: 88,
                            height: 88,
                            child: Opacity(
                              opacity: (1.0 - _scorchFadeCtrl.value).clamp(
                                0.0,
                                1.0,
                              ),
                              child: const DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Color(0xCC1A0A00),
                                      Color(0x661A0A00),
                                      Color(0x001A0A00),
                                    ],
                                    stops: [0.0, 0.5, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                // Explosions
                for (final exp in _explosions)
                  () {
                    final radius =
                        _kExplosionMaxRadius * exp.radiusMult * exp.t;
                    final opacity = (1.0 - exp.t).clamp(0.0, 1.0);
                    return Positioned(
                      left: exp.center.dx - radius,
                      top: exp.center.dy - radius,
                      width: radius * 2,
                      height: radius * 2,
                      child: Opacity(
                        opacity: opacity,
                        child: CustomPaint(
                          painter: _ExplosionPainter(progress: exp.t),
                        ),
                      ),
                    );
                  }(),

                // Debris particles
                for (final d in _debris)
                  Positioned(
                    left: d.pos.dx,
                    top: d.pos.dy,
                    width: d.size,
                    height: d.size,
                    child: Opacity(
                      opacity: (1.0 - d.t).clamp(0.0, 1.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6A00),
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ),

                // Stand — pivot at image center = pivotX/Y
                Positioned(
                  left: pivotX - sw * _kStandW / 2,
                  top: pivotY - sh * _kStandH / 2,
                  width: sw * _kStandW,
                  height: sh * _kStandH,
                  child: Transform.scale(
                    scale: t,
                    alignment: Alignment.center,
                    child: Image.asset(_standSprite, fit: BoxFit.contain),
                  ),
                ),

                // HUD stars (row after back button, wrap to 2nd row if >7)
                for (int i = 0; i < totalStars; i++)
                  () {
                    final (tl, tt) = starTargets[i];
                    // intro: fly from original corner position if available, else start at target
                    final (sl, st) = i < _kStarPositions.length
                        ? _kStarPositions[i]
                        : (tl, tt);
                    final scale = 1.0 + (_kStarEndScale - 1.0) * t;
                    final visible = i < _starsLeft;
                    return Positioned(
                      left: sw * (sl + (tl - sl) * t),
                      top: sh * (st + (tt - st) * t),
                      width: _kStarW,
                      height: _kStarH,
                      child: Opacity(
                        opacity: visible ? 1.0 : 0.0,
                        child: Transform.scale(
                          scale: scale,
                          child: Image.asset(
                            '${_p}kosovo_star.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  }(),

                // Выпавшие снаряды: летят из лодки в свободную ячейку счётчика
                for (final (k, d) in _ammoDrops.indexed)
                  () {
                    final slot = math.min(_starsLeft + k, totalStars - 1);
                    final (tl, tt) = starTargets[slot];
                    final e = Curves.easeInOut.transform(d.t.clamp(0.0, 1.0));
                    final arc =
                        math.sin(d.t * math.pi) * sh * 0.12; // дуга вверх
                    final size = _kStarW * (1.2 + (_kStarEndScale - 1.2) * e);
                    final cx =
                        d.from.dx + (sw * tl + _kStarW / 2 - d.from.dx) * e;
                    final cy =
                        d.from.dy +
                        (sh * tt + _kStarH / 2 - d.from.dy) * e -
                        arc;
                    return Positioned(
                      key: ObjectKey(d),
                      left: cx - size / 2,
                      top: cy - size / 2,
                      width: size,
                      height: size,
                      child: IgnorePointer(
                        child: Image.asset(
                          '${_p}kosovo_star.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }(),

                // Projectiles (between stand and cannon)
                for (final proj in _projectiles) ...[
                  // trail
                  for (int i = 0; i < proj.trail.length; i++) ...[
                    () {
                      final frac =
                          (i + 1) / proj.trail.length; // 0..1, старые → новые
                      final opacity = frac * 0.55;
                      final size = _kBulletSize * 0.5 * frac;
                      final c = proj.trail[i];
                      return Positioned(
                        left: c.dx - size / 2,
                        top: c.dy - size / 2,
                        width: size,
                        height: size,
                        child: Opacity(
                          opacity: opacity,
                          child: Image.asset(
                            '${_p}kosovo_star.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }(),
                  ],
                  Positioned(
                    left: proj.pos.dx,
                    top: proj.pos.dy,
                    width: _kBulletSize,
                    height: _kBulletSize,
                    child: Transform.rotate(
                      angle: proj.rot,
                      child: Image.asset(
                        '${_p}kosovo_star.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  if (_kShowBulletHitbox)
                    Positioned(
                      left: proj.pos.dx + _kBulletSize / 2 - _kBulletHitR,
                      top: proj.pos.dy + _kBulletSize / 2 - _kBulletHitR,
                      width: _kBulletHitR * 2,
                      height: _kBulletHitR * 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.cyan.withOpacity(0.35),
                          border: Border.all(color: Colors.cyan, width: 1.0),
                        ),
                      ),
                    ),
                ],

                // Canon — rotates strictly around pivot point
                Positioned(
                  left: pivotX,
                  top: pivotY,
                  child: Transform.rotate(
                    angle: _canonAngle,
                    alignment: Alignment.topLeft,
                    child: Transform.scale(
                      scale: t,
                      alignment: Alignment.topLeft,
                      child: Transform.translate(
                        offset: Offset(
                          -canonW / 2 - _recoilOffset,
                          -canonH / 2,
                        ),
                        child: SizedBox(
                          width: canonW,
                          height: canonH,
                          child: Image.asset(_canonSprite, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  ),
                ),

                // Smoke animation (after cannon destroyed)
                if (_gameOver)
                  AnimatedBuilder(
                    animation: Listenable.merge([_smokeCtrl, _smokeFadeCtrl]),
                    builder: (_, __) {
                      final frame = (_smokeCtrl.value * _kSmokeFrames)
                          .floor()
                          .clamp(0, _kSmokeFrames - 1);
                      final name =
                          'smoke${frame.toString().padLeft(2, '0')}.png';
                      final opacity = _smokeFadeCtrl.value;
                      return Positioned(
                        left: sw * _kSmokeL,
                        top: sh * _kSmokeT,
                        width: sw * _kSmokeW,
                        height: sh * _kSmokeH,
                        child: Opacity(
                          opacity: opacity,
                          child: Image.asset(
                            'assets/images/flag_games/kosovo/smoke/$name',
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),

                // Back button
                // «Tap to start» — один раз, на первом открытом флаге
                Positioned.fill(
                  child: FlagGameTapHint(visible: !_introStarted),
                ),
                const Positioned(top: 8, left: 8, child: FBackButton()),

                // Best wave record (only before game start)
                if (_bestWave > 0 && !_introStarted)
                  Positioned(
                    top: 12,
                    right: 16,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/winner_cup.png',
                          width: 32,
                          height: 32,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$_bestWave',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 6),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Wave label
                if (_introStarted)
                  Positioned(
                    top: 12,
                    right: 16,
                    child: Text(
                      'Wave ${_wave + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                      ),
                    ),
                  ),

                // Controls (fade in after intro)
                AnimatedBuilder(
                  animation: _controlsAnim,
                  builder: (_, __) => Opacity(
                    opacity: _controlsAnim.value,
                    child: Stack(
                      children: [
                        // Stick slider — bottom left
                        Positioned(
                          left: _kSliderLeft,
                          bottom: _kSliderBottom,
                          width: _kSliderWidth,
                          child: _StickSlider(
                            value: _stickValue,
                            onChanged: (v) {
                              setState(() => _stickValue = v);
                              _updateSpinSound();
                            },
                            onReleased: () {
                              setState(() => _stickValue = 0.0);
                              _updateSpinSound();
                            },
                          ),
                        ),

                        // Fire button — bottom right
                        Positioned(
                          right: _kFireRight,
                          bottom: _kFireBottom,
                          child: _FireButton(
                            onFire: _fireCanon,
                            enabled: !_cooldownActive && _starsLeft > 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Wave announcement overlay
                if (_announcingWave >= 0)
                  AnimatedBuilder(
                    animation: _waveAnnCtrl,
                    builder: (_, __) {
                      final p = _waveAnnCtrl.value; // 0→1
                      // затемнение: плавно появляется и исчезает
                      final overlayOpacity = p < 0.15
                          ? p / 0.15
                          : p > 0.85
                          ? (1.0 - p) / 0.15
                          : 1.0;
                      // фаза 1 (0→0.35): вылет справа → центр (easeOut)
                      // фаза 2 (0.35→0.57): пауза по центру ~0.5s
                      // фаза 3 (0.57→1.0): ускорение влево (easeIn)
                      final double dx;
                      if (p < 0.35) {
                        final t1 = p / 0.35;
                        final eased = 1.0 - (1.0 - t1) * (1.0 - t1); // easeOut
                        dx = sw * (1.0 - eased);
                      } else if (p < 0.57) {
                        dx = 0;
                      } else {
                        final t3 = (p - 0.57) / 0.43;
                        final eased = t3 * t3; // easeIn
                        dx = -sw * eased;
                      }
                      return Stack(
                        children: [
                          // затемнение
                          Opacity(
                            opacity: (overlayOpacity * 0.65).clamp(0.0, 1.0),
                            child: Container(color: Colors.black),
                          ),
                          // надпись
                          Center(
                            child: Transform.translate(
                              offset: Offset(dx, 0),
                              child: Text(
                                'Wave ${_announcingWave + 1}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(
                                    overlayOpacity.clamp(0.0, 1.0),
                                  ),
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 6,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black87,
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                // Game over overlay
                if (_showGameOver)
                  Positioned.fill(
                    child: GestureDetector(
                      onTapUp: (_) => _restart(),
                      child: Container(
                        color: Colors.black54,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'GAME OVER',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'tap to restart',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Crosshair stick slider ────────────────────────────────────────────────────
class _StickSlider extends StatelessWidget {
  final double value; // -1..1
  final ValueChanged<double> onChanged;
  final VoidCallback onReleased;

  const _StickSlider({
    required this.value,
    required this.onChanged,
    required this.onReleased,
  });

  static const double _trackH = 8.0;
  static const double _thumbW = 36.0;
  static const double _thumbH = 56.0;
  static const double _totalH = 72.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (d) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final w = box.size.width;
        final raw = d.localPosition.dx / w * 2 - 1;
        onChanged(raw.clamp(-1.0, 1.0));
      },
      onHorizontalDragEnd: (_) => onReleased(),
      onHorizontalDragCancel: onReleased,
      child: SizedBox(
        height: _totalH,
        child: CustomPaint(painter: _CrosshairPainter(value: value)),
      ),
    );
  }
}

class _CrosshairPainter extends CustomPainter {
  final double value;
  const _CrosshairPainter({required this.value});

  static const double _trackH = _StickSlider._trackH;
  static const double _thumbW = _StickSlider._thumbW;
  static const double _thumbH = _StickSlider._thumbH;
  static const double _radius = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.5);
    final cx = size.width / 2;
    final cy = size.height / 2;

    // horizontal track
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, cy),
          width: size.width,
          height: _trackH,
        ),
        const Radius.circular(_trackH / 2),
      ),
      paint,
    );

    // thumb rectangle centered at value position
    final thumbCx = cx + value * (size.width / 2 - _thumbW / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(thumbCx, cy),
          width: _thumbW,
          height: _thumbH,
        ),
        const Radius.circular(_radius),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CrosshairPainter old) => old.value != value;
}

// ── Fire button with press animation ─────────────────────────────────────────
class _FireButton extends StatefulWidget {
  final VoidCallback onFire;
  final bool enabled;

  const _FireButton({required this.onFire, required this.enabled});

  @override
  State<_FireButton> createState() => _FireButtonState();
}

class _FireButtonState extends State<_FireButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween(
      begin: 1.0,
      end: 0.82,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    if (!widget.enabled) return;
    _pressCtrl.forward();
  }

  void _onTapUp(_) {
    _pressCtrl.reverse();
    if (widget.enabled) widget.onFire();
  }

  void _onTapCancel() => _pressCtrl.reverse();

  @override
  Widget build(BuildContext context) {
    final opacity = widget.enabled ? 1.0 : 0.35;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 200),
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            width: _kFireSize,
            height: _kFireSize,
            decoration: BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 2),
            ),
            child: Icon(Icons.star, color: Colors.white, size: _kFireIconSize),
          ),
        ),
      ),
    );
  }
}

// ── Explosion circle painter ──────────────────────────────────────────────────
class _ExplosionPainter extends CustomPainter {
  final double progress; // 0..1

  const _ExplosionPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // outer ring — yellow-orange, fades and expands
    final ringPaint = Paint()
      ..color = const Color(0xFFFF9900).withOpacity((1.0 - progress) * 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0 + progress * 8.0;
    canvas.drawCircle(center, radius * 0.9, ringPaint);

    // mid fill — orange
    final midPaint = Paint()
      ..color = const Color(0xFFFF6600).withOpacity((1.0 - progress) * 0.6);
    canvas.drawCircle(center, radius * 0.65 * (1.0 - progress * 0.5), midPaint);

    // inner core — bright yellow, fades quickly
    final corePaint = Paint()
      ..color = const Color(
        0xFFFFE600,
      ).withOpacity((1.0 - progress * 2).clamp(0.0, 1.0));
    canvas.drawCircle(center, radius * 0.75 * (1.0 - progress), corePaint);
  }

  @override
  bool shouldRepaint(_ExplosionPainter old) => old.progress != progress;
}
