import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flags/features/flag_games/flag_game_viewport.dart';
import 'package:flags/features/flag_games/flag_game_background_pause.dart';
import 'package:flags/features/flag_games/flag_game_tap_hint.dart';
import 'package:flags/features/flag_games/flag_game_ads.dart';
import 'package:flags/features/flag_games/flag_game_vibration.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flags/uikit/components/buttons/actions/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Background ────────────────────────────────────────────────────────────────
const double _kMusicVolume = 0.6; // фоновая музыка (по кругу, с начала игры)

const Color _kBgColor = Color(0xFFFFFFFF);
const Color _kCircleColor = Color(0xFFa00030);

// ── Circle — игровое положение ────────────────────────────────────────────────
const double _kCircleSize = 210.0; // игровой размер
const double _kCircleY = 0.42; // игровая позиция по Y (чуть ниже центра)
// До интро — круг крупнее и строго по центру (0.5)
const double _kCircleIdleSize = 270.0;
const double _kCircleIdleY = 0.5;

// ── Katana — размер (один для всех состояний) ─────────────────────────────────
const double _kKnifeSize = 240.0;
// Угол изображения катаны относительно направления движения
const double _kKnifeImgRot = pi / 2;
// Смещение центра воткнутой катаны от центра круга (px)
const double _kEmbedOffset = 75.0;
// Порог совпадения углов — меньше = сложнее
const double _kCollThresh = 0.18;
// Радиус попадания
const double _kHitRadius = _kCircleSize * 0.38;

// ── Katana corner positions (доли экрана) ─────────────────────────────────────
const double _kCornerRightX = 0.85;
const double _kCornerRightY = 0.88;
const double _kCornerLeftX = 0.15;
const double _kCornerLeftY = 0.88;

// ── Intro — начальная позиция катаны (до анимации к угловой) ─────────────────
// Позиция (доли экрана) и угол (рад) откуда катана стартует
const double _kIntroFromX = 0.85; // X старта
const double _kIntroFromY = 1.15; // Y старта (за нижним краем экрана)
const double _kIntroFromAngle =
    -0.8; // угол старта (рад, доп. к направлению на круг)
// Длительность анимации от старта до угловой позиции
const double _kSlideInDur = 0.55;

// ── Intro — вращение круга ────────────────────────────────────────────────────
const double _kSpinUpDur = 0.35;
const double _kSpinDownDur = 0.9;
const double _kMaxVel = 22.0;

// ── Gameplay — вращение круга ─────────────────────────────────────────────────
const double _kOscMaxVel = 1.4;
const double _kOscAccel = 0.5;
const double _kDirMinTime = 1.5;
const double _kDirMaxTime = 4.0;

// ── Throw ─────────────────────────────────────────────────────────────────────
const double _kThrowSpeed = 900.0;

// ── Dead physics ──────────────────────────────────────────────────────────────
const double _kDeadGravity = 700.0;
const double _kDeadSpinVel = 9.0;

// ── Slide-in animation (выезд катаны снизу) ───────────────────────────────────
const double _kKnifeSlideDur = 0.35;

// ── Levels ────────────────────────────────────────────────────────────────────
const int _kMaxKnives = 6;
const int _kMaxKnivesCap = 16;
const double _kLevelSpeedMult = 0.3;
const double _kLevelTimeMult = 0.12;
const double _kLevelTimeMin = 0.5;

// ── Circle break ──────────────────────────────────────────────────────────────
const int _kGearPieceCount = 7;
const double _kPieceSpeedMin = 250.0;
const double _kPieceSpeedMax = 520.0;
const double _kPieceSpinMax = 12.0;
const double _kKnifeExplodeSpeedMin = 200.0;
const double _kKnifeExplodeSpeedMax = 450.0;

// ── Damage / dents / cracks ───────────────────────────────────────────────────
const double _kDentDepth = 14.0; // макс. глубина вмятины (px)
const double _kDentHalfWidth = 0.38; // полуширина вмятины (рад)
const double _kChunkSweep = 0.22; // угловой размер отрывающегося куска (рад)
const double _kChunkSpeedMin = 180.0;
const double _kChunkSpeedMax = 360.0;
const double _kHitboxLength =
    _kKnifeSize * 0.9; // длина хитбокса вдоль лезвия (визуально)
const double _kHitboxWidth =
    _kKnifeSize * 0.09; // ширина хитбокса поперёк лезвия (визуально)

// ── Reward (flag icon) ────────────────────────────────────────────────────────
const double _kRewardSize = 40.0;
const double _kRewardSizeFrom = 90.0;
const double _kRewardPadX = 70.0;
const double _kRewardPadY = 18.0;
const double _kRewardSpacing = 48.0;
const double _kRewardRowGap = 48.0;
const int _kRewardPerRow = 5;
const double _kRewardFlyDur = 1.6;

const _p = 'assets/images/flag_games/japan/';

enum _IntroPhase { idle, slideIn, spinUp, spinDown, done }

enum _GamePhase { waiting, flying, dead, broken }

class _StuckKnife {
  final double relAngle;
  _StuckKnife(this.relAngle);
}

// Трещина в локальных координатах круга (origin = центр круга)
class _Crack {
  final List<Offset> points;
  _Crack(this.points);
}

// Отколотый сектор (в локальных координатах круга, relAngle)
class _BrokenSector {
  final double startRel; // начало сектора (relAngle)
  final double endRel; // конец сектора
  _BrokenSector(this.startRel, this.endRel);
}

class _CircleHalf {
  double x, y, vx, vy, angle, spin;
  final double splitAngle; // угол разреза в локальных координатах круга
  final bool isFirst; // true = дуга от splitAngle до splitAngle+π
  final double radius;
  final List<_StuckKnife> stuck;
  final List<_Crack> cracks;
  final List<_BrokenSector> brokenSectors;

  _CircleHalf({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.angle,
    required this.spin,
    required this.splitAngle,
    required this.isFirst,
    required this.radius,
    required this.stuck,
    required this.cracks,
    required this.brokenSectors,
  });
}

class _FlyingPiece {
  double x, y, vx, vy, angle, spin;
  final bool isKnife;
  // Для летящего сектора:
  final bool isSector;
  final double sectorSweep;
  final double sectorRadius;
  _FlyingPiece({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.angle,
    required this.spin,
    this.isKnife = false,
    this.isSector = false,
    this.sectorSweep = 0,
    this.sectorRadius = 0,
  });
}

