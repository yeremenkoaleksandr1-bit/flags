import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flags/features/flag_games/flag_game_viewport.dart';
import 'package:flags/features/flag_games/flag_game_background_pause.dart';
import 'package:flags/features/flag_games/flag_game_tap_hint.dart';
import 'package:flags/features/flag_games/flag_game_ads.dart';
import 'package:flags/features/flag_games/flag_game_vibration.dart';
import 'package:flags/uikit/components/buttons/actions/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Flag colors ───────────────────────────────────────────────────────────────
const double _kMusicVolume =
    0.6; // фоновая музыка (по кругу, с начала каждой попытки)

const Color _kBgColor = Color(0xFFFFFFFF);
const Color _kStripeColor = Color(0xFF213BB3);

// ── Stripe positions ──────────────────────────────────────────────────────────
const double _kStripe1YFrac = 0.07;
const double _kStripe2YFrac = 0.78;
const double _kStripeHFrac = 0.15;

// ── Star (idle position) ──────────────────────────────────────────────────────
const double _kStarCenterXFrac = 0.5;
const double _kStarCenterYFrac = 0.5;
const double _kStarSizeFrac = 0.2;

// ── Intro animation ───────────────────────────────────────────────────────────
const Duration _kAnimDur = Duration(milliseconds: 800);
const Curve _kAnimCurve = Curves.easeInOut;

// End positions (intro anim)
const double _kStripe1EndYFrac = 0.0;
const double _kStripe2EndYFrac = 0.85;
const double _kStarEndXFrac = 0.26;
const double _kStarEndYFrac = 0.73;
const double _kStarEndAngleDeg = 30.0;
const double _kStarEndSizeFrac = 0.13;

// ── Geometry Dash game settings ───────────────────────────────────────────────
// Нижняя граница — верхний край нижней полоски после анимации
// Звезда стоит на этой границе
const double _kGroundYFrac = _kStripe2EndYFrac; // Y верха платформы
const double _kStarGameXFrac = 0.26; // X звезды во время игры (не меняется)

// Прыжок
const double _kJumpVelocity = -1500.0; // пикселей/сек вверх
const double _kGravity = 6000.0; // пикселей/сек²
// Прыжок подстраивается под экран: не выше этой высоты (px) и не выше
// доли свободного места до верхней полосы. Время в воздухе фиксированное.
const double _kJumpMaxHeight = 187.5;
const double _kJumpSpaceFrac = 0.85;
const double _kJumpAirTime = 2 * 1500.0 / _kGravity; // 0.5 с

// Скорость и размер треугольников
const double _kObstacleSpeed = 400.0; // начальная скорость (пикселей/сек)
const double _kSpeedUpEvery = 200.0; // каждые N метров ускорение
const double _kSpeedUpAmount = 50.0; // прибавка скорости (пикселей/сек)
// насколько расстояния в генерации растут со скоростью (1.0 = пропорционально, 0 = не растут)
const double _kGapSpeedScale = 0.75;
const double _kObstacleMinGap = 250.0; // мин расстояние между препятствиями
const double _kObstacleMaxGap = 500.0; // макс расстояние
const double _kObstacleMinSize =
    40.0; // не используется (оставлено для совместимости)
const double _kObstacleMaxSize = 90.0; // не используется

// Фиксированный размер каждого типа шипа (px, передаётся как size в _Obstacle)
const double _kSpikeSize = 60.0;
const double _kTallSpikeSize = 60.0;
const double _kDoubleSpikeSize = 60.0;

// Градусов за один прыжок
const double _kSpinPerJump = 120.0;
// Скорость вращения вычисляется автоматически из времени прыжка
// air_time = 2 * |_kJumpVelocity| / _kGravity
double get _kSpinSpeed =>
    _kSpinPerJump / (2 * _kJumpVelocity.abs() / _kGravity);

// Смещение звезды вниз относительно верхнего края платформы (доля от размера звезды)
// 0.0 = низ звезды касается платформы сверху
// 0.5 = звезда наполовину утоплена в платформу
const double _kStarGroundOffset = 0.1;

// Позиция счётчика дистанции в игре
const double _kScoreTop = 60.0; // отступ сверху (px)
const double _kScoreRight = 16.0; // отступ справа (px)

// ── Platform settings ─────────────────────────────────────────────────────────
const double _kPlatformLength = 220.0; // длина платформы (px)
const double _kPlatformThickness = 14.0; // толщина платформы (px)
const double _kPlatformYFrac =
    0.55; // Y центра платформы (доля высоты экрана, 0=верх, 1=низ)

// ── Spike settings ────────────────────────────────────────────────────────────
// Обычный шип: ширина = size * _kSpikeWidthScale, высота = size * _kSpikeHeightScale
const double _kSpikeWidthScale = 1.0;
const double _kSpikeHeightScale = 1.0;

// Высокий шип: ширина = size * _kTallSpikeWidthScale, высота = size * _kTallSpikeHeightScale
const double _kTallSpikeWidthScale = 0.55;
const double _kTallSpikeHeightScale = 1.6;

// ── Double spike settings ─────────────────────────────────────────────────────
// Множитель размера каждого из двух шипов относительно size (1.0 = такой же, как одиночный шип)
const double _kDSpikeScale = 1.0;
// Зазор между двумя шипами (px): 0 = основания касаются, < 0 = перекрытие (вплотную), > 0 = расстояние
const double _kDSpikeGap = -8.0;

// Показывать хитбоксы
const bool _kShowHitboxes = false;

// Размер хитбокса звезды (доля от размера спрайта, 1.0 = полный размер)
const double _kStarHitRadius = 0.9;
// Хитбокс треугольника (отступ от краёв, доля от размера)
const double _kTriHitInset = 0.15;

const _p = 'assets/images/flag_games/israel/';

enum _PShape { triangle, rect, diamond }

// ── Монеты ────────────────────────────────────────────────────────────────────
const double _kSfxVolume = 1.0; // прыжок, приземление, смерть
const double _kCoinSize = 38.0; // размер значка (px)
const int _kCoinValue = 5; // сколько денег даёт одна монета
const double _kCoinMinGap = 40.0; // мин. расстояние между монетами (м)
const double _kCoinMaxGap = 90.0; // макс. расстояние между монетами (м)

class _Coin {
  double x, y; // центр
  double takenT = -1; // >= 0 — анимация подбора (сек)
  _Coin(this.x, this.y);
}

// ── Particle ──────────────────────────────────────────────────────────────────
class _Particle {
  double x, y, vx, vy, angle, spin, opacity, size;
  final _PShape shape;
  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.angle,
    required this.spin,
    required this.size,
    required this.shape,
  }) : opacity = 1.0;
}

// ── Obstacle types ────────────────────────────────────────────────────────────
// ─── Level item (used by editor + saved level) ────────────────────────────────
class _LevelItem {
  _OType type;
  double
  x; // позиция в метрах от старта игры (1м = 50px, не зависит от скорости)
  double size;
  double? elev; // высота над землёй (px); null = по умолчанию
  _LevelItem({
    required this.type,
    required this.x,
    required this.size,
    this.elev,
  });

