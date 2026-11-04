import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flags/features/flag_games/flag_game_viewport.dart';
import 'package:flags/features/flag_games/flag_game_background_pause.dart';
import 'package:flags/features/flag_games/flag_game_tap_hint.dart';
import 'package:flags/features/flag_games/flag_game_ads.dart';
import 'package:flags/features/flag_games/flag_game_vibration.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/uikit/components/buttons/actions/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Road ─────────────────────────────────────────────────────────────────────
const double _kRoadWidth = 150.0; // px (perp to road dir)
const double _kRoadScaleL = 1.0; // length multiplier (1 = full diagonal)
const double _kRoadOffsetAlong = 0.0; // shift along road direction (px)
const double _kRoadOffsetLat = 0.0; // shift perpendicular to road (px)
const double _kRoadExtraAngle = 0.0; // extra rotation on top of diagonal (rad)
const int _kLaneCount = 3;
const double _kLaneWidth = _kRoadWidth / _kLaneCount;

// ── Player car ────────────────────────────────────────────────────────────────
const bool _kShowHitbox = false; // TODO: false before release
// Hitbox insets (px, positive = shrink from that edge of the sprite)
const double _kHitInsetLeft = 4.0;
const double _kHitInsetRight = 4.0;
const double _kHitInsetTop = 0.0;
const double _kHitInsetBottom = 0.0;
const double _kCarW = 36.0; // perpendicular to road (sprite width)
const double _kCarL = 62.0; // along road
const double _kSpeedNormal = 300.0; // px/s along road
const double _kSpeedBrake = 140.0;
const double _kSpeedAccelRate = 120.0; // px/s² (re-acceleration after brake)
const double _kSpeedBrakeRate = 180.0; // px/s² (braking deceleration)
const double _kSteerSpeed = 170.0; // px/s lateral
const double _kMaxWheelAngle = pi / 3; // ±60°
// Visual car tilt while steering
const double _kCarSteerFactor = 0.30; // car rotation = wheelAngle * factor
const double _kCarSteerLerp = 8.0; // lerp speed (higher = snappier)
// Rear axle pivot: 0.5 = 75% from top in Alignment coords
const double _kRearAxlePivotY = 0.5;
// Brake visual shift: car moves backward along road when braking
const double _kBrakeShiftMax = 18.0; // px along road
const double _kBrakeShiftLerp = 1.5; // lerp speed
const double _kBrakeMaxHold = 0.7; // seconds before brake auto-releases
const double _kBrakeRecharge =
    2.5; // extra wait after speed recovery before brake is ready

// ── Steering wheel UI ─────────────────────────────────────────────────────────
const double _kWheelSize = 300.0; // diameter of the wheel image (px)
const double _kWheelOffsetX =
    -20.0; // horizontal offset from panel center (px, + = right)
const double _kWheelOffsetY =
    200.0; // vertical offset from screen center  (px, + = down)

// ── Brake button UI ───────────────────────────────────────────────────────────
const double _kBrakeSize = 160.0; // size of the brake image (px)
const double _kBrakeRight = 70.0; // distance from right edge (px)
const double _kBrakeBottom = 24.0; // distance from bottom edge (px)

// ── Decorative shapes ─────────────────────────────────────────────────────────

// Yellow stripe 1 (left border of road, lateral offset from road center)
const double _kStripe1Lat = -90.0; // lateral offset (negative = left)
const double _kStripe1W = 30.0; // width perp to road
const double _kStripe1ScaleL = 1.0; // length multiplier (1 = full road length)
const double _kStripe1Angle = 0.0; // extra rotation (rad, 0 = parallel to road)

// Yellow stripe 2 (right border of road)
const double _kStripe2Lat = 90.0;
const double _kStripe2W = 30.0;
const double _kStripe2ScaleL = 1.0;
const double _kStripe2Angle = 0.0;

// ── Traffic ───────────────────────────────────────────────────────────────────
const double _kTrafficW = 36.0; // default car width
const double _kTrafficL = 62.0; // default car length
const double _kBusW = 42.0;
const double _kBusL = 110.0;
const double _kTrafficSpeed = 180.0;
const double _kSpawnInterval = 2.2;
const double _kLaneChangeDuration =
    1.8; // seconds to complete one lane change (ease-in-out)
const double _kLaneChangeChance = 0.20; // probability per decision
const double _kLaneChangeMinWait = 3.0; // min seconds between decisions (base)
const double _kLaneChangeMaxWait = 7.0; // max seconds between decisions (base)
const double _kLaneChangeWaitDecr =
    0.3; // seconds removed per difficulty step (levels 1+)
const double _kLaneChangeWaitDecr2 =
    0.5; // stronger decrement from level 2 (1000m+)
const double _kLaneChangeMinWaitCap = 0.8; // hard minimum
const double _kLaneChangeSafeGap =
    220.0; // min road-progress gap to player before lane change

// ── Trees ─────────────────────────────────────────────────────────────────────
const double _kTreeLat = -130.0;
const double _kTreeSize = 72.0;
const double _kTreeMinGap = 80.0;
const double _kTreeMaxGap = 220.0;
const int _kTreePoolSize = 30;

// ── Boats ─────────────────────────────────────────────────────────────────────
const double _kBoatLat = 180.0; // base lateral offset (right of road center)
const double _kBoatLatJitter = 40.0; // max random lateral shift (± px)
const double _kBoatSize = 100.0; // rendered size (px)
const double _kBoatAngle = 45.1; // rotation (rad)
const double _kBoatMinGap = 800.0; // min distance between boats
const double _kBoatMaxGap = 1800.0; // max distance between boats
const int _kBoatPoolSize = 8;

// ── Intro animation ───────────────────────────────────────────────────────────
const double _kIntroDuration = 1.6; // seconds for car to drive in
const double _kControlsSlideDuration = 0.5; // seconds for controls to slide up

// ── Crash animation ───────────────────────────────────────────────────────────
const double _kCrashDuration = 1.4; // seconds total spin
const double _kCrashMaxSpin = 18.0; // rad/s initial angular velocity

// ── Difficulty progression (every 500 m) ──────────────────────────────────────
const double _kProgressStep = 500.0; // metres between difficulty steps
const double _kSpeedIncrement = 15.0; // px/s added to max speed per step
const double _kSpawnDecrement =
    0.35; // seconds removed from spawn interval per step
const double _kSpeedMax = 600.0; // px/s hard cap
const double _kSpawnIntervalMin = 0.5; // seconds hard cap

class _TrafficType {
  final String sprite;
  final double width;
  final double length;
  final int weight;
  // Hitbox insets (px trimmed from sprite edges)
  final double hitL;
  final double hitR;
  final double hitT;
  final double hitB;
  const _TrafficType(
    this.sprite,
    this.width,
    this.length,
    this.weight, {
    this.hitL = 4.0,
    this.hitR = 4.0,
    this.hitT = 4.0,
    this.hitB = 4.0,
  });
}

