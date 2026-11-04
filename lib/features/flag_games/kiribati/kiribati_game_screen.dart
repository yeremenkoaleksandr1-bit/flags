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
import 'package:flags/uikit/components/buttons/actions/back_button.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double _kMusicVolume = 0.6; // фоновая музыка (по кругу, с начала игры)

const String _p = 'assets/images/flag_games/kiribati/';

const Color _kBgColor = Color(0xFFC81010);

// ── Ручные настройки объектов ─────────────────────────────────────────────────
// X/Y — центр объекта в долях экрана (0 = левый/верхний край, 1 = правый/нижний)
// W   — ширина объекта в долях ширины экрана (высота считается по пропорциям картинки)

// Солнце
const double _kSunX = 0.5;
const double _kSunY = 0.5;
const double _kSunW = 0.28;

// Птица
const double _kBirdX = 0.5;
const double _kBirdY = 0.11;
const double _kBirdW = 0.26;

// Море (верхний слой). Привязано к нижнему краю экрана.
const double _kSeaX = 0.5;
const double _kSeaW = 1.0;
const double _kSeaBottom =
    -0.04; // отступ от нижнего края в долях высоты экрана
const double _kSeaSpeed =
    0.015; // скорость ленты вправо (доли ширины экрана в секунду)
const double _kSeaBobAmp =
    0.012; // амплитуда качания вверх-вниз (доли высоты экрана)
const double _kSeaBobPeriod = 4.0; // период качания (сек)

// При старте море и солнце плавно опускаются
const double _kStartDrop = 0.08; // на сколько (доли высоты экрана)
const double _kSunStartDrop = 0.11; // на сколько опускается солнце
const double _kStartDropDur = 1.2; // за сколько секунд

// Взмахи крыльев
const double _kBirdFlapFps = 8.0; // кадров в секунду у главной птицы

const double _kBirdFlySpeed =
    0.05; // скорость, с которой главная птица улетает влево (доли ширины/сек)

// Случайные птицы (вылетают из боковых краёв)
const double _kFlySpawnMin = 1.5; // мин. пауза между появлениями (сек)
const double _kFlySpawnMax = 4.5; // макс. пауза (сек)
const double _kFlySizeMin = 0.05; // мин. ширина (доли ширины экрана)
const double _kFlySizeMax = 0.16; // макс. ширина
const double _kFlySpeedMin =
    0.06; // мин. скорость (доли ширины экрана в секунду)
const double _kFlySpeedMax = 0.09; // макс. скорость
const double _kFlyYMin = 0.05; // по высоте — от (доли высоты экрана)
const double _kFlyYMax = 0.55; // до

// Кадры взмаха: 1 — крылья вверх, 5 — вниз. Размеры картинок в px.
const _kBirdFrames = [
  (865.0, 306.0),
  (894.0, 265.0),
  (878.0, 246.0),
  (872.0, 217.0),
  (844.0, 189.0),
];
const _kFlapOrder = [0, 1, 2, 3, 4, 3, 2, 1];
const double _kBirdRefW = 894; // ширина кадра 2 — по нему задан размер птицы

// Подбитые птицы
const _kDeadFrames = [
  ('kiribati_bird_dead', 451.0, 389.0),
  ('kiribati_bird_dead1', 423.0, 395.0),
  ('kiribati_bird_dead2', 236.0, 388.0),
];
const double _kDeadGravity = 1.6; // ускорение падения (доли высоты экрана/сек²)
const double _kDeadSpin = 0.6; // скорость вращения при падении (рад/сек)
const double _kDeadScale = 1.2; // размер мёртвой птицы относительно летящей
const double _kBloodSize = 0.16; // размер пятна (доли ширины мёртвой птицы)
// Деньги за убийства (сколько начисляется: случайно от min до max)
const double _kMoneyChance = 0.10; // шанс денег за одиночное убийство
const int _kMoneySingleMin = 10, _kMoneySingleMax = 20;
const int _kMoneyDoubleMin = 30, _kMoneyDoubleMax = 45; // двойное — всегда
const int _kMoneyTripleMin = 70, _kMoneyTripleMax = 100; // тройное — всегда

const int _kMaxKillsPerShot = 3; // сколько птиц максимум за один выстрел
const double _kHitMargin = 12.0; // запас попадания вокруг птицы (px)

// ── Хитбоксы птиц ─────────────────────────────────────────────────────────────
const bool _kShowHitboxes = false; // рисовать хитбоксы
// Все размеры — в долях ширины птицы. OffX/OffY — сдвиг центра хитбокса от
// центра птицы (OffX > 0 — к хвосту; при полёте вправо зеркалится автоматически).
const double _kBirdHitW = 0.8;
const double _kBirdHitH = 0.25;
const double _kBirdHitOffX = 0.0;
const double _kBirdHitOffY = 0.0;
const double _kPeaceHitW = 0.85;
const double _kPeaceHitH = 0.85;
const double _kPeaceHitOffX = 0.0;
const double _kPeaceHitOffY = 0.0;

class _DeadBird {
  final double x; // центр, доли ширины
  double y; // центр, доли высоты
  double vy = 0; // доли высоты/сек
  double angle = 0;
  final double width; // ширина летящей птицы, доли ширины
  final bool faceRight;
  final int sprite;
  final double spin;
  final Offset
  hit; // точка попадания относительно центра, доли размера птицы (-0.5..0.5)
  final int seed;
  final bool peace;
  _DeadBird(
    this.x,
    this.y,
    this.width,
    this.faceRight,
    this.sprite,
    this.spin,
    this.hit,
    this.seed, {
    this.peace = false,
  });
}

// Нарастание сложности
const double _kSpawnRamp = 0.03; // ускорение спавна за каждое убийство
const double _kFlySpawnFloor = 0.45; // пауза между появлениями не меньше (сек)
const int _kFancyAfterKills =
    15; // после скольких убийств появляются хитрые траектории
const double _kFancyChance = 0.45; // доля птиц с диагональю/зигзагом
const double _kDiagSlope = 0.45; // наклон диагонали (верт. скорость / гориз.)
const double _kZigAmp = 0.08; // амплитуда зигзага (доли высоты)
const double _kZigPeriod = 1.4; // период зигзага (сек)

enum _FlyPath { straight, diagonal, zigzag }

// ── Голубь мира — убил его, проиграл ──────────────────────────────────────────
const int _kPeaceAfterKills = 10; // после скольких убийств появляется
const double _kPeaceChance =
    0.15; // доля появлений, когда вместо птицы — голубь