  Map<String, dynamic> toJson() => {
    't': type.index,
    'x': x,
    's': size,
    if (elev != null) 'e': elev,
  };
  static _LevelItem fromJson(Map<String, dynamic> j) => _LevelItem(
    type: _OType.values[j['t'] as int],
    x: (j['x'] as num).toDouble(),
    size: (j['s'] as num).toDouble(),
    elev: (j['e'] as num?)?.toDouble(),
  );
}

// ── Встроенный уровень в стиле Stereo Madness ─────────────────────────────────
// x — метры (1м = 50px), elev — высота над землёй в px.
// Прыжок: высота ~187px, длина ~4м на стартовой скорости.
List<_LevelItem> _buildStereoLevel() {
  final l = <_LevelItem>[];
  void s(double x, [double? e]) =>
      l.add(_LevelItem(type: _OType.spike, x: x, size: _kSpikeSize, elev: e));
  void d(double x, [double? e]) => l.add(
    _LevelItem(
      type: _OType.doublespike,
      x: x,
      size: _kDoubleSpikeSize,
      elev: e,
    ),
  );
  void t(double x) =>
      l.add(_LevelItem(type: _OType.tallspike, x: x, size: _kTallSpikeSize));
  void p(double x, double lenM, double e) =>
      l.add(_LevelItem(type: _OType.platform, x: x, size: lenM * 50, elev: e));

  // 1. Разминка — одиночные шипы
  s(10);
  s(20);
  s(28);
  d(37);
  // 2. Ритм — шипы через прыжок
  s(46);
  s(51);
  s(56);
  t(64);
  // 3. Первые блоки — две ступеньки и спуск
  p(72, 3, 60);
  p(77, 3, 110);
  d(73);
  d(78); // под ступеньками нельзя падать
  s(86);
  // 4. Мост над шипами со шипом на мосту
  p(94, 9, 80);
  d(95);
  d(98);
  d(101);
  s(98.5, 80);
  s(108);
  // 5. Быстрая серия
  d(116);
  s(122);
  s(126.5);
  d(132);
  t(139);
  t(143);
  // 6. Лестница вверх и прыжок вниз
  p(150, 3, 50);
  p(155, 3, 95);
  p(160, 4, 130);
  d(151);
  d(156);
  d(160);
  d(162.5);
  s(162, 130);
  s(170);
  // 7. Платформы-островки
  p(178, 3, 70);
  d(181.2);
  p(184, 3, 70);
  d(187.2);
  p(190, 3, 70);
  s(197);
  // 8. Финал
  d(205);
  s(211);
  t(217);
  d(222);
  s(229);
  s(233.5);
  s(238);
  p(245, 6, 80);
  d(246);
  d(249);
  s(248, 80);
  return l;
}

// ── Секции для бесконечной генерации (x — метры от начала секции) ─────────────
List<_LevelItem> Function() _chunk(void Function(_ChunkB b) f) => () {
  final b = _ChunkB();
  f(b);
  return b.l;
};

class _ChunkB {
  final l = <_LevelItem>[];
  void s(double x, [double? e]) =>
      l.add(_LevelItem(type: _OType.spike, x: x, size: _kSpikeSize, elev: e));
  void d(double x, [double? e]) => l.add(
    _LevelItem(
      type: _OType.doublespike,
      x: x,
      size: _kDoubleSpikeSize,
      elev: e,
    ),
  );
  void t(double x) =>
      l.add(_LevelItem(type: _OType.tallspike, x: x, size: _kTallSpikeSize));
  void p(double x, double lenM, double e) =>
      l.add(_LevelItem(type: _OType.platform, x: x, size: lenM * 50, elev: e));
}

final List<List<_LevelItem> Function()> _kChunks = [
  // ритм шипов
  _chunk((b) {
    b.s(0);
    b.s(5);
    b.s(10);
    b.d(16);
  }),
  // высокие шипы
  _chunk((b) {
    b.t(0);
    b.t(4);
    b.s(9);
    b.t(14);
  }),
  // две ступеньки
  _chunk((b) {
    b.p(0, 3, 60);
    b.p(5, 3, 110);
    b.d(1);
    b.d(6);
    b.s(14);
  }),
  // мост над шипами со шипом наверху
  _chunk((b) {
    b.p(0, 9, 80);
    b.d(1);
    b.d(4);
    b.d(7);
    b.s(4.5, 80);
  }),
  // лестница вверх
  _chunk((b) {
    b.p(0, 3, 50);
    b.p(5, 3, 95);
    b.p(10, 4, 130);
    b.d(1);
    b.d(6);
    b.d(10);
    b.d(12.5);
    b.s(12, 130);
  }),
  // островки
  _chunk((b) {
    b.p(0, 3, 70);
    b.d(3.2);
    b.p(6, 3, 70);
    b.d(9.2);
    b.p(12, 3, 70);
  }),
  // быстрая серия
  _chunk((b) {
    b.d(0);
    b.s(6);
    b.s(10.5);
    b.d(16);
    b.t(23);
  }),
  // мост с двумя шипами
  _chunk((b) {
    b.p(0, 12, 80);
    b.d(1);
    b.d(4);
    b.d(7);
    b.d(10);
    b.s(3, 80);
    b.s(8, 80);
  }),
];

enum _OType {
  spike, // одиночный шип
  doublespike, // два шипа рядом
  tallspike, // высокий узкий шип
  platform, // горизонтальная платформа по середине
}

class _HitShape {
  final bool isTriangle; // true=треугольник, false=прямоугольник
  // для rect: left,top,right,bottom
  final double left, top, right, bottom;
  // для triangle: apex, bl, br
  final Offset apex, bl, br;
  _HitShape.rect(this.left, this.top, this.right, this.bottom)
    : isTriangle = false,
      apex = Offset.zero,
      bl = Offset.zero,
      br = Offset.zero;
  _HitShape.tri(this.apex, this.bl, this.br)
    : isTriangle = true,
      left = 0,
      top = 0,
      right = 0,
      bottom = 0;
}

// (left, right, surfaceY) — поверхность на которую можно встать
typedef _Surface = ({double left, double right, double y});

class _Obstacle {
  double x;
  final _OType type;
  double size;
  final int id;
  final double? elev;
  _Obstacle({
    required this.x,
    required this.type,
    required this.size,
    required this.id,
    this.elev,
  });

  // основание шипа (Y)
  double baseY(double groundY, double screenH) =>
      (elev == null || elev! <= 0) ? groundY : screenH * _kGroundYFrac - elev!;

  // верх платформы (Y)
  double platTop(double screenH) => elev == null
      ? screenH * _kPlatformYFrac
      : screenH * _kGroundYFrac - elev!;

  // верхняя граница объекта (для выбора в редакторе)
  double topY(double groundY, double screenH) => type == _OType.platform
      ? platTop(screenH)
      : baseY(groundY, screenH) - size * 2;

  bool get isDeadly => type != _OType.platform;

  double get width {
    switch (type) {
      case _OType.spike:
        return size * _kSpikeWidthScale;
      case _OType.tallspike:
        return size * _kTallSpikeWidthScale;
      case _OType.doublespike:
        return size * _kDSpikeScale * 2 + _kDSpikeGap;
      case _OType.platform:
        return size;
    }
  }

