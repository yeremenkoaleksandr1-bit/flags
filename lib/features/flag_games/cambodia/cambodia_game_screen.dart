import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flags/features/flag_games/flag_game_viewport.dart';
import 'package:flags/features/flag_games/flag_game_background_pause.dart';
import 'package:flags/features/flag_games/flag_game_tap_hint.dart';
import 'package:flags/features/flag_games/flag_game_ads.dart';
import 'package:flags/features/flag_games/flag_game_vibration.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flags/uikit/components/buttons/actions/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forge2d/forge2d.dart' as b2;
import 'package:shared_preferences/shared_preferences.dart';

const double _kMusicVolume =
    0.6; // фоновая музыка (cambodia_music1 → cambodia_music2)

const Color _kBgColor = Color(0xFFCC0001);
const int _kDarkenAfter = 3; // с какого блока начинается затемнение
const int _kDarkenMax = 50; // при каком числе блоков фон становится чёрным
const Color _kStripeColor = Color(0xFF032EA1);

// ── Stripe settings ───────────────────────────────────────────────────────────
const double _kStripeHeightFrac = 0.22;
const double _kStripe1YFrac = 0.0;
const double _kStripe2YFrac = 0.78;

// ── Building settings ─────────────────────────────────────────────────────────
const double _kBuildingWidthFrac = 0.33;
const double _kPartWidthFrac = 0.2;
const double _kBuildingYFrac = 0.26;
const double _kBuildingBotWidthFrac = 0.33;
const double _kBuildingBotYFrac = 0.26;

// ── Building bottom hitbox ────────────────────────────────────────────────────
const bool _kShowHitbox = false; // показать хитбокс
const double _kHitboxXFrac = 0.33; // левый край (доля ширины экрана)
const double _kHitboxYFrac = 0.59; // верхний край (доля высоты экрана)
const double _kHitboxWFrac = 0.33; // ширина (доля ширины экрана)
const double _kHitboxHFrac = 0.15; // высота (доля высоты экрана)

// ── Building part hitbox (падающая часть) ────────────────────────────────────
const bool _kShowPartHitbox = false; // показать хитбокс части
const double _kPartHbDxFrac =
    0.0; // смещение центра по X от центра части (доля ширины части)
const double _kPartHbDyFrac =
    0.0; // верх хитбокса от верха части (доля высоты экрана)
const double _kPartHbWFrac = 1.0; // ширина хитбокса (доля ширины части)
const double _kPartSpriteAspect = 330.0 / 656.0; // высота / ширина спрайта

// ── Roof block (cambodia_building.png как финальная крыша) ─────────────────
const bool _kShowRoofHitbox = false; // показать хитбокс крыши
const double _kRoofHbWFrac = 0.8; // ширина хитбокса (доля ширины спрайта крыши)
const double _kRoofHbHFrac =
    0.45; // высота хитбокса (доля ширины спрайта крыши)
const double _kRoofHbDxFrac = 0.0; // смещение центра хитбокса по X
const double _kRoofHbDyFrac =
    0.0; // верх хитбокса от верха части (доля высоты экрана)

// ── Crane/chain settings ──────────────────────────────────────────────────────
const double _kCraneWidthFrac = 0.03;
const double _kPivotAbove = 500.0;

// ── Building part (hanging) settings ─────────────────────────────────────────

// ── Crane hook overlap ────────────────────────────────────────────────────────
const double _kHookOverlap = 18.0;
const double _kPartOffsetY = -20.0; // отрицательное — выше крюка

// ── Pendulum settings ─────────────────────────────────────────────────────────
const double _kSwingAmp = 0.25;
const double _kSwingAmpWind = 0.50; // размах при ветре
const double _kSwingPeriod = 2.8;
const double _kPendulumYFrac =
    0.10; // Y покоя крюка (доля высоты); меньше — выше

// ── Wind settings ─────────────────────────────────────────────────────────────
const double _kWindChance = 0.30; // вероятность ветра (после N блоков)
const double _kWindDur = 4.0; // длительность эффекта ветра (сек)
const int _kWindAfter = 5; // с какого блока начинается шанс ветра
const double _kWindLineSpeed = 0.30; // скорость линий (доли ширины в секунду)

// ── Falling physics ───────────────────────────────────────────────────────────
const double _kGravity = 980.0; // px/s²
const double _kBounceDamp = 0.25; // коэф. отскока
const double _kFriction = 0.65; // затухание горизонтальной скорости при ударе
const double _kAirSpinDamp =
    0.4; // демпфирование вращения в воздухе (angularDamping)

// ── Slide-down / loop ────────────────────────────────────────────────────────
const double _kSettleDelay = 1.5; // пауза после приземления до сдвига
const double _kSlideDownDur = 0.55; // длительность анимации сдвига
const double _kShiftFrac = 0.22; // доля высоты экрана для сдвига (2+ блок)
const double _kFirstShiftFrac =
    0.32; // доля высоты экрана для сдвига (первый блок)

// ── Phase durations ───────────────────────────────────────────────────────────
const double _kStripeUpDur = 0.55;
const double _kCraneDown1Dur = 1.2;
const double _kGrabDur = 0.35;
const double _kBuildingUpDur = 0.75;
const double _kCraneDown2Dur = 1.3;
const double _kCraneRetractDur = 0.4;

// ── Screen shake ─────────────────────────────────────────────────────────────
// ── Coins ─────────────────────────────────────────────────────────────────────
const int _kCoinMin = 3; // минимум монет за ровную постановку
const int _kCoinMax = 8; // максимум монет
const double _kPerfectAngle = 0.06; // макс. угол (рад) для "ровно" (~3.4°)
const double _kPerfectOffX =
    0.08; // макс. смещение по X (доля ширины блока) для "ровно"

// ── Screen shake ─────────────────────────────────────────────────────────────
const double _kShakeDur = 0.45; // длительность тряски (сек)
const double _kShakeMax = 9.0; // максимальная амплитуда (px)

// ── Zoom-out (финальная анимация) ────────────────────────────────────────────
const double _kFlashDur = 0.35; // длительность вспышки перед зумом (сек)
const double _kZoomDur = 1.8; // длительность анимации зума (сек)
const double _kZoomPad = 0.06; // отступ сверху/снизу (доля высоты экрана)

const _p = 'assets/images/flag_games/cambodia/';

enum _Phase {
  idle,
  stripeUp,
  craneDown1,
  grab,
  buildingUp,
  craneDown2,
  wind,
  pendulum,
  falling,
  slideDown,
}

@RoutePage()
class CambodiaGameScreen extends StatefulWidget implements AutoRouteWrapper {
  // игра строится на «экране Pixel 10» и масштабируется под реальный экран
  @override
  Widget wrappedRoute(BuildContext context) =>
      FlagGameViewport(background: _kBgColor, child: this);

  const CambodiaGameScreen({super.key});

  @override
  State<CambodiaGameScreen> createState() => _CambodiaGameScreenState();
}