const double _kPeaceScale = 0.9; // размер голубя относительно обычной птицы
const int _kPeaceFrames = 7; // кадры peace_bird/bird0..bird6, по кругу
const double _kPeaceFps = 10.0;
const double _kPeaceDeadScale =
    0.65; // размер мёртвого голубя (доля ширины живого × _kDeadScale)
const double _kPeaceDeadW = 783, _kPeaceDeadH = 1037;
const double _kGameOverDim = 0.6; // затемнение экрана при проигрыше (0..1)
const double _kGameOverFade = 0.5; // за сколько секунд затемняется
// Улетевшие птицы
const int _kMaxEscaped = 3; // сколько птиц может улететь до проигрыша
const double _kEscapeMarkSize = 36.0; // размер красного крестика (px)
const double _kEscapeMarkInset = 10.0; // отступ крестика от края экрана (px)

const double _kRetryDelay =
    0.8; // через сколько секунд после проигрыша можно рестартить

class _Casing {
  double x, y, vx, vy, angle; // px, px/сек
  final double spin;
  _Casing(this.x, this.y, this.vx, this.vy, this.spin) : angle = 0;
}

class _FlyBird {
  double x; // центр, доли ширины
  double y; // центр, доли высоты
  double baseY; // линия полёта (для диагонали — двигается)
  final double size; // ширина, доли ширины
  final double vx; // доли ширины/сек; > 0 — летит вправо
  double vy; // для диагонали, доли высоты/сек
  final double fps;
  final double phase;
  final _FlyPath path;
  final bool peace;
  double t = 0;
  _FlyBird(
    this.x,
    this.y,
    this.size,
    this.vx,
    this.fps,
    this.phase, {
    this.path = _FlyPath.straight,
    this.vy = 0,
    this.peace = false,
  }) : baseY = y;
}

// ── Оружие ────────────────────────────────────────────────────────────────────
const double _kGunW =
    0.75; // ширина (доли ширины экрана), картинка 1920x1920, расчёты по верхней части 1920x1080
const double _kGunX = 0.62; // центр по X в начальном положении (доли ширины)
const double _kGunBottom =
    -0.4; // низ оружия относительно низа экрана (доли высоты, < 0 — ниже края)
const double _kGunAppear = 0.6; // время выезда снизу (сек)
// Зона перемещения считается так, чтобы прицел доставал до любой точки экрана.
// Запас — насколько прицел может выйти за край экрана (px).
const double _kAimEdgeMargin = 0.0;

// Отдача
const double _kRecoilDist = 0.06; // откат вниз-вправо (доли высоты экрана)
const double _kRecoilAngle = 0.1; // подброс ствола (радианы)
const int _kRecoilMs = 300; // длительность отдачи

// Прицел — положение относительно левого верхнего угла картинки оружия
// (доли ширины/высоты картинки). Мушка на картинке — примерно (0.407, 0.03).
const double _kAimDX = 0.227;
const double _kAimDY = -0.16;
const double _kAimSize = 22.0; // размер прицела (px)

// Огонь выстрела (kiribati_fire_shot, 796x639). Основание пламени на картинке —
// правый нижний угол, пламя идёт влево-вверх по стволу.
const double _kFireDX =
    0.47; // точка появления относительно оружия (доли ширины картинки оружия)
const double _kFireDY =
    0.03; // (доли высоты картинки оружия) — по умолчанию мушка
const double _kFireW = 0.12; // ширина огня (доли ширины оружия)
const int _kFireFrames = 4; // кадров: обычный / отзеркаленный по очереди
const int _kFireFrameMs = 20; // длительность кадра
const double _kFireBaseX = 0.98; // основание пламени на картинке огня (доли)
const double _kFireBaseY = 0.93;
const double _kAimKickX =
    0.04; // отскок прицела при выстреле вправо (доли ширины экрана)
const double _kAimKickY = 0.09; // отскок прицела вверх (доли высоты экрана)

// Кнопка выстрела
const double _kFireSize = 84.0; // диаметр (px)
const double _kFireRight = 68.0; // отступ справа (px)
const double _kFireBottom = 68.0; // отступ снизу (px)

// Звук
const double _kSeaVolume = 0.5; // фоновое море (зациклено)
const double _kShotVolume = 1.0; // выстрелы shot1/shot2
const double _kSfxVolume = 1.0; // no_ammo, reload_ammo, reload
const double _kSplashVolume = 1.0; // всплеск при выстреле в море
const double _kSeaSurfaceFrac =
    0.16; // поверхность моря на картинке (доля её высоты сверху)
const Duration _kNoAmmoDelay = Duration(
  milliseconds: 250,
); // no_ammo после последнего выстрела
const Duration _kReloadDoneDelay = Duration(
  milliseconds: 120,
); // reload после последнего патрона

// Патроны и перезарядка
const double _kShotCooldown = 0.25; // задержка между выстрелами (сек)
const int _kMagazine = 6; // патронов в дробовике
const double _kReloadTime = 4.0; // через сколько оружие возвращается (сек)
const double _kGunHideDelay = 0.25; // пауза перед тем, как оружие уедет вниз
const double _kGunHideDur = 0.4; // время, за которое оружие уезжает вниз
const double _kReloadBtnSize = 60.0; // кнопка перезарядки (px)
const double _kReloadBtnGap = 14.0; // расстояние над кнопкой выстрела (px)
// Вылет гильзы
const double _kEjectDX =
    0.62; // точка вылета относительно оружия (доли ширины картинки оружия)
const double _kEjectDY =
    0.27; // (доли высоты картинки оружия) — по умолчанию окно ствольной коробки
const double _kEjectDelay = 0.12; // через сколько после выстрела вылетает (сек)
const double _kEjectVX = 0.35; // скорость вправо (доли высоты экрана/сек)
const double _kEjectVY = -0.9; // скорость вверх (< 0 — вверх)
const double _kEjectSpread = 0.25; // случайный разброс скорости
const double _kEjectGravity = 3.0; // гравитация (доли высоты экрана/сек²)
const double _kEjectSpin = 12.0; // вращение (рад/сек)
const double _kEjectScale = 1.3; // размер гильзы относительно иконки патрона

const double _kShellW = 14.0; // иконка патрона (px)
const double _kShellH = 34.0;
const double _kShellGap = 6.0;
const double _kShellsBottom = 14.0; // отступ ряда патронов снизу (px)

// Картинка моря повторяется без шва с периодом 1575px из 1920px
const double _kSeaTileFrac = 1575 / 1920;