  // Смертельные хитшейпы (только для isDeadly и hangingBar снизу)
  List<_HitShape> deadlyShapes(
    double groundBase,
    double screenH,
    double inset,
  ) {
    final s = size;
    final i = inset;
    final groundY = baseY(groundBase, screenH);
    switch (type) {
      case _OType.spike:
        final sw = s * _kSpikeWidthScale;
        final sh = s * _kSpikeHeightScale;
        return [
          _HitShape.tri(
            Offset(x + sw / 2, groundY - sh + sw * i),
            Offset(x + sw * i, groundY),
            Offset(x + sw * (1 - i), groundY),
          ),
        ];
      case _OType.tallspike:
        final tw = s * _kTallSpikeWidthScale;
        final th = s * _kTallSpikeHeightScale;
        return [
          _HitShape.tri(
            Offset(x + tw / 2, groundY - th + tw * i),
            Offset(x + tw * i, groundY),
            Offset(x + tw * (1 - i), groundY),
          ),
        ];
      case _OType.doublespike:
        final ds = s * _kDSpikeScale;
        final gap = _kDSpikeGap;
        return [
          _HitShape.tri(
            Offset(x + ds / 2, groundY - ds + ds * i),
            Offset(x + ds * i, groundY),
            Offset(x + ds * (1 - i), groundY),
          ),
          _HitShape.tri(
            Offset(x + ds + gap + ds / 2, groundY - ds + ds * i),
            Offset(x + ds + gap + ds * i, groundY),
            Offset(x + ds + gap + ds * (1 - i), groundY),
          ),
        ];
      case _OType.platform:
        return [];
    }
  }

  // screenH — полная высота экрана для вычисления Y платформы
  List<_Surface> topSurfaces(double groundY, double screenH) {
    if (type != _OType.platform) return [];
    return [(left: x, right: x + size, y: platTop(screenH))];
  }

  List<_HitShape> solidSideShapes(double screenH) {
    if (type != _OType.platform) return [];
    final top = platTop(screenH);
    return [_HitShape.rect(x, top, x + size, top + _kPlatformThickness)];
  }
}

@RoutePage()
class IsraelGameScreen extends StatefulWidget implements AutoRouteWrapper {
  // игра строится на «экране Pixel 10» и масштабируется под реальный экран
  @override
  Widget wrappedRoute(BuildContext context) =>
      FlagGameViewport(background: _kBgColor, child: this);

  const IsraelGameScreen({super.key});

  @override
  State<IsraelGameScreen> createState() => _IsraelGameScreenState();
}

