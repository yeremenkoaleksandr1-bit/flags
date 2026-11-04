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

const Color _kColorTop = Color(0xFFCC0000);
const Color _kColorBottom = Color(0xFF000000);

// ── Angola star — начальное положение ────────────────────────────────────────
const double _kStarSize = 70.0;
const double _kStarX = 0.48;
const double _kStarY = 0.36;
const double _kStarAngle = 0.0;

// ── Angola star — конечное положение (после интро) ────────────────────────────
const double _kStarEndSize = 70.0;
const double _kStarEndAngle = 0.0;
const double _kStarFlyDist = 1.6; // доли экрана, дальность вылета за край

// ── Gear — начальное положение (до интро) ─────────────────────────────────────
const double _kGearSize = 260.0;
const double _kGearX = 0.46;
const double _kGearY = 0.47;
const double _kGearAngle = 0.0;

// ── Gear — конечное положение / игровое ───────────────────────────────────────
const double _kGearEndSize = 210.0;
const double _kGearEndX = 0.5;
const double _kGearEndY = 0.35;

// ── Knife — начальное положение ───────────────────────────────────────────────
const double _kKnifeSize = 220.0;
const double _kKnifeX = 0.52;
const double _kKnifeY = 0.66;
const double _kKnifeAngle = -1.0;

// ── Knife — позиция покоя после интро (нижний центр, почти за экраном) ────────
const double _kKnifeEndSize = 160.0;
const double _kKnifeEndX = 0.5;
const double _kKnifeEndY = 1.0; // нижний край экрана
const double _kKnifeEndAngle = 0.0;

// ── Intro animation ───────────────────────────────────────────────────────────
const double _kSpinUpDur = 0.7;
const double _kSpinDownDur = 1.8;
const double _kMaxVel = 22.0; // рад/с на пике интро

// ── Gameplay — шестерня ───────────────────────────────────────────────────────
const double _kOscMaxVel = 1.4; // рад/с максимальная скорость осцилляции
const double _kOscAccel = 0.5; // рад/с²
const double _kDirMinTime = 1.5; // мин. секунд до смены направления
const double _kDirMaxTime = 4.0;
const double _kSpringDecay = 7.0; // коэффициент затухания пружины

// ── Gameplay — нож ────────────────────────────────────────────────────────────
const double _kThrowSpeed = 900.0; // px/s скорость броска
// Смещение центра ножа от центра шестерни после попадания (px)
// положительное = дальше от центра (ручка торчит наружу)
const double _kEmbedOffset = 70.0;
// Поворот картинки ножа относительно направления торчащей ручки (рад)
// подбирайте если нож смотрит не туда
const double _kKnifeImgRot = pi / 2;
// Порог совпадения углов ножей (рад) — меньше = сложнее
const double _kCollThresh = 0.18;
// Радиус шестерни для определения попадания (px)
const double _kHitRadius = _kGearEndSize * 0.38;

// ── Dead knife physics ────────────────────────────────────────────────────────
const double _kDeadGravity = 700.0;
const double _kDeadSpinVel = 9.0;

// ── Levels ────────────────────────────────────────────────────────────────────
const int _kMaxKnives =
    6; // ножей на 1-м уровне (увеличивается на 1 за уровень)
const int _kMaxKnivesCap = 16; // максимально возможное число ножей
const double _kLevelSpeedMult = 0.3; // +30% скорости за уровень
const double _kLevelTimeMult =
    0.12; // -12% интервала смены направления за уровень
const double _kLevelTimeMin = 0.5; // минимальный интервал смены направления
// ── Gear break ────────────────────────────────────────────────────────────────
const int _kGearPieceCount = 7; // сколько gear_piece вылетает
const double _kGearPieceSize = _kGearEndSize;
const double _kPieceSpeedMin = 250.0;
const double _kPieceSpeedMax = 520.0;
const double _kPieceSpinMax = 12.0;
const double _kKnifeExplodeSpeedMin = 200.0;
const double _kKnifeExplodeSpeedMax = 450.0;

// ── Reward star (угол экрана) ─────────────────────────────────────────────────
const double _kRewardStarSize = 40.0; // конечный размер звезды в углу
const double _kRewardStarSizeFrom =
    90.0; // начальный размер (уменьшается в полёте)
const double _kRewardStarPadX =
    70.0; // отступ от левого края (не налазит на кнопку)