@RoutePage()
class KiribatiGameScreen extends StatefulWidget implements AutoRouteWrapper {
  // игра строится на «экране Pixel 10» и масштабируется под реальный экран
  @override
  Widget wrappedRoute(BuildContext context) =>
      FlagGameViewport(background: _kBgColor, child: this);

  const KiribatiGameScreen({super.key});

  @override
  State<KiribatiGameScreen> createState() => _KiribatiGameScreenState();
}

class _KiribatiGameScreenState extends State<KiribatiGameScreen>
    with TickerProviderStateMixin, FlagGameBackgroundPause<KiribatiGameScreen> {
  late final AnimationController _recoil = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: _kRecoilMs),
  )..addListener(() => setState(() {}));
  Offset _gunDrag = Offset.zero; // смещение оружия пальцем (px)
  double _gunTime = -1; // время с появления оружия, < 0 — ещё не появилось

  late final Ticker _ticker = createTicker(_tick);
  Duration _last = Duration.zero;

  // ── Пауза, пока приложение свёрнуто ──
  bool _tickerWasActive = false;

  @override
  void onAppHidden() {
    _tickerWasActive = _ticker.isActive;
    if (_tickerWasActive) _ticker.stop();
    pausePlayingPlayers([_seaPlayer]);
  }

  @override
  void onAppShown() {
    if (_tickerWasActive && mounted) {
      // новый отсчёт времени — первый кадр после возврата без скачка
      _last = Duration.zero;
      _ticker.start();
    }
    resumePausedPlayers();
  }
  double _seaOffset = 0; // в долях ширины экрана
  double _time = 0;
  final _rng = Random();
  final List<_FlyBird> _flyBirds = [];
  double _nextSpawn = 0.5;
  int _ammo = _kMagazine;
  int _shellsShown = _kMagazine; // для звука на каждый появившийся патрон
  AudioPlayer? _seaPlayer;
  bool _seaReady = false; // звук моря загружен в плеер
  double _seaSurfaceY = 0; // Y поверхности моря (px), для выстрела в море
  double _reloadT = -1; // >= 0 — идёт перезарядка
  double _reloadDur = _kReloadTime;
  int _reloadFrom = 0; // сколько патронов было в начале перезарядки
  double _lastShot = -10;
  double _mainBirdDx = 0; // смещение главной птицы, доли ширины
  bool _mainBirdAlive = true;
  int _kills = 0;
  final List<_Casing> _casings = [];
  final List<double> _pendingEjects = []; // таймеры до вылета гильз
  Offset _gunOrigin = Offset.zero; // левый верхний угол оружия без отдачи (px)
  int _moneyAnimToken = 0;
  double _gameOverTime = -1; // >= 0 — проиграл, сколько секунд назад
  String _gameOverText = '';
  final List<(bool, double)> _escapes = []; // (правый край?, y в долях высоты)
  int _bestKills = 0;
  static const _kBestScoreKey = 'kiribati_best_score';
  final List<_DeadBird> _deadBirds = [];
  Offset _aimRest = Offset.zero; // точка прицела без отдачи (px)
  Size _screen = Size.zero;

  void _tick(Duration elapsed) {
    final dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    setState(() {
      _seaOffset += _kSeaSpeed * dt;
      _time += dt;
      if (_gunTime >= 0) _gunTime += dt;
      if (_reloadT >= 0) {
        _reloadT += dt;
        if (_reloadT >= _reloadDur) {
          _reloadT = -1;
          _ammo = _kMagazine;
          _gunTime = 0; // снова выезжает снизу
          // после звука последнего патрона — звук готовности
          Future.delayed(_kReloadDoneDelay, () {
            if (mounted) _audio.playSfx(GameSfx.reload, volume: _kSfxVolume);
          });
        }
      }
      final shown = _shownAmmo;
      if (shown > _shellsShown) {
        _audio.playSfx(GameSfx.reloadAmmo, volume: _kSfxVolume);
      }
      _shellsShown = shown;
      if (_mainBirdDx > -1) _mainBirdDx -= _kBirdFlySpeed * dt;
      for (final b in _flyBirds) {
        b.x += b.vx * dt;
        b.t += dt;
        switch (b.path) {
          case _FlyPath.straight:
            break;
          case _FlyPath.diagonal:
            b.baseY += b.vy * dt;
            // отскок от границ зоны полёта
            if (b.baseY < _kFlyYMin && b.vy < 0 ||
                b.baseY > _kFlyYMax && b.vy > 0) {
              b.vy = -b.vy;
            }
            b.y = b.baseY;
          case _FlyPath.zigzag:
            // треугольная волна — резкие повороты, как зигзаг
            final ph = (b.t / _kZigPeriod + b.phase) % 1.0;
            final tri = ph < 0.5 ? ph * 4 - 1 : 3 - ph * 4;
            b.y = b.baseY + tri * _kZigAmp;
        }
      }
      _flyBirds.removeWhere((b) {
        final out = b.x < -b.size || b.x > 1 + b.size;
        if (out && !b.peace && _gameOverTime < 0) {
          _escapes.add((b.vx > 0, b.y));
          if (_escapes.length >= _kMaxEscaped) {
            _gameOverTime = 0;
            _gameOverText = '$_kMaxEscaped birds escaped';
            flagGameVibrate(context, 'Kiribati', 'lose (birds escaped)');
            flagGameLossAd(
              context,
              'Kiribati',
              isStillLost: () => _gameOverTime >= 0,
            );
            _audio.pauseBgm();
          }
        }
        return out;
      });
      for (final d in _deadBirds) {
        d.vy += _kDeadGravity * dt;
        d.y += d.vy * dt;
        d.angle += d.spin * dt;
      }
      _deadBirds.removeWhere((d) => d.y > 1.3);
      for (var i = _pendingEjects.length - 1; i >= 0; i--) {
        _pendingEjects[i] -= dt;
        if (_pendingEjects[i] <= 0) {
          _pendingEjects.removeAt(i);
          _ejectCasing();
        }
      }
      final hpx = _screen.height;
      for (final c in _casings) {
        c.vy += _kEjectGravity * hpx * dt;
        c.x += c.vx * dt;
        c.y += c.vy * dt;
        c.angle += c.spin * dt;
      }
      _casings.removeWhere((c) => c.y > hpx + 50 || c.x > _screen.width + 50);
      if (_gameOverTime >= 0) _gameOverTime += dt;
      _nextSpawn -= dt;
      if (_nextSpawn <= 0 && _gameOverTime < 0) {
        _nextSpawn = max(
          _kFlySpawnFloor,
          (_kFlySpawnMin +
                  _rng.nextDouble() * (_kFlySpawnMax - _kFlySpawnMin)) /
              (1 + _kills * _kSpawnRamp),
        );
        _spawnBird();
      }
    });
  }

  double _lerp(double a, double b) => a + _rng.nextDouble() * (b - a);

  void _spawnBird() {
    final peace =
        _kills >= _kPeaceAfterKills && _rng.nextDouble() < _kPeaceChance;
    final size = _lerp(_kFlySizeMin, _kFlySizeMax) * (peace ? _kPeaceScale : 1);
    final fromLeft = _rng.nextBool();
    final speed = _lerp(_kFlySpeedMin, _kFlySpeedMax);
    var path = _FlyPath.straight;
    if (_kills >= _kFancyAfterKills && _rng.nextDouble() < _kFancyChance) {
      path = _rng.nextBool() ? _FlyPath.diagonal : _FlyPath.zigzag;
    }
    final y = path == _FlyPath.zigzag
        ? _lerp(_kFlyYMin + _kZigAmp, _kFlyYMax - _kZigAmp)
        : _lerp(_kFlyYMin, _kFlyYMax);
    // диагональ направлена к середине зоны полёта, чтобы птица её пересекла
    final mid = (_kFlyYMin + _kFlyYMax) / 2;
    final vy = path == _FlyPath.diagonal
        ? (y < mid ? 1 : -1) * speed * _kDiagSlope * _screenAspect
        : 0.0;
    _flyBirds.add(
      _FlyBird(
        fromLeft ? -size / 2 : 1 + size / 2,
        y,
        size,
        fromLeft ? speed : -speed,
        _lerp(5, 9),
        _rng.nextDouble(),
        path: path,
        vy: vy,
        peace: peace,
      ),
    );
  }

  // Голубь: квадратные кадры 1000x1000, голова слева — при полёте вправо отражаем
  Widget _peaceFrame(_FlyBird b, double w, double h) {
    final frame =
        ((_time * _kPeaceFps + b.phase * _kPeaceFrames).floor()) %
        _kPeaceFrames;
    final size = b.size * w;
    return Positioned(
      key: ObjectKey(b),
      left: b.x * w - size / 2,
      top: b.y * h - size / 2,
      width: size,
      height: size,
      child: Transform.flip(
        flipX: b.vx > 0,
        child: Image.asset(
          '${_p}peace_bird/bird$frame.png',
          fit: BoxFit.contain,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  // скорость в долях ширины → доли высоты
  double get _screenAspect =>
      _screen.height > 0 ? _screen.width / _screen.height : 2;

  // Кадр взмаха. width — ширина птицы (по кадру 2), левый край и низ фиксированы,
  // чтобы тело не прыгало между кадрами разной высоты.
  // Голова на спрайтах слева, поэтому при полёте вправо отражаем.
  Widget _birdFrame(
    Key key,
    int frame,
    double left,
    double bottomY,
    double width,
    bool faceRight,
  ) {
    final (fw, fh) = _kBirdFrames[frame];
    final fwPx = width * fw / _kBirdRefW;
    final fhPx = fwPx * fh / fw;
    return Positioned(
      key: key,
      left: faceRight ? left + width - fwPx : left,
      top: bottomY - fhPx,
      width: fwPx,
      height: fhPx,
      child: Transform.flip(
        flipX: faceRight,
        child: Image.asset(
          '${_p}kiribati_bird${frame + 1}.png',
          fit: BoxFit.fill,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  int _frameAt(double fps, double phase) =>
      _kFlapOrder[((_time * fps + phase).floor()) % _kFlapOrder.length];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var i = 1; i <= 5; i++) {
      precacheImage(AssetImage('${_p}kiribati_bird$i.png'), context);
    }
    precacheImage(AssetImage('${_p}kiribati_fire_shot.png'), context);
    precacheImage(AssetImage('${_p}peace_bird_dead.png'), context);
    for (var i = 0; i < _kPeaceFrames; i++) {
      precacheImage(AssetImage('${_p}peace_bird/bird$i.png'), context);
    }
    for (final (name, _, _) in _kDeadFrames) {
      precacheImage(AssetImage('$_p$name.png'), context);
    }
  }

  void _restart() {
    // музыка после проигрыша — снова с начала трека
    _audio.playBgm(GameMusics.kiribati, volume: _kMusicVolume, fromStart: true);
    setState(() {
      _gameOverTime = -1;
      _escapes.clear();
      _kills = 0;
      _flyBirds.clear();
      _deadBirds.clear();
      _casings.clear();
      _pendingEjects.clear();
      _nextSpawn = 0.5;
      _gunDrag = Offset.zero;
      _recoil.reset();
      _ammo = _kMagazine;
      _shellsShown = _kMagazine;
      _reloadT = -1;
    });
  }

  // фоновая музыка по кругу — запускается один раз при старте игры и играет
  // и после рестартов; при выходе в список флагов её останавливает releaseGameAudio
  bool _musicStarted = false;

  void _startMusic() {
    if (_musicStarted) return;
    _musicStarted = true;
    _audio.playBgm(GameMusics.kiribati, volume: _kMusicVolume, fromStart: true);
    if (_seaReady) _seaPlayer?.resume();
  }

  void _onTap() {
    _startMusic();
    if (_gameOverTime >= _kRetryDelay) {
      _restart();
      return;
    }
    if (!_ticker.isActive) _ticker.start();
    if (_gunTime < 0) _gunTime = 0;
  }

  Rect _hitRect(
    double cx,
    double cy,
    double width,
    bool faceRight, {
    bool peace = false,
  }) {
    final bw = width * _screen.width;
    final dir = faceRight ? -1.0 : 1.0;
    return Rect.fromCenter(
      center: Offset(
        cx * _screen.width +
            dir * bw * (peace ? _kPeaceHitOffX : _kBirdHitOffX),
        cy * _screen.height + bw * (peace ? _kPeaceHitOffY : _kBirdHitOffY),
      ),
      width: bw * (peace ? _kPeaceHitW : _kBirdHitW),
      height: bw * (peace ? _kPeaceHitH : _kBirdHitH),
    );
  }

  bool _aimHits(
    double cx,
    double cy,
    double width,
    bool faceRight, {
    bool peace = false,
  }) => _hitRect(
    cx,
    cy,
    width,
    faceRight,
    peace: peace,
  ).inflate(_kHitMargin).contains(_aimRest);

  List<Widget> _buildHitboxes() {
    final rects = <(Rect, bool)>[
      for (final b in _flyBirds)
        (_hitRect(b.x, b.y, b.size, b.vx > 0, peace: b.peace), b.peace),
      if (_mainBirdAlive)
        (_hitRect(_kBirdX + _mainBirdDx, _kBirdY, _kBirdW, false), false),
    ];
    return [
      for (final (i, (r, peace)) in rects.indexed)
        Positioned.fromRect(
          key: ValueKey('hb$i'),
          rect: r,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: peace ? Colors.greenAccent : Colors.cyanAccent,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadBest();
    _audio = context.read<IAudioCubit>();
    _initSounds();
  }

  late final IAudioCubit _audio;

  static const _kGameSounds = [
    GameSfx.shot1,
    GameSfx.shot2,
    GameSfx.noAmmo,
    GameSfx.reloadAmmo,
    GameSfx.reload,
    GameSfx.waterSplash,
    GameSfx.waterSplash2,
    GameSfx.moneyShort,
    GameSfx.money,
  ];

  Future<void> _initSounds() async {
    await FlameAudio.audioCache.loadAll(
      _kGameSounds.map((s) => s.file).toList(),
    );
    if (!mounted || _audio.state.muted) return;
    // прогреваем пулы плееров, чтобы первый выстрел не запаздывал
    for (final sfx in _kGameSounds) {
      _audio.playSfx(sfx, volume: 0);
    }
    // море — отдельный зацикленный плеер (длинный mp3 → mediaPlayer)
    final sea = AudioPlayer()..audioCache = FlameAudio.audioCache;
    _seaPlayer = sea;
    try {
      // mixWithOthers: не забираем аудиофокус у других звуков
      await sea.setAudioContext(
        AudioContextConfig(
          focus: AudioContextConfigFocus.mixWithOthers,
        ).build(),
      );
      await sea.setPlayerMode(PlayerMode.mediaPlayer);
      await sea.setReleaseMode(ReleaseMode.loop);
      await sea.setVolume(_kSeaVolume);
      await sea.setSource(AssetSource(GameSfx.seaSound.file));
      if (!mounted) return;
      _seaReady = true;
      // море — только после старта игры; если тап был раньше загрузки, включаем здесь
      if (_musicStarted) await sea.resume();
    } catch (e) {
      debugPrint('Kiribati sea sound error: $e');
    }
  }

  Future<void> _loadBest() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => _bestKills = prefs.getInt(_kBestScoreKey) ?? 0);
  }

  Future<void> _saveBest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kBestScoreKey, _bestKills);
  }

  void _killBird(
    double x,
    double y,
    double width,
    bool faceRight, {
    bool peace = false,
  }) {
    if (peace) {
      _gameOverTime = 0;
      _gameOverText = 'You killed the bird of peace';
      flagGameVibrate(context, 'Kiribati', 'lose (bird of peace)');
      flagGameLossAd(
        context,
        'Kiribati',
        isStillLost: () => _gameOverTime >= 0,
      );
      _audio.pauseBgm();
    } else {
      _kills++;
      if (_kills > _bestKills) {
        _bestKills = _kills;
        _saveBest();
      }
    }
    final bw = width * _screen.width;
    final bh = bw * (peace ? _kPeaceHitH : _kBirdHitH);
    // переносим точку попадания на мёртвый спрайт, прижимая к телу
    final hit = Offset(
      ((_aimRest.dx - x * _screen.width) / bw).clamp(-0.5, 0.5) * 0.6,
      ((_aimRest.dy - y * _screen.height) / bh).clamp(-0.5, 0.5) * 0.6,
    );
    _deadBirds.add(
      _DeadBird(
        x,
        y,
        width,
        faceRight,
        _rng.nextInt(_kDeadFrames.length),
        (_rng.nextBool() ? 1 : -1) * _kDeadSpin * (0.5 + _rng.nextDouble()),
        hit,
        _rng.nextInt(1 << 30),
        peace: peace,
      ),
    );
  }

  void _shootBirds() {
    if (_gunTime < 0 || _gameOverTime >= 0) return;
    // дробь задевает всех птиц под прицелом, но не больше _kMaxKillsPerShot
    var hits = 0;
    var peaceHit = false;
    final killedAt = <Offset>[];
    for (final b in List.of(_flyBirds.reversed)) {
      if (hits >= _kMaxKillsPerShot) break;
      if (_aimHits(b.x, b.y, b.size, b.vx > 0, peace: b.peace)) {
        _flyBirds.remove(b);
        _killBird(b.x, b.y, b.size, b.vx > 0, peace: b.peace);
        hits++;
        peaceHit |= b.peace;
        killedAt.add(Offset(b.x * _screen.width, b.y * _screen.height));
      }
    }
    if (hits < _kMaxKillsPerShot &&
        _mainBirdAlive &&
        _aimHits(_kBirdX + _mainBirdDx, _kBirdY, _kBirdW, false)) {
      _mainBirdAlive = false;
      _killBird(_kBirdX + _mainBirdDx, _kBirdY, _kBirdW, false);
      hits++;
      killedAt.add(
        Offset(
          (_kBirdX + _mainBirdDx) * _screen.width,
          _kBirdY * _screen.height,
        ),
      );
    }
    if (hits > 0 && !peaceHit) _dropMoney(killedAt);
  }

  int _randInt(int a, int b) => a + _rng.nextInt(b - a + 1);

  void _dropMoney(List<Offset> killedAt) {
    final int amount;
    switch (killedAt.length) {
      case 1:
        if (_rng.nextDouble() >= _kMoneyChance) return;
        amount = _randInt(_kMoneySingleMin, _kMoneySingleMax);
      case 2:
        amount = _randInt(_kMoneyDoubleMin, _kMoneyDoubleMax);
      default:
        amount = _randInt(_kMoneyTripleMin, _kMoneyTripleMax);
    }
    context.read<GamePreferencesCubit>().addMoney(amount);
    context.read<IAudioCubit>().playSfx(
      amount > 20 ? GameSfx.money : GameSfx.moneyShort,
    );
    final token = ++_moneyAnimToken;
    // монетки по очереди вылетают из места каждой убитой птицы
    var next = 0;
    Offset from() => killedAt[next++ % killedAt.length];
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
      await layer.addMoneys(() => FlagGameViewport.toScreen(context, from()), amount.clamp(1, 30));
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted && token == _moneyAnimToken) await layer.hide();
    });
  }

  Widget _deadBirdWidget(_DeadBird d, double w, double h) {
    final (name, fw, fh) = d.peace
        ? ('peace_bird_dead', _kPeaceDeadW, _kPeaceDeadH)
        : _kDeadFrames[d.sprite];
    // тот же масштаб пикселей, что у летящей птицы
    final dw = d.peace
        ? d.width * w * _kDeadScale * _kPeaceDeadScale
        : d.width * w * fw / _kBirdRefW * _kDeadScale;
    final dh = dw * fh / fw;
    return Positioned(
      key: ObjectKey(d),
      left: d.x * w - dw / 2,
      top: d.y * h - dh / 2,
      width: dw,
      height: dh,
      child: Transform.rotate(
        angle: d.angle,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Transform.flip(
                flipX: d.faceRight,
                child: Image.asset('$_p$name.png', fit: BoxFit.fill),
              ),
            ),
            Positioned(
              left: (0.5 + d.hit.dx) * dw - dw * _kBloodSize / 2,
              top: (0.5 + d.hit.dy) * dh - dw * _kBloodSize / 2,
              width: dw * _kBloodSize,
              height: dw * _kBloodSize,
              child: CustomPaint(painter: _BloodPainter(d.seed)),
            ),
          ],
        ),
      ),
    );
  }

  void _fire() {
    if (_gameOverTime >= 0) {
      _onTap();
      return;
    }
    _onTap();
    if (_reloadT >= 0 || _ammo <= 0) return;
    if (_time - _lastShot < _kShotCooldown) return;
    _lastShot = _time;
    _shootBirds();
    // выстрел в море — всплеск
    if (_seaSurfaceY > 0 && _aimRest.dy >= _seaSurfaceY) {
      _audio.playSfx(
        _rng.nextBool() ? GameSfx.waterSplash : GameSfx.waterSplash2,
        volume: _kSplashVolume,
      );
    }
    _audio.playSfx(
      _rng.nextBool() ? GameSfx.shot1 : GameSfx.shot2,
      volume: _kShotVolume,
    );
    _recoil.forward(from: 0);
    _pendingEjects.add(_kEjectDelay);
    _ammo--;
    _shellsShown = _ammo;
    if (_ammo == 0) {
      Future.delayed(_kNoAmmoDelay, () {
        if (mounted) _audio.playSfx(GameSfx.noAmmo, volume: _kSfxVolume);
      });
      _startReload();
    }
  }

  static const double _kReloadStart = _kGunHideDelay + _kGunHideDur;
  // время на один патрон: полная перезарядка (6 патронов) = _kReloadTime
  static const double _kPerShell = (_kReloadTime - _kReloadStart) / _kMagazine;

  // длительность зависит от того, сколько патронов не хватает
  void _startReload() {
    if (_reloadT >= 0 || _ammo >= _kMagazine || _gunTime < 0) return;
    _reloadFrom = _ammo;
    _reloadDur = _kReloadStart + _kPerShell * (_kMagazine - _ammo);
    _reloadT = 0;
  }

  void _onReloadTap() {
    if (_gameOverTime >= 0) {
      _onTap();
      return;
    }
    setState(_startReload);
  }

  // во время перезарядки иконки заполняются по одной
  int get _shownAmmo {
    if (_reloadT < 0) return _ammo;
    final added = ((_reloadT - _kReloadStart) / _kPerShell).floor();
    return (_reloadFrom + max(0, added)).clamp(0, _kMagazine).toInt();
  }

  Widget _buildShells() {
    final shown = _shownAmmo;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _kMagazine; i++)
          Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : _kShellGap),
            child: CustomPaint(
              size: const Size(_kShellW, _kShellH),
              painter: _ShellPainter(i < shown),
            ),
          ),
      ],
    );
  }

  // 0 → 1 быстро, затем плавно обратно
  double get _recoilAmount {
    final t = _recoil.value;
    if (_recoil.isDismissed || _recoil.isCompleted) return 0;
    return t < 0.2 ? t / 0.2 : Curves.easeOut.transform(1 - (t - 0.2) / 0.8);
  }

  void _dragGun(Offset delta, double w, double h) {
    // перезапуск только новым нажатием, не движением зажатого пальца
    if (_gameOverTime >= 0) return;
    _onTap();
    // положение прицела при нулевом сдвиге
    final gunW = w * _kGunW;
    final gunH = gunW * 1080 / 1920;
    final ax = w * _kGunX - gunW / 2 + gunW * _kAimDX;
    final ay = h * (1 - _kGunBottom) - gunH + gunH * _kAimDY;
    const m = _kAimEdgeMargin;
    setState(() {
      _gunDrag = Offset(
        (_gunDrag.dx + delta.dx).clamp(-ax - m, w - ax + m),
        (_gunDrag.dy + delta.dy).clamp(-ay - m, h - ay + m),
      );
    });
  }

  // Отражение вдоль оси пламени (от основания к кончику): язычки меняются
  // местами, а направление огня остаётся тем же.
  Matrix4 _mirrorAlongFlame(double fw, double fh) {
    final bx = fw * _kFireBaseX, by = fh * _kFireBaseY;
    final a = atan2(-by, -bx); // ось: от основания к левому верхнему углу
    final c2 = cos(2 * a), s2 = sin(2 * a);
    return Matrix4.translationValues(bx, by, 0)
      ..multiply(Matrix4(c2, s2, 0, 0, s2, -c2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1))
      ..multiply(Matrix4.translationValues(-bx, -by, 0));
  }

  // 0 — оружие на месте, 1 — уехало вниз за экран (перезарядка)
  double get _gunHide => _reloadT < 0
      ? 0
      : Curves.easeIn.transform(
          ((_reloadT - _kGunHideDelay) / _kGunHideDur).clamp(0.0, 1.0),
        );

  void _ejectCasing() {
    final w = _screen.width, h = _screen.height;
    final gunW = w * _kGunW;
    final gunH = gunW * 1080 / 1920;
    double jitter() => 1 + (_rng.nextDouble() * 2 - 1) * _kEjectSpread;
    _casings.add(
      _Casing(
        _gunOrigin.dx + gunW * _kEjectDX,
        _gunOrigin.dy + gunH * _kEjectDY,
        _kEjectVX * h * jitter(),
        _kEjectVY * h * jitter(),
        _kEjectSpin * jitter(),
      ),
    );
  }

  List<Widget> _buildCasings() => [
    for (final c in _casings)
      Positioned(
        key: ObjectKey(c),
        left: c.x - _kShellW * _kEjectScale / 2,
        top: c.y - _kShellH * _kEjectScale / 2,
        width: _kShellW * _kEjectScale,
        height: _kShellH * _kEjectScale,
        child: IgnorePointer(
          child: Transform.rotate(
            angle: c.angle,
            child: CustomPaint(painter: _ShellPainter(true)),
          ),
        ),
      ),
  ];

  List<Widget> _buildGun(double w, double h) {
    if (_gunTime < 0) return const [];
    final gunW = w * _kGunW;
    final gunH = gunW * 1080 / 1920;
    final appear = Curves.easeOutBack.transform(
      (_gunTime / _kGunAppear).clamp(0.0, 1.0),
    );
    final r = _recoilAmount;
    final left =
        w * _kGunX - gunW / 2 + _gunDrag.dx + r * h * _kRecoilDist * 0.5;
    final top =
        h * (1 - _kGunBottom) -
        gunH +
        _gunDrag.dy +
        (1 - appear) * gunH +
        r * h * _kRecoilDist +
        _gunHide * gunH * 1.2;
    // прицел не повторяет откат оружия вниз, а подскакивает вверх-вправо
    _gunOrigin = Offset(
      left - r * h * _kRecoilDist * 0.5,
      top - r * h * _kRecoilDist,
    );
    _aimRest = Offset(
      left - r * h * _kRecoilDist * 0.5 + gunW * _kAimDX,
      top - r * h * _kRecoilDist + gunH * _kAimDY,
    );
    final aim = Offset(
      left - r * h * _kRecoilDist * 0.5 + gunW * _kAimDX + r * w * _kAimKickX,
      top - r * h * _kRecoilDist + gunH * _kAimDY - r * h * _kAimKickY,
    );
    final fireFrame = _recoil.isAnimating
        ? (_recoil.value * _kRecoilMs / _kFireFrameMs).floor()
        : _kFireFrames;
    final fireW = gunW * _kFireW;
    final fireH = fireW * 639 / 796;
    return [
      Positioned(
        key: const ValueKey('gun'),
        left: left,
        top: top,
        width: gunW,
        // картинка квадратная: верх совпадает со старой 1920x1080 (по ней
        // считаются прицел, огонь, гильзы), снизу дорисованы руки
        height: gunW,
        child: Transform.rotate(
          angle: r * _kRecoilAngle,
          // точка поворота — низ прежней картинки 1920x1080
          alignment: const Alignment(1, 2 * 1080 / 1920 - 1),
          child: Image.asset('${_p}kiribati_gun.png', fit: BoxFit.fill),
        ),
      ),
      if (fireFrame < _kFireFrames)
        Positioned(
          key: const ValueKey('fire'),
          // огонь стоит на месте, без отката оружия
          left:
              left -
              r * h * _kRecoilDist * 0.5 +
              gunW * _kFireDX -
              fireW * _kFireBaseX,
          top:
              top -
              r * h * _kRecoilDist +
              gunH * _kFireDY -
              fireH * _kFireBaseY,
          width: fireW,
          height: fireH,
          child: IgnorePointer(
            child: Transform(
              transform: fireFrame.isOdd
                  ? _mirrorAlongFlame(fireW, fireH)
                  : Matrix4.identity(),
              child: Image.asset(
                '${_p}kiribati_fire_shot.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ..._buildCasings(),
      Positioned(
        key: const ValueKey('aim'),
        left: aim.dx - _kAimSize / 2,
        top: aim.dy - _kAimSize / 2,
        width: _kAimSize,
        height: _kAimSize,
        child: IgnorePointer(child: CustomPaint(painter: _AimPainter())),
      ),
    ];
  }

  @override
  void dispose() {
    _ticker.dispose();
    _recoil.dispose();
    _seaPlayer?.dispose();
    _seaPlayer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _onTap(),
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;
            _screen = Size(w, h);
            final sunW = w * _kSunW;
            final birdW = w * _kBirdW;
            final seaW = w * _kSeaW;
            final drop =
                _kStartDrop *
                Curves.easeInOut.transform(
                  (_time / _kStartDropDur).clamp(0.0, 1.0),
                );
            // верх первой волны на картинке моря — выстрел ниже него попадает в море
            final seaH = seaW * 481 / 1920;
            final seaBottom =
                h *
                (_kSeaBottom -
                    drop +
                    _kSeaBobAmp * sin(_time * 2 * pi / _kSeaBobPeriod));
            _seaSurfaceY = h - seaBottom - seaH + seaH * _kSeaSurfaceFrac;
            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  key: const ValueKey('sun'),
                  left: w * _kSunX - sunW / 2,
                  top:
                      h * (_kSunY + drop / _kStartDrop * _kSunStartDrop) -
                      sunW / 2,
                  width: sunW,
                  child: Image.asset(
                    '${_p}kiribati_sun.png',
                    fit: BoxFit.contain,
                  ),
                ),
                for (final b in _flyBirds)
                  if (b.peace)
                    _peaceFrame(b, w, h)
                  else
                    _birdFrame(
                      ObjectKey(b),
                      _frameAt(b.fps, b.phase * _kFlapOrder.length),
                      (b.x - b.size / 2) * w,
                      b.y * h + b.size * w * 265 / 894 / 2,
                      b.size * w,
                      b.vx > 0,
                    ),
                for (final d in _deadBirds) _deadBirdWidget(d, w, h),
                if (_mainBirdAlive)
                  _birdFrame(
                    const ValueKey('mainBird'),
                    _ticker.isActive ? _frameAt(_kBirdFlapFps, 0) : 1,
                    w * (_kBirdX + _mainBirdDx) - birdW / 2,
                    h * _kBirdY + birdW * 265 / 894 / 2,
                    birdW,
                    false,
                  ),
                // бесконечная лента: копии с шагом в период картинки,
                // каждая следующая перекрывает хвост предыдущей
                for (final (i, x) in _seaTiles(w, seaW).indexed)
                  Positioned(
                    key: ValueKey('sea$i'),
                    left: x,
                    bottom:
                        h *
                        (_kSeaBottom -
                            drop +
                            _kSeaBobAmp * sin(_time * 2 * pi / _kSeaBobPeriod)),
                    width: seaW,
                    child: Image.asset(
                      '${_p}kiribati_sea.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ..._buildGun(w, h),
                // левая половина — двигать оружие пальцем
                // Listener вместо GestureDetector: без порога и конкуренции жестов
                Positioned(
                  key: const ValueKey('dragZone'),
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: w / 2,
                  child: Listener(
                    behavior: HitTestBehavior.translucent,
                    onPointerDown: (_) => _onTap(),
                    onPointerMove: (e) => _dragGun(e.delta, w, h),
                  ),
                ),
                // кнопка выстрела — после старта игры
                if (_gunTime >= 0)
                  Positioned(
                    key: const ValueKey('fireButton'),
                    right: _kFireRight,
                    bottom: _kFireBottom,
                    width: _kFireSize,
                    height: _kFireSize,
                    child: GestureDetector(
                      onTapDown: (_) => _fire(),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withValues(alpha: 0.35),
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.gps_fixed,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                if (_gunTime >= 0)
                  Positioned(
                    key: const ValueKey('reloadButton'),
                    right: _kFireRight + (_kFireSize - _kReloadBtnSize) / 2,
                    bottom: _kFireBottom + _kFireSize + _kReloadBtnGap,
                    width: _kReloadBtnSize,
                    height: _kReloadBtnSize,
                    child: GestureDetector(
                      onTapDown: (_) => _onReloadTap(),
                      child: Opacity(
                        opacity: _reloadT >= 0 || _ammo >= _kMagazine ? 0.4 : 1,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.35),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_bestKills > 0)
                  Positioned(
                    key: const ValueKey('best'),
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
                          '$_bestKills',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_kShowHitboxes) ..._buildHitboxes(),
                for (final (i, (right, y)) in _escapes.indexed)
                  Positioned(
                    key: ValueKey('escape$i'),
                    left: right ? null : _kEscapeMarkInset,
                    right: right ? _kEscapeMarkInset : null,
                    top: (y * h - _kEscapeMarkSize / 2).clamp(
                      0.0,
                      h - _kEscapeMarkSize,
                    ),
                    width: _kEscapeMarkSize,
                    height: _kEscapeMarkSize,
                    child: const IgnorePointer(
                      child: CustomPaint(painter: _CrossPainter()),
                    ),
                  ),
                if (_gunTime >= 0)
                  Positioned(
                    key: const ValueKey('shells'),
                    left: 0,
                    right: 0,
                    bottom: _kShellsBottom,
                    child: IgnorePointer(child: Center(child: _buildShells())),
                  ),
                if (_gunTime >= 0)
                  Positioned(
                    key: const ValueKey('kills'),
                    top: 60,
                    right: 16,
                    child: Text(
                      '$_kills',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
                      ),
                    ),
                  ),
                if (_gameOverTime >= 0)
                  Positioned.fill(
                    key: const ValueKey('gameOver'),
                    child: IgnorePointer(
                      child: ColoredBox(
                        color: Colors.black.withValues(
                          alpha:
                              _kGameOverDim *
                              (_gameOverTime / _kGameOverFade).clamp(0.0, 1.0),
                        ),
                        child: Center(
                          child: Text(
                            _gameOverTime >= _kRetryDelay
                                ? '$_gameOverText\ntap to retry'
                                : _gameOverText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(color: Colors.black54, blurRadius: 6),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                // «Tap to start» — один раз, на первом открытом флаге
                Positioned.fill(
                  key: const ValueKey('tapHint'),
                  child: FlagGameTapHint(visible: !_ticker.isActive),
                ),
                const Positioned(
                  key: ValueKey('back'),
                  top: 8,
                  left: 8,
                  child: FBackButton(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<double> _seaTiles(double w, double seaW) {
    final period = seaW * _kSeaTileFrac;
    final base = w * _kSeaX - seaW / 2 + (_seaOffset * w) % period;
    var x = base;
    while (x > -seaW) {
      x -= period;
    }
    final xs = <double>[];
    for (; x < w; x += period) {
      xs.add(x);
    }
    return xs;
  }
}

class _AimPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final shadow = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(c, r - 2, shadow);
    canvas.drawCircle(c, r - 2, stroke);
    canvas.drawCircle(c, 3, Paint()..color = Colors.redAccent);
  }

  @override
  bool shouldRepaint(_AimPainter oldDelegate) => false;
}

class _BloodPainter extends CustomPainter {
  final int seed;
  _BloodPainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(seed);
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final dark = Paint()..color = const Color(0xFF8B0000);
    final red = Paint()..color = const Color(0xFFD10000);
    // неровная клякса из нескольких кругов + брызги
    canvas.drawCircle(c, r * 0.62, dark);
    for (var i = 0; i < 5; i++) {
      final a = rng.nextDouble() * 2 * pi;
      final d = r * (0.2 + rng.nextDouble() * 0.3);
      canvas.drawCircle(
        c + Offset(cos(a), sin(a)) * d,
        r * (0.3 + rng.nextDouble() * 0.2),
        red,
      );
    }
    canvas.drawCircle(c, r * 0.45, red);
    for (var i = 0; i < 4; i++) {
      final a = rng.nextDouble() * 2 * pi;
      final d = r * (0.8 + rng.nextDouble() * 0.4);
      canvas.drawCircle(
        c + Offset(cos(a), sin(a)) * d,
        r * (0.08 + rng.nextDouble() * 0.08),
        dark,
      );
    }
  }

  @override
  bool shouldRepaint(_BloodPainter oldDelegate) => oldDelegate.seed != seed;
}

class _ShellPainter extends CustomPainter {
  final bool full;
  _ShellPainter(this.full);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final a = full ? 1.0 : 0.25;
    final outline = Paint()
      ..color = Colors.black.withValues(alpha: 0.6 * a)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final body = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, w, h * 0.72),
      topLeft: Radius.circular(w * 0.35),
      topRight: Radius.circular(w * 0.35),
    );
    final base = Rect.fromLTWH(-1, h * 0.72, w + 2, h * 0.28);
    canvas.drawRRect(
      body,
      Paint()..color = const Color(0xFFD32F2F).withValues(alpha: a),
    );
    canvas.drawRect(
      base,
      Paint()..color = const Color(0xFFE0B040).withValues(alpha: a),
    );
    canvas.drawRRect(body, outline);
    canvas.drawRect(base, outline);
  }

  @override
  bool shouldRepaint(_ShellPainter old) => old.full != full;
}

class _CrossPainter extends CustomPainter {
  const _CrossPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final line = Paint()..strokeCap = StrokeCap.round;
    void cross() {
      canvas.drawLine(
        Offset(w * 0.15, h * 0.15),
        Offset(w * 0.85, h * 0.85),
        line,
      );
      canvas.drawLine(
        Offset(w * 0.85, h * 0.15),
        Offset(w * 0.15, h * 0.85),
        line,
      );
    }

    line
      ..color = Colors.white
      ..strokeWidth = w * 0.32;
    cross();
    line
      ..color = const Color(0xFFE00000)
      ..strokeWidth = w * 0.2;
    cross();
  }

  @override
  bool shouldRepaint(_CrossPainter oldDelegate) => false;
}