class _IsraelGameScreenState extends State<IsraelGameScreen>
    with TickerProviderStateMixin, FlagGameBackgroundPause<IsraelGameScreen> {
  // intro
  late final AnimationController _introCtrl;
  late final Animation<double> _introAnim;
  bool _gameStarted = false;

  // game loop
  Ticker? _ticker;
  Duration _lastTime = Duration.zero;

  // ── Пауза, пока приложение свёрнуто ──
  bool _tickerWasActive = false;

  @override
  void onAppHidden() {
    _tickerWasActive = _ticker?.isActive ?? false;
    if (_tickerWasActive) _ticker!.stop();
  }

  @override
  void onAppShown() {
    if (_tickerWasActive && mounted) {
      // новый отсчёт времени — первый кадр после возврата без скачка
      _lastTime = Duration.zero;
      _ticker?.start();
    }
  }

  // star physics
  double _starY = 0.0;
  double _starVY = 0.0;
  double _starAngle = _kStarEndAngleDeg * pi / 180;
  double _jumpStartAngle = _kStarEndAngleDeg * pi / 180;
  bool _isOnGround = true;
  bool _isDead = false;
  double _topStripeShift = 0.0; // 0 = на месте, 1 = полностью уехала за экран
  bool _pressing = false;
  Offset _shakeOffset = Offset.zero;
  double _shakeTime = 0.0;

  // монеты
  final List<_Coin> _coins = [];
  double _nextCoinM = 0;
  int _moneyAnimToken = 0;

  // score
  double _distance = 0.0;
  int _bestScore = 0;
  static const _kBestScoreKey = 'israel_best_score';

  // obstacles
  final List<_Obstacle> _obstacles = [];
  final List<_Particle> _particles = [];
  final _rng = Random();
  double _nextObstacleX = 0.0;
  int _spawnCount = 0;

  // level editor
  bool _editorOpen = false;
  bool _isPaused = false;
  bool _isInvincible = false;
  int _selectedObsIdx = -1;
  int _draggingObsIdx = -1;
  // level map: id → item; накапливается при спавне, редактор синхронизирует
  final Map<int, _LevelItem> _levelMap = {};
  int _nextObsId = 0;
  double _levelFirstM = 0; // опорный метр уровня (firstM при загрузке)
  List<_LevelItem> _levelItems = []; // загруженный уровень из prefs
  bool _useCustomLevel = false;
  static const _kLevelSaveKey = 'israel_level_v2';

  // cached screen size
  double _w = 0, _h = 0;
  double _groundY = 0; // Y верха платформы в пикселях
  double _starX = 0; // X звезды в пикселях
  double _starSize = 0;

  @override
  void initState() {
    super.initState();
    _introCtrl = AnimationController(vsync: this, duration: _kAnimDur);
    _introAnim = CurvedAnimation(parent: _introCtrl, curve: _kAnimCurve);
    _loadBestScore();
    _loadLevel();
    _audio = context.read<IAudioCubit>();
    _preloadSounds();
  }

  late final IAudioCubit _audio;

  static const _kGameSounds = [
    GameSfx.israelJump,
    GameSfx.israelFall,
    GameSfx.israelCrash,
  ];

  Future<void> _preloadSounds() async {
    await FlameAudio.audioCache.loadAll(
      _kGameSounds.map((s) => s.file).toList(),
    );
    if (!mounted) return;
    // прогрев пулов, чтобы первый прыжок не запаздывал
    for (final sfx in _kGameSounds) {
      _audio.playSfx(sfx, volume: 0);
    }
  }

  void _playSfx(GameSfx sfx) => _audio.playSfx(sfx, volume: _kSfxVolume);

  Future<void> _loadLevel() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kLevelSaveKey);
    if (!mounted) return;
    if (raw == null) {
      setState(() {
        _levelItems = _buildStereoLevel();
        _useCustomLevel = true;
      });
      return;
    }
    try {
      final list = jsonDecode(raw) as List;
      setState(() {
        _levelItems = list
            .map((e) => _LevelItem.fromJson(e as Map<String, dynamic>))
            .toList();
        _useCustomLevel = _levelItems.isNotEmpty;
      });
    } catch (_) {}
  }

  Future<void> _saveLevel(List<_LevelItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    if (items.isEmpty) {
      await prefs.remove(_kLevelSaveKey);
      items = _buildStereoLevel();
    } else {
      await prefs.setString(
        _kLevelSaveKey,
        jsonEncode(items.map((e) => e.toJson()).toList()),
      );
    }
    if (!mounted) return;
    setState(() {
      _levelItems = items;
      _useCustomLevel = items.isNotEmpty;
    });
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
    _introCtrl.dispose();
    _ticker?.dispose();
    super.dispose();
  }

  void _initSizes(double w, double h) {
    _w = w;
    _h = h;
    _starSize = w * _kStarEndSizeFrac;
    _groundY = h * _kGroundYFrac + _starSize * _kStarGroundOffset;
    _starX = w * _kStarGameXFrac;

    // Высота прыжка — от свободного места между верхом звезды на земле и
    // нижним краем верхней полосы именно на этом экране (на низких экранах
    // фиксированные пиксели доставали до полосы). Время прыжка прежнее,
    // поэтому ритм уровня не меняется.
    final starTopOnGround = _groundY - _starSize;
    final stripeBottom = h * (_kStripe1EndYFrac + _kStripeHFrac);
    final space = starTopOnGround - stripeBottom;
    _jumpHeight = min(_kJumpMaxHeight, space * _kJumpSpaceFrac);
    _jumpVelocity = -4 * _jumpHeight / _kJumpAirTime;
    _gravity = 8 * _jumpHeight / (_kJumpAirTime * _kJumpAirTime);
  }

  // физика прыжка под текущий экран (см. _initSizes)
  double _jumpHeight = 187.5;
  double _jumpVelocity = _kJumpVelocity;
  double _gravity = _kGravity;

  void _startGame() {
    // музыка с начала трека на каждом старте/рестарте, при смерти — пауза
    _audio.playBgm(GameMusics.israel, volume: _kMusicVolume, fromStart: true);
    _isDead = false;
    _topStripeShift = 0.0;
    _shakeOffset = Offset.zero;
    _shakeTime = 0.0;
    _isPaused = false;
    _isInvincible = false;
    _editorOpen = false;
    _selectedObsIdx = -1;
    _draggingObsIdx = -1;
    _levelMap.clear();
    _nextObsId = 0;
    _levelFirstM = (_w + 200 - _starX) / 50.0;
    _isOnGround = true;
    _starY = _groundY - _starSize;
    _starVY = 0;
    _starAngle = _kStarEndAngleDeg * pi / 180;
    _jumpStartAngle = _starAngle;
    _distance = 0.0;
    _pressing = false;
    _spawnCount = 0;
    _obstacles.clear();
    _particles.clear();
    _coins.clear();
    _nextCoinM = 20 + _rng.nextDouble() * 40;
    _nextObstacleX = _w + 200;

    if (_useCustomLevel && _levelItems.isNotEmpty) {
      final sorted = List.of(_levelItems)..sort((a, b) => a.x.compareTo(b.x));
      final firstM = sorted.first.x;
      _levelFirstM = firstM;
      for (final item in sorted) {
        final id = _nextObsId++;
        final obs = _Obstacle(
          x: _w + 200 + (item.x - firstM) * 50.0,
          type: item.type,
          size: item.size,
          id: id,
          elev: item.elev,
        );
        _obstacles.add(obs);
        _levelMap[id] = _LevelItem(
          type: item.type,
          x: item.x,
          size: item.size,
          elev: item.elev,
        );
      }
      _nextObstacleX = double.maxFinite;
    }
    _lastTime = Duration.zero;
    _ticker?.dispose();
    _ticker = createTicker(_tick)..start();
  }

  void _tick(Duration elapsed) {
    if (_lastTime == Duration.zero) {
      _lastTime = elapsed;
      return;
    }
    if (_isPaused) {
      _lastTime = elapsed;
      return;
    }
    final dt = (elapsed - _lastTime).inMicroseconds / 1e6;
    _lastTime = elapsed;

    if (_isDead) return;

    setState(() {
      // текущая скорость
      final speed =
          _kObstacleSpeed +
          (_distance / _kSpeedUpEvery).floorToDouble() * _kSpeedUpAmount;

      // move obstacles first (so surfaces are at correct X)
      for (final o in _obstacles) {
        o.x -= speed * dt;
      }
      _obstacles.removeWhere((o) => o.x + o.width < 0);
      // после конца уровня — бесконечная генерация похожих секций
      if (_useCustomLevel && _levelItems.isNotEmpty) {
        double rightmost = 0;
        for (final o in _obstacles) {
          rightmost = max(rightmost, o.x + o.width);
        }
        if (rightmost < _w + 100) {
          // прыжок длится фиксированное время, значит его длина растёт со скоростью —
          // растягиваем расстояния секции пропорционально
          final k = 1 + (speed / _kObstacleSpeed - 1) * _kGapSpeedScale;
          final startX = _obstacles.isEmpty
              ? _w + 200
              : rightmost + (6 + _rng.nextDouble() * 3) * 50 * k;
          final chunk = _kChunks[_rng.nextInt(_kChunks.length)];
          for (final it in chunk()) {
            _obstacles.add(
              _Obstacle(
                x: startX + it.x * 50 * k,
                type: it.type,
                size: it.type == _OType.platform ? it.size * k : it.size,
                id: _nextObsId++,
                elev: it.elev,
              ),
            );
          }
        }
      }

      // spawn (пропускаем если используется кастомный уровень)
      if (!(_useCustomLevel && _levelItems.isNotEmpty) &&
          (_obstacles.isEmpty || _nextObstacleX <= _w + 50)) {
        const _firstFour = [
          _OType.spike,
          _OType.doublespike,
          _OType.tallspike,
          _OType.platform,
        ];
        final type = _spawnCount < _firstFour.length
            ? _firstFour[_spawnCount]
            : _OType.values[_rng.nextInt(_OType.values.length)];
        final gap =
            _kObstacleMinGap +
            _rng.nextDouble() * (_kObstacleMaxGap - _kObstacleMinGap);
        final size = switch (type) {
          _OType.spike => _kSpikeSize,
          _OType.tallspike => _kTallSpikeSize,
          _OType.doublespike => _kDoubleSpikeSize,
          _OType.platform => _kPlatformLength,
        };
        final spawnX = _obstacles.isEmpty
            ? _w + 200
            : _obstacles.last.x + _obstacles.last.width + gap;
        final newId = _nextObsId++;
        _obstacles.add(_Obstacle(x: spawnX, type: type, size: size, id: newId));
        _levelMap[newId] = _LevelItem(
          type: type,
          x: _distance + (spawnX - _starX) / 50.0,
          size: size,
        );
        _nextObstacleX = spawnX + gap;
        _spawnCount++;
      }

      _updateCoins(speed, dt);

      // distance
      _distance += speed * dt / 50;

      // после 65м верхняя полоска уезжает вверх за экран
      if (_distance >= 65 && _topStripeShift < 1) {
        _topStripeShift = (_topStripeShift + dt * 1.5).clamp(0.0, 1.0);
      }

      // physics
      if (!_isOnGround) {
        _starVY += _gravity * dt;
        _starY += _starVY * dt;
        _starAngle += _kSpinSpeed * pi / 180 * dt;
      }

      // ── Вычисляем эффективную высоту земли (база + поверхности платформ) ──
      double effectiveGround = _groundY;
      for (final o in _obstacles) {
        for (final surf in o.topSurfaces(_groundY, _h)) {
          // звезда горизонтально над поверхностью?
          if (_starX + _starSize * 0.3 > surf.left &&
              _starX - _starSize * 0.3 < surf.right) {
            // учитываем поверхность только если низ звезды уже выше верха платформы
            // (т.е. звезда подходит сверху, а не снизу)
            final starBottom = _starY + _starSize;
            if (surf.y < effectiveGround &&
                starBottom <= surf.y + _starSize * 0.6) {
              effectiveGround = surf.y + _starSize * _kStarGroundOffset;
            }
          }
        }
      }

      // ── Приземление ──────────────────────────────────────────────────────
      final groundTop = effectiveGround - _starSize;
      if (_starY >= groundTop && _starVY >= 0) {
        // условие выполняется каждый кадр, пока стоим — звук только при касании после полёта
        if (!_isOnGround) _playSfx(GameSfx.israelFall);
        _starY = groundTop;
        _starAngle = _jumpStartAngle + _kSpinPerJump * pi / 180;
        if (_pressing) {
          _jumpStartAngle = _starAngle;
          _starVY = _jumpVelocity;
          _isOnGround = false;
          _playSfx(GameSfx.israelJump);
        } else {
          _starVY = 0;
          _isOnGround = true;
        }
      } else if (_isOnGround && _starY < groundTop - 1) {
        // платформа ушла из-под ног — падаем
        _isOnGround = false;
      }

      // ── Коллизия — только смертельные шейпы ─────────────────────────────
      final starCX = _starX;
      final starCY = _starY + _starSize / 2;
      final R = _starSize / 2 * _kStarHitRadius;
      final r = R / sqrt(3);
      final starPoints = List.generate(12, (i) {
        final a = i * pi / 6 - pi / 2 + _starAngle;
        final rad = i.isEven ? R : r;
        return Offset(starCX + rad * cos(a), starCY + rad * sin(a));
      });

      bool dead = false;
      for (final o in _obstacles) {
        // смертельные треугольники/шипы
        for (final shape in o.deadlyShapes(_groundY, _h, _kTriHitInset)) {
          for (final p in starPoints) {
            final hit = shape.isTriangle
                ? _pointInTriangle(p, shape.apex, shape.bl, shape.br)
                : (p.dx > shape.left &&
                      p.dx < shape.right &&
                      p.dy > shape.top &&
                      p.dy < shape.bottom);
            if (hit) {
              dead = true;
              break;
            }
          }
          if (dead) break;
        }
        if (dead) break;
        // бок/низ платформы — тоже смерть
        for (final shape in o.solidSideShapes(_h)) {
          final onTop =
              _starY + _starSize <= shape.top + _starSize * 0.3 && _starVY >= 0;
          if (onTop) continue; // сверху — это приземление, не смерть
          for (final p in starPoints) {
            if (p.dx > shape.left &&
                p.dx < shape.right &&
                p.dy > shape.top &&
                p.dy < shape.bottom) {
              dead = true;
              break;
            }
          }
          if (dead) break;
        }
        if (dead) break;
      }
      // верхняя синяя полоска — смерть при касании снизу
      if (!dead && _topStripeShift < 1) {
        final topStripeBottom =
            _h *
            (_kStripe1EndYFrac +
                _kStripeHFrac * (1 - Curves.easeIn.transform(_topStripeShift)));
        if (_starY < topStripeBottom) dead = true;
      }

      if (dead && !_isInvincible) {
        _isDead = true;
        flagGameVibrate(context, 'Israel', 'lose');
        flagGameLossAd(context, 'Israel', isStillLost: () => _isDead);
        _playSfx(GameSfx.israelCrash);
        _audio.pauseBgm();
        _shakeTime = 0.4;
        _saveBestScore(_distance.toInt());
        _spawnParticles(starCX, starCY);
      }
    });
  }

  void _updateCoins(double speed, double dt) {
    for (final c in _coins) {
      c.x -= speed * dt;
      if (c.takenT >= 0) c.takenT += dt;
    }
    _coins.removeWhere((c) => c.x < -_kCoinSize || c.takenT > 0.35);

    // спавн в случайном месте пути
    if (_distance >= _nextCoinM) {
      _nextCoinM =
          _distance +
          _kCoinMinGap +
          _rng.nextDouble() * (_kCoinMaxGap - _kCoinMinGap);
      final x = _w + _kCoinSize;
      final standY = _groundY - _starSize / 2; // центр звезды на земле
      final jump = _jumpHeight; // высота прыжка на этом экране
      double? y;
      bool spikeNear = false;
      for (final o in _obstacles) {
        if (o.x > x + _kCoinSize || o.x + o.width < x - _kCoinSize) continue;
        if (o.type == _OType.platform) {
          final onPlat =
              o.platTop(_h) + _starSize * _kStarGroundOffset - _starSize / 2;
          y = onPlat - _rng.nextDouble() * jump * 0.7;
        } else {
          spikeNear = true;
        }
      }
      y ??= spikeNear
          ? standY -
                jump *
                    (0.65 +
                        _rng.nextDouble() * 0.3) // над шипом — по дуге прыжка
          : standY -
                (_rng.nextBool() ? 0 : jump * (0.3 + _rng.nextDouble() * 0.6));
      final minY =
          _h *
              (_kStripeHFrac * (1 - Curves.easeIn.transform(_topStripeShift))) +
          _kCoinSize;
      _coins.add(_Coin(x, max(y, minY)));
    }

    // подбор
    final cx = _starX, cy = _starY + _starSize / 2;
    final reach = _starSize * 0.45 + _kCoinSize * 0.4;
    for (final c in _coins) {
      if (c.takenT >= 0) continue;
      if ((Offset(c.x, c.y) - Offset(cx, cy)).distance < reach) {
        c.takenT = 0;
        _collectCoin(Offset(c.x, c.y));
      }
    }
  }

  void _collectCoin(Offset pos) {
    context.read<GamePreferencesCubit>().addMoney(_kCoinValue);
    context.read<IAudioCubit>().playSfx(GameSfx.moneyShort);
    final token = ++_moneyAnimToken;
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
      await layer.addMoneys(() => FlagGameViewport.toScreen(context, pos), _kCoinValue);
      await Future.delayed(const Duration(milliseconds: 900));
      // прячем только если за это время не подобрали новую монету
      if (mounted && token == _moneyAnimToken) await layer.hide();
    });
  }

  void _spawnParticles(double cx, double cy) {
    _particles.clear();
    const count = 18;
    for (int i = 0; i < count; i++) {
      final angle = _rng.nextDouble() * 2 * pi;
      final speed = 150 + _rng.nextDouble() * 400;
      _particles.add(
        _Particle(
          x: cx,
          y: cy,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed - 200,
          angle: _rng.nextDouble() * 2 * pi,
          spin: (_rng.nextDouble() - 0.5) * 20,
          size: _starSize * (0.08 + _rng.nextDouble() * 0.14),
          shape: _PShape.values[_rng.nextInt(_PShape.values.length)],
        ),
      );
    }
    // запускаем тикер только для частиц
    _ticker?.dispose();
    _lastTime = Duration.zero;
    _ticker = createTicker(_tickParticles)..start();
  }

  void _tickParticles(Duration elapsed) {
    if (_lastTime == Duration.zero) {
      _lastTime = elapsed;
      return;
    }
    final dt = (elapsed - _lastTime).inMicroseconds / 1e6;
    _lastTime = elapsed;
    setState(() {
      for (final p in _particles) {
        p.vy += 1200 * dt;
        p.x += p.vx * dt;
        p.y += p.vy * dt;
        p.angle += p.spin * dt;
        p.opacity = (p.opacity - dt * 1.2).clamp(0.0, 1.0);
      }
      _particles.removeWhere((p) => p.opacity <= 0);
      // тряска экрана: 0.4s, амплитуда затухает
      if (_shakeTime > 0) {
        _shakeTime = (_shakeTime - dt).clamp(0.0, double.infinity);
        const amp = 12.0;
        final t = _shakeTime;
        _shakeOffset = t > 0
            ? Offset(
                amp * t * (sin(t * 80) * 0.7 + sin(t * 120) * 0.3),
                amp * t * (sin(t * 60) * 0.5 + sin(t * 100) * 0.5),
              )
            : Offset.zero;
      }
      if (_particles.isEmpty && _shakeTime <= 0) _ticker?.stop();
    });
  }

  void _placeObstacle(_OType type, double screenX) {
    final size = switch (type) {
      _OType.spike => _kSpikeSize,
      _OType.tallspike => _kTallSpikeSize,
      _OType.doublespike => _kDoubleSpikeSize,
      _OType.platform => _kPlatformLength,
    };
    setState(() {
      final newId = _nextObsId++;
      _obstacles.add(_Obstacle(x: screenX, type: type, size: size, id: newId));
      _levelMap[newId] = _LevelItem(
        type: type,
        x: _levelFirstM + (screenX - (_w + 200 - _distance * 50)) / 50.0,
        size: size,
      );
      _selectedObsIdx = _obstacles.length - 1;
    });
  }

  void _handleEditorTap(Offset pos) {
    for (int i = _obstacles.length - 1; i >= 0; i--) {
      final o = _obstacles[i];
      final top = o.topY(_groundY, _h) - 20;
      if (pos.dx >= o.x - 20 &&
          pos.dx <= o.x + o.width + 20 &&
          pos.dy >= top &&
          pos.dy <= _groundY + 10) {
        setState(() => _selectedObsIdx = i);
        return;
      }
    }
    setState(() => _selectedObsIdx = -1);
  }

  void _saveFromObstacles() {
    final sorted = _levelMap.values.toList()
      ..sort((a, b) => a.x.compareTo(b.x));
    _saveLevel(sorted);
  }

  bool _pointInTriangle(Offset p, Offset a, Offset b, Offset c) {
    double sign(Offset p1, Offset p2, Offset p3) =>
        (p1.dx - p3.dx) * (p2.dy - p3.dy) - (p2.dx - p3.dx) * (p1.dy - p3.dy);
    final d1 = sign(p, a, b);
    final d2 = sign(p, b, c);
    final d3 = sign(p, c, a);
    final hasNeg = (d1 < 0) || (d2 < 0) || (d3 < 0);
    final hasPos = (d1 > 0) || (d2 > 0) || (d3 > 0);
    return !(hasNeg && hasPos);
  }

  void _onTap() {
    if (_editorOpen) return;
    if (!_gameStarted) {
      // intro not done yet — play it
      if (_introCtrl.isDismissed) {
        _introCtrl.forward().then((_) {
          if (!mounted) return;
          _initSizes(_w, _h);
          setState(() {
            _gameStarted = true;
          });
          _startGame();
        });
      }
      return;
    }

    if (_isDead) {
      _startGame();
      return;
    }

    // jump
    if (_isOnGround) {
      _playSfx(GameSfx.israelJump);
      setState(() {
        _jumpStartAngle = _starAngle;
        _starVY = _jumpVelocity;
        _isOnGround = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    if (_w != w || _h != h) {
      _initSizes(w, h);
      if (_gameStarted) {
        _starY = _groundY - _starSize;
      }
    }

    final stripeH = h * _kStripeHFrac;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: _kBgColor,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) {
              _pressing = true;
              _onTap();
            },
            onTapUp: (_) => _pressing = false,
            onTapCancel: () => _pressing = false,
            child: AnimatedBuilder(
              animation: _introAnim,
              builder: (context, _) {
                final t = _introAnim.value;

                final stripe1Y =
                    h * lerpDouble(_kStripe1YFrac, _kStripe1EndYFrac, t)!;
                final stripe2Y =
                    h * lerpDouble(_kStripe2YFrac, _kStripe2EndYFrac, t)!;

                // конечная позиция интро = позиция стоя на платформе
                final gameStarSize = w * _kStarEndSizeFrac;
                final gameStarCY =
                    h * _kStripe2EndYFrac +
                    gameStarSize * _kStarGroundOffset -
                    gameStarSize / 2;

                final starCX =
                    w * lerpDouble(_kStarCenterXFrac, _kStarEndXFrac, t)!;
                final starCY = _gameStarted
                    ? _starY + _starSize / 2
                    : lerpDouble(h * _kStarCenterYFrac, gameStarCY, t)!;
                final starSize =
                    w * lerpDouble(_kStarSizeFrac, _kStarEndSizeFrac, t)!;
                final starAngle = _gameStarted
                    ? _starAngle
                    : lerpDouble(0, _kStarEndAngleDeg * pi / 180, t)!;

                return Transform.translate(
                  offset: _shakeOffset,
                  child: Stack(
                    children: [
                      const Positioned.fill(
                        child: ColoredBox(color: _kBgColor),
                      ),

                      // ── Верхняя полоска ──────────────────────────────────────────
                      if (_topStripeShift < 1)
                        Positioned(
                          left: 0,
                          right: 0,
                          top:
                              stripe1Y -
                              stripeH *
                                  Curves.easeIn.transform(_topStripeShift),
                          height: stripeH,
                          child: const ColoredBox(color: _kStripeColor),
                        ),

                      // ── Нижняя полоска (платформа) ───────────────────────────────
                      Positioned(
                        left: 0,
                        right: 0,
                        top: stripe2Y,
                        height: stripeH,
                        child: const ColoredBox(color: _kStripeColor),
                      ),

                      // ── Препятствия ──────────────────────────────────────────────
                      if (_gameStarted)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _ObstaclePainter(
                              _obstacles,
                              _groundY,
                              _h,
                              _kStripeColor,
                              showHitboxes: _kShowHitboxes,
                              inset: _kTriHitInset,
                            ),
                          ),
                        ),

                      // ── Монеты ──────────────────────────────────────────────────
                      for (final c in _coins)
                        Positioned(
                          left: c.x - _kCoinSize / 2,
                          top:
                              c.y -
                              _kCoinSize / 2 -
                              (c.takenT >= 0 ? c.takenT * 120 : 0),
                          width: _kCoinSize,
                          height: _kCoinSize,
                          child: Opacity(
                            opacity: c.takenT >= 0
                                ? (1 - c.takenT / 0.35).clamp(0.0, 1.0)
                                : 1,
                            child: Transform.scale(
                              scale: c.takenT >= 0 ? 1 + c.takenT * 2.5 : 1,
                              child: Image.asset(
                                'assets/images/money.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                      // ── Частицы ─────────────────────────────────────────────────
                      if (_particles.isNotEmpty)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _ParticlePainter(_particles),
                          ),
                        ),

                      // ── Звезда Давида ────────────────────────────────────────────
                      if (!_isDead)
                        Positioned(
                          left: starCX - starSize / 2,
                          top: starCY - starSize / 2,
                          width: starSize,
                          height: starSize,
                          child: Transform.rotate(
                            angle: starAngle,
                            child: Image.asset(
                              '${_p}israel_star.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                      // ── Хитбокс звезды ───────────────────────────────────────────
                      if (_gameStarted && _kShowHitboxes)
                        Positioned(
                          left: starCX - starSize * _kStarHitRadius / 2,
                          top: starCY - starSize * _kStarHitRadius / 2,
                          width: starSize * _kStarHitRadius,
                          height: starSize * _kStarHitRadius,
                          child: Transform.rotate(
                            angle: _starAngle,
                            child: CustomPaint(painter: _StarHitboxPainter()),
                          ),
                        ),

                      // ── Рекорд ───────────────────────────────────────────────────
                      if (_bestScore > 0)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/winner_cup.png',
                                width: 26,
                                height: 26,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_bestScore}m',
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      // ── Счётчик дистанции ────────────────────────────────────────
                      if (_gameStarted)
                        Positioned(
                          top: _kScoreTop,
                          right: _kScoreRight,
                          child: Text(
                            '${_distance.toInt()}m',
                            style: TextStyle(
                              color: _kStripeColor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(color: Colors.black26, blurRadius: 4),
                              ],
                            ),
                          ),
                        ),

                      // ── Dead message ─────────────────────────────────────────────
                      if (_isDead)
                        Center(
                          child: Text(
                            'tap to retry',
                            style: TextStyle(
                              color: _kStripeColor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      // ── Back button ──────────────────────────────────────────────
                      // «Tap to start» — один раз, на первом открытом флаге
                      Positioned.fill(
                        child: FlagGameTapHint(visible: !_gameStarted && _introCtrl.isDismissed),
                      ),
                      const Positioned(top: 8, left: 8, child: FBackButton()),

                      // ── Кнопки управления (пауза, бессмертие, редактор) ─────────
                      // ── Редактор: палитра ────────────────────────────────────────
                      if (_editorOpen && _gameStarted)
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: _buildEditorPalette(),
                        ),

                      // ── Редактор: DragTarget на всю игровую область ──────────────
                      if (_editorOpen && _gameStarted)
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          right: 88,
                          child: DragTarget<_OType>(
                            onAcceptWithDetails: (d) {
                              final box =
                                  context.findRenderObject() as RenderBox?;
                              final local =
                                  box?.globalToLocal(d.offset) ?? d.offset;
                              _placeObstacle(d.data, local.dx);
                            },
                            builder: (ctx, cands, _) => GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTapDown: (d) =>
                                  _handleEditorTap(d.localPosition),
                              onPanStart: (d) {
                                for (
                                  int i = _obstacles.length - 1;
                                  i >= 0;
                                  i--
                                ) {
                                  final o = _obstacles[i];
                                  final top = o.topY(_groundY, _h) - 20;
                                  if (d.localPosition.dx >= o.x - 20 &&
                                      d.localPosition.dx <=
                                          o.x + o.width + 20 &&
                                      d.localPosition.dy >= top &&
                                      d.localPosition.dy <= _groundY + 10) {
                                    setState(() {
                                      _draggingObsIdx = i;
                                      _selectedObsIdx = i;
                                    });
                                    return;
                                  }
                                }
                              },
                              onPanUpdate: (d) {
                                if (_draggingObsIdx >= 0) {
                                  setState(() {
                                    final obs = _obstacles[_draggingObsIdx];
                                    obs.x += d.delta.dx;
                                    final item = _levelMap[obs.id];
                                    if (item != null)
                                      item.x += d.delta.dx / 50.0;
                                  });
                                }
                              },
                              onPanEnd: (_) =>
                                  setState(() => _draggingObsIdx = -1),
                              child: Container(
                                color: cands.isNotEmpty
                                    ? _kStripeColor.withOpacity(0.06)
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),

                      // ── Редактор: панель выбранного препятствия ──────────────────
                      if (_editorOpen &&
                          _selectedObsIdx >= 0 &&
                          _selectedObsIdx < _obstacles.length)
                        Positioned(
                          left: 0,
                          right: 88,
                          bottom: 0,
                          child: _buildSelectedObstaclePanel(),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ctrlBtn(
          icon: _isPaused ? Icons.play_arrow : Icons.pause,
          active: _isPaused,
          tooltip: _isPaused ? 'Resume' : 'Pause',
          onTap: () => setState(() => _isPaused = !_isPaused),
        ),
        const SizedBox(width: 6),
        _ctrlBtn(
          icon: Icons.shield,
          active: _isInvincible,
          tooltip: 'Invincibility',
          onTap: () => setState(() => _isInvincible = !_isInvincible),
        ),
        const SizedBox(width: 6),
        _ctrlBtn(
          icon: _editorOpen ? Icons.close : Icons.edit,
          active: _editorOpen,
          tooltip: _editorOpen ? 'Close editor' : 'Level editor',
          onTap: () => setState(() {
            _editorOpen = !_editorOpen;
            if (_editorOpen) {
              _isPaused = true;
            }
            if (!_editorOpen) _selectedObsIdx = -1;
          }),
        ),
        if (_editorOpen) ...[
          const SizedBox(width: 6),
          _ctrlBtn(
            icon: Icons.save,
            active: false,
            color: Colors.greenAccent.shade700,
            tooltip: 'Save level',
            onTap: () {
              _saveFromObstacles();
              setState(() {
                _editorOpen = false;
                _selectedObsIdx = -1;
                _draggingObsIdx = -1;
                // пауза снимается автоматически — объекты остаются на месте
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _ctrlBtn({
    required IconData icon,
    required bool active,
    required String tooltip,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: (color ?? _kStripeColor).withOpacity(active ? 0.95 : 0.65),
          borderRadius: BorderRadius.circular(8),
          border: active ? Border.all(color: Colors.white54, width: 1.5) : null,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildEditorPalette() {
    return Container(
      width: 88,
      color: Colors.black.withOpacity(0.75),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '↓ drag',
            style: TextStyle(color: Colors.white38, fontSize: 9),
          ),
          const SizedBox(height: 6),
          for (final type in _OType.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildDraggableCard(type),
            ),
          const Spacer(),
          if (_useCustomLevel)
            GestureDetector(
              onTap: () => setState(() {
                _obstacles.clear();
                _levelMap.clear();
                _selectedObsIdx = -1;
                _saveLevel([]);
              }),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.delete_sweep,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDraggableCard(_OType type) {
    final name = switch (type) {
      _OType.spike => 'Spike',
      _OType.tallspike => 'Tall',
      _OType.doublespike => 'Double',
      _OType.platform => 'Platf.',
    };
    final card = Container(
      width: 76,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: _kStripeColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: _kStripeColor.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 36,
            child: CustomPaint(
              painter: _PalettePreviewPainter(type: type, color: _kStripeColor),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
    return Draggable<_OType>(
      data: type,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(opacity: 0.85, child: card),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: card),
      child: card,
    );
  }

  Widget _buildSelectedObstaclePanel() {
    final o = _obstacles[_selectedObsIdx];
    final (minSize, maxSize) = switch (o.type) {
      _OType.platform => (80.0, 600.0),
      _ => (20.0, 150.0),
    };
    return Container(
      color: Colors.black.withOpacity(0.75),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Text(switch (o.type) {
            _OType.spike => 'Spike',
            _OType.tallspike => 'Tall spike',
            _OType.doublespike => 'Double spike',
            _OType.platform => 'Platform',
          }, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(width: 8),
          const Text(
            'Size:',
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
          Expanded(
            child: Slider(
              value: o.size.clamp(minSize, maxSize),
              min: minSize,
              max: maxSize,
              divisions: 100,
              activeColor: _kStripeColor,
              inactiveColor: _kStripeColor.withOpacity(0.2),
              onChanged: (v) => setState(() {
                o.size = v;
                _levelMap[o.id]?.size = v;
              }),
            ),
          ),
          Text(
            '${o.size.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => setState(() {
              final obsId = _obstacles[_selectedObsIdx].id;
              _obstacles.removeAt(_selectedObsIdx);
              _levelMap.remove(obsId);
              _selectedObsIdx = -1;
            }),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.delete,
                color: Colors.redAccent,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarHitboxPainter extends CustomPainter {
  const _StarHitboxPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final R = size.width / 2; // внешний радиус
    final r = R / sqrt(3); // внутренний радиус звезды Давида

    final path = Path();
    for (int i = 0; i < 12; i++) {
      final angle = i * pi / 6 - pi / 2; // старт сверху
      final rad = i.isEven ? R : r;
      final x = cx + rad * cos(angle);
      final y = cy + rad * sin(angle);
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarHitboxPainter _) => false;
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = _kStripeColor.withValues(alpha: p.opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.angle);

      final h = p.size;
      final w = p.size;

      final path = Path();
      switch (p.shape) {
        case _PShape.triangle:
          path
            ..moveTo(0, -h / 2)
            ..lineTo(w / 2, h / 2)
            ..lineTo(-w / 2, h / 2)
            ..close();
        case _PShape.rect:
          path.addRect(
            Rect.fromCenter(center: Offset.zero, width: w * 0.6, height: h),
          );
        case _PShape.diamond:
          path
            ..moveTo(0, -h / 2)
            ..lineTo(w / 2, 0)
            ..lineTo(0, h / 2)
            ..lineTo(-w / 2, 0)
            ..close();
      }
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

class _ObstaclePainter extends CustomPainter {
  final List<_Obstacle> obstacles;
  final double groundY;
  final double screenH;
  final Color color;
  final bool showHitboxes;
  final double inset;

  const _ObstaclePainter(
    this.obstacles,
    this.groundY,
    this.screenH,
    this.color, {
    required this.showHitboxes,
    required this.inset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final hbPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (final o in obstacles) {
      final s = o.size;
      final x = o.x;
      final gy = o.baseY(groundY, screenH);

      switch (o.type) {
        case _OType.spike:
          final sw = s * _kSpikeWidthScale;
          final sh = s * _kSpikeHeightScale;
          _drawTriangle(canvas, fill, x + sw / 2, gy - sh, x, gy, x + sw, gy);

        case _OType.tallspike:
          final tw = s * _kTallSpikeWidthScale;
          final th = s * _kTallSpikeHeightScale;
          _drawTriangle(canvas, fill, x + tw / 2, gy - th, x, gy, x + tw, gy);

        case _OType.doublespike:
          final ds = s * _kDSpikeScale;
          final gap = _kDSpikeGap;
          _drawTriangle(canvas, fill, x + ds / 2, gy - ds, x, gy, x + ds, gy);
          _drawTriangle(
            canvas,
            fill,
            x + ds + gap + ds / 2,
            gy - ds,
            x + ds + gap,
            gy,
            x + ds * 2 + gap,
            gy,
          );

        case _OType.platform:
          canvas.drawRect(
            Rect.fromLTWH(x, o.platTop(screenH), s, _kPlatformThickness),
            fill,
          );
      }

      if (showHitboxes) {
        // смертельные — красные
        for (final hs in o.deadlyShapes(groundY, screenH, inset)) {
          if (hs.isTriangle) {
            canvas.drawPath(
              Path()
                ..moveTo(hs.apex.dx, hs.apex.dy)
                ..lineTo(hs.bl.dx, hs.bl.dy)
                ..lineTo(hs.br.dx, hs.br.dy)
                ..close(),
              hbPaint,
            );
          } else {
            canvas.drawRect(
              Rect.fromLTRB(hs.left, hs.top, hs.right, hs.bottom),
              hbPaint,
            );
          }
        }
      }
    }
  }

  void _drawTriangle(
    Canvas c,
    Paint p,
    double ax,
    double ay,
    double bx,
    double by,
    double cx2,
    double cy,
  ) {
    c.drawPath(
      Path()
        ..moveTo(ax, ay)
        ..lineTo(bx, by)
        ..lineTo(cx2, cy)
        ..close(),
      p,
    );
  }

  @override
  bool shouldRepaint(_ObstaclePainter old) => true;
}

// ─── Palette Preview Painter ──────────────────────────────────────────────────

class _PalettePreviewPainter extends CustomPainter {
  final _OType type;
  final Color color;

  const _PalettePreviewPainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final gY = size.height - 8.0;
    final cx = size.width / 2;

    switch (type) {
      case _OType.spike:
        final w = size.width * 0.55;
        final h = size.height * 0.75;
        canvas.drawPath(
          Path()
            ..moveTo(cx, gY - h)
            ..lineTo(cx - w / 2, gY)
            ..lineTo(cx + w / 2, gY)
            ..close(),
          fill,
        );
      case _OType.tallspike:
        final w = size.width * 0.35;
        final h = size.height * 0.85;
        canvas.drawPath(
          Path()
            ..moveTo(cx, gY - h)
            ..lineTo(cx - w / 2, gY)
            ..lineTo(cx + w / 2, gY)
            ..close(),
          fill,
        );
      case _OType.doublespike:
        final w = size.width * 0.4;
        final h = size.height * 0.65;
        for (final ox in [size.width * 0.22, size.width * 0.62]) {
          canvas.drawPath(
            Path()
              ..moveTo(ox, gY - h)
              ..lineTo(ox - w / 2, gY)
              ..lineTo(ox + w / 2, gY)
              ..close(),
            fill,
          );
        }
      case _OType.platform:
        canvas.drawRect(
          Rect.fromLTWH(
            4,
            size.height * 0.35,
            size.width - 8,
            size.height * 0.18,
          ),
          fill,
        );
    }

    // ground line
    canvas.drawLine(
      Offset(0, gY + 2),
      Offset(size.width, gY + 2),
      Paint()
        ..color = color.withOpacity(0.4)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_PalettePreviewPainter old) => false;
}