const _p = 'assets/images/flag_games/tanzania/';
final List<_TrafficType> _kTrafficTypes = [
  _TrafficType(
    '${_p}car_traffic_cx5_gray.png',
    _kTrafficW,
    _kTrafficL,
    2,
    hitL: 2,
    hitR: 2,
    hitT: 0,
    hitB: 0,
  ),
  _TrafficType(
    '${_p}car_traffic_cx5_red.png',
    _kTrafficW,
    _kTrafficL,
    2,
    hitL: 2,
    hitR: 2,
    hitT: 0,
    hitB: 0,
  ),
  _TrafficType(
    '${_p}car_traffic_cx5_white.png',
    _kTrafficW,
    _kTrafficL,
    2,
    hitL: 2,
    hitR: 2,
    hitT: 0,
    hitB: 0,
  ),
  _TrafficType(
    '${_p}car_traffic_hilux_gray.png',
    _kTrafficW,
    _kTrafficL,
    2,
    hitL: 2,
    hitR: 2,
    hitT: 0,
    hitB: 0,
  ),
  _TrafficType(
    '${_p}car_traffic_hilux_green.png',
    _kTrafficW,
    _kTrafficL,
    2,
    hitL: 2,
    hitR: 2,
    hitT: 0,
    hitB: 0,
  ),
  _TrafficType(
    '${_p}car_traffic_hilux_white.png',
    _kTrafficW,
    _kTrafficL,
    2,
    hitL: 2,
    hitR: 2,
    hitT: 0,
    hitB: 0,
  ),
  _TrafficType(
    '${_p}car_traffic_ist.png',
    _kTrafficW,
    _kTrafficL,
    2,
    hitL: 2,
    hitR: 2,
    hitT: 0,
    hitB: 0,
  ),
  _TrafficType(
    '${_p}car_traffic_ist_yellow.png',
    _kTrafficW,
    _kTrafficL,
    2,
    hitL: 2,
    hitR: 2,
    hitT: 0,
    hitB: 0,
  ),
  _TrafficType(
    '${_p}car_traffic_noah_blue.png',
    _kTrafficW,
    _kTrafficL,
    2,
    hitL: 2,
    hitR: 2,
    hitT: 0,
    hitB: 0,
  ),
  _TrafficType(
    '${_p}car_traffic_noah_brown.png',
    _kTrafficW,
    _kTrafficL,
    2,
    hitL: 2,
    hitR: 2,
    hitT: 0,
    hitB: 0,
  ),
  _TrafficType(
    '${_p}car_traffic_noah_white.png',
    _kTrafficW,
    _kTrafficL,
    2,
    hitL: 2,
    hitR: 2,
    hitT: 0,
    hitB: 0,
  ),
  _TrafficType(
    '${_p}car_traffic_probox_beige.png',
    _kTrafficW,
    _kTrafficL,
    2,
    hitL: 2,
    hitR: 2,
    hitT: 0,
    hitB: 0,
  ),
  _TrafficType(
    '${_p}car_traffic_probox_white.png',
    _kTrafficW,
    _kTrafficL,
    2,
    hitL: 2,
    hitR: 2,
    hitT: 0,
    hitB: 0,
  ),
  _TrafficType(
    '${_p}car_traffic_bus_gray.png',
    _kBusW,
    _kBusL,
    1,
    hitL: 2,
    hitR: 2,
    hitT: 2,
    hitB: 2,
  ),
  _TrafficType(
    '${_p}car_traffic_bus_white.png',
    _kBusW,
    _kBusL,
    1,
    hitL: 2,
    hitR: 2,
    hitT: 2,
    hitB: 2,
  ),
];

@RoutePage()
class TrafficGameScreen extends StatefulWidget implements AutoRouteWrapper {
  // игра строится на «экране Pixel 10» и масштабируется под реальный экран
  @override
  Widget wrappedRoute(BuildContext context) =>
      FlagGameViewport(background: const Color(0xFF68B347), child: this);

  const TrafficGameScreen({super.key});

  @override
  State<TrafficGameScreen> createState() => _TrafficGameScreenState();
}

class _TrafficGameScreenState extends State<TrafficGameScreen> with FlagGameBackgroundPause<TrafficGameScreen> {
  AudioPlayer? _engineAccel;
  AudioPlayer? _engineLoop;
  AudioPlayer? _engineBrakePlayer;
  Duration? _brakeDuration;
  Timer? _brakeTimer;
  bool _audioPreloaded = false;
  // ── Screen/road setup ─────────────────────────────────────────────────────
  double _screenW = 0;
  double _screenH = 0;
  double _roadAngle = 0; // rad from +X axis
  Offset _roadDir =
      Offset.zero; // unit vector along road (bottom-left → top-right)
  Offset _perpDir = Offset.zero; // unit vector perp to road (right side)
  Offset _roadStart = Offset.zero; // bottom-left corner
  double _roadLength = 0;

  // Player progress along road (fixed); lateral = offset from center
  double _playerProgress = 0;
  double _lateral = 0;
  double _speed = _kSpeedNormal;
  bool _braking = false;
  double _brakeHeldTime = 0; // how long brake has been held this press
  double _brakeRechargeLeft =
      0; // cooldown after each release before next press
  double _carVisualAngle = 0; // visual tilt of car sprite
  double _brakeShift = 0; // visual shift backward along road when braking (px)

  // ── Steering wheel ────────────────────────────────────────────────────────
  double _wheelAngle = 0;
  Offset? _wheelGrabOff; // grab offset from wheel center
  double _wheelGrabAngle = 0;
  Timer? _wheelReturnTimer;

  // ── Traffic ───────────────────────────────────────────────────────────────
  final List<_TrafficCar> _traffic = [];
  final Random _rand = Random();
  double _spawnTimer = 0;

  // ── Game loop ─────────────────────────────────────────────────────────────
  Timer? _timer;
  DateTime? _lastTick;

  // ── Пауза, пока приложение свёрнуто: игровой таймер работал бы и в фоне ──
  bool _loopWasRunning = false;

  @override
  void onAppHidden() {
    _loopWasRunning = _timer?.isActive ?? false;
    _timer?.cancel();
    pausePlayingPlayers([_engineAccel, _engineLoop, _engineBrakePlayer]);
  }

  @override
  void onAppShown() {
    if (_loopWasRunning && mounted) {
      _lastTick = DateTime.now(); // без скачка времени после возврата
      _timer = Timer.periodic(const Duration(milliseconds: 16), _tick);
    }
    resumePausedPlayers();
  }
  double _roadOffset = 0;
  double _treeOffset = 0; // scroll offset, wraps at _treePeriod
  double _treePeriod = 1.0;
  List<(double, int)> _treePool = [];
  double _boatPeriod = 1.0;
  double _boatOffset =
      0; // separate scroll offset for boats, wraps at _boatPeriod
  List<(double, double)> _boatPool = [];
  double _scenerySlideFadeT = 0; // 0→1 fade-in for trees after game start
  double _distanceM = 0;
  double _recordM = 0;
  int _score = 0;

  // ── Difficulty ────────────────────────────────────────────────────────────
  int _diffLevel = 0;
  double _maxSpeed = _kSpeedNormal;
  double _spawnInterval = _kSpawnInterval;