class _CambodiaGameScreenState extends State<CambodiaGameScreen>
    with
        SingleTickerProviderStateMixin,
        FlagGameBackgroundPause<CambodiaGameScreen> {
  // Box2D physics world (active only during _Phase.falling)
  b2.World? _b2World;
  b2.Body? _fallingBody;
  b2.Body?
  _prevDynamicBody; // последний упавший блок — динамический пока падает следующий
  static const double _kB2Scale = 100.0; // pixels per Box2D unit

  b2.Vector2 _v2(double x, double y) =>
      b2.Vector2(x / _kB2Scale, y / _kB2Scale);

  static const double _kWindFadeDur = 0.6; // секунды fade-in / fade-out

  late final Ticker _ticker;
  Duration? _lastTick;

  // ── Пауза, пока приложение свёрнуто ──
  bool _tickerWasActive = false;

  @override
  void onAppHidden() {
    _tickerWasActive = _ticker.isActive;
    if (_tickerWasActive) _ticker.stop();
    pausePlayingPlayers([_music1, _music2]);
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

  _Phase _phase = _Phase.idle;
  double _phaseT = 0.0;
  double _swingT = 0.0;
  double _curSwingAmp = 0.25;
  double _curSwingPeriod = 2.8;
  int _partIndex = 1; // 1, 2 или 3
  bool _isRoofNext = false; // следующий блок — крыша
  bool _isRoof = false; // текущий висящий/падающий блок — крыша
  bool _gameComplete = false; // игра завершена после крыши
  int _bestScore = 0; // рекорд (кол-во блоков)
  static const _kBestScoreKey = 'cambodia_best_score';
  double _bgDarkenT = 0.0; // 0..1, плавно анимируется к целевому затемнению
  bool _coinAnimPlaying = false;
  GameSfx _pendingHitSfx = GameSfx.fallHit1;
  double _peakSpeed = 0.0; // максимальная скорость тела с момента отпускания
  double _chain2WarmupTimer = 0.0;
  static const double _kChain2WarmupInterval = 1.5;
  double _flashT = 0.0; // 1..0, вспышка перед зумом
  double _shakeAmt = 0.0; // 0..1, затухает до 0
  bool _shakeTriggered = false; // первый удар уже был в этом броске
  double _zoomT = 0.0; // 0..1, прогресс анимации зума
  double _zoomScale = 1.0; // целевой масштаб
  double _zoomCenterY = 0.0; // Y центра здания (экранные координаты)
  double _retractAngle = 0.0;
  double _retractT = 0.0;
  bool _craneRetracting = false;
  final _rng = Random();

  // Wind state
  bool _windActive = false;
  AudioPlayer? _windPlayer;
  double _windVolume = 1.0;
  int _windSoundId =
      0; // защищает от плеера, который загрузился уже после конца ветра
  double _windDir = 1.0; // +1 = вправо, -1 = влево
  double _windTimer = 0.0;
  double _windLineOff = 0.0; // 0..1, смещение линий ветра
  double _windOpacity = 0.0; // плавно затухает после смены фазы

  // Текущая экранная позиция верха building_part (обновляется каждый тик маятника)
  double _partScreenX = 0, _partScreenY = 0;

  // Falling part state
  double _fallX = 0, _fallY = 0;
  double _fallVx = 0, _fallVy = 0;
  double _fallAngle = 0, _fallSpin = 0;
  bool _fallLanded = false;
  double _settleTimer = 0.0;
  double _slideT = 0.0;
  double _stackOff = 0.0; // накопленный постоянный сдвиг
  double _animOff = 0.0; // текущий анимационный сдвиг (0..slideStep)
  double _slideStep = 0.0; // на сколько сдвигаем в этом раунде
  final List<(double, double, double, int)> _landedBlocks =
      []; // x, y, angle, partIndex

  double _w = 1, _h = 1;

  double get _totalOffset => _stackOff + _animOff;

  double get _ropeLen =>
      _kPivotAbove + _kPendulumYFrac * _refH + (_h - _refH) / 2;
  // Здание привязано к центру красной полосы (середина экрана) с тем же
  // отступом в пикселях, что на эталонном Pixel 10: размер здания считается
  // от ширины, и при доле от высоты на экранах других пропорций оно уезжало
  // вверх/вниз относительно полосы.
  // размеры объектов — в пикселях эталонного Pixel 10, а не долях экрана
  static double get _refW => FlagGameViewport.reference.width;
  static double get _refH => FlagGameViewport.reference.height;
  // X от центра экрана с тем же отступом, что на Pixel 10
  double _xFromCenter(double refFrac) => _w / 2 - (0.5 - refFrac) * _refW;

  double _yFromCenter(double refFrac) =>
      _h / 2 - (0.5 - refFrac) * FlagGameViewport.reference.height;
  double get _buildingTopY => _yFromCenter(_kBuildingYFrac);
  double get _craneW => _refW * _kCraneWidthFrac;
  double get _buildingW => _refW * _kBuildingWidthFrac;
  double get _buildingBotW => _refW * _kBuildingBotWidthFrac;
  double get _partW => _refW * _kPartWidthFrac;
  double get _partHbH => _partW * _kPartHbWFrac * _kPartSpriteAspect;
  String get _partAsset =>
      '${_p}cambodia_building_part${_partIndex == 1 ? '' : _partIndex}.png';

  // Текущий висящий/падающий блок (обычный или крыша)
  String get _curAsset => _isRoof ? '${_p}cambodia_building.png' : _partAsset;
  double get _curSpriteW => _isRoof ? _buildingW : _partW;
  double get _curHbW =>
      _isRoof ? _buildingW * _kRoofHbWFrac : _partW * _kPartHbWFrac;
  double get _curHbH => _isRoof ? _buildingW * _kRoofHbHFrac : _partHbH;
  double get _curHbDxFrac => _isRoof ? _kRoofHbDxFrac : _kPartHbDxFrac;
  double get _curHbDyFrac => _isRoof ? _kRoofHbDyFrac : _kPartHbDyFrac;

  bool get _isSwingPhase =>
      _phase == _Phase.pendulum ||
      _phase == _Phase.wind ||
      _phase == _Phase.craneDown2 ||
      _phase == _Phase.slideDown;

  double get _pendulumAngle {
    if (_craneRetracting) {
      final t = _retractT;
      return _retractAngle * (1 - t * t * (3 - 2 * t));
    }
    if (_isSwingPhase) {
      return _curSwingAmp * sin(2 * pi * _swingT / _curSwingPeriod);
    }
    return 0.0;
  }

  // Текущая длина цепи
  double get _craneLen {
    if (_craneRetracting) {
      final t = _retractT;
      return _ropeLen * (1 - t * t * (3 - 2 * t));
    }
    if (_phase == _Phase.pendulum || _phase == _Phase.wind) return _ropeLen;
    if (_isSwingPhase) {
      final t = _phaseT;
      return (t * t * (3 - 2 * t)) * _ropeLen;
    }
    return _ropeLen;
  }

  Offset get _hook {
    final cx = _w / 2;
    double smoothstep(double t) => t * t * (3 - 2 * t);

    switch (_phase) {
      case _Phase.craneDown1:
        final y = -_ropeLen + smoothstep(_phaseT) * (_buildingTopY + _ropeLen);
        return Offset(cx, y);
      case _Phase.grab:
        return Offset(cx, _buildingTopY);
      case _Phase.buildingUp:
        final y =
            _buildingTopY - smoothstep(_phaseT) * (_buildingTopY + _ropeLen);
        return Offset(cx, y);
      case _Phase.craneDown2:
      case _Phase.slideDown:
      case _Phase.pendulum:
        final a = _pendulumAngle;
        final len = _craneLen;
        return Offset(cx + len * sin(a), -_kPivotAbove + len * cos(a));
      default:
        return Offset(cx, -_ropeLen);
    }
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
    _loadBestScore();
    _preloadSounds();
  }

  static const _kGameSounds = [
    GameSfx.chain1,
    GameSfx.chain2,
    GameSfx.chainGear,
    GameSfx.fallHit1,
    GameSfx.fallHit2,
    GameSfx.fallHit3,
    GameSfx.moneyShort,
    GameSfx.flash,
    GameSfx.wind,
  ];

  // играем один раз (без цикла) и гасим вместе с визуальным fade-out ветра,
  // чтобы звук не пережил эффект, если файл окажется длиннее _kWindDur
  void _startWindSound() {
    _stopWindSound();
    final id = ++_windSoundId;
    _windVolume = 1.0;
    final audio = context.read<IAudioCubit>();
    audio.playSfx(GameSfx.wind).then((p) {
      if (p == null) return;
      if (!mounted || id != _windSoundId) {
        audio.stopSfx(p);
        return;
      }
      _windPlayer = p;
    });
  }

  void _fadeWindSound(double volume) {
    final p = _windPlayer;
    // обновляем громкость шагами, а не каждый кадр — меньше вызовов в платформу
    if (p == null || (volume - _windVolume).abs() < 0.1) return;
    _windVolume = volume;
    p.setVolume(volume).catchError((Object _) {});
  }

  void _stopWindSound() {
    _windSoundId++;
    final p = _windPlayer;
    _windPlayer = null;
    if (p != null) context.read<IAudioCubit>().stopSfx(p);
  }

  Future<void> _preloadSounds() async {
    await FlameAudio.audioCache.loadAll(
      _kGameSounds.map((s) => s.file).toList(),
    );
    // Прогреваем AudioPlayer для каждого звука — создаёт экземпляр плеера
    // заранее чтобы при реальном воспроизведении не было задержки
    if (!mounted) return;
    final audio = context.read<IAudioCubit>();
    for (final sfx in _kGameSounds) {
      audio.playSfx(sfx, volume: 0);
    }
  }

  Future<void> _loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => _bestScore = prefs.getInt(_kBestScoreKey) ?? 0);
  }

  Future<void> _saveBestScore(int score) async {
    if (score <= _bestScore) return;
    _bestScore = score;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kBestScoreKey, score);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _music1Done?.cancel();
    _music1?.dispose();
    _music2?.dispose();
    FlameAudio.audioCache.clearAll();
    super.dispose();
  }

  void _tick(Duration elapsed) {
    final dt = _lastTick == null
        ? 0.016
        : (elapsed - _lastTick!).inMicroseconds / 1e6;
    _lastTick = elapsed;
    if (_phase == _Phase.idle) {
      final targetDarkenT = _landedBlocks.length <= _kDarkenAfter
          ? 0.0
          : ((_landedBlocks.length - _kDarkenAfter) /
                    (_kDarkenMax - _kDarkenAfter))
                .clamp(0.0, 1.0);
      if (_gameComplete && (_flashT > 0 || _zoomT < 1.0) ||
          _shakeAmt > 0 ||
          (_bgDarkenT - targetDarkenT).abs() > 0.001) {
        setState(() {
          if (_gameComplete && _flashT > 0) {
            _flashT = (_flashT - dt / _kFlashDur).clamp(0.0, 1.0);
          }
          if (_gameComplete && _zoomT < 1.0) {
            _zoomT = (_zoomT + dt / _kZoomDur).clamp(0.0, 1.0);
          }
          if (_shakeAmt > 0)
            _shakeAmt = (_shakeAmt - dt / _kShakeDur).clamp(0.0, 1.0);
          if ((_bgDarkenT - targetDarkenT).abs() > 0.001) {
            _bgDarkenT =
                (_bgDarkenT + (targetDarkenT - _bgDarkenT) * (dt * 2.0)).clamp(
                  0.0,
                  1.0,
                );
          }
        });
      }
      return;
    }

    setState(() {
      if (_shakeAmt > 0)
        _shakeAmt = (_shakeAmt - dt / _kShakeDur).clamp(0.0, 1.0);
      final targetDarkenT2 = _landedBlocks.length <= _kDarkenAfter
          ? 0.0
          : ((_landedBlocks.length - _kDarkenAfter) /
                    (_kDarkenMax - _kDarkenAfter))
                .clamp(0.0, 1.0);
      if ((_bgDarkenT - targetDarkenT2).abs() > 0.001) {
        _bgDarkenT = (_bgDarkenT + (targetDarkenT2 - _bgDarkenT) * (dt * 2.0))
            .clamp(0.0, 1.0);
      }
      // Затухание ветра — работает в любой фазе
      if (_phase != _Phase.wind && _windOpacity > 0) {
        _windLineOff = (_windLineOff + dt * _kWindLineSpeed * _windDir) % 1.0;
        if (_windLineOff < 0) _windLineOff += 1.0;
        _windOpacity = (_windOpacity - dt / _kWindFadeDur).clamp(0.0, 1.0);
      }

      if (_craneRetracting) {
        _retractT = (_retractT + dt / _kCraneRetractDur).clamp(0.0, 1.0);
        if (_retractT >= 1.0) _craneRetracting = false;
      }

      if (_phase == _Phase.pendulum || _phase == _Phase.wind) {
        // Беззвучный прогрев chain2 чтобы не было фриза при отпускании
        _chain2WarmupTimer += dt;
        if (_chain2WarmupTimer >= _kChain2WarmupInterval) {
          _chain2WarmupTimer = 0.0;
          Future.microtask(() {
            if (!mounted) return;
            context.read<IAudioCubit>().playSfx(GameSfx.chain2, volume: 0);
          });
        }
        _tickPhysicsOnly(dt);
        _swingT += dt;
        final a = _curSwingAmp * sin(2 * pi * _swingT / _curSwingPeriod);
        final ca = cos(a), sa = sin(a);
        final dx = _curSpriteW * _curHbDxFrac;
        final dy =
            _ropeLen + _kPartOffsetY + _refH * _curHbDyFrac + _curHbH / 2;
        _partScreenX = _w / 2 + dx * ca - dy * sa;
        _partScreenY = (-_kPivotAbove + _kHookOverlap) + dx * sa + dy * ca;
        if (_phase == _Phase.pendulum) return;
      }

      if (_phase == _Phase.falling) {
        _tickFalling(dt);

        // Блок вылетел за нижний край экрана
        if (_fallY > _h + 50) {
          if (_isRoof) {
            // Крыша упала — всё равно завершаем игру
            _fallingBody = null;
            _b2World = null;
            _isRoof = false;
            _gameComplete = true;
            _flashT = 1.0;
            _stopMusic();
            flagGameLossAd(
              context,
              'Cambodia',
              isStillLost: () => _gameComplete,
            );
            _phase = _Phase.idle;
            _computeZoom();
            _saveBestScore(_landedBlocks.length);
            Future.microtask(() {
              if (!mounted) return;
              context.read<IAudioCubit>().playSfx(GameSfx.flash);
            });
            return;
          }
          _isRoofNext = true;
          _fallingBody = null;
          _b2World = null;
          _prevDynamicBody = null;
          _slideStep = 0.0;
          _animOff = 0.0;
          _phaseT = 0.0;
          _swingT = _rng.nextBool() ? 0.0 : _curSwingPeriod / 2;
          _fallLanded = false;
          _settleTimer = 0.0;
          _fallAngle = 0;
          _fallSpin = 0;
          _fallVx = 0;
          _fallVy = 0;
          _slideT = 0.0;
          _phase = _Phase.slideDown;
          return;
        }

        _settleTimer += dt;
        if (_settleTimer >= _kSettleDelay && _fallLanded) {
          if (_isRoof) {
            // Крыша — финальный блок, завершаем игру
            _landedBlocks.add((_fallX, _fallY - _stackOff, _fallAngle, 0));
            _fallingBody = null;
            _b2World = null;
            _isRoof = false;
            _gameComplete = true;
            _flashT = 1.0;
            _stopMusic();
            flagGameLossAd(
              context,
              'Cambodia',
              isStillLost: () => _gameComplete,
            );
            _phase = _Phase.idle;
            _computeZoom();
            _saveBestScore(_landedBlocks.length);
            Future.microtask(() {
              if (!mounted) return;
              context.read<IAudioCubit>().playSfx(GameSfx.flash);
            });
          } else {
            // Замораживаем старое динамическое тело в его текущей физической позиции
            if (_prevDynamicBody != null && _landedBlocks.isNotEmpty) {
              final pos = _prevDynamicBody!.position;
              final idx = _landedBlocks.length - 1;
              _landedBlocks[idx] = (
                pos.x * _kB2Scale,
                pos.y * _kB2Scale - _stackOff,
                _prevDynamicBody!.angle,
                _landedBlocks[idx].$4,
              );
              _prevDynamicBody!.setType(b2.BodyType.static);
            }
            _landedBlocks.add((
              _fallX,
              _fallY - _stackOff,
              _fallAngle,
              _partIndex,
            ));
            _prevDynamicBody = _fallingBody;
            _fallingBody = null;
            // Монеты если блок упал ровно
            final isPerfect =
                _landedBlocks.length >= 2 &&
                _fallAngle.abs() < _kPerfectAngle &&
                (_fallX - _landedBlocks[_landedBlocks.length - 2].$1).abs() <
                    _partW * _kPerfectOffX;
            if (isPerfect) {
              // Стык = низ нового блока = его центр + половина высоты хитбокса
              final junctionY = _fallY + _partHbH / 2;
              _triggerCoinDrop(Offset(_fallX, junctionY));
            }
            final shiftFrac = _landedBlocks.length % 7 == 1
                ? _kFirstShiftFrac
                : _kShiftFrac;
            _slideStep = _refH * shiftFrac; // шаг камеры в пикселях Pixel 10
            _animOff = 0.0;
            _phaseT = 0.0;
            _swingT = _rng.nextBool() ? 0.0 : _curSwingPeriod / 2;
            _phase = _Phase.slideDown;
            _slideT = 0.0;
            _settleTimer = 0.0;
          }
        }
        return;
      }

      if (_phase == _Phase.slideDown) {
        _tickPhysicsOnly(dt);
        _slideT = (_slideT + dt / _kSlideDownDur).clamp(0.0, 1.0);
        final t = _slideT;
        _animOff = _slideStep * t * t * (3 - 2 * t);
        // Кран спускается и качается одновременно со сдвигом
        _phaseT = (_phaseT + dt / _kCraneDown2Dur).clamp(0.0, 1.0);
        _swingT += dt;
        if (_slideT >= 1.0) {
          // Фиксируем сдвиг: переносим animOff в stackOff
          _stackOff += _slideStep;
          _animOff = 0.0;
          // Сдвигаем все тела Box2D вниз на slideStep, чтобы мир совпал с визуальным сдвигом
          if (_b2World != null) {
            final shift = _slideStep / _kB2Scale;
            for (final body in _b2World!.bodies) {
              body.setTransform(
                b2.Vector2(body.position.x, body.position.y + shift),
                body.angle,
              );
            }
          }
          _slideStep = 0.0;
          _slideT = 0.0;
          _fallLanded = false;
          _windActive = false;
          _fallAngle = 0;
          _fallSpin = 0;
          _fallVx = 0;
          _fallVy = 0;
          // Если кран уже доехал до низа — сразу в маятник
          if (_phaseT >= 1.0) {
            if (_isRoofNext) {
              _isRoof = true;
              _isRoofNext = false;
            }
            _phase = _Phase.pendulum;
          } else {
            _curSwingAmp = _kSwingAmp + _rng.nextDouble() * 0.12;
            _curSwingPeriod = 2.4 + _rng.nextDouble() * 0.8;
            if (_isRoofNext) {
              _isRoof = true;
              _isRoofNext = false;
            } else {
              _partIndex = _rng.nextInt(3) + 1;
            }
            _phase = _Phase.craneDown2;
            _chain2WarmupTimer = 0.0;
            Future.microtask(() {
              if (!mounted) return;
              context.read<IAudioCubit>().playSfx(GameSfx.chain1);
            });
          }
        }
        return;
      }

      // craneDown2: качаемся и спускаемся одновременно
      if (_phase == _Phase.craneDown2) {
        _tickPhysicsOnly(dt);
        _swingT += dt;
        _phaseT = (_phaseT + dt / _kCraneDown2Dur).clamp(0.0, 1.0);
        if (_phaseT >= 1.0) _advance();
        return;
      }

      // wind: 4-секундный эффект ветра перед маятником
      if (_phase == _Phase.wind) {
        _windTimer += dt;
        _windLineOff = (_windLineOff + dt * _kWindLineSpeed * _windDir) % 1.0;
        if (_windLineOff < 0) _windLineOff += 1.0;
        final fadeIn = (_windTimer / _kWindFadeDur).clamp(0.0, 1.0);
        final fadeOut = ((_kWindDur - _windTimer) / _kWindFadeDur).clamp(
          0.0,
          1.0,
        );
        _windOpacity = fadeIn * fadeOut;
        _fadeWindSound(fadeOut);
        if (_windTimer >= _kWindDur) {
          _phase = _Phase.pendulum;
          _stopWindSound();
        }
        return;
      }
      final dur = switch (_phase) {
        _Phase.stripeUp => _kStripeUpDur,
        _Phase.craneDown1 => _kCraneDown1Dur,
        _Phase.grab => _kGrabDur,
        _Phase.buildingUp => _kBuildingUpDur,
        _ => 1.0,
      };

      _phaseT = (_phaseT + dt / dur).clamp(0.0, 1.0);
      if (_phaseT >= 1.0) _advance();
    });
  }

  // Инициализирует Box2D мир с телами поверхностей и динамическим блоком
  void _setupPhysicsWorld() {
    _b2World = b2.World(_v2(0, _kGravity));
    _prevDynamicBody = null;

    const double kThickness = 20.0;
    // Размеры хитбокса обычного блока (для лежащих в стеке)
    final partHbw = _partW * _kPartHbWFrac / 2;
    final partHbh = _partHbH / 2;
    // Размеры хитбокса текущего падающего блока (может быть крышей)
    final fallHbw = _curHbW / 2;
    final fallHbh = _curHbH / 2;

    // Базовая платформа — всегда статическая
    {
      final left = _xFromCenter(_kHitboxXFrac);
      final top = _yFromCenter(_kHitboxYFrac) + _stackOff;
      final right = left + _refW * _kHitboxWFrac;
      final cx = (left + right) / 2;
      final hw = (right - left) / 2;
      final bd = b2.BodyDef()
        ..type = b2.BodyType.static
        ..position = _v2(cx, top + kThickness / 2);
      final shape = b2.PolygonShape()
        ..setAsBoxXY(hw / _kB2Scale, kThickness / 2 / _kB2Scale);
      _b2World!
          .createBody(bd)
          .createFixture(b2.FixtureDef(shape)..friction = 0.5);
    }

    // Упавшие блоки: все кроме последнего — статические, последний — динамический
    for (int i = 0; i < _landedBlocks.length; i++) {
      final blk = _landedBlocks[i];
      final cx = blk.$1;
      final cy = blk.$2 + _stackOff;
      final angle = blk.$3;
      // Лежащие блоки всегда используют part-размеры, даже если будущий — крыша
      final bhw = partHbw;
      final bhh = partHbh;

      if (i == _landedBlocks.length - 1) {
        // Последний блок — динамический, реагирует на падение нового
        final bd = b2.BodyDef()
          ..type = b2.BodyType.dynamic
          ..position = _v2(cx, cy)
          ..angle = angle
          ..linearVelocity = b2.Vector2.zero()
          ..angularVelocity = 0.0;
        final shape = b2.PolygonShape()
          ..setAsBoxXY(bhw / _kB2Scale, bhh / _kB2Scale);
        final fd = b2.FixtureDef(shape)
          ..density = 2.0
          ..restitution = 0.05
          ..friction = 0.8;
        _prevDynamicBody = _b2World!.createBody(bd)..createFixture(fd);
      } else {
        // Старые блоки — статические
        final bd = b2.BodyDef()
          ..type = b2.BodyType.static
          ..position = _v2(cx, cy + kThickness / 2 - bhh);
        final shape = b2.PolygonShape()
          ..setAsBoxXY(bhw / _kB2Scale, kThickness / 2 / _kB2Scale);
        _b2World!
            .createBody(bd)
            .createFixture(b2.FixtureDef(shape)..friction = 0.5);
      }
    }

    // Падающий блок — динамический (использует свои размеры: part или крыша)
    final bd = b2.BodyDef()
      ..type = b2.BodyType.dynamic
      ..position = _v2(_fallX, _fallY)
      ..angle = _fallAngle
      ..linearVelocity = _v2(_fallVx, _fallVy)
      ..angularVelocity = _fallSpin
      ..linearDamping = 0.0
      ..angularDamping = _kAirSpinDamp;
    final shape = b2.PolygonShape()
      ..setAsBoxXY(fallHbw / _kB2Scale, fallHbh / _kB2Scale);
    final fd = b2.FixtureDef(shape)
      ..density = 1.0
      ..restitution = _kBounceDamp
      ..friction = _kFriction;
    _fallingBody = _b2World!.createBody(bd)..createFixture(fd);
  }

  void _tickPhysicsOnly(double dt) {
    final world = _b2World;
    if (world == null) return;
    world.stepDt(dt);
    if (_prevDynamicBody != null && _landedBlocks.isNotEmpty) {
      final pos = _prevDynamicBody!.position;
      final last = _landedBlocks.last;
      _landedBlocks[_landedBlocks.length - 1] = (
        pos.x * _kB2Scale,
        pos.y * _kB2Scale - _stackOff,
        _prevDynamicBody!.angle,
        last.$4,
      );
    }
  }

  void _tickFalling(double dt) {
    final world = _b2World;
    final body = _fallingBody;
    if (world == null || body == null) return;

    world.stepDt(dt);

    // Отслеживаем пик скорости и срабатываем при резком падении
    if (!_shakeTriggered) {
      final speed = body.linearVelocity.length;
      if (speed > _peakSpeed) {
        _peakSpeed = speed;
      } else if (_peakSpeed > 1.5 && speed < _peakSpeed * 0.55) {
        _shakeTriggered = true;
        _shakeAmt = 1.0;
        // момент удара блока — тот же, что у звука удара и тряски экрана
        flagGameVibrate(
          context,
          'Cambodia',
          'block hit',
          ms: kCambodiaHitVibrationMs,
        );
        Future.microtask(() {
          if (!mounted) return;
          context.read<IAudioCubit>().playSfx(_pendingHitSfx);
        });
      }
    }

    // Обновляем позицию последнего упавшего блока (он динамический)
    if (_prevDynamicBody != null && _landedBlocks.isNotEmpty) {
      final pos = _prevDynamicBody!.position;
      final last = _landedBlocks.last;
      _landedBlocks[_landedBlocks.length - 1] = (
        pos.x * _kB2Scale,
        pos.y * _kB2Scale - _stackOff,
        _prevDynamicBody!.angle,
        last.$4,
      );
    }

    _fallX = body.position.x * _kB2Scale;
    _fallY = body.position.y * _kB2Scale;
    _fallAngle = body.angle;
    _fallVx = body.linearVelocity.x * _kB2Scale;
    _fallVy = body.linearVelocity.y * _kB2Scale;
    _fallSpin = body.angularVelocity;

    // Определяем момент покоя
    if (!_fallLanded) {
      final speed = body.linearVelocity.length * _kB2Scale;
      if (speed < 20 && _fallSpin.abs() < 0.3) {
        _fallVy = 0;
        _fallVx = 0;
        _fallLanded = true;
      }
    }

    if (_fallLanded) {
      body.linearVelocity = b2.Vector2.zero();
      body.angularVelocity = 0.0;

      if (!_isSupported()) {
        _fallLanded = false;
        final hw = _curHbW / 2;
        bool overRight = false, overLeft = false;
        for (final surf in _surfaces) {
          if (_fallX + hw > surf.$1 && _fallX - hw < surf.$3) {
            if (_fallX > surf.$3) overRight = true;
            if (_fallX < surf.$1) overLeft = true;
          }
        }
        body.angularVelocity = overRight ? 1.5 : (overLeft ? -1.5 : 0.0);
        _fallSpin = body.angularVelocity;
      }
    }
  }

  // Проверяет, находится ли центр масс блока над хотя бы одной опорной поверхностью
  bool _isSupported() {
    final hw = _curHbW / 2;
    for (final surf in _surfaces) {
      final blockLeft = _fallX - hw;
      final blockRight = _fallX + hw;
      final overlapLeft = blockLeft < surf.$3;
      final overlapRight = blockRight > surf.$1;
      if (!overlapLeft || !overlapRight) continue;
      final supportLeft = surf.$1;
      final supportRight = surf.$3;
      if (_fallX >= supportLeft && _fallX <= supportRight) return true;
    }
    return false;
  }

  // Все поверхности для коллизии: (left, top, right)
  List<(double, double, double)> get _surfaces {
    final bhw = _curHbW / 2;
    final bhh = _curHbH / 2;
    final list = <(double, double, double)>[
      (
        _xFromCenter(_kHitboxXFrac),
        _yFromCenter(_kHitboxYFrac) + _stackOff,
        _xFromCenter(_kHitboxXFrac) + _refW * _kHitboxWFrac,
      ),
    ];
    for (final b in _landedBlocks) {
      list.add((b.$1 - bhw, b.$2 + _stackOff - bhh, b.$1 + bhw));
    }
    return list;
  }

  void _advance() {
    _phaseT = 0.0;
    switch (_phase) {
      case _Phase.stripeUp:
        _phase = _Phase.craneDown1;
      case _Phase.craneDown1:
        _phase = _Phase.grab;
      case _Phase.grab:
        _partIndex = _rng.nextInt(3) + 1;
        _phase = _Phase.buildingUp;
        context.read<IAudioCubit>().playSfx(GameSfx.chainGear);
      case _Phase.buildingUp:
        _curSwingAmp = _kSwingAmp + _rng.nextDouble() * 0.12; // 0.25..0.37
        _curSwingPeriod = 2.4 + _rng.nextDouble() * 0.8; // 2.4..3.2
        _phase = _Phase.craneDown2;
        _chain2WarmupTimer = 0.0;
        Future.microtask(() {
          if (!mounted) return;
          context.read<IAudioCubit>().playSfx(GameSfx.chain1);
        });
      case _Phase.craneDown2:
        if (_landedBlocks.length >= _kWindAfter &&
            _rng.nextDouble() < _kWindChance) {
          _windActive = true;
          _startWindSound();
          _windDir = _rng.nextBool() ? 1.0 : -1.0;
          _windTimer = 0.0;
          _windLineOff = 0.0;
          // Сохраняем текущий угол и пересчитываем _swingT под новую амплитуду,
          // чтобы маятник не дёрнулся при смене амплитуды.
          final curAngle =
              _curSwingAmp * sin(2 * pi * _swingT / _curSwingPeriod);
          _curSwingAmp = _kSwingAmpWind;
          // asin возвращает значение в [-π/2, π/2], что соответствует первой полуволне.
          // Знак скорости определяет направление — берём ближайшую точку на синусоиде.
          final ratio = (curAngle / _curSwingAmp).clamp(-1.0, 1.0);
          final curSpeed =
              _curSwingAmp *
              (2 * pi / _curSwingPeriod) *
              cos(2 * pi * _swingT / _curSwingPeriod);
          final t0 = asin(ratio) / (2 * pi) * _curSwingPeriod;
          // Если скорость имеет противоположный знак cos(t0), берём симметричную точку
          final t0cos = cos(2 * pi * t0 / _curSwingPeriod);
          if (curSpeed * t0cos < 0) {
            _swingT = _curSwingPeriod / 2 - t0;
          } else {
            _swingT = t0;
          }
          _phase = _Phase.wind;
        } else {
          _windActive = false;
          _phase = _Phase.pendulum;
        }
      default:
        break;
    }
  }

  void _detachPart() {
    _peakSpeed = 0.0;
    // Предзагружаем один из звуков удара чтобы не было задержки при воспроизведении
    _pendingHitSfx = [
      GameSfx.fallHit1,
      GameSfx.fallHit2,
      GameSfx.fallHit3,
    ][_rng.nextInt(3)];
    Future.microtask(() {
      if (!mounted) return;
      context.read<IAudioCubit>().playSfx(GameSfx.chain2);
    });

    final a = _curSwingAmp * sin(2 * pi * _swingT / _curSwingPeriod);
    final da =
        _curSwingAmp *
        (2 * pi / _curSwingPeriod) *
        cos(2 * pi * _swingT / _curSwingPeriod);
    // Берём точную позицию центра хитбокса из последнего тика
    _fallX = _partScreenX;
    _fallY = _partScreenY;

    // Скорость = d/dt позиции центра хитбокса
    final ca = cos(a), sa = sin(a);
    final dx = _curSpriteW * _curHbDxFrac;
    final dy = _ropeLen + _kPartOffsetY + _refH * _curHbDyFrac + _curHbH / 2;
    _fallVx = -(dx * sa + dy * ca) * da;
    _fallVy = (dx * ca - dy * sa) * da;

    _fallAngle = a;
    _fallSpin = da;
    _fallLanded = false;

    _retractAngle = a;
    _retractT = 0.0;
    _craneRetracting = true;

    _phase = _Phase.falling;
    _settleTimer = 0.0;
    _shakeTriggered = false;
    _setupPhysicsWorld();
  }

  void _triggerCoinDrop(Offset junctionPos) {
    if (_coinAnimPlaying) return;
    _coinAnimPlaying = true;
    final amount = _kCoinMin + _rng.nextInt(_kCoinMax - _kCoinMin + 1);
    context.read<IAudioCubit>().playSfx(GameSfx.moneyShort);
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
      await layer.addMoneys(
        () => FlagGameViewport.toScreen(context, junctionPos),
        amount.clamp(1, 50),
      );
      await Future.delayed(const Duration(milliseconds: 600));
      await layer.hide();
      if (mounted) setState(() => _coinAnimPlaying = false);
    });
  }

  void _computeZoom() {
    if (_landedBlocks.isEmpty) return;
    // Верхний край самого высокого блока
    double topY = double.infinity;
    for (final b in _landedBlocks) {
      final isRoofBlock = b.$4 == 0;
      final hbH = isRoofBlock ? _buildingW * _kRoofHbHFrac : _partHbH;
      final screenY = b.$2 + _stackOff - hbH / 2;
      if (screenY < topY) topY = screenY;
    }
    // Нижний край платформы основания
    final bottomY =
        _yFromCenter(_kHitboxYFrac) + _kHitboxHFrac * _refH + _stackOff;
    final contentH = bottomY - topY;
    _zoomScale = (_h * (1.0 - 2 * _kZoomPad)) / contentH;
    _zoomCenterY = (topY + bottomY) / 2;
    _zoomT = 0.0;
  }

  // ── Музыка: cambodia_music1 один раз, затем cambodia_music2 по кругу ──────
  AudioPlayer? _music1;
  AudioPlayer? _music2;
  StreamSubscription<void>? _music1Done;
  Future<void>? _musicInit;

  Future<void> _initMusic() async {
    final mix = AudioContextConfig(
      focus: AudioContextConfigFocus.mixWithOthers,
    ).build();
    Future<AudioPlayer> create(String file, ReleaseMode mode) async {
      final p = AudioPlayer()..audioCache = FlameAudio.audioCache;
      await p.setAudioContext(mix);
      await p.setPlayerMode(PlayerMode.mediaPlayer);
      await p.setReleaseMode(mode);
      await p.setVolume(_kMusicVolume);
      await p.setSource(AssetSource(file));
      return p;
    }

    // stop, а не release: трек остаётся загруженным для повторного запуска
    final m1 = await create(GameMusics.cambodia1.file, ReleaseMode.stop);
    final m2 = await create(GameMusics.cambodia2.file, ReleaseMode.loop);
    if (!mounted) {
      m1.dispose();
      m2.dispose();
      return;
    }
    _music1 = m1;
    _music2 = m2;
    _music1Done = m1.onPlayerComplete.listen((_) {
      if (mounted) _music2?.resume();
    });
  }

  // конец игры (вспышка): музыка замолкает до рестарта
  void _stopMusic() {
    _music1?.stop().catchError((Object _) {});
    _music2?.stop().catchError((Object _) {});
  }

  // старт и рестарт: сначала первый трек с начала, второй — после него
  Future<void> _startMusic() async {
    if (context.read<IAudioCubit>().state.muted) return;
    try {
      await (_musicInit ??= _initMusic());
      if (!mounted) return;
      await _music2?.stop();
      await _music1?.stop(); // в режиме stop — возврат в начало трека
      await _music1?.resume();
    } catch (e) {
      debugPrint('Cambodia music error: $e');
    }
  }

  void _onTap() {
    if (_gameComplete) {
      if (_zoomT >= 1.0) {
        _startMusic();
        setState(() {
          _gameComplete = false;
          _zoomT = 0.0;
          _zoomScale = 1.0;
          _zoomCenterY = 0.0;
          _isRoof = false;
          _isRoofNext = false;
          _landedBlocks.clear();
          _stackOff = 0.0;
          _animOff = 0.0;
          _slideStep = 0.0;
          _slideT = 0.0;
          _fallLanded = false;
          _settleTimer = 0.0;
          _fallX = 0;
          _fallY = 0;
          _fallVx = 0;
          _fallVy = 0;
          _fallAngle = 0;
          _fallSpin = 0;
          _shakeAmt = 0.0;
          _bgDarkenT = 0.0;
          _flashT = 0.0;
          _coinAnimPlaying = false;
          _shakeTriggered = false;
          _prevDynamicBody = null;
          _fallingBody = null;
          _b2World = null;
          _craneRetracting = false;
          _retractT = 0.0;
          _windActive = false;
          _stopWindSound();
          _windTimer = 0.0;
          _windOpacity = 0.0;
          _partIndex = 1;
          _phaseT = 0.0;
          _swingT = 0.0;
          _phase = _Phase.stripeUp;
        });
      }
      return;
    }
    if (_phase == _Phase.idle) {
      _startMusic();
      setState(() {
        _phase = _Phase.stripeUp;
        _phaseT = 0.0;
      });
    } else if (_phase == _Phase.pendulum || _phase == _Phase.wind) {
      setState(_detachPart);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _w = size.width;
    _h = size.height;

    final stripeH = _h * _kStripeHeightFrac;
    final hook = _hook;

    double stripe1Top = _h * _kStripe1YFrac;
    if (_phase == _Phase.stripeUp) {
      final ease = _phaseT * _phaseT * (3 - 2 * _phaseT);
      stripe1Top = -stripeH * ease;
    } else if (_phase.index > _Phase.stripeUp.index) {
      stripe1Top = -stripeH;
    }

    final showBuilding =
        !_gameComplete && _phase.index <= _Phase.buildingUp.index;
    final buildingTop = (_phase == _Phase.buildingUp || _phase == _Phase.grab)
        ? hook.dy
        : _buildingTopY;

    final showCrane =
        _phase.index > _Phase.stripeUp.index &&
        (_phase != _Phase.falling || _craneRetracting);
    final showPart =
        _phase == _Phase.craneDown2 ||
        _phase == _Phase.wind ||
        _phase == _Phase.pendulum ||
        _phase == _Phase.slideDown;

    // Матрица зума: масштабируем вокруг центра здания, сдвигая его к центру экрана
    Matrix4 zoomMatrix = Matrix4.identity();
    if (_gameComplete && _zoomT > 0) {
      final s = 1.0 + (_zoomScale - 1.0) * (_zoomT * _zoomT * (3 - 2 * _zoomT));
      final tx = (_w / 2) * (1 - s);
      final ty = _h / 2 - s * _zoomCenterY;
      zoomMatrix = Matrix4.identity()
        ..translate(tx, ty)
        ..scale(s, s);
    }

    // Цвет фона в зависимости от числа блоков
    final currentBgColor = Color.lerp(_kBgColor, Colors.black, _bgDarkenT)!;

    // Смещение тряски экрана
    final shakeX = _shakeAmt > 0
        ? (_rng.nextDouble() * 2 - 1) * _kShakeMax * _shakeAmt
        : 0.0;
    final shakeY = _shakeAmt > 0
        ? (_rng.nextDouble() * 2 - 1) * _kShakeMax * _shakeAmt
        : 0.0;

    return GestureDetector(
      onTapUp: (_) => _onTap(),
      child: Scaffold(
        backgroundColor: currentBgColor,
        body: Transform.translate(
          offset: Offset(shakeX, shakeY),
          child: Stack(
            children: [
              // ── Фон (затемняется с блоками; градиент при финальном зуме) ──────
              Positioned.fill(
                child: _gameComplete && _zoomT > 0
                    ? DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [_kBgColor, currentBgColor],
                          ),
                        ),
                      )
                    : ColoredBox(color: currentBgColor),
              ),

              // ── Нижняя полоска (за зданием, во всю ширину) ───────────────────
              () {
                final naturalTop = _h * _kStripe2YFrac + _totalOffset;
                final targetTop = _h - stripeH;
                final t = _zoomT * _zoomT * (3 - 2 * _zoomT);
                final top = _gameComplete
                    ? naturalTop + (targetTop - naturalTop) * t
                    : naturalTop;
                return Positioned(
                  left: 0,
                  right: 0,
                  top: top,
                  height: stripeH,
                  child: const ColoredBox(color: _kStripeColor),
                );
              }(),

              Transform(
                transform: zoomMatrix,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // ── Верхняя полоска ──────────────────────────────────────────────
                    if (!_gameComplete)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: stripe1Top,
                        height: stripeH,
                        child: const ColoredBox(color: _kStripeColor),
                      ),

                    // ── Нижняя часть здания (статичная, твёрдая поверхность) ─────────
                    Positioned(
                      left: (_w - _buildingBotW) / 2,
                      top: _yFromCenter(_kBuildingBotYFrac) + _totalOffset,
                      width: _buildingBotW,
                      child: Image.asset(
                        '${_p}cambodia_building_bottom.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    // ── Хитбокс building_bottom ──────────────────────────────────────
                    if (_kShowHitbox)
                      Positioned(
                        left: _xFromCenter(_kHitboxXFrac),
                        top: _yFromCenter(_kHitboxYFrac) + _totalOffset,
                        width: _refW * _kHitboxWFrac,
                        height: _kHitboxHFrac * _refH,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF00FF00),
                              width: 2,
                            ),
                            color: const Color(0x3300FF00),
                          ),
                        ),
                      ),

                    // ── Цепь крана + висящая часть ───────────────────────────────────
                    if (showCrane)
                      if (_isSwingPhase || _craneRetracting)
                        Positioned(
                          left: _w / 2 - _craneW / 2,
                          top: -_kPivotAbove + _kHookOverlap,
                          width: _craneW,
                          height: _ropeLen,
                          child: Transform.rotate(
                            angle: _pendulumAngle,
                            alignment: Alignment.topCenter,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: _craneW,
                                  height: _craneLen,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: const AssetImage(
                                        '${_p}cambodia_crane.png',
                                      ),
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.bottomCenter,
                                      repeat: ImageRepeat.repeatY,
                                    ),
                                  ),
                                ),
                                if (showPart)
                                  Positioned(
                                    left: -(_curSpriteW - _craneW) / 2,
                                    top: _craneLen + _kPartOffsetY,
                                    width: _curSpriteW,
                                    child: Image.asset(
                                      _curAsset,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      else
                        Positioned(
                          left: _w / 2 - _craneW / 2,
                          top: hook.dy - _ropeLen + _kHookOverlap,
                          width: _craneW,
                          height: _ropeLen,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: _craneW,
                                height: _ropeLen,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage(
                                      '${_p}cambodia_crane.png',
                                    ),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.bottomCenter,
                                    repeat: ImageRepeat.repeatY,
                                  ),
                                ),
                              ),
                              if (showPart)
                                Positioned(
                                  left: -(_curSpriteW - _craneW) / 2,
                                  top: _ropeLen + _kPartOffsetY,
                                  width: _curSpriteW,
                                  child: Image.asset(
                                    _curAsset,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                            ],
                          ),
                        ),

                    // ── Ранее упавшие блоки ──────────────────────────────────────────
                    for (final b in _landedBlocks) ...[
                      () {
                        final isRoofBlock = b.$4 == 0;
                        final sw = isRoofBlock ? _buildingW : _partW;
                        final hbW = isRoofBlock
                            ? _buildingW * _kRoofHbWFrac
                            : _partW * _kPartHbWFrac;
                        final hbH = isRoofBlock
                            ? _buildingW * _kRoofHbHFrac
                            : _partHbH;
                        final dxF = isRoofBlock
                            ? _kRoofHbDxFrac
                            : _kPartHbDxFrac;
                        final dyF = isRoofBlock
                            ? _kRoofHbDyFrac
                            : _kPartHbDyFrac;
                        final asset = isRoofBlock
                            ? '${_p}cambodia_building.png'
                            : '${_p}cambodia_building_part${b.$4 == 1 ? '' : b.$4}.png';
                        return Positioned(
                          left: b.$1 - sw * (0.5 + dxF),
                          top: b.$2 - (_refH * dyF + hbH / 2) + _totalOffset,
                          width: sw,
                          child: Transform(
                            transform: Matrix4.rotationZ(b.$3),
                            origin: Offset(
                              sw * (0.5 + dxF),
                              _refH * dyF + hbH / 2,
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Image.asset(
                                  asset,
                                  width: sw,
                                  fit: BoxFit.contain,
                                ),
                                if (isRoofBlock && _kShowRoofHitbox)
                                  Positioned(
                                    left:
                                        sw * (1 - _kRoofHbWFrac) / 2 +
                                        sw * _kRoofHbDxFrac,
                                    top: _refH * _kRoofHbDyFrac,
                                    width: hbW,
                                    height: hbH,
                                    child: const DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: Border.fromBorderSide(
                                          BorderSide(
                                            color: Color(0xFFFF8800),
                                            width: 2,
                                          ),
                                        ),
                                        color: Color(0x33FF8800),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }(),
                    ],

                    // ── Падающая часть здания (с хитбоксом внутри rotate) ───────────
                    if (_phase == _Phase.falling)
                      Positioned(
                        left: _fallX - _curSpriteW * (0.5 + _curHbDxFrac),
                        top:
                            _fallY -
                            (_refH * _curHbDyFrac + _curHbH / 2) +
                            _animOff,
                        width: _curSpriteW,
                        child: Transform(
                          transform: Matrix4.rotationZ(_fallAngle),
                          origin: Offset(
                            _curSpriteW * (0.5 + _curHbDxFrac),
                            (_refH * _curHbDyFrac + _curHbH / 2),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Image.asset(
                                _curAsset,
                                width: _curSpriteW,
                                fit: BoxFit.contain,
                              ),
                              if (!_isRoof && _kShowPartHitbox)
                                Positioned(
                                  left:
                                      _curSpriteW * (1 - _kPartHbWFrac) / 2 +
                                      _curSpriteW * _kPartHbDxFrac,
                                  top: _refH * _kPartHbDyFrac,
                                  width: _curHbW,
                                  height: _curHbH,
                                  child: const DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                          color: Color(0xFF0000FF),
                                          width: 2,
                                        ),
                                      ),
                                      color: Color(0x330000FF),
                                    ),
                                  ),
                                ),
                              if (_isRoof && _kShowRoofHitbox)
                                Positioned(
                                  left:
                                      _curSpriteW * (1 - _kRoofHbWFrac) / 2 +
                                      _curSpriteW * _kRoofHbDxFrac,
                                  top: _refH * _kRoofHbDyFrac,
                                  width: _curHbW,
                                  height: _curHbH,
                                  child: const DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                          color: Color(0xFFFF8800),
                                          width: 2,
                                        ),
                                      ),
                                      color: Color(0x33FF8800),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                    // ── Основное здание (поверх цепи) ────────────────────────────────
                    if (showBuilding)
                      Positioned(
                        left: (_w - _buildingW) / 2,
                        top: buildingTop,
                        width: _buildingW,
                        child: Image.asset(
                          '${_p}cambodia_building.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                    // ── Wind effect ──────────────────────────────────────────────────
                    if (_windOpacity > 0)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _WindPainter(
                            offset: _windLineOff,
                            dir: _windDir,
                            opacity: _windOpacity,
                          ),
                        ),
                      ),
                  ],
                ),
              ), // Transform
              // ── Счётчик блоков + рекорд ──────────────────────────────────────
              Positioned(
                top: 8,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_bestScore > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/winner_cup.png',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$_bestScore',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(color: Colors.black54, blurRadius: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (_phase != _Phase.idle || _gameComplete)
                      Text(
                        '${_landedBlocks.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.black54, blurRadius: 6),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // ── Back button (не масштабируется) ──────────────────────────────
              // «Tap to start» — один раз, на первом открытом флаге
              Positioned.fill(
                child: FlagGameTapHint(
                  visible:
                      _phase == _Phase.idle &&
                      !_gameComplete &&
                      _landedBlocks.isEmpty,
                ),
              ),
              const Positioned(top: 8, left: 8, child: FBackButton()),

              // ── Вспышка (фото-эффект перед зумом) ────────────────────────────
              if (_flashT > 0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: ColoredBox(
                      color: Colors.white.withValues(alpha: _flashT),
                    ),
                  ),
                ),
            ],
          ), // Stack
        ), // Transform.translate (shake)
      ),
    );
  }
}

class _WindPainter extends CustomPainter {
  final double offset; // 0..1, циклическое смещение
  final double dir; // +1 вправо, -1 влево
  final double opacity; // 0..1, плавное появление/исчезание

  const _WindPainter({
    required this.offset,
    required this.dir,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    const int groups = 10;
    const double groupSpacing = 1.0 / groups;

    for (int i = 0; i < groups; i++) {
      final base = ((i * groupSpacing + offset) % 1.0);
      final x = base * size.width * 1.4 - size.width * 0.2;

      // Основная линия
      paint.color = Color.fromARGB((0x33 * opacity).round(), 0xFF, 0xFF, 0xFF);
      final y1 = size.height * (0.1 + (i % 5) * 0.18);
      canvas.drawLine(Offset(x, y1), Offset(x + dir * 90, y1 + 8), paint);

      // Короткая линия рядом
      paint.color = Color.fromARGB((0x22 * opacity).round(), 0xFF, 0xFF, 0xFF);
      final y2 = y1 + 30;
      canvas.drawLine(
        Offset(x + dir * 20, y2),
        Offset(x + dir * 65, y2 + 5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WindPainter old) =>
      old.offset != offset || old.dir != dir || old.opacity != opacity;
}