const double _kRewardStarPadY = 18.0; // отступ от верхнего края
const double _kRewardStarSpacing = 48.0; // расстояние между звёздами по X
const double _kRewardStarRowGap = 48.0; // расстояние между строками по Y
const int _kRewardStarPerRow = 5; // звёзд в одной строке
const double _kRewardStarFlyDur = 1.6; // секунды полёта

const _p = 'assets/images/flag_games/angola/';

enum _IntroPhase { idle, spinUp, spinDown, done }

enum _GamePhase { waiting, flying, dead, broken }

class _StuckKnife {
  final double relAngle;
  _StuckKnife(this.relAngle);
}

const List<String> _kGearPieceSprites = [
  '${_p}gear_piece1.png',
  '${_p}gear_piece2.png',
  '${_p}gear_piece3.png',
  '${_p}gear_piece4.png',
  '${_p}gear_piece5.png',
  '${_p}gear_piece6.png',
];

class _FlyingPiece {
  double x, y, vx, vy, angle, spin;
  final bool isKnife;
  final int spriteIdx; // индекс в _kGearPieceSprites (игнорируется для ножей)
  _FlyingPiece({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.angle,
    required this.spin,
    this.isKnife = false,
    this.spriteIdx = 0,
  });
}

@RoutePage()
class KnifeHitScreen extends StatefulWidget implements AutoRouteWrapper {
  // игра строится на «экране Pixel 10» и масштабируется под реальный экран
  @override
  Widget wrappedRoute(BuildContext context) =>
      FlagGameViewport(background: _kColorTop, child: this);

  const KnifeHitScreen({super.key});

  @override
  State<KnifeHitScreen> createState() => _KnifeHitScreenState();
}