@RoutePage()
class JapanKnifeHitScreen extends StatefulWidget implements AutoRouteWrapper {
  // игра строится на «экране Pixel 10» и масштабируется под реальный экран
  @override
  Widget wrappedRoute(BuildContext context) =>
      FlagGameViewport(background: _kBgColor, child: this);

  const JapanKnifeHitScreen({super.key});

  @override
  State<JapanKnifeHitScreen> createState() => _JapanKnifeHitScreenState();
}

class _JapanKnifeHitScreenState extends State<JapanKnifeHitScreen>
    with SingleTickerProviderStateMixin, FlagGameBackgroundPause<JapanKnifeHitScreen> {
  IAudioCubit get _audio => context.read<IAudioCubit>();

  // Беззвучная петля держит аудиовыход Android активным. Без неё после паузы
  // выход засыпает, и первый звук попадания будит его в главном потоке — фриз
  // тем сильнее, чем дольше была тишина. В других играх эту роль играет фон.
  AudioPlayer? _keepAlivePlayer;

  Future<void> _startKeepAlive() async {
    if (_keepAlivePlayer != null) return;
    final p = AudioPlayer()..audioCache = FlameAudio.audioCache;
    _keepAlivePlayer = p;
    try {
      await p.setAudioContext(
        AudioContextConfig(
          focus: AudioContextConfigFocus.mixWithOthers,
        ).build(),
      );
      await p.setPlayerMode(PlayerMode.mediaPlayer);
      await p.setReleaseMode(ReleaseMode.loop);
      await p.setVolume(0);
      if (!mounted) return;
      await p.play(AssetSource(GameSfx.japanIntro.file), volume: 0);
    } catch (e) {
      debugPrint('Japan keep-alive error: $e');
    }
  }

  Timer? _warmupTimer;
  final _rand = Random();

  // ── Intro ──────────────────────────────────────────────────────────────────
  _IntroPhase _intro = _IntroPhase.idle;
  double _introT = 0;
  double _introSlideT = 0.0; // катана: 0=скрыта, 1=на месте
  // Интерполированные параметры круга (idle→game)
  double _curCircleSize = _kCircleIdleSize;
  double _curCircleY = _kCircleIdleY;

  // ── Gameplay ───────────────────────────────────────────────────────────────
  _GamePhase _game = _GamePhase.waiting;

  // Круг — вращение
  double _gearAngle = 0;
  double _gearOscVel = 0;
  double _gearTargetVel = _kOscMaxVel * 0.6;
  double _gearSpringX = 0;
  double _gearSpringVX = 0;
  double _gearSpringY = 0;
  double _gearSpringVY = 0;
  double _gearDirTimer = 2.0;

  // Воткнутые катаны
  final List<_StuckKnife> _stuck = [];

  // Повреждения
  final List<_Crack> _cracks = [];
  final List<_BrokenSector> _brokenSectors = [];
  int _chunksDropped = 0;

  // Текущая сторона броска (true = правый угол, false = левый угол)
  bool _throwFromRight = true;

  // Slide-in нового ножа
  double _knifeSlideT = 1.0;

  // Летящая катана
  double _flyX = 0, _flyY = 0, _flyVX = 0, _flyVY = 0;

  // Отскочившая катана
  double _deadX = 0, _deadY = 0, _deadVX = 0, _deadVY = 0;
  double _deadAngle = 0, _deadSpin = 0;

  // Разлетевшиеся куски
  final List<_FlyingPiece> _pieces = [];

  // Две половинки круга при разрушении
  final List<_CircleHalf> _halves = [];

  // ── Уровни ─────────────────────────────────────────────────────────────────
  int _level = 1;
  int _completedLevels = 0;
  int _bestStars = 0;
  static const String _kBestKey = 'japan_best_stars';

  bool _coinAnimPlaying = false;

  // Летящий флаг-награда
  bool _rewardFlying = false;
  double _rewardX = 0, _rewardY = 0;
  double _rewardFromX = 0, _rewardFromY = 0;
  double _rewardTX = 0, _rewardTY = 0;
  double _rewardT = 0;

  double _w = 1, _h = 1;

  bool get _gameActive => _intro == _IntroPhase.done;

  // Центр круга — X всегда по центру, Y анимируется в интро
  double get _circleCX => _w / 2 + _gearSpringX;
  // В игре используем _kCircleY + spring; в интро/idle — _curCircleY
  double get _circleCY =>
      _gameActive ? _h * _kCircleY + _gearSpringY : _h * _curCircleY;
  // Текущий визуальный размер круга
  double get _circleDisplaySize => _gameActive ? _kCircleSize : _curCircleSize;

  // Позиция катаны в покое (угловая)
  double get _restX => _w * (_throwFromRight ? _kCornerRightX : _kCornerLeftX);
  double get _restY => _h * (_throwFromRight ? _kCornerRightY : _kCornerLeftY);
  // Угол всегда направлен точно от угла к центру круга + поправка изображения
  double get _restAngle {
    final dx = _circleCX - _restX;
    final dy = (_h * _kCircleY) - _restY;
    return atan2(dy, dx) + _kKnifeImgRot;
  }

  late final Ticker _ticker;
  Duration? _lastTick;

  // ── Пауза, пока приложение свёрнуто ──
  bool _tickerWasActive = false;

  @override
  void onAppHidden() {
    _tickerWasActive = _ticker.isActive;
    if (_tickerWasActive) _ticker.stop();
    pausePlayingPlayers([_keepAlivePlayer]);
  }

  @override
  void onAppShown() {
    if (_tickerWasActive && mounted) {
      // новый отсчёт времени — первый кадр после возврата без скачка
      _lastTick = null;
      _ticker.start();
    }
    resumePausedPlayers();
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    _loadBest();
    _warmupTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _audio.playSfx(GameSfx.japanHit1, volume: 0);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _audio.pauseBgm());
  }

  bool _audioPreloaded = false;

  Future<void> _preloadAudio() async {
    if (_audioPreloaded) return;
    _audioPreloaded = true;
    try {
      await FlameAudio.audioCache.loadAll([
        GameSfx.japanHit1.file,
        GameSfx.japanHit2.file,
        GameSfx.japanIntro.file,
        GameSfx.gearCrash.file,
        GameSfx.knifeLose.file,
      ]);
    } catch (_) {}
    // Таймер прогрева больше не нужен — файлы в кэше
    _warmupTimer?.cancel();
    _warmupTimer = null;
  }

  Future<void> _loadBest() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bestStars = prefs.getInt(_kBestKey) ?? 0;
    });
  }

  Future<void> _saveBest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kBestKey, _bestStars);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _keepAlivePlayer?.dispose();
    _keepAlivePlayer = null;
    _warmupTimer?.cancel();
    FlameAudio.audioCache.clear(GameSfx.japanHit1.file);
    FlameAudio.audioCache.clear(GameSfx.japanHit2.file);
    FlameAudio.audioCache.clear(GameSfx.japanIntro.file);
    FlameAudio.audioCache.clear(GameSfx.gearCrash.file);
    FlameAudio.audioCache.clear(GameSfx.knifeLose.file);
    super.dispose();
  }

  // ── Tick ───────────────────────────────────────────────────────────────────
  void _onTick(Duration elapsed) {
    final raw = _lastTick == null
        ? 0.016
        : (elapsed - _lastTick!).inMicroseconds / 1e6;
    final dt = raw.clamp(0.0, 0.05);
    _lastTick = elapsed;
    setState(() {
      if (_intro != _IntroPhase.done) {
        _tickIntro(dt);
      } else {
        _tickGame(dt);
      }
    });
  }

  void _tickIntro(double dt) {
    if (_intro == _IntroPhase.idle) return;

    _introT += dt;

    if (_intro == _IntroPhase.slideIn) {
      // Катана плавно летит от стартовой позиции к угловой
      _introSlideT = (_introT / _kSlideInDur).clamp(0.0, 1.0);
      if (_introSlideT >= 1.0) {
        _intro = _IntroPhase.spinUp;
        _introT = 0;
      }
      return;
    }
    // В spinUp/spinDown катана уже на месте (slideT=1)
    _introSlideT = 1.0;

    if (_intro == _IntroPhase.spinUp) {
      final t = (_introT / _kSpinUpDur).clamp(0.0, 1.0);
      _gearAngle += _kMaxVel * t * t * dt;
      if (_introT >= _kSpinUpDur) {
        _intro = _IntroPhase.spinDown;
        _introT = 0;
      }
    } else if (_intro == _IntroPhase.spinDown) {
      final t = (_introT / _kSpinDownDur).clamp(0.0, 1.0);
      _gearAngle += _kMaxVel * (1.0 - t * t) * dt;
      if (_introT >= _kSpinDownDur) {
        _intro = _IntroPhase.done;
        _initGame();
      }
    }

    // Анимируем круг: idle-размер/позиция → игровые (smoothstep по всему интро)
    final spinTotal = _kSpinUpDur + _kSpinDownDur;
    final spinElapsed = _intro == _IntroPhase.spinUp
        ? _introT
        : _kSpinUpDur + _introT;
    final mp = (spinElapsed / spinTotal).clamp(0.0, 1.0);
    final ease = mp * mp * (3.0 - 2.0 * mp);
    _curCircleSize =
        _kCircleIdleSize + (_kCircleSize - _kCircleIdleSize) * ease;
    _curCircleY = _kCircleIdleY + (_kCircleY - _kCircleIdleY) * ease;
  }

  void _initGame() {
    _cracks.clear();
    _brokenSectors.clear();
    _chunksDropped = 0;
    _gearOscVel = 0;
    _gearSpringX = 0;
    _gearSpringVX = 0;
    _gearSpringY = 0;
    _gearSpringVY = 0;
    _gearTargetVel = _levelOscMaxVel * 0.6;
    _gearDirTimer =
        _levelDirTime(_kDirMinTime) +
        _rand.nextDouble() *
            (_levelDirTime(_kDirMaxTime) - _levelDirTime(_kDirMinTime));
    _knifeSlideT = 1.0;
    _throwFromRight = true;
    _stuck.clear();
    _game = _GamePhase.waiting;
  }

  void _tickGame(double dt) {
    // Вращение круга
    if (_level == 1) {
      // Уровень 1: непрерывное вращение в одну сторону
      _gearOscVel += (_kOscMaxVel - _gearOscVel).clamp(
        -_kOscAccel * dt,
        _kOscAccel * dt,
      );
    } else {
      _gearDirTimer -= dt;
      if (_gearDirTimer <= 0) {
        _gearTargetVel =
            -_gearTargetVel.sign *
            (_levelOscMaxVel * (0.4 + _rand.nextDouble() * 0.6));
        final dMin = _levelDirTime(_kDirMinTime);
        final dMax = _levelDirTime(_kDirMaxTime);
        _gearDirTimer = dMin + _rand.nextDouble() * (dMax - dMin);
      }
      final diff = _gearTargetVel - _gearOscVel;
      _gearOscVel += diff.clamp(-_kOscAccel * dt, _kOscAccel * dt);
    }
    _gearAngle += _gearOscVel * dt;

    // Пружина (вертикальный отскок при попадании)
    const kSpring = 600.0;
    const kDamp = 18.0;
    _gearSpringVX += (-kSpring * _gearSpringX - kDamp * _gearSpringVX) * dt;
    _gearSpringX += _gearSpringVX * dt;
    _gearSpringVY += (-kSpring * _gearSpringY - kDamp * _gearSpringVY) * dt;
    _gearSpringY += _gearSpringVY * dt;

    // Выезд нового ножа
    if (_knifeSlideT < 1.0) {
      _knifeSlideT = (_knifeSlideT + dt / _kKnifeSlideDur).clamp(0.0, 1.0);
    }

    // Летящая катана
    if (_game == _GamePhase.flying) {
      _flyX += _flyVX * dt;
      _flyY += _flyVY * dt;
      final dx = _flyX - _circleCX;
      final dy = _flyY - (_h * _kCircleY);
      if (sqrt(dx * dx + dy * dy) < _kHitRadius) {
        _onKnifeHit(dx, dy);
      } else {
        // OBB коллизия с застрявшими катанами
        // Проверяем только если катана уже достаточно далеко от точки старта
        final travelDx = _flyX - _restX;
        final travelDy = _flyY - _restY;
        final travelDist = sqrt(travelDx * travelDx + travelDy * travelDy);
        if (travelDist > _kKnifeSize * 0.5) {
          final flyAngle = atan2(_flyVY, _flyVX) + _kKnifeImgRot + pi / 2;
          final flyHW = _kHitboxLength / 2;
          final flyHH = _kHitboxWidth / 2;
          final cx = _circleCX;
          final cy = _h * _kCircleY;
          for (final k in _stuck) {
            final wa = _normAngle(k.relAngle + _gearAngle);
            final kx = cx + cos(wa) * _kEmbedOffset;
            final ky = cy + sin(wa) * _kEmbedOffset;
            final stuckAngle = wa + _kKnifeImgRot + pi + pi / 2;
            if (_obbOverlap(
              _flyX,
              _flyY,
              flyAngle,
              flyHW,
              flyHH,
              kx,
              ky,
              stuckAngle,
              flyHW,
              flyHH,
            )) {
              _onKnifeHit(dx, dy);
              break;
            }
          }
        }
      }
    }

    // Отскочившая катана
    if (_game == _GamePhase.dead) {
      _deadVY += _kDeadGravity * dt;
      _deadX += _deadVX * dt;
      _deadY += _deadVY * dt;
      _deadAngle += _deadSpin * dt;
    }

    // Летящий флаг-награда
    if (_rewardFlying) {
      _rewardT = (_rewardT + dt / _kRewardFlyDur).clamp(0.0, 1.0);
      final ease = _rewardT * _rewardT * (3.0 - 2.0 * _rewardT);
      _rewardX = _rewardFromX + (_rewardTX - _rewardFromX) * ease;
      _rewardY = _rewardFromY + (_rewardTY - _rewardFromY) * ease;
      if (_rewardT >= 1.0) {
        _rewardFlying = false;
        _completedLevels++;
        if (_completedLevels > _bestStars) {
          _bestStars = _completedLevels;
          _saveBest();
        }
      }
    }

    // Куски — летят всегда (и во время игры при отколе, и при финальном взрыве)
    for (final p in _pieces) {
      p.vy += _kDeadGravity * dt;
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.angle += p.spin * dt;
    }
    _pieces.removeWhere((p) => p.y > _h + 200);

    // Половинки круга при разрушении
    for (final h in _halves) {
      h.vy += _kDeadGravity * dt;
      h.x += h.vx * dt;
      h.y += h.vy * dt;
      h.angle += h.spin * dt;
    }
    _halves.removeWhere((h) => h.y - h.radius > _h + 200);
  }

  void _onKnifeHit(double dx, double dy) {
    final arrivalAngle = atan2(dy, dx);
    final relAngle = _normAngle(arrivalAngle - _gearAngle);

    bool collision = false;
    for (final k in _stuck) {
      if (_angleDiff(_normAngle(k.relAngle), relAngle).abs() < _kCollThresh) {
        collision = true;
        break;
      }
    }

    if (collision) {
      _audio.playSfx(GameSfx.knifeLose);
      _deadX = _flyX;
      _deadY = _flyY;
      _deadVX = (_rand.nextDouble() - 0.5) * 300;
      _deadVY = -(_flyVY.abs() * 0.5) - 200;
      _deadSpin = (_rand.nextBool() ? 1 : -1) * _kDeadSpinVel;
      _deadAngle = atan2(_flyVY, _flyVX) + _kKnifeImgRot;
      _game = _GamePhase.dead;
      _audio.pauseBgm();
      flagGameVibrate(context, 'Japan', 'lose');
      flagGameLossAd(
        context,
        'Japan',
        isStillLost: () => _game == _GamePhase.dead,
      );
    } else {
      _audio.playSfx(_rand.nextBool() ? GameSfx.japanHit1 : GameSfx.japanHit2);
      _stuck.add(_StuckKnife(relAngle));

      if (_stuck.length >= _levelMaxKnives) {
        _audio.playSfx(GameSfx.gearCrash);
        _breakCircle(relAngle);
      } else {
        // Порог 33%: каждые ~33% отрывается кусок (макс 3 куска)
        final pct = _stuck.length / _levelMaxKnives;
        final threshold = ((_chunksDropped + 1) / 3.0);
        final droppingChunk = pct >= threshold && _chunksDropped < 3;
        if (droppingChunk) {
          _dropChunk(relAngle);
          _chunksDropped++;
        } else {
          // Трещина только если кусок не отваливается
          _cracks.add(_generateCrack(relAngle));
        }

        final speed = sqrt(_flyVX * _flyVX + _flyVY * _flyVY);
        if (speed > 0.01) {
          const impulse = 380.0;
          _gearSpringVX = (_flyVX / speed) * impulse;
          _gearSpringVY = (_flyVY / speed) * impulse;
        }
        _knifeSlideT = 0.0;
        _throwFromRight = _level >= 3 ? _rand.nextBool() : !_throwFromRight;
        _game = _GamePhase.waiting;
      }
    }
  }

  _Crack _generateCrack(double relAngle) {
    final r = _kCircleSize / 2;
    final points = <Offset>[];
    // Стартуем с поверхности круга в точке попадания
    double curR = r * 0.95;
    double curAngle = relAngle;
    points.add(Offset(cos(curAngle) * curR, sin(curAngle) * curR));
    // 4-5 сегментов внутрь с небольшим угловым смещением
    final segs = 4 + _rand.nextInt(2);
    for (int i = 0; i < segs; i++) {
      curR -= r * 0.12 + _rand.nextDouble() * r * 0.08;
      curAngle += (_rand.nextDouble() - 0.5) * 0.22;
      points.add(Offset(cos(curAngle) * curR, sin(curAngle) * curR));
    }
    // Небольшой ответвление
    final branchStart = points[1];
    final branchAngle = relAngle + (_rand.nextBool() ? 0.35 : -0.35);
    final branchR = r * 0.72;
    final branchEnd = Offset(
      cos(branchAngle) * branchR,
      sin(branchAngle) * branchR,
    );
    return _Crack([...points, branchStart, branchEnd]);
  }

  void _dropChunk(double relAngle) {
    final r = _kCircleSize / 2;
    final chunkR = r * 0.55;
    final cx = _circleCX;
    final cy = _h * _kCircleY;
    final worldAngle = _normAngle(relAngle + _gearAngle);
    // Мировой угол центра куска
    final chunkCX = cx + cos(worldAngle) * r * 0.7;
    final chunkCY = cy + sin(worldAngle) * r * 0.7;
    final speed =
        _kChunkSpeedMin +
        _rand.nextDouble() * (_kChunkSpeedMax - _kChunkSpeedMin);
    // Летит в направлении от центра круга
    final vx = cos(worldAngle) * speed + (_rand.nextDouble() - 0.5) * 80;
    final vy = sin(worldAngle) * speed - 60;
    _pieces.add(
      _FlyingPiece(
        x: chunkCX,
        y: chunkCY,
        vx: vx,
        vy: vy,
        angle: worldAngle,
        spin: (_rand.nextBool() ? 1 : -1) * _rand.nextDouble() * 3.0,
        isSector: true,
        sectorSweep: _kChunkSweep,
        sectorRadius: chunkR,
      ),
    );
    // Добавляем сектор в список сломанных
    _brokenSectors.add(
      _BrokenSector(relAngle - _kChunkSweep / 2, relAngle + _kChunkSweep / 2),
    );
  }

  void _breakCircle(double splitRelAngle) {
    _pieces.clear();
    _halves.clear();
    final cx = _circleCX;
    final cy = _h * _kCircleY;
    final r = _kCircleSize / 2;

    // Разрез вдоль последней катаны — два полукруга летят вниз
    final splitWorldAngle = _normAngle(splitRelAngle + _gearAngle);
    // Перпендикуляр к катане — направление разлёта каждой половины
    final perpX = -sin(splitWorldAngle);
    final perpY = cos(splitWorldAngle);
    const halfSpeed = 120.0;

    for (int i = 0; i < 2; i++) {
      final sign = i == 0 ? 1.0 : -1.0;
      _halves.add(
        _CircleHalf(
          x: cx,
          y: cy,
          vx: perpX * sign * halfSpeed + (_rand.nextDouble() - 0.5) * 40,
          vy: 60.0 + _rand.nextDouble() * 60,
          angle: _gearAngle,
          spin: sign * (0.5 + _rand.nextDouble() * 1.2),
          splitAngle: splitRelAngle,
          isFirst: i == 0,
          radius: r,
          stuck: List.of(_stuck),
          cracks: List.of(_cracks),
          brokenSectors: List.of(_brokenSectors),
        ),
      );
    }

    // Катаны разлетаются отдельно
    for (final k in _stuck) {
      final worldAngle = _normAngle(k.relAngle + _gearAngle);
      final kx = cx + cos(worldAngle) * _kEmbedOffset;
      final ky = cy + sin(worldAngle) * _kEmbedOffset;
      final a = worldAngle + (_rand.nextDouble() - 0.5) * 1.2;
      final speed =
          _kKnifeExplodeSpeedMin +
          _rand.nextDouble() *
              (_kKnifeExplodeSpeedMax - _kKnifeExplodeSpeedMin);
      _pieces.add(
        _FlyingPiece(
          x: kx,
          y: ky,
          vx: cos(a) * speed,
          vy: sin(a) * speed - 150,
          angle: worldAngle + _kKnifeImgRot + pi,
          spin:
              (_rand.nextBool() ? 1 : -1) * _rand.nextDouble() * _kPieceSpinMax,
          isKnife: true,
        ),
      );
    }

    _stuck.clear();
    _game = _GamePhase.broken;

    _triggerCoinDrop(cx, cy);

    _rewardFromX = cx;
    _rewardFromY = cy;
    _rewardX = cx;
    _rewardY = cy;
    _rewardT = 0;
    final col = _completedLevels % _kRewardPerRow;
    final row = _completedLevels ~/ _kRewardPerRow;
    _rewardTX = _kRewardPadX + col * _kRewardSpacing + _kRewardSize / 2;
    _rewardTY = _kRewardPadY + row * _kRewardRowGap + _kRewardSize / 2;
    _rewardFlying = true;
  }

  // ── Ввод ───────────────────────────────────────────────────────────────────
  void _onTap() {
    if (_intro == _IntroPhase.idle) {
      _startIntro();
    } else if (_gameActive && _game == _GamePhase.waiting) {
      _throwKnife();
    } else if (_gameActive && _game == _GamePhase.dead && _deadY > _h + 80) {
      _restartGame();
    } else if (_gameActive && _game == _GamePhase.broken && !_rewardFlying) {
      _nextLevel();
    }
  }

  // фоновая музыка по кругу — запускается один раз при старте игры и играет
  // и после рестартов; при выходе в список флагов её останавливает releaseGameAudio
  bool _musicStarted = false;

  void _startMusic() {
    if (_musicStarted) return;
    _musicStarted = true;
    _audio.playBgm(GameMusics.japan, volume: _kMusicVolume, fromStart: true);
  }

  void _startIntro() {
    _preloadAudio();
    _startMusic();
    _audio.playSfx(GameSfx.japanIntro);
    _startKeepAlive();
    _intro = _IntroPhase.slideIn;
    _introT = 0;
    _introSlideT = 0.0;
  }

  void _throwKnife() {
    // Стартуем из угловой позиции катаны
    _flyX = _restX;
    _flyY = _restY;
    final dx = _circleCX - _flyX;
    final dy = _h * _kCircleY - _flyY;
    final dist = sqrt(dx * dx + dy * dy);
    _flyVX = dx / dist * _kThrowSpeed;
    _flyVY = dy / dist * _kThrowSpeed;
    _game = _GamePhase.flying;
  }

  void _restartGame() {
    // музыка после проигрыша — снова с начала трека
    _audio.playBgm(GameMusics.japan, volume: _kMusicVolume, fromStart: true);
    _level = 1;
    _completedLevels = 0;
    _coinAnimPlaying = false;
    _rewardFlying = false;
    _startLevel();
  }

  void _nextLevel() {
    _level++;
    _startLevel();
  }

  void _startLevel() {
    _stuck.clear();
    _pieces.clear();
    _halves.clear();
    _cracks.clear();
    _brokenSectors.clear();
    _chunksDropped = 0;
    _gearAngle = 0;
    _gearOscVel = 0;
    _gearSpringX = 0;
    _gearSpringVX = 0;
    _gearSpringY = 0;
    _gearSpringVY = 0;
    _gearTargetVel = _levelOscMaxVel * 0.6;
    final dMin = _levelDirTime(_kDirMinTime);
    final dMax = _levelDirTime(_kDirMaxTime);
    _gearDirTimer = dMin + _rand.nextDouble() * (dMax - dMin);
    _knifeSlideT = 0.0; // анимация появления катаны
    _throwFromRight = true;
    _game = _GamePhase.waiting;
  }

  // OBB коллизия (SAT) — две повёрнутые прямоугольные зоны
  static List<Offset> _obbCorners(
    double cx,
    double cy,
    double angle,
    double hw,
    double hh,
  ) {
    final ca = cos(angle), sa = sin(angle);
    return [
      Offset(cx + ca * hw - sa * hh, cy + sa * hw + ca * hh),
      Offset(cx - ca * hw - sa * hh, cy - sa * hw + ca * hh),
      Offset(cx - ca * hw + sa * hh, cy - sa * hw - ca * hh),
      Offset(cx + ca * hw + sa * hh, cy + sa * hw - ca * hh),
    ];
  }

  static bool _obbOverlap(
    double cx1,
    double cy1,
    double a1,
    double hw1,
    double hh1,
    double cx2,
    double cy2,
    double a2,
    double hw2,
    double hh2,
  ) {
    final c1 = _obbCorners(cx1, cy1, a1, hw1, hh1);
    final c2 = _obbCorners(cx2, cy2, a2, hw2, hh2);
    final axes = [
      Offset(cos(a1), sin(a1)),
      Offset(-sin(a1), cos(a1)),
      Offset(cos(a2), sin(a2)),
      Offset(-sin(a2), cos(a2)),
    ];
    for (final ax in axes) {
      final p1 = c1.map((v) => v.dx * ax.dx + v.dy * ax.dy);
      final p2 = c2.map((v) => v.dx * ax.dx + v.dy * ax.dy);
      if (p1.reduce(max) < p2.reduce(min) || p2.reduce(max) < p1.reduce(min)) {
        return false;
      }
    }
    return true;
  }

  void _triggerCoinDrop(double cx, double cy) {
    if (_coinAnimPlaying) return;
    _coinAnimPlaying = true;
    final amount = (_completedLevels + 1) * 5;
    if (amount > 15) _audio.playSfx(GameSfx.money);
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
      await layer.addMoneys(() => FlagGameViewport.toScreen(context, Offset(cx, cy)), amount.clamp(1, 50));
      await Future.delayed(const Duration(milliseconds: 600));
      await layer.hide();
      if (mounted) setState(() => _coinAnimPlaying = false);
    });
  }

  double _normAngle(double a) {
    while (a > pi) {
      a -= 2 * pi;
    }
    while (a < -pi) {
      a += 2 * pi;
    }
    return a;
  }

  double _angleDiff(double a, double b) => _normAngle(a - b);

  int get _levelMaxKnives => _level == 1
      ? _kMaxKnives
      : (8 + (_level - 2) * 2).clamp(0, _kMaxKnivesCap);

  double get _levelOscMaxVel =>
      _kOscMaxVel * (1.0 + (_level - 1) * _kLevelSpeedMult);

  double _levelDirTime(double base) =>
      (base * (1.0 - (_level - 1) * _kLevelTimeMult)).clamp(
        _kLevelTimeMin,
        base,
      );

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _w = size.width;
    _h = size.height;

    return Scaffold(
      backgroundColor: _kBgColor,
      body: GestureDetector(
        onTapUp: (_) => _onTap(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(child: ColoredBox(color: _kBgColor)),

            // ── Круг (цель) — всегда по центру ───────────────────────────────
            if (_game != _GamePhase.broken) ...[
              Positioned(
                left: _circleCX - _circleDisplaySize / 2,
                top: _circleCY - _circleDisplaySize / 2,
                width: _circleDisplaySize,
                height: _circleDisplaySize,
                child: Transform.rotate(
                  angle: _gearAngle,
                  child: CustomPaint(
                    painter: _CirclePainter(
                      radius: _circleDisplaySize / 2,
                      stuck: _stuck,
                      cracks: _cracks,
                      brokenSectors: _brokenSectors,
                      color: _kCircleColor,
                    ),
                    size: Size(_circleDisplaySize, _circleDisplaySize),
                  ),
                ),
              ),
              // Воткнутые катаны
              for (final k in _stuck)
                Builder(
                  builder: (_) {
                    final worldAngle = _normAngle(k.relAngle + _gearAngle);
                    final kx = _circleCX + cos(worldAngle) * _kEmbedOffset;
                    final ky =
                        (_h * _kCircleY) + sin(worldAngle) * _kEmbedOffset;
                    return _placedAbs(
                      kx,
                      ky,
                      worldAngle + _kKnifeImgRot + pi,
                      Image.asset(
                        '${_p}japan_katana.png',
                        width: _kKnifeSize,
                        height: _kKnifeSize,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
            ],

            // ── Летящая катана ────────────────────────────────────────────────
            if (_game == _GamePhase.flying)
              _placedAbs(
                _flyX,
                _flyY,
                atan2(_flyVY, _flyVX) + _kKnifeImgRot,
                Image.asset(
                  '${_p}japan_katana.png',
                  width: _kKnifeSize,
                  height: _kKnifeSize,
                  fit: BoxFit.contain,
                ),
              ),

            // ── Катана в покое (в угловой позиции, выезжает снизу) ───────────
            if (_gameActive && _game == _GamePhase.waiting)
              Builder(
                builder: (_) {
                  final ease =
                      1.0 - (1.0 - _knifeSlideT) * (1.0 - _knifeSlideT);
                  final slideY = (1.0 - ease) * _kKnifeSize;
                  return _placedAbs(
                    _restX,
                    _restY + slideY,
                    _restAngle,
                    Image.asset(
                      '${_p}japan_katana.png',
                      width: _kKnifeSize,
                      height: _kKnifeSize,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),

            // ── Катана в интро: анимирует от _kIntroFrom* → угловая позиция ───
            if (_intro == _IntroPhase.slideIn ||
                _intro == _IntroPhase.spinUp ||
                _intro == _IntroPhase.spinDown)
              Builder(
                builder: (_) {
                  // smoothstep: 0=старт, 1=угловая позиция
                  final t = _introSlideT;
                  final ease = t * t * (3.0 - 2.0 * t);

                  final toX = _w * _kCornerRightX;
                  final toY = _h * _kCornerRightY;
                  final toAngle =
                      atan2(_h * _kCircleY - toY, _circleCX - toX) +
                      _kKnifeImgRot;

                  final fromX = _w * _kIntroFromX;
                  final fromY = _h * _kIntroFromY;
                  // Угол старта: toAngle + дополнительный offset
                  final fromAngle = toAngle + _kIntroFromAngle;

                  final curX = fromX + (toX - fromX) * ease;
                  final curY = fromY + (toY - fromY) * ease;
                  final curAngle = fromAngle + (toAngle - fromAngle) * ease;

                  return _placedAbs(
                    curX,
                    curY,
                    curAngle,
                    Image.asset(
                      '${_p}japan_katana.png',
                      width: _kKnifeSize,
                      height: _kKnifeSize,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),

            // ── Отскочившая катана (game over) ────────────────────────────────
            if (_game == _GamePhase.dead)
              _placedAbs(
                _deadX,
                _deadY,
                _deadAngle,
                Image.asset(
                  '${_p}japan_katana.png',
                  width: _kKnifeSize,
                  height: _kKnifeSize,
                  fit: BoxFit.contain,
                ),
              ),

            // ── Разлетевшиеся куски + отколовшиеся секторы ───────────────────
            // ── Половинки круга при разрушении ───────────────────────────────
            for (final h in _halves)
              Positioned(
                left: h.x - h.radius,
                top: h.y - h.radius,
                width: h.radius * 2,
                height: h.radius * 2,
                child: Transform.rotate(
                  angle: h.angle,
                  child: CustomPaint(
                    painter: _HalfCirclePainter(
                      radius: h.radius,
                      splitAngle: h.splitAngle,
                      isFirst: h.isFirst,
                      stuck: h.stuck,
                      cracks: h.cracks,
                      brokenSectors: h.brokenSectors,
                      color: _kCircleColor,
                    ),
                    size: Size(h.radius * 2, h.radius * 2),
                  ),
                ),
              ),

            for (final p in _pieces)
              _placedAbs(
                p.x,
                p.y,
                p.angle,
                p.isKnife
                    ? Image.asset(
                        '${_p}japan_katana.png',
                        width: _kKnifeSize,
                        height: _kKnifeSize,
                        fit: BoxFit.contain,
                      )
                    : p.isSector
                    ? CustomPaint(
                        painter: _SectorPainter(
                          sweep: p.sectorSweep,
                          radius: p.sectorRadius,
                          color: _kCircleColor,
                        ),
                        size: Size(p.sectorRadius * 2, p.sectorRadius * 2),
                      )
                    : CustomPaint(
                        painter: _CirclePiecePainter(
                          angle: p.angle,
                          color: _kCircleColor,
                        ),
                        size: const Size(
                          _kCircleSize * 0.7,
                          _kCircleSize * 0.7,
                        ),
                      ),
              ),

            // ── Счётчик ───────────────────────────────────────────────────────
            if (_gameActive && _game != _GamePhase.broken)
              Positioned(
                left: _circleCX + _kCircleSize * 0.55,
                top: _h * _kCircleY - _kCircleSize * 0.15,
                child: Text(
                  '${_stuck.length}/$_levelMaxKnives',
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // ── Номер уровня ──────────────────────────────────────────────────
            if (_gameActive)
              Positioned(
                top: 12,
                right: 16,
                child: Text(
                  'Level $_level',
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // ── Back button ───────────────────────────────────────────────────
            // «Tap to start» — один раз, на первом открытом флаге
            Positioned.fill(
              child: FlagGameTapHint(visible: _intro == _IntroPhase.idle),
            ),
            const Positioned(top: 8, left: 8, child: FBackButton()),

            // ── Best score ────────────────────────────────────────────────────
            Positioned(
              top: 40,
              right: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/winner_cup.png',
                    width: 28,
                    height: 28,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$_bestStars',
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ── Overlay ───────────────────────────────────────────────────────
            if ((_game == _GamePhase.dead && _deadY > _h + 80) ||
                (_game == _GamePhase.broken && !_rewardFlying))
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Text(
                      _game == _GamePhase.broken
                          ? 'LEVEL $_level DONE!\nTAP TO CONTINUE'
                          : 'TAP TO RESTART',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),

            // ── Прогрев GPU ───────────────────────────────────────────────────
            Positioned(
              left: -9999,
              top: -9999,
              child: Opacity(
                opacity: 0.01,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('${_p}japan_katana.png', width: 1, height: 1),
                    Image.asset('${_p}japan_flag.png', width: 1, height: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placedAbs(double x, double y, double angle, Widget child) {
    return Positioned(
      left: x,
      top: y,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: Transform.rotate(angle: angle, child: child),
      ),
    );
  }
}

// Основной painter круга с вмятинами, трещинами и отколами
class _CirclePainter extends CustomPainter {
  final double radius;
  final List<_StuckKnife> stuck;
  final List<_Crack> cracks;
  final List<_BrokenSector> brokenSectors;
  final Color color;

  const _CirclePainter({
    required this.radius,
    required this.stuck,
    required this.cracks,
    required this.brokenSectors,
    required this.color,
  });

  // Проверяет находится ли угол внутри отколотого сектора
  bool _inBroken(double theta) {
    for (final s in brokenSectors) {
      double start = s.startRel, end = s.endRel;
      // Нормализуем к [-pi, pi]
      double t = theta;
      while (t - start > pi) t -= 2 * pi;
      while (start - t > pi) t += 2 * pi;
      if (t >= start && t <= end) return true;
    }
    return false;
  }

  // Радиус с вмятиной в точке theta
  double _dentedRadius(double theta) {
    double r = radius;
    for (final k in stuck) {
      double diff = theta - k.relAngle;
      while (diff > pi) diff -= 2 * pi;
      while (diff < -pi) diff += 2 * pi;
      if (diff.abs() < _kDentHalfWidth) {
        final t = diff / _kDentHalfWidth; // -1..1
        final cos2 = cos(t * pi / 2);
        r -= _kDentDepth * cos2 * cos2;
      }
    }
    return r;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final fillPaint = Paint()..color = color;
    const steps = 120;

    // Рисуем тело круга по сегментам (пропуская отколотые сектора)
    Path? currentPath;

    void closeSeg() {
      if (currentPath != null) {
        currentPath!.close();
        canvas.drawPath(currentPath!, fillPaint);
        currentPath = null;
      }
    }

    for (int i = 0; i <= steps; i++) {
      final theta = -pi + 2 * pi * i / steps;
      if (_inBroken(theta)) {
        closeSeg();
        continue;
      }
      final r = _dentedRadius(theta);
      final pt = center + Offset(cos(theta) * r, sin(theta) * r);
      if (currentPath == null) {
        currentPath = Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(pt.dx, pt.dy);
      } else {
        currentPath!.lineTo(pt.dx, pt.dy);
      }
    }
    closeSeg();

    // Трещины
    final crackPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.45)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final crack in cracks) {
      if (crack.points.length < 2) continue;
      // Рисуем основной сегмент
      final half = (crack.points.length / 2).ceil();
      final mainPath = Path()
        ..moveTo(
          center.dx + crack.points[0].dx,
          center.dy + crack.points[0].dy,
        );
      for (int i = 1; i < half; i++) {
        mainPath.lineTo(
          center.dx + crack.points[i].dx,
          center.dy + crack.points[i].dy,
        );
      }
      canvas.drawPath(mainPath, crackPaint);
      // Ответвление
      if (crack.points.length > half) {
        final branch = Path()
          ..moveTo(
            center.dx + crack.points[half].dx,
            center.dy + crack.points[half].dy,
          );
        for (int i = half + 1; i < crack.points.length; i++) {
          branch.lineTo(
            center.dx + crack.points[i].dx,
            center.dy + crack.points[i].dy,
          );
        }
        canvas.drawPath(
          branch,
          Paint()
            ..color = Colors.black.withValues(alpha: 0.3)
            ..strokeWidth = 0.9
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_CirclePainter old) => true;
}

// Половина круга при финальном разрушении (сохраняет повреждения)
class _HalfCirclePainter extends CustomPainter {
  final double radius;
  final double splitAngle; // угол разреза в локальных координатах
  final bool isFirst; // true = дуга [splitAngle, splitAngle+π]
  final List<_StuckKnife> stuck;
  final List<_Crack> cracks;
  final List<_BrokenSector> brokenSectors;
  final Color color;

  const _HalfCirclePainter({
    required this.radius,
    required this.splitAngle,
    required this.isFirst,
    required this.stuck,
    required this.cracks,
    required this.brokenSectors,
    required this.color,
  });

  bool _inBroken(double theta) {
    for (final s in brokenSectors) {
      double t = theta;
      while (t - s.startRel > pi) t -= 2 * pi;
      while (s.startRel - t > pi) t += 2 * pi;
      if (t >= s.startRel && t <= s.endRel) return true;
    }
    return false;
  }

  double _dentedRadius(double theta) {
    double r = radius;
    for (final k in stuck) {
      double diff = theta - k.relAngle;
      while (diff > pi) diff -= 2 * pi;
      while (diff < -pi) diff += 2 * pi;
      if (diff.abs() < _kDentHalfWidth) {
        final t = diff / _kDentHalfWidth;
        final c = cos(t * pi / 2);
        r -= _kDentDepth * c * c;
      }
    }
    return r;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final startAngle = isFirst ? splitAngle : splitAngle + pi;
    const steps = 60;

    final path = Path();
    // Начинаем с центра, идём вдоль дуги 180°
    path.moveTo(center.dx, center.dy);
    bool first = true;
    for (int i = 0; i <= steps; i++) {
      final theta = startAngle + pi * i / steps;
      if (_inBroken(theta)) continue;
      final r = _dentedRadius(theta);
      final pt = center + Offset(cos(theta) * r, sin(theta) * r);
      if (first) {
        path.lineTo(pt.dx, pt.dy);
        first = false;
      } else
        path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);

    // Трещины
    final crackPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.45)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (final crack in cracks) {
      if (crack.points.length < 2) continue;
      final half = (crack.points.length / 2).ceil();
      final p = Path()
        ..moveTo(
          center.dx + crack.points[0].dx,
          center.dy + crack.points[0].dy,
        );
      for (int i = 1; i < half; i++) {
        p.lineTo(
          center.dx + crack.points[i].dx,
          center.dy + crack.points[i].dy,
        );
      }
      canvas.drawPath(p, crackPaint);
      if (crack.points.length > half) {
        final b = Path()
          ..moveTo(
            center.dx + crack.points[half].dx,
            center.dy + crack.points[half].dy,
          );
        for (int i = half + 1; i < crack.points.length; i++) {
          b.lineTo(
            center.dx + crack.points[i].dx,
            center.dy + crack.points[i].dy,
          );
        }
        canvas.drawPath(
          b,
          Paint()
            ..color = Colors.black.withValues(alpha: 0.3)
            ..strokeWidth = 0.9
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_HalfCirclePainter old) => false;
}

// Летящий сектор (кусок отколовшегося круга)
class _SectorPainter extends CustomPainter {
  final double sweep;
  final double radius;
  final Color color;
  const _SectorPainter({
    required this.sweep,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Рисуем неровный многоугольник (приближение сектора с кривыми краями)
    final paint = Paint()..color = color;
    final path = Path()..moveTo(center.dx, center.dy);
    final steps = 8;
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final angle = -sweep / 2 + sweep * t;
      // Немного неровные края (имитация разлома)
      final jitter = (i > 0 && i < steps) ? (i.isOdd ? 0.08 : -0.05) : 0.0;
      final r = radius * (0.92 + jitter);
      path.lineTo(center.dx + cos(angle) * r, center.dy + sin(angle) * r);
    }
    path.close();
    canvas.drawPath(path, paint);
    // Тёмная граница разлома
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_SectorPainter old) => false;
}

// Финальный разлёт — маленькие куски
class _CirclePiecePainter extends CustomPainter {
  final double angle;
  final Color color;
  const _CirclePiecePainter({required this.angle, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width * 0.45),
      angle,
      pi * 0.6,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CirclePiecePainter old) =>
      old.angle != angle || old.color != color;
}