  // ── Crash animation ───────────────────────────────────────────────────────
  bool _crashing = false;
  double _crashElapsed = 0;
  double _crashAngle = 0; // accumulated spin (rad)
  double _crashCamSpeed = 0; // camera inertia speed (decelerates to 0)
  double _crashedCarProg = 0; // road-local position of crashed car (fixed)
  double _crashedCarLat = 0;

  // ── Intro animation ───────────────────────────────────────────────────────
  bool _intro = false;
  double _introT = 0; // 0→1 progress
  double _introProgress = 0; // road-local progress of car during intro
  double _introMarkOp = 0; // lane marking opacity 0→1
  double _controlsSlideT =
      0; // 0→1 controls slide-up progress (1 = fully visible)

  static const _kRecordKey = 'traffic_game_record_m';
  bool _dead = false;
  bool _started = false;

  // ── Coin drop ─────────────────────────────────────────────────────────────
  static const double _kNearMissCoinChance = 0.05;
  static const int _kCoinMin = 10;
  static const int _kCoinMax = 50;
  bool _coinAnimPlaying = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    _screenW = size.width;
    _screenH = size.height;
    _setupRoad();
  }

  void _setupRoad() {
    // Exact corner-to-corner diagonal
    _roadAngle = atan2(_screenH, _screenW);
    _roadDir = Offset(cos(_roadAngle), -sin(_roadAngle));
    _perpDir = Offset(sin(_roadAngle), cos(_roadAngle));
    _roadStart = Offset(0, _screenH);
    _roadLength = sqrt(_screenW * _screenW + _screenH * _screenH);
    _playerProgress = _roadLength * 0.33;
  }

  // Convert road-local (progress, lateral) to screen Offset
  Offset _toScreen(double progress, double lateral) {
    return _roadStart +
        Offset(_roadDir.dx * progress, _roadDir.dy * progress) +
        Offset(_perpDir.dx * lateral, _perpDir.dy * lateral);
  }

  // ── Game control ──────────────────────────────────────────────────────────
  void _startGame() {
    if (!_audioPreloaded) {
      _audioPreloaded = true;
      FlameAudio.audioCache.loadAll([
        GameMusics.tanzania.file,
        GameSfx.carCrash.file,
        GameSfx.carBrake.file,
        GameSfx.carHorn.file,
        GameSfx.carHorn2.file,
        'sfx/car_acceleration_start.wav',
        'sfx/car_speed_loop.wav',
      ]);
    }
    _stopEngineAudio();
    _traffic.clear();
    _score = 0;
    _dead = false;
    _lateral = 0;
    _speed = _kSpeedNormal;
    _spawnTimer = 0;
    _wheelAngle = 0;
    _carVisualAngle = 0;
    _coinAnimPlaying = false;
    _roadOffset = 0;
    _treeOffset = 0;
    _boatOffset = 0;
    _scenerySlideFadeT = 0;
    // Pre-generate tree pool with random spacing and sprites
    double cumulative = 0;
    _treePool = List.generate(_kTreePoolSize, (i) {
      cumulative +=
          _kTreeMinGap + _rand.nextDouble() * (_kTreeMaxGap - _kTreeMinGap);
      return (cumulative, _rand.nextInt(3));
    });
    _treePeriod = cumulative;
    // Boats
    double boatCum = 0;
    _boatPool = List.generate(_kBoatPoolSize, (_) {
      boatCum +=
          _kBoatMinGap + _rand.nextDouble() * (_kBoatMaxGap - _kBoatMinGap);
      final jitter = (_rand.nextDouble() * 2 - 1) * _kBoatLatJitter;
      return (boatCum, jitter);
    });
    _boatPeriod = boatCum;
    _distanceM = 0;
    _diffLevel = 0;
    _maxSpeed = _kSpeedNormal;
    _spawnInterval = _kSpawnInterval;
    _playerProgress = _roadLength * 0.33;
    _brakeShift = 0;
    _brakeHeldTime = 0;
    _brakeRechargeLeft = 0;
    _crashing = false;
    _crashElapsed = 0;
    _crashAngle = 0;
    _crashCamSpeed = 0;
    _crashedCarProg = 0;
    _crashedCarLat = 0;
    _wheelReturnTimer?.cancel();
    _intro = true;
    _introT = 0;
    _introProgress = -_kCarL - 50;
    _introMarkOp = 0;
    _controlsSlideT = 0;
    _lastTick = DateTime.now();
    setState(() => _started = true);
    _timer = Timer.periodic(const Duration(milliseconds: 16), _tick);
    _startEngineAudio();
    context.read<IAudioCubit>().playBgm(GameMusics.tanzania, fromStart: true);
  }

  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

  Future<void> _loadRecord() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _recordM = prefs.getDouble(_kRecordKey) ?? 0);
  }

  Future<void> _saveRecord() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kRecordKey, _recordM);
  }

  Future<void> _initEngineAudio() async {
    _engineAccel = AudioPlayer()..audioCache = FlameAudio.audioCache;
    _engineLoop = AudioPlayer()..audioCache = FlameAudio.audioCache;
    // mixWithOthers: иначе плееры двигателя забирают аудиофокус у музыки и друг у друга
    final mix = AudioContextConfig(
      focus: AudioContextConfigFocus.mixWithOthers,
    ).build();
    await _engineAccel!.setAudioContext(mix);
    await _engineLoop!.setAudioContext(mix);
    // stop, а не release: иначе после окончания/остановки звук выгружается
    // и seek() на рестарте зависает навсегда (TimeoutException)
    await _engineAccel!.setReleaseMode(ReleaseMode.stop);
    await _engineLoop!.setPlayerMode(PlayerMode.lowLatency);
    await _engineLoop!.setReleaseMode(ReleaseMode.loop);
    final brakeHelper = AudioPlayer()..audioCache = FlameAudio.audioCache;
    await Future.wait([
      _engineAccel!.setSource(AssetSource('sfx/car_acceleration_start.wav')),
      _engineLoop!.setSource(AssetSource('sfx/car_speed_loop.wav')),
      brakeHelper.setSource(AssetSource('sfx/car_brake.wav')),
    ]);
    _brakeDuration = await brakeHelper.getDuration();
    await brakeHelper.dispose();
  }

  Future<void> _startEngineAudio() async {
    if (_engineAccel == null) await _initEngineAudio();
    final accel = _engineAccel!;
    final loop = _engineLoop!;
    await accel.seek(Duration.zero);
    await loop.stop();
    final accelDuration = await accel.getDuration();
    await accel.resume();
    if (accelDuration != null && mounted) {
      Future.delayed(accelDuration, () {
        if (mounted) loop.resume();
      });
    }
  }

  void _startBrakeAudio() {
    if (_engineLoop == null) return;
    _brakeTimer?.cancel();
    _engineBrakePlayer?.dispose();
    _engineBrakePlayer = null;
    FlameAudio.play(GameSfx.carBrake.file).then((p) {
      if (!mounted) {
        p.dispose();
        return;
      }
      _engineBrakePlayer = p;
    });
    Future.delayed(const Duration(milliseconds: 80), () {
      if (!mounted) return;
      _engineAccel?.stop();
      _engineLoop?.pause();
    });
    final dur = _brakeDuration;
    if (dur != null) {
      _brakeTimer = Timer(dur, () {
        if (mounted) _engineLoop?.resume();
      });
    }
  }

  void _stopBrakeAudio() {
    // brake plays to completion; loop resumes via timer
  }

  void _stopEngineAudio() {
    _brakeTimer?.cancel();
    _brakeTimer = null;
    _engineBrakePlayer?.dispose();
    _engineBrakePlayer = null;
    _engineAccel?.stop();
    _engineLoop?.stop();
  }

  void _disposeEngineAudio() {
    _stopEngineAudio();
    _engineAccel?.dispose();
    _engineAccel = null;
    _engineLoop?.dispose();
    _engineLoop = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wheelReturnTimer?.cancel();
    _brakeTimer?.cancel();
    _disposeEngineAudio();
    FlameAudio.audioCache.clearAll();
    super.dispose();
  }

  void _tick(Timer _) {
    if (!mounted) return;
    final now = DateTime.now();
    final dt = (now.difference(_lastTick!).inMicroseconds / 1e6).clamp(
      0.0,
      0.1,
    );
    _lastTick = now;

    // Intro animation: car drives in diagonally along the road from bottom-left
    if (_intro) {
      setState(() {
        _introT = (_introT + dt / _kIntroDuration).clamp(0.0, 1.0);
        // ease-out: fast entry, smooth stop
        final ease = 1.0 - (1.0 - _introT) * (1.0 - _introT);
        _introProgress =
            (_kCarL * -1 - 50) + (_playerProgress - (-_kCarL - 50)) * ease;
        _introMarkOp = ease;
        _roadOffset = (_roadOffset + _kSpeedNormal * dt) % 40;
        _treeOffset = (_treeOffset + _kSpeedNormal * dt) % _treePeriod;
        _boatOffset = (_boatOffset + _kSpeedNormal * dt) % _boatPeriod;
        if (_introT >= 1.0) {
          _intro = false;
          _introMarkOp = 1;
        }
      });
      return;
    }

    // Crash animation: car spins and drifts backward, traffic keeps moving
    if (_crashing) {
      setState(() {
        _crashElapsed += dt;
        final t = (_crashElapsed / _kCrashDuration).clamp(0.0, 1.0);

        // Spin: fast at start, eases out
        final spinSpeed = _kCrashMaxSpin * (1.0 - t) * (1.0 - t);
        _crashAngle += spinSpeed * dt;

        // Car drifts backward
        _crashedCarProg -= _crashCamSpeed * 0.35 * (1.0 - t) * dt;

        // Road marking decelerates from crash speed to 0
        final markSpeed = _crashCamSpeed * (1.0 - t);
        _roadOffset = (_roadOffset + markSpeed * dt) % 40;
        _treeOffset = (_treeOffset + markSpeed * dt) % _treePeriod;
        _boatOffset = (_boatOffset + markSpeed * dt) % _boatPeriod;

        // Traffic smoothly reverses; hit car stops and rotates
        for (final car in _traffic) {
          if (car.isHit) {
            car.hitAngle +=
                (car.hitAngleTarget - car.hitAngle) *
                (5.0 * dt).clamp(0.0, 1.0);
            // Push backward on impact, decelerating with crash
            car.progress -= _crashCamSpeed * 0.08 * (1.0 - t) * dt;
            continue;
          }
          final v = car.currentSpeed * (1.0 - t) - _kTrafficSpeed * t;
          car.progress -= v * dt;
        }
        _traffic.removeWhere((c) => c.progress < -(c.length + 20));

        if (t >= 1.0) {
          _crashing = false;
          _dead = true;
          _timer?.cancel();
        }
      });
      return;
    }

    setState(() {
      // Speed (smooth brake and accelerate)
      // Difficulty step-up every _kProgressStep metres
      final newLevel = (_distanceM / _kProgressStep).floor();
      if (newLevel > _diffLevel) {
        _diffLevel = newLevel;
        _maxSpeed = (_kSpeedNormal + _diffLevel * _kSpeedIncrement).clamp(
          0.0,
          _kSpeedMax,
        );
        _spawnInterval = (_kSpawnInterval - _diffLevel * _kSpawnDecrement)
            .clamp(_kSpawnIntervalMin, _kSpawnInterval);
      }

      // Auto-release brake after max hold time, then lock until speed recovers
      if (_braking) {
        _brakeHeldTime += dt;
        if (_brakeHeldTime >= _kBrakeMaxHold) {
          _braking = false;
          _brakeHeldTime = 0;
          _brakeRechargeLeft = _kBrakeRecharge;
          _stopBrakeAudio();
        }
      }
      if (_brakeRechargeLeft > 0) {
        _brakeRechargeLeft = (_brakeRechargeLeft - dt).clamp(
          0.0,
          _kBrakeRecharge,
        );
      }

      final targetSpeed = _braking ? _kSpeedBrake : _maxSpeed;
      if (_speed > targetSpeed) {
        _speed = (_speed - _kSpeedBrakeRate * dt).clamp(targetSpeed, _maxSpeed);
      } else if (_speed < targetSpeed) {
        _speed = (_speed + _kSpeedAccelRate * dt).clamp(0.0, targetSpeed);
      }

      // Brake shift: car drifts backward visually when braking, returns on accelerate
      final targetShift = _braking ? _kBrakeShiftMax : 0.0;
      _brakeShift +=
          (targetShift - _brakeShift) * (_kBrakeShiftLerp * dt).clamp(0.0, 1.0);

      // Steering → lateral drift + visual car tilt
      final steerInput = (_wheelAngle / _kMaxWheelAngle).clamp(-1.0, 1.0);
      final minLat = -_kRoadWidth / 2 + _kCarW / 2;
      final maxLat = _kRoadWidth / 2 - _kCarW / 2;
      final rawLateral = _lateral + steerInput * _kSteerSpeed * dt;
      final newLateral = rawLateral.clamp(minLat, maxLat);
      final hitEdge = rawLateral < minLat || rawLateral > maxLat;
      _lateral = newLateral;

      // Crash into road edge
      if (hitEdge) {
        _triggerDeath();
        return;
      }
      final targetTilt = _wheelAngle * _kCarSteerFactor;
      _carVisualAngle +=
          (targetTilt - _carVisualAngle) *
          (_kCarSteerLerp * dt).clamp(0.0, 1.0);

      // Slide controls up after intro
      if (_controlsSlideT < 1.0) {
        _controlsSlideT = (_controlsSlideT + dt / _kControlsSlideDuration)
            .clamp(0.0, 1.0);
      }

      // Road scroll offset (dash period = dashLen + gapLen = 40)
      _roadOffset = (_roadOffset + _speed * dt) % 40;
      _treeOffset = (_treeOffset + _speed * dt) % _treePeriod;
      _boatOffset = (_boatOffset + _speed * dt) % _boatPeriod;
      if (_scenerySlideFadeT < 1.0) {
        _scenerySlideFadeT = (_scenerySlideFadeT + dt / 1.5).clamp(0.0, 1.0);
      }

      // Distance: 1 px = 0.1 m
      _distanceM += _speed * dt * 0.1;

      // Spawn traffic
      _spawnTimer += dt;
      final effectiveSpawnInterval = _braking
          ? _spawnInterval * 7.0
          : _spawnInterval;
      if (_spawnTimer >= effectiveSpawnInterval) {
        _spawnTimer = 0;
        _spawnTraffic();
      }

      // Move traffic with car-following (front-to-back so currentSpeed propagates)
      _traffic.sort((a, b) => b.progress.compareTo(a.progress));
      for (final car in _traffic) {
        // Find nearest car ahead in the same lane
        double minDist = double.infinity;
        double aheadCurrent = car.speed;
        for (final other in _traffic) {
          if (identical(other, car)) continue;
          if ((other.lateral - car.lateral).abs() > _kLaneWidth * 0.6) continue;
          final dist = other.progress - car.progress;
          if (dist > 0 && dist < minDist) {
            minDist = dist;
            aheadCurrent = other.currentSpeed; // use actual speed, not base
          }
        }
        // Target speed: match car ahead if too close, otherwise base speed
        final targetSpeed = (minDist < car.length + 40)
            ? aheadCurrent.clamp(0.0, car.speed)
            : car.speed;
        // Smooth approach: decelerate fast, accelerate slowly
        const brakeRate = 90.0; // px/s² deceleration
        const accelRate = 40.0; // px/s² re-acceleration
        final rate = targetSpeed < car.currentSpeed ? brakeRate : accelRate;
        car.currentSpeed =
            (car.currentSpeed +
                    (targetSpeed - car.currentSpeed).sign * rate * dt)
                .clamp(
                  targetSpeed < car.currentSpeed
                      ? targetSpeed
                      : car.currentSpeed,
                  targetSpeed < car.currentSpeed
                      ? car.currentSpeed
                      : targetSpeed,
                );

        car.progress -= (_speed - car.currentSpeed) * dt;

        // Lane changing
        if (!car.isHit) {
          if (car.laneTarget != null) {
            // Ease-in-out lane change
            car.laneChangeProg =
                (car.laneChangeProg + dt / _kLaneChangeDuration).clamp(
                  0.0,
                  1.0,
                );
            final t = car.laneChangeProg;
            final ease = t * t * (3.0 - 2.0 * t); // smoothstep
            car.lateral =
                car.laneStart + (car.laneTarget! - car.laneStart) * ease;
            if (car.laneChangeProg >= 1.0) {
              car.lateral = car.laneTarget!;
              car.laneTarget = null;
              car.laneChangeTimer = _laneChangeWait();
            }
          } else {
            car.laneChangeTimer -= dt;
            if (car.laneChangeTimer <= 0) {
              final gap = car.progress - _playerProgress;
              if (_rand.nextDouble() < _kLaneChangeChance &&
                  gap >= _kLaneChangeSafeGap) {
                // Pick an adjacent lane (lanes are at multiples of _kLaneWidth)
                final curLane = (car.lateral / _kLaneWidth).round();
                final dir = _rand.nextBool() ? 1 : -1;
                final newLane = (curLane + dir).clamp(
                  -(_kLaneCount ~/ 2),
                  _kLaneCount ~/ 2,
                );
                if (newLane != curLane) {
                  car.laneTarget = newLane * _kLaneWidth;
                  car.laneStart = car.lateral;
                  car.laneChangeProg = 0;
                }
              }
              car.laneChangeTimer = _laneChangeWait();
            }
          }
        }
      }
      _traffic.removeWhere((c) => c.progress < -(c.length + 20));

      // Collision (road-local AABB)
      _checkCollisions();
    });
  }

  void _triggerDeath() {
    if (_crashing || _dead) return;
    flagGameVibrate(context, 'Tanzania', 'lose');
    flagGameLossAd(context, 'Tanzania', isStillLost: () => _dead || _crashing);
    _stopEngineAudio();
    context.read<IAudioCubit>().playSfx(GameSfx.carCrash);
    context.read<IAudioCubit>().pauseBgm();
    _crashing = true;
    _crashCamSpeed = _speed;
    _crashedCarProg = _playerProgress;
    _crashedCarLat = _lateral;
    if (_distanceM > _recordM) {
      _recordM = _distanceM;
      _saveRecord();
    }
    HapticFeedback.heavyImpact();
  }

  void _triggerCoinDrop() {
    _coinAnimPlaying = true;
    final amount = _kCoinMin + _rand.nextInt(_kCoinMax - _kCoinMin + 1);
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
      await layer.addMoneys(() {
        final pos = _toScreen(_playerProgress - _brakeShift, _lateral);
        return FlagGameViewport.toScreen(context, Offset(pos.dx, pos.dy));
      }, amount.clamp(1, 50));
      await Future.delayed(const Duration(milliseconds: 600));
      await layer.hide();
      if (mounted) setState(() => _coinAnimPlaying = false);
    });
  }

  double _laneChangeWait() {
    // Levels 0-1: gentle decrement; level 2+ (1000m+): stronger decrement
    final level1 = _diffLevel.clamp(0, 1);
    final level2 = (_diffLevel - 2).clamp(0, 99);
    final totalDecr =
        level1 * _kLaneChangeWaitDecr + level2 * _kLaneChangeWaitDecr2;
    final minWait = (_kLaneChangeMinWait - totalDecr).clamp(
      _kLaneChangeMinWaitCap,
      _kLaneChangeMinWait,
    );
    final maxWait = (_kLaneChangeMaxWait - totalDecr).clamp(
      _kLaneChangeMinWaitCap + 1.0,
      _kLaneChangeMaxWait,
    );
    return minWait + _rand.nextDouble() * (maxWait - minWait);
  }

  void _spawnTraffic() {
    final lane = _rand.nextInt(_kLaneCount) - _kLaneCount ~/ 2;
    final speed = _kTrafficSpeed + (_rand.nextDouble() * 80 - 40);
    final t = _pickTrafficType();
    final car = _TrafficCar(
      progress: _playerProgress + _roadLength * 0.68 + t.length / 2,
      lateral: lane * _kLaneWidth,
      sprite: t.sprite,
      width: t.width,
      length: t.length,
      hitL: t.hitL,
      hitR: t.hitR,
      hitT: t.hitT,
      hitB: t.hitB,
      speed: speed,
    );
    car.laneChangeTimer =
        _kLaneChangeMinWait +
        _rand.nextDouble() * (_kLaneChangeMaxWait - _kLaneChangeMinWait);
    _traffic.add(car);
  }

  _TrafficType _pickTrafficType() {
    final totalWeight = _kTrafficTypes.fold(0, (s, t) => s + t.weight);
    var pick = _rand.nextInt(totalWeight);
    for (final t in _kTrafficTypes) {
      pick -= t.weight;
      if (pick < 0) return t;
    }
    return _kTrafficTypes.last;
  }

  // Effective hitbox size (after insets)
  static const double _kHitW = _kCarW - _kHitInsetLeft - _kHitInsetRight;
  static const double _kHitL = _kCarL - _kHitInsetTop - _kHitInsetBottom;
  // Lateral offset of hitbox center from sprite center (insets can be asymmetric)
  static const double _kHitLatOff = (_kHitInsetRight - _kHitInsetLeft) / 2;
  static const double _kHitProgOff = (_kHitInsetBottom - _kHitInsetTop) / 2;

  void _checkCollisions() {
    for (final car in _traffic) {
      final dp = ((car.progress - _kHitProgOff) - _playerProgress).abs();
      final dl = ((car.lateral - _kHitLatOff) - _lateral).abs();
      if (dp < (_kHitL + car.hitH) / 2 && dl < (_kHitW + car.hitW) / 2) {
        car.isHit = true;
        car.hitAngleTarget =
            (_rand.nextDouble() * 0.6 + 0.3) * (_rand.nextBool() ? 1 : -1);
        _triggerDeath();
        return;
      }
      // Near-miss horn: car just passed the player and was laterally close
      if (!car.hornTriggered &&
          car.progress < _playerProgress &&
          dp < (_kHitL + car.hitH) / 2 + 30 &&
          dl < (_kHitW + car.hitW) / 2 + _kLaneWidth * 0.6) {
        car.hornTriggered = true;
        if (_rand.nextDouble() < 0.20) {
          context.read<IAudioCubit>().playSfx(
            _rand.nextBool() ? GameSfx.carHorn : GameSfx.carHorn2,
          );
        }
        if (!_coinAnimPlaying && _rand.nextDouble() < _kNearMissCoinChance) {
          _triggerCoinDrop();
        }
      }
    }
  }

  // ── Steering wheel gesture ────────────────────────────────────────────────
  static const double _kWheelPanelW =
      _kWheelSize + 40; // touch area wider than image
  Offset get _localWheelCenter =>
      Offset(_kWheelPanelW / 2 + _kWheelOffsetX, _screenH / 2 + _kWheelOffsetY);

  void _onWheelPanStart(DragStartDetails d) {
    _wheelReturnTimer?.cancel();
    _wheelGrabOff = d.localPosition - _localWheelCenter;
    _wheelGrabAngle = _wheelAngle;
  }

  void _onWheelPanUpdate(DragUpdateDetails d) {
    if (_wheelGrabOff == null) return;
    final cur = d.localPosition - _localWheelCenter;
    final startAng = atan2(_wheelGrabOff!.dy, _wheelGrabOff!.dx);
    final curAng = atan2(cur.dy, cur.dx);
    setState(() {
      _wheelAngle = (_wheelGrabAngle + (curAng - startAng)).clamp(
        -_kMaxWheelAngle,
        _kMaxWheelAngle,
      );
    });
  }

  void _onWheelPanEnd(DragEndDetails _) {
    _wheelReturnTimer = Timer.periodic(const Duration(milliseconds: 16), (t) {
      if (_wheelAngle.abs() < 0.02) {
        _wheelAngle = 0;
        t.cancel();
      } else {
        _wheelAngle *= 0.85;
      }
      if (mounted) setState(() {});
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF68B347),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative shapes (below road)
          Positioned.fill(
            child: CustomPaint(
              painter: _DecorPainter(
                screenW: _screenW,
                screenH: _screenH,
                roadStart: _roadStart,
                roadDir: _roadDir,
                perpDir: _perpDir,
                roadLength: _roadLength,
              ),
            ),
          ),

          // Trees and boats — fade in after intro
          if (_started)
            Opacity(
              opacity: _scenerySlideFadeT,
              child: Stack(clipBehavior: Clip.none, children: _buildTrees()),
            ),
          if (_started)
            Opacity(
              opacity: _scenerySlideFadeT,
              child: Stack(clipBehavior: Clip.none, children: _buildBoats()),
            ),

          // Road
          Positioned.fill(
            child: CustomPaint(
              painter: _RoadPainter(
                roadStart: _roadStart,
                roadDir: _roadDir,
                perpDir: _perpDir,
                roadLength: _roadLength,
                roadWidth: _kRoadWidth,
                laneCount: _kLaneCount,
                scaleL: _kRoadScaleL,
                offsetAlong: _kRoadOffsetAlong,
                offsetLat: _kRoadOffsetLat,
                extraAngle: _kRoadExtraAngle,
                dashOffset: _roadOffset,
                markOpacity: !_started ? 0.0 : (_intro ? _introMarkOp : 1.0),
              ),
            ),
          ),

          // Traffic cars
          ..._traffic.map((car) => _buildTrafficCar(car)),

          // Player car (sprite + optional hitbox overlay)
          if (_started)
            Builder(
              builder: (_) {
                final isCrash = _crashing || _dead;
                final pos = isCrash
                    ? _toScreen(_crashedCarProg, _crashedCarLat)
                    : _intro
                    ? _toScreen(_introProgress, _lateral)
                    : _toScreen(_playerProgress - _brakeShift, _lateral);
                return Positioned(
                  left: pos.dx - _kCarW / 2,
                  top: pos.dy - _kCarL / 2,
                  child: Transform.rotate(
                    angle: pi / 2 - _roadAngle,
                    child: Transform.rotate(
                      angle: isCrash ? _crashAngle : _carVisualAngle,
                      alignment: isCrash
                          ? Alignment.center
                          : Alignment(0, _kRearAxlePivotY),
                      child: SizedBox(
                        width: _kCarW,
                        height: _kCarL,
                        child: Stack(
                          children: [
                            Image.asset(
                              isCrash
                                  ? 'assets/images/flag_games/tanzania/car_main_subaru_crash.png'
                                  : 'assets/images/flag_games/tanzania/car_main_subaru.png',
                              width: _kCarW,
                              height: _kCarL,
                              fit: BoxFit.fill,
                            ),
                            if (_kShowHitbox && !isCrash)
                              Positioned(
                                left: _kHitInsetLeft,
                                right: _kHitInsetRight,
                                top: _kHitInsetTop,
                                bottom: _kHitInsetBottom,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          // Distance counter (only during active game)
          if (_started && !_dead)
            Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  _distanceM >= 1000
                      ? '${(_distanceM / 1000).toStringAsFixed(2)} km'
                      : '${_distanceM.toInt()} m',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                  ),
                ),
              ),
            ),

          // Record (shown before start and after game over)
          if (!_started || _dead)
            Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/winner_cup.png',
                      width: 28,
                      height: 28,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _recordM >= 1000
                          ? '${(_recordM / 1000).toStringAsFixed(2)} km'
                          : '${_recordM.toInt()} m',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Тап в любом месте экрана — старт и рестарт после аварии
          // (кнопка «назад» выше по слоям и по-прежнему нажимается)
          if (!_started || _dead)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _startGame,
              ),
            ),

          // Game Over
          if (_dead)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'GAME OVER',
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // счёт заезда — пройденная дистанция, в том же формате, что и в игре
                  Text(
                    'Score: ${_distanceM >= 1000 ? '${(_distanceM / 1000).toStringAsFixed(2)} km' : '${_distanceM.toInt()} m'}',
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _startGame,
                    // без тёмной подложки; тень, чтобы текст читался на дороге
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      child: Text(
                        'Tap to restart',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Steering wheel (left) — slides up from below after intro
          if (_started && !_dead && !_intro)
            Builder(
              builder: (_) {
                final ease =
                    1.0 - (1.0 - _controlsSlideT) * (1.0 - _controlsSlideT);
                final slideY = (1.0 - ease) * (_screenH * 0.5);
                return Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: _kWheelPanelW,
                  child: Transform.translate(
                    offset: Offset(0, slideY),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanStart: _onWheelPanStart,
                      onPanUpdate: _onWheelPanUpdate,
                      onPanEnd: _onWheelPanEnd,
                      child: Center(
                        child: Transform.translate(
                          offset: Offset(_kWheelOffsetX, _kWheelOffsetY),
                          child: _SteeringWheel(angle: _wheelAngle),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          // Brake button (right) — slides up from below after intro
          if (_started && !_dead && !_intro)
            Builder(
              builder: (_) {
                final ease =
                    1.0 - (1.0 - _controlsSlideT) * (1.0 - _controlsSlideT);
                final slideY = (1.0 - ease) * (_screenH * 0.5);
                return Positioned(
                  right: _kBrakeRight,
                  bottom: _kBrakeBottom,
                  child: Transform.translate(
                    offset: Offset(0, slideY),
                    child: GestureDetector(
                      onTapDown: _brakeRechargeLeft > 0
                          ? null
                          : (_) {
                              setState(() {
                                _braking = true;
                                _brakeHeldTime = 0;
                              });
                              _startBrakeAudio();
                            },
                      onTapUp: _brakeRechargeLeft > 0
                          ? null
                          : (_) {
                              setState(() {
                                _braking = false;
                                _brakeHeldTime = 0;
                                _brakeRechargeLeft = _kBrakeRecharge;
                              });
                              _stopBrakeAudio();
                            },
                      onTapCancel: _brakeRechargeLeft > 0
                          ? null
                          : () {
                              setState(() {
                                _braking = false;
                                _brakeHeldTime = 0;
                                _brakeRechargeLeft = _kBrakeRecharge;
                              });
                              _stopBrakeAudio();
                            },
                      child: AnimatedScale(
                        scale: _braking ? 0.88 : 1.0,
                        duration: const Duration(milliseconds: 80),
                        child: Opacity(
                          opacity: _brakeRechargeLeft > 0
                              ? 0.35 +
                                    0.65 *
                                        (1.0 -
                                            (_brakeRechargeLeft /
                                                    _kBrakeRecharge)
                                                .clamp(0.0, 1.0))
                              : 1.0,
                          child: Image.asset(
                            'assets/images/flag_games/tanzania/brake.png',
                            width: _kBrakeSize,
                            height: _kBrakeSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          // Back button
          // «Tap to start» — один раз, на первом открытом флаге
          Positioned.fill(
            child: FlagGameTapHint(visible: !_started && !_dead),
          ),
          const Positioned(top: 8, left: 8, child: FBackButton()),
        ],
      ),
    );
  }

  static const _kTreeSprites = [
    '${_p}tree_1.png',
    '${_p}tree_2.png',
    '${_p}tree_3.png',
  ];

  List<Widget> _buildTrees() {
    if (_treePool.isEmpty) return [];
    final trees = <Widget>[];
    // Render 3 tiles: one behind, one at player, one ahead — covers full screen
    for (int tile = -1; tile <= 1; tile++) {
      for (final (offset, spriteIdx) in _treePool) {
        final progress =
            _playerProgress + tile * _treePeriod + offset - _treeOffset;
        final pos = _toScreen(progress, _kTreeLat);
        if (pos.dx < -_kTreeSize ||
            pos.dx > _screenW + _kTreeSize ||
            pos.dy < -_kTreeSize ||
            pos.dy > _screenH + _kTreeSize) {
          continue;
        }
        trees.add(
          Positioned(
            left: pos.dx - _kTreeSize / 2,
            top: pos.dy - _kTreeSize / 2,
            child: Image.asset(
              _kTreeSprites[spriteIdx],
              width: _kTreeSize,
              height: _kTreeSize,
              fit: BoxFit.contain,
            ),
          ),
        );
      }
    }
    return trees;
  }

  List<Widget> _buildBoats() {
    if (_boatPool.isEmpty) return [];
    final boats = <Widget>[];
    for (int tile = -1; tile <= 1; tile++) {
      for (final (offset, latJitter) in _boatPool) {
        final progress =
            _playerProgress + tile * _boatPeriod + offset - _boatOffset;
        final pos = _toScreen(progress, _kBoatLat + latJitter);
        if (pos.dx < -_kBoatSize ||
            pos.dx > _screenW + _kBoatSize ||
            pos.dy < -_kBoatSize ||
            pos.dy > _screenH + _kBoatSize) {
          continue;
        }
        boats.add(
          Positioned(
            left: pos.dx - _kBoatSize / 2,
            top: pos.dy - _kBoatSize / 2,
            child: Transform.rotate(
              angle: _kBoatAngle,
              child: Image.asset(
                '${_p}boat.png',
                width: _kBoatSize,
                height: _kBoatSize,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      }
    }
    return boats;
  }

  Widget _buildTrafficCar(_TrafficCar car) {
    final pos = _toScreen(car.progress, car.lateral);
    return Positioned(
      left: pos.dx - car.width / 2,
      top: pos.dy - car.length / 2,
      child: Transform.rotate(
        angle: pi / 2 - _roadAngle,
        child: Transform.rotate(
          angle: car.hitAngle,
          child: SizedBox(
            width: car.width,
            height: car.length,
            child: Stack(
              children: [
                Image.asset(
                  car.sprite,
                  width: car.width,
                  height: car.length,
                  fit: BoxFit.fill,
                ),
                if (_kShowHitbox)
                  Positioned(
                    left: car.hitL,
                    right: car.hitR,
                    top: car.hitT,
                    bottom: car.hitB,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Steering wheel widget ─────────────────────────────────────────────────────
class _SteeringWheel extends StatelessWidget {
  final double angle;
  const _SteeringWheel({required this.angle});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Image.asset(
        'assets/images/flag_games/tanzania/steering_wheel.png',
        width: _kWheelSize,
        height: _kWheelSize,
      ),
    );
  }
}

// ── Road painter ──────────────────────────────────────────────────────────────
class _RoadPainter extends CustomPainter {
  final Offset roadStart;
  final Offset roadDir;
  final Offset perpDir;
  final double roadLength;
  final double roadWidth;
  final int laneCount;
  final double scaleL;
  final double offsetAlong;
  final double offsetLat;
  final double extraAngle;
  final double dashOffset;
  final double markOpacity;

  const _RoadPainter({
    required this.roadStart,
    required this.roadDir,
    required this.perpDir,
    required this.roadLength,
    required this.roadWidth,
    required this.laneCount,
    this.scaleL = 1.0,
    this.offsetAlong = 0.0,
    this.offsetLat = 0.0,
    this.extraAngle = 0.0,
    this.dashOffset = 0.0,
    this.markOpacity = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final length = roadLength * scaleL;
    final half = roadWidth / 2;

    // Apply angle rotation on top of the base road angle
    final baseAngle = atan2(-roadDir.dy, roadDir.dx);
    final totalAngle = baseAngle + extraAngle;
    final dir = Offset(cos(totalAngle), -sin(totalAngle));
    final perp = Offset(sin(totalAngle), cos(totalAngle));

    // Centre of the road shifted by offsets
    final centre =
        roadStart +
        Offset(
          roadDir.dx * (roadLength / 2 + offsetAlong),
          roadDir.dy * (roadLength / 2 + offsetAlong),
        ) +
        Offset(perpDir.dx * offsetLat, perpDir.dy * offsetLat);

    final halfL = length / 2;
    Offset corner(double along, double lat) =>
        centre +
        Offset(dir.dx * along, dir.dy * along) +
        Offset(perp.dx * lat, perp.dy * lat);

    final p1 = corner(-halfL, -half);
    final p2 = corner(-halfL, half);
    final p3 = corner(halfL, half);
    final p4 = corner(halfL, -half);

    final roadPath = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(p4.dx, p4.dy)
      ..close();

    canvas.drawPath(roadPath, Paint()..color = Colors.black);

    // Dashed lane dividers
    final dashPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.54 * markOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 1; i < laneCount; i++) {
      final lat = -half + i * (roadWidth / laneCount);
      _drawDashedLine(
        canvas,
        corner(-halfL, lat),
        corner(halfL, lat),
        dashPaint,
        dashLen: 20,
        gapLen: 20,
        startOffset: dashOffset,
      );
    }
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset a,
    Offset b,
    Paint paint, {
    double dashLen = 20,
    double gapLen = 20,
    double startOffset = 0,
  }) {
    final total = (b - a).distance;
    final dir = (b - a) / total;
    // startOffset shifts start so dashes appear to move from b toward a
    double dist = -startOffset;
    bool drawing = dist >= 0;
    if (dist < 0) {
      // skip partial first gap
      dist += gapLen;
      drawing = true;
    }
    while (dist < total) {
      final segLen = drawing ? dashLen : gapLen;
      final end = (dist + segLen).clamp(0.0, total);
      if (drawing) {
        canvas.drawLine(a + dir * dist, a + dir * end, paint);
      }
      dist += segLen;
      drawing = !drawing;
    }
  }

  @override
  bool shouldRepaint(_RoadPainter old) =>
      old.dashOffset != dashOffset ||
      old.markOpacity != markOpacity ||
      old.roadStart != roadStart ||
      old.roadLength != roadLength;
}

// ── Decorative shapes painter ─────────────────────────────────────────────────
class _DecorPainter extends CustomPainter {
  final double screenW;
  final double screenH;
  final Offset roadStart;
  final Offset roadDir;
  final Offset perpDir;
  final double roadLength;

  const _DecorPainter({
    required this.screenW,
    required this.screenH,
    required this.roadStart,
    required this.roadDir,
    required this.perpDir,
    required this.roadLength,
  });

  Offset _s(Offset p) => p; // identity — canvas matches screen coords

  Offset _toScreen(double progress, double lateral) =>
      roadStart +
      Offset(roadDir.dx * progress, roadDir.dy * progress) +
      Offset(perpDir.dx * lateral, perpDir.dy * lateral);

  @override
  void paint(Canvas canvas, Size size) {
    _drawTriangle(canvas);
    _drawStripe(
      canvas,
      _kStripe1Lat,
      _kStripe1W,
      _kStripe1ScaleL,
      _kStripe1Angle,
    );
    _drawStripe(
      canvas,
      _kStripe2Lat,
      _kStripe2W,
      _kStripe2ScaleL,
      _kStripe2Angle,
    );
  }

  // Синяя часть флага — вся полуплоскость справа от дороги, начиная под
  // правой жёлтой полосой (шов закрыт полосой). Строится от самой дороги,
  // поэтому на любом экране справа от дороги синий, а не зелёный клин.
  void _drawTriangle(Canvas canvas) {
    final far = (screenW + screenH) * 4; // заведомо за краями экрана
    final p0 = _toScreen(-far, _kStripe2Lat);
    final p1 = _toScreen(roadLength + far, _kStripe2Lat);
    final out = Offset(perpDir.dx * far, perpDir.dy * far);
    final path = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p1.dx + out.dx, p1.dy + out.dy)
      ..lineTo(p0.dx + out.dx, p0.dy + out.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF5BA1DA));
  }

  void _drawStripe(
    Canvas canvas,
    double lateral,
    double w,
    double scaleL,
    double extraAngle,
  ) {
    final length = roadLength * scaleL;
    final center = _toScreen(roadLength / 2, lateral);
    final halfL = length / 2;
    final halfW = w / 2;

    final roadAngle = atan2(roadDir.dy, roadDir.dx);
    final totalAngle = roadAngle + extraAngle;

    Offset rot(Offset p) {
      final c = cos(totalAngle), s = sin(totalAngle);
      return Offset(p.dx * c - p.dy * s, p.dx * s + p.dy * c);
    }

    final corners = [
      Offset(-halfL, -halfW),
      Offset(halfL, -halfW),
      Offset(halfL, halfW),
      Offset(-halfL, halfW),
    ].map((p) => _s(center + rot(p))).toList();

    final path = Path()
      ..moveTo(corners[0].dx, corners[0].dy)
      ..lineTo(corners[1].dx, corners[1].dy)
      ..lineTo(corners[2].dx, corners[2].dy)
      ..lineTo(corners[3].dx, corners[3].dy)
      ..close();

    canvas.drawPath(path, Paint()..color = const Color(0xFFF1D037));
  }

  @override
  bool shouldRepaint(_DecorPainter old) =>
      old.screenW != screenW || old.screenH != screenH;
}

// ── Traffic car data ──────────────────────────────────────────────────────────
class _TrafficCar {
  double progress;
  double lateral;
  final String sprite;
  final double width;
  final double length;
  final double hitL;
  final double hitR;
  final double hitT;
  final double hitB;
  final double speed; // base speed (px/s)
  double currentSpeed; // actual speed this tick (updated each frame)
  bool isHit = false;
  double hitAngle = 0.0;
  double hitAngleTarget = 0.0;
  bool hornTriggered = false;
  double? laneTarget; // lateral target during lane change (null = staying)
  double laneStart = 0; // lateral at start of current lane change
  double laneChangeProg = 0; // 0→1 ease-in-out progress of current lane change
  double laneChangeTimer = 0; // countdown to next lane-change decision

  double get hitW => width - hitL - hitR;
  double get hitH => length - hitT - hitB;

  _TrafficCar({
    required this.progress,
    required this.lateral,
    required this.sprite,
    required this.width,
    required this.length,
    required this.hitL,
    required this.hitR,
    required this.hitT,
    required this.hitB,
    required this.speed,
  }) : currentSpeed = speed;
}