class _KnifeHitScreenState extends State<KnifeHitScreen>
    with SingleTickerProviderStateMixin, FlagGameBackgroundPause<KnifeHitScreen> {
  IAudioCubit get _audio => context.read<IAudioCubit>();

  Timer? _warmupTimer;
  final _rand = Random();

  // ── Intro ──────────────────────────────────────────────────────────────────
  _IntroPhase _intro = _IntroPhase.idle;
  double _introT = 0;
  bool _useFullGear = false;

  // Интерполированные координаты объектов
  double _curX = _kGearX, _curY = _kGearY, _curSize = _kGearSize;
  double _starX = _kStarX,
      _starY = _kStarY,
      _starSize = _kStarSize,
      _starAngle = _kStarAngle;
  double _starEndX = _kStarX, _starEndY = _kStarY;
  double _knifeRestX = _kKnifeX,
      _knifeRestY = _kKnifeY,
      _knifeRestSize = _kKnifeSize,
      _knifeRestAngle = _kKnifeAngle;

  // ── Gameplay ───────────────────────────────────────────────────────────────
  _GamePhase _game = _GamePhase.waiting;

  // Шестерня
  double _gearAngle = _kGearAngle;
  double _gearOscVel = 0;
  double _gearTargetVel = _kOscMaxVel * 0.6;
  double _gearSpring = 0; // угловая пружина (не используется для дёргания)
  double _gearSpringY = 0; // смещение по Y (px)
  double _gearSpringVY = 0; // скорость смещения по Y (px/s)
  double _gearDirTimer = 2.0;

  // Ножи на шестерне
  final List<_StuckKnife> _stuck = [];

  // Анимация появления нового ножа снизу
  double _knifeSlideT = 1.0; // 0 = за экраном, 1 = на месте
  static const double _kKnifeSlideDur = 0.35; // секунды

  // Летящий нож
  double _flyX = 0, _flyY = 0, _flyVX = 0, _flyVY = 0;

  // Отскочивший нож (смерть)
  double _deadX = 0, _deadY = 0, _deadVX = 0, _deadVY = 0;
  double _deadAngle = 0, _deadSpin = 0;

  // Разлетевшиеся куски (broken)
  final List<_FlyingPiece> _pieces = [];

  // ── Уровни ─────────────────────────────────────────────────────────────────
  int _level = 1;
  int _completedLevels = 0; // звёзды текущей сессии
  int _bestStars = 0; // рекорд (сохраняется)

  static const String _kBestStarsKey = 'angola_best_stars';

  // Летящая звезда-награда
  bool _rewardStarFlying = false;
  double _rewardStarX = 0, _rewardStarY = 0; // текущая позиция
  double _rewardStarFromX = 0,
      _rewardStarFromY = 0; // начальная позиция (фикс.)
  double _rewardStarTX = 0, _rewardStarTY = 0; // целевая позиция
  double _rewardStarT = 0;

  // Размеры экрана (обновляются в build)
  double _w = 1, _h = 1;

  bool _coinAnimPlaying = false;

  // Нет активной игры пока не закончилось интро
  bool get _gameActive => _intro == _IntroPhase.done;

  late final Ticker _ticker;
  Duration? _lastTick;

  // ── Пауза, пока приложение свёрнуто ──
  bool _tickerWasActive = false;

  @override
  void onAppHidden() {
    _tickerWasActive = _ticker.isActive;
    if (_tickerWasActive) _ticker.stop();
    pausePlayingPlayers([]);
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

  static const double _kTotalDur = _kSpinUpDur + _kSpinDownDur;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    _loadBest();
    _warmupTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _audio.playSfx(GameSfx.knifeThrow1, volume: 0);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _audio.pauseBgm());
  }

  bool _audioPreloaded = false;

  Future<void> _preloadAudio() async {
    if (_audioPreloaded) return;
    _audioPreloaded = true;
    try {
      await FlameAudio.audioCache.loadAll([
        GameSfx.knifeThrow1.file,
        GameSfx.knifeThrow2.file,
        GameSfx.gearCrash.file,
        GameSfx.gearSpin.file,
        GameSfx.knifeLose.file,
      ]);
    } catch (e) {
      debugPrint('KnifeHit audio preload error: $e');
    }
  }

  Future<void> _loadBest() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bestStars = prefs.getInt(_kBestStarsKey) ?? 0;
    });
  }

  Future<void> _saveBest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kBestStarsKey, _bestStars);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _warmupTimer?.cancel();
    FlameAudio.audioCache.clearAll();
    super.dispose();
  }

  // ── Tick ───────────────────────────────────────────────────────────────────
  void _onTick(Duration elapsed) {
    final raw = _lastTick == null
        ? 0.016
        : (elapsed - _lastTick!).inMicroseconds / 1e6;
    final dt = raw.clamp(0.0, 0.05); // не более 50 мс за тик
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

    if (_intro == _IntroPhase.spinUp) {
      final t = (_introT / _kSpinUpDur).clamp(0.0, 1.0);
      final vel = _kMaxVel * t * t;
      _gearAngle += vel * dt;
      if (_introT >= _kSpinUpDur) {
        _useFullGear = true;
        _intro = _IntroPhase.spinDown;
        _introT = 0;
      }
    } else if (_intro == _IntroPhase.spinDown) {
      final t = (_introT / _kSpinDownDur).clamp(0.0, 1.0);
      final vel = _kMaxVel * (1.0 - t * t);
      _gearAngle += vel * dt;
      if (_introT >= _kSpinDownDur) {
        _intro = _IntroPhase.done;
        _initGame();
        return;
      }
    }

    final elapsed = _intro == _IntroPhase.spinUp
        ? _introT
        : _kSpinUpDur + _introT;
    final t = (elapsed / _kTotalDur).clamp(0.0, 1.0);
    final mp = t * t * (3.0 - 2.0 * t); // smoothstep

    _curX = _kGearX + (_kGearEndX - _kGearX) * mp;
    _curY = _kGearY + (_kGearEndY - _kGearY) * mp;
    _curSize = _kGearSize + (_kGearEndSize - _kGearSize) * mp;
    _starX = _kStarX + (_starEndX - _kStarX) * mp;
    _starY = _kStarY + (_starEndY - _kStarY) * mp;
    _starSize = _kStarSize + (_kStarEndSize - _kStarSize) * mp;
    _starAngle = _kStarAngle + (_kStarEndAngle - _kStarAngle) * mp;
    _knifeRestX = _kKnifeX + (_kKnifeEndX - _kKnifeX) * mp;
    _knifeRestY = _kKnifeY + (_kKnifeEndY - _kKnifeY) * mp;
    _knifeRestSize = _kKnifeSize + (_kKnifeEndSize - _kKnifeSize) * mp;
    _knifeRestAngle = _kKnifeAngle + (_kKnifeEndAngle - _kKnifeAngle) * mp;
  }

  void _initGame() {
    _curX = _kGearEndX;
    _curY = _kGearEndY;
    _curSize = _kGearEndSize;
    _knifeRestX = _kKnifeEndX;
    _knifeRestY = _kKnifeEndY;
    _knifeRestSize = _kKnifeEndSize;
    _knifeRestAngle = _kKnifeEndAngle;
    // _gearAngle сохраняем из интро — не сбрасываем
    _gearOscVel = 0;
    _gearSpring = 0;
    _gearSpringY = 0;
    _gearSpringVY = 0;
    _gearTargetVel = _levelOscMaxVel * 0.6;
    _gearDirTimer =
        _levelDirTime(_kDirMinTime) +
        _rand.nextDouble() *
            (_levelDirTime(_kDirMaxTime) - _levelDirTime(_kDirMinTime));
    _knifeSlideT = 1.0;
    _stuck.clear();
    _game = _GamePhase.waiting;
  }

  void _tickGame(double dt) {
    // Шестерня: осцилляция
    _gearDirTimer -= dt;
    if (_gearDirTimer <= 0) {
      _gearTargetVel =
          -_gearTargetVel.sign *
          (_levelOscMaxVel * (0.4 + _rand.nextDouble() * 0.6));
      final dMin = _levelDirTime(_kDirMinTime);
      final dMax = _levelDirTime(_kDirMaxTime);
      _gearDirTimer = dMin + _rand.nextDouble() * (dMax - dMin);
    }
    // Плавно приближаем текущую скорость к целевой
    final diff = _gearTargetVel - _gearOscVel;
    final step = _kOscAccel * dt;
    _gearOscVel += diff.clamp(-step, step);
    _gearAngle += _gearOscVel * dt;

    // Spring Y: масса-пружина-демпфер (k=600, damping=18)
    const double kSpring = 600.0;
    const double kDamp = 18.0;
    _gearSpringVY += (-kSpring * _gearSpringY - kDamp * _gearSpringVY) * dt;
    _gearSpringY += _gearSpringVY * dt;

    // Выезд нового ножа снизу
    if (_knifeSlideT < 1.0) {
      _knifeSlideT = (_knifeSlideT + dt / _kKnifeSlideDur).clamp(0.0, 1.0);
    }

    // Летящий нож
    if (_game == _GamePhase.flying) {
      _flyX += _flyVX * dt;
      _flyY += _flyVY * dt;

      final gearCX = _px(_curX);
      final gearCY = _py(_curY);
      final dx = _flyX - gearCX;
      final dy = _flyY - gearCY;
      final dist = sqrt(dx * dx + dy * dy);

      if (dist < _kHitRadius) {
        _onKnifeHit(dx, dy, gearCX, gearCY);
      }
    }

    // Отскочивший нож (физика)
    if (_game == _GamePhase.dead) {
      _deadVY += _kDeadGravity * dt;
      _deadX += _deadVX * dt;
      _deadY += _deadVY * dt;
      _deadAngle += _deadSpin * dt;
    }

    // Летящая звезда-награда
    if (_rewardStarFlying) {
      _rewardStarT = (_rewardStarT + dt / _kRewardStarFlyDur).clamp(0.0, 1.0);
      final t = _rewardStarT;
      final ease = t * t * (3.0 - 2.0 * t); // smoothstep
      _rewardStarX =
          _rewardStarFromX + (_rewardStarTX - _rewardStarFromX) * ease;
      _rewardStarY =
          _rewardStarFromY + (_rewardStarTY - _rewardStarFromY) * ease;
      if (_rewardStarT >= 1.0) {
        _rewardStarFlying = false;
        _completedLevels++;
        if (_completedLevels > _bestStars) {
          _bestStars = _completedLevels;
          _saveBest();
        }
      }
    }

    // Разлетевшиеся куски (физика)
    if (_game == _GamePhase.broken) {
      for (final p in _pieces) {
        p.vy += _kDeadGravity * dt;
        p.x += p.vx * dt;
        p.y += p.vy * dt;
        p.angle += p.spin * dt;
      }
    }
  }

  void _onKnifeHit(double dx, double dy, double gearCX, double gearCY) {
    final arrivalAngle = atan2(dy, dx);
    final relAngle = arrivalAngle - _gearAngle;
    final relNorm = _normAngle(relAngle);

    // Проверяем столкновение с уже воткнутыми ножами
    bool collision = false;
    for (final k in _stuck) {
      if (_angleDiff(_normAngle(k.relAngle), relNorm).abs() < _kCollThresh) {
        collision = true;
        break;
      }
    }

    if (collision) {
      // Нож отскакивает → game over
      _audio.playSfx(GameSfx.knifeLose);
      _deadX = _flyX;
      _deadY = _flyY;
      _deadVX = (_rand.nextDouble() - 0.5) * 300;
      _deadVY = -(_flyVY.abs() * 0.5) - 200;
      _deadSpin = (_rand.nextBool() ? 1 : -1) * _kDeadSpinVel;
      _deadAngle = atan2(_flyVY, _flyVX) + _kKnifeImgRot;
      _game = _GamePhase.dead;
      _audio.pauseBgm();
      flagGameVibrate(context, 'Angola', 'lose');
      flagGameLossAd(
        context,
        'Angola',
        isStillLost: () => _game == _GamePhase.dead,
      );
    } else {
      // Нож втыкается
      _stuck.add(_StuckKnife(relNorm));

      if (_stuck.length >= _levelMaxKnives) {
        _audio.playSfx(GameSfx.gearCrash);
        _breakGear(gearCX, gearCY);
      } else {
        // Пружинный эффект
        _gearSpringVY = -280.0;
        _knifeSlideT = 0.0;
        _game = _GamePhase.waiting;
      }
    }
  }

  void _breakGear(double gearCX, double gearCY) {
    _pieces.clear();

    // Куски шестерни — равномерно по кругу с разбросом
    for (int i = 0; i < _kGearPieceCount; i++) {
      final baseAngle = 2 * pi * i / _kGearPieceCount;
      final a = baseAngle + (_rand.nextDouble() - 0.5) * 0.8;
      final speed =
          _kPieceSpeedMin +
          _rand.nextDouble() * (_kPieceSpeedMax - _kPieceSpeedMin);
      _pieces.add(
        _FlyingPiece(
          x: gearCX,
          y: gearCY,
          vx: cos(a) * speed,
          vy: sin(a) * speed - 100,
          angle: _rand.nextDouble() * 2 * pi,
          spin:
              (_rand.nextBool() ? 1 : -1) * _rand.nextDouble() * _kPieceSpinMax,
          spriteIdx: i % _kGearPieceSprites.length,
        ),
      );
    }

    // Воткнутые ножи — разлетаются со своих позиций
    for (final k in _stuck) {
      final worldAngle = _normAngle(k.relAngle + _gearAngle);
      final kx = gearCX + cos(worldAngle) * _kEmbedOffset;
      final ky = gearCY + sin(worldAngle) * _kEmbedOffset;
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

    _triggerCoinDrop(gearCX, gearCY);

    // Звезда летит из центра шестерни в угол
    _rewardStarFromX = gearCX;
    _rewardStarFromY = gearCY;
    _rewardStarX = gearCX;
    _rewardStarY = gearCY;
    _rewardStarT = 0;
    final col = _completedLevels % _kRewardStarPerRow;
    final row = _completedLevels ~/ _kRewardStarPerRow;
    _rewardStarTX =
        _kRewardStarPadX + col * _kRewardStarSpacing + _kRewardStarSize / 2;
    _rewardStarTY =
        _kRewardStarPadY + row * _kRewardStarRowGap + _kRewardStarSize / 2;
    _rewardStarFlying = true;
  }

  // ── Ввод ───────────────────────────────────────────────────────────────────
  void _onTap() {
    if (_intro == _IntroPhase.idle) {
      _startIntro();
    } else if (_gameActive && _game == _GamePhase.waiting) {
      _throwKnife();
    } else if (_gameActive && _game == _GamePhase.dead && _deadY > _h + 80) {
      _restartGame();
    } else if (_gameActive &&
        _game == _GamePhase.broken &&
        !_rewardStarFlying) {
      _nextLevel();
    }
  }

  // фоновая музыка по кругу — запускается один раз при старте игры и играет
  // и после рестартов; при выходе в список флагов её останавливает releaseGameAudio
  bool _musicStarted = false;

  void _startMusic() {
    if (_musicStarted) return;
    _musicStarted = true;
    _audio.playBgm(GameMusics.angola, volume: _kMusicVolume, fromStart: true);
  }

  void _startIntro() {
    _preloadAudio();
    _startMusic();
    _audio.playSfx(GameSfx.gearSpin);
    final angle = _rand.nextDouble() * 2 * pi;
    _starEndX = _kStarX + cos(angle) * _kStarFlyDist;
    _starEndY = _kStarY + sin(angle) * _kStarFlyDist;
    _intro = _IntroPhase.spinUp;
    _introT = 0;
    _useFullGear = false;
  }

  void _throwKnife() {
    _audio.playSfx(
      _rand.nextBool() ? GameSfx.knifeThrow1 : GameSfx.knifeThrow2,
    );
    final gearCX = _px(_curX);
    final gearCY = _py(_curY);
    // Spawn чуть ниже нижнего края экрана
    _flyX = _px(_kKnifeEndX);
    _flyY = _py(_kKnifeEndY) + _kKnifeEndSize * 0.5;
    final dx = gearCX - _flyX;
    final dy = gearCY - _flyY;
    final dist = sqrt(dx * dx + dy * dy);
    _flyVX = dx / dist * _kThrowSpeed;
    _flyVY = dy / dist * _kThrowSpeed;
    _game = _GamePhase.flying;
  }

  void _restartGame() {
    // музыка после проигрыша — снова с начала трека
    _audio.playBgm(GameMusics.angola, volume: _kMusicVolume, fromStart: true);
    // Смерть → сброс прогресса
    _level = 1;
    _completedLevels = 0;
    _coinAnimPlaying = false;
    _rewardStarFlying = false;
    _startLevel();
  }

  void _nextLevel() {
    _level++;
    _startLevel();
  }

  void _startLevel() {
    _stuck.clear();
    _pieces.clear();
    _gearAngle = 0;
    _gearOscVel = 0;
    _gearSpring = 0;
    _gearSpringY = 0;
    _gearSpringVY = 0;
    _gearTargetVel = _levelOscMaxVel * 0.6;
    final dMin = _levelDirTime(_kDirMinTime);
    final dMax = _levelDirTime(_kDirMaxTime);
    _gearDirTimer = dMin + _rand.nextDouble() * (dMax - dMin);
    _knifeSlideT = 1.0;
    _game = _GamePhase.waiting;
  }

  void _triggerCoinDrop(double gearCX, double gearCY) {
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
      await layer.addMoneys(() => FlagGameViewport.toScreen(context, Offset(gearCX, gearCY)), amount.clamp(1, 50));
      await Future.delayed(const Duration(milliseconds: 600));
      await layer.hide();
      if (mounted) setState(() => _coinAnimPlaying = false);
    });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
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

  // Целевое число ножей для текущего уровня
  int get _levelMaxKnives =>
      (_kMaxKnives + _level - 1).clamp(0, _kMaxKnivesCap);

  // Максимальная скорость осцилляции для текущего уровня
  double get _levelOscMaxVel =>
      _kOscMaxVel * (1.0 + (_level - 1) * _kLevelSpeedMult);

  // Интервал смены направления для текущего уровня
  double _levelDirTime(double base) =>
      (base * (1.0 - (_level - 1) * _kLevelTimeMult)).clamp(
        _kLevelTimeMin,
        base,
      );

  // Спрайт шестерни в зависимости от стадии повреждения
  String get _gearSprite {
    if (!_gameActive) {
      return _useFullGear ? '${_p}gear_full.png' : '${_p}gear.png';
    }
    final pct = _stuck.length / _levelMaxKnives;
    if (pct >= 0.85) return '${_p}gear_broke4.png';
    if (pct >= 0.75) return '${_p}gear_broke3.png';
    if (pct >= 0.50) return '${_p}gear_broke2.png';
    if (pct >= 0.25) return '${_p}gear_broke1.png';
    return '${_p}gear_full.png';
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _w = size.width;
    _h = size.height;
    final w = _w, h = _h;

    final gearCX = _px(_curX);
    final gearCY = _py(_curY) + _gearSpringY;

    return Scaffold(
      backgroundColor: _kColorTop,
      body: GestureDetector(
        onTapUp: (_) => _onTap(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(child: CustomPaint(painter: _BgPainter())),

            // ── Шестерня и воткнутые ножи (скрыты при взрыве) ────────────────
            if (_game != _GamePhase.broken) ...[
              _placedAbs(
                gearCX,
                gearCY,
                _gearAngle,
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 50), // ~3 кадра
                  transitionBuilder: (child, animation) {
                    // Новый спрайт проявляется поверх; старый остаётся непрозрачным
                    final isCurrent = child.key == ValueKey(_gearSprite);
                    return FadeTransition(
                      opacity: isCurrent
                          ? animation
                          : const AlwaysStoppedAnimation(1.0),
                      child: child,
                    );
                  },
                  child: Image.asset(
                    _gearSprite,
                    key: ValueKey(_gearSprite),
                    width: _curSize,
                    height: _curSize,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              for (final k in _stuck)
                Builder(
                  builder: (_) {
                    final worldAngle = _normAngle(k.relAngle + _gearAngle);
                    final kx = gearCX + cos(worldAngle) * _kEmbedOffset;
                    final ky = gearCY + sin(worldAngle) * _kEmbedOffset;
                    final kAngle = worldAngle + _kKnifeImgRot + pi;
                    return _placedAbs(
                      kx,
                      ky,
                      kAngle,
                      Image.asset(
                        '${_p}knife.png',
                        width: _kKnifeEndSize,
                        height: _kKnifeEndSize,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
            ], // end if (_game != broken)
            // ── Летящий нож ───────────────────────────────────────────────────
            if (_game == _GamePhase.flying) ...[
              _placedAbs(
                _flyX,
                _flyY,
                atan2(_flyVY, _flyVX) + _kKnifeImgRot,
                Image.asset(
                  '${_p}knife.png',
                  width: _kKnifeEndSize,
                  height: _kKnifeEndSize,
                  fit: BoxFit.contain,
                ),
              ),
            ],

            // ── Нож в покое (ожидание броска, выезжает снизу) ─────────────────
            if (_gameActive && _game == _GamePhase.waiting) ...[
              Builder(
                builder: (_) {
                  final ease =
                      1.0 - (1.0 - _knifeSlideT) * (1.0 - _knifeSlideT);
                  final slideY = (1.0 - ease) * _knifeRestSize;
                  return _placedAbs(
                    _px(_knifeRestX),
                    _py(_knifeRestY) + slideY,
                    _knifeRestAngle,
                    Image.asset(
                      '${_p}knife.png',
                      width: _knifeRestSize,
                      height: _knifeRestSize,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
            ],

            // ── Нож до интро ──────────────────────────────────────────────────
            if (!_gameActive && _intro != _IntroPhase.done) ...[
              _placed(
                w,
                h,
                _knifeRestX,
                _knifeRestY,
                _knifeRestAngle,
                Image.asset(
                  '${_p}knife.png',
                  width: _knifeRestSize,
                  height: _knifeRestSize,
                  fit: BoxFit.contain,
                ),
              ),
            ],

            // ── Отскочивший нож (game over) ───────────────────────────────────
            if (_game == _GamePhase.dead) ...[
              _placedAbs(
                _deadX,
                _deadY,
                _deadAngle,
                Image.asset(
                  '${_p}knife.png',
                  width: _kKnifeEndSize,
                  height: _kKnifeEndSize,
                  fit: BoxFit.contain,
                ),
              ),
            ],

            // ── Разлетевшиеся куски шестерни и ножей ─────────────────────────
            if (_game == _GamePhase.broken) ...[
              for (final p in _pieces)
                _placedAbs(
                  p.x,
                  p.y,
                  p.angle,
                  Image.asset(
                    p.isKnife
                        ? '${_p}knife.png'
                        : _kGearPieceSprites[p.spriteIdx],
                    width: p.isKnife ? _kKnifeEndSize : _kGearPieceSize,
                    height: p.isKnife ? _kKnifeEndSize : _kGearPieceSize,
                    fit: BoxFit.contain,
                  ),
                ),
            ],

            // ── Счётчик ножей ─────────────────────────────────────────────────
            if (_gameActive && _game != _GamePhase.broken) ...[
              Positioned(
                left: gearCX + _curSize * 0.55,
                top: gearCY - _curSize * 0.15,
                child: Text(
                  '${_stuck.length}/$_levelMaxKnives',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],

            // ── Звёзды в углу (завершённые уровни) ───────────────────────────
            if (_gameActive) ...[
              for (int i = 0; i < _completedLevels; i++)
                Positioned(
                  left:
                      _kRewardStarPadX +
                      (i % _kRewardStarPerRow) * _kRewardStarSpacing,
                  top:
                      _kRewardStarPadY +
                      (i ~/ _kRewardStarPerRow) * _kRewardStarRowGap,
                  child: Image.asset(
                    '${_p}angola_star.png',
                    width: _kRewardStarSize,
                    height: _kRewardStarSize,
                    fit: BoxFit.contain,
                  ),
                ),
              if (_rewardStarFlying)
                Builder(
                  builder: (_) {
                    // smoothstep для плавного замедления
                    final t = _rewardStarT;
                    final ease = t * t * (3.0 - 2.0 * t);
                    final sz =
                        _kRewardStarSizeFrom +
                        (_kRewardStarSize - _kRewardStarSizeFrom) * ease;
                    return Positioned(
                      left: _rewardStarX - sz / 2,
                      top: _rewardStarY - sz / 2,
                      child: Image.asset(
                        '${_p}angola_star.png',
                        width: sz,
                        height: sz,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
            ],

            // ── Звезда ────────────────────────────────────────────────────────
            if (_intro != _IntroPhase.done) ...[
              _placed(
                w,
                h,
                _starX,
                _starY,
                _starAngle,
                Image.asset(
                  '${_p}angola_star.png',
                  width: _starSize,
                  height: _starSize,
                  fit: BoxFit.contain,
                ),
              ),
            ],

            // ── Back button ───────────────────────────────────────────────────
            // «Tap to start» — один раз, на первом открытом флаге
            Positioned.fill(
              child: FlagGameTapHint(visible: _intro == _IntroPhase.idle),
            ),
            const Positioned(top: 8, left: 8, child: FBackButton()),

            // ── Best score (bottom-left) ──────────────────────────────────────
            Positioned(
              bottom: 12,
              left: 12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/winner_cup.png',
                    width: 36,
                    height: 36,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$_bestStars',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset('${_p}angola_star.png', width: 22, height: 22),
                ],
              ),
            ),

            // ── Overlay ───────────────────────────────────────────────────────
            if ((_game == _GamePhase.dead && _deadY > _h + 80) ||
                (_game == _GamePhase.broken && !_rewardStarFlying)) ...[
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Text(
                      _game == _GamePhase.broken
                          ? 'LEVEL $_level DONE!\nTAP TO CONTINUE'
                          : 'TAP TO RESTART',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],

            // ── Прогрев GPU: держим все текстуры в памяти постоянно ───────────
            Positioned(
              left: -9999,
              top: -9999,
              child: Opacity(
                opacity: 0.01,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('${_p}knife.png', width: 1, height: 1),
                    Image.asset('${_p}gear_full.png', width: 1, height: 1),
                    Image.asset('${_p}gear_broke1.png', width: 1, height: 1),
                    Image.asset('${_p}gear_broke2.png', width: 1, height: 1),
                    Image.asset('${_p}gear_broke3.png', width: 1, height: 1),
                    Image.asset('${_p}gear_broke4.png', width: 1, height: 1),
                    Image.asset('${_p}gear_piece1.png', width: 1, height: 1),
                    Image.asset('${_p}gear_piece2.png', width: 1, height: 1),
                    Image.asset('${_p}gear_piece3.png', width: 1, height: 1),
                    Image.asset('${_p}gear_piece4.png', width: 1, height: 1),
                    Image.asset('${_p}gear_piece5.png', width: 1, height: 1),
                    Image.asset('${_p}gear_piece6.png', width: 1, height: 1),
                    Image.asset('${_p}angola_star.png', width: 1, height: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Позиционирование по долям экрана
  // Позиции объектов (доли) отсчитываются от центра экрана в пикселях
  // эталонного Pixel 10: шестерня, мачете и звезда стоят друг относительно
  // друга одинаково на любом экране, а не растягиваются по долям экрана.
  double _px(double frac) =>
      _w / 2 + (frac - 0.5) * FlagGameViewport.reference.width;
  double _py(double frac) =>
      _h / 2 + (frac - 0.5) * FlagGameViewport.reference.height;

  Widget _placed(
    double w,
    double h,
    double fx,
    double fy,
    double angle,
    Widget child,
  ) {
    return Positioned(
      left: _px(fx),
      top: _py(fy),
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: Transform.rotate(angle: angle, child: child),
      ),
    );
  }

  // Позиционирование по абсолютным пикселям
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

class _BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final half = size.height / 2;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, half),
      Paint()..color = _kColorTop,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, half, size.width, half),
      Paint()..color = _kColorBottom,
    );
  }

  @override
  bool shouldRepaint(_BgPainter old) => false;
}
