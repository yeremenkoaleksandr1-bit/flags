import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flags/features/flag_games/flag_game_viewport.dart';
import 'package:flags/features/flag_games/flag_game_background_pause.dart';
import 'package:flags/features/flag_games/flag_game_tap_hint.dart';
import 'package:flags/features/flag_games/flag_game_ads.dart';
import 'package:flags/features/flag_games/flag_game_vibration.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _birdFlySfx = [GameSfx.birdFly, GameSfx.birdFly2, GameSfx.birdFly3];
final _birdFlyRand = Random();

// Принудительно переключает ориентацию экрана и восстанавливает при выходе
class _LandscapeWrapper extends StatefulWidget {
  final Widget child;
  const _LandscapeWrapper({required this.child});

  @override
  State<_LandscapeWrapper> createState() => _LandscapeWrapperState();
}

class _LandscapeWrapperState extends State<_LandscapeWrapper> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Ориентацию не сбрасываем — это делает родительский экран (picker)
    // при своём dispose, чтобы не было конфликта порядка вызовов.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

@RoutePage()
class FlappyGameScreen extends StatefulWidget implements AutoRouteWrapper {
  // игра строится на «экране Pixel 10» и масштабируется под реальный экран
  @override
  Widget wrappedRoute(BuildContext context) =>
      FlagGameViewport(background: Colors.black, child: this);

  const FlappyGameScreen({super.key});

  @override
  State<FlappyGameScreen> createState() => _FlappyGameScreenState();
}

// ══════════════════════════════════════════════════════════════════════════════
// Настройки интро-анимации (3 секунды перед стартом игры)
// Все координаты — в пикселях от левого верхнего угла экрана.
// ══════════════════════════════════════════════════════════════════════════════

class _IntroConfig {
  // ── Птица ────────────────────────────────────────────────────────────────
  // Точка А (начало анимации) — относительно размера экрана.
  // Менять коэффициенты чтобы двигать начальную позицию:
  //   birdStartX: 0.0 = левый край, 1.0 = правый край
  //   по Y птица ставится по центру между верхним краем и верхом столба
  static double birdStartX(double w) => w * 0.69; // правая часть экрана
  static double birdStartSize(double w) => w * 0.30; // ~30% ширины экрана

  // Точка Б (конец анимации) — вычисляется из размеров экрана:
  // birdEndX   = screenW * _FlappyGameScreenState._birdX
  // birdEndY   = screenH / 2
  // birdEndSize = _FlappyGameScreenState._birdSize

  // ── Нижний столб ─────────────────────────────────────────────────────────
  // Точка А (начало анимации) — относительно размера экрана.
  static double pipeStartX(double w) => w * 0.69; // правая часть экрана
  static double pipeStartGapY(double h) => h * 0.13; // ближе к верху
  static double pipeStartWidth(double w) => w * 0.31; // ~28% ширины экрана

  // Точка Б (конец анимации) — вычисляется из размеров экрана:
  // pipeEndX     = screenW
  // pipeEndGapY  = screenH * 0.5
  // pipeEndWidth = _FlappyGameScreenState._pipeWidth
}

double _lerpD(double a, double b, double t) => a + (b - a) * t;

// ══════════════════════════════════════════════════════════════════════════════

class _FlappyGameScreenState extends State<FlappyGameScreen>
    with TickerProviderStateMixin, FlagGameBackgroundPause<FlappyGameScreen> {
  // Включи true чтобы видеть хитбоксы, выключи перед релизом
  static const bool _showHitboxes = false;

  static const double _gravity = 1800;
  static const double _jumpVelocity = -560;
  static const double _pipeSpeedBase = 200; // начальная скорость
  static const double _pipeSpeedStep = 60; // прибавка каждые 5 столбиков
  // Текущая скорость: _pipeSpeedBase + (_score ~/ 5) * _pipeSpeedStep
  static const double _pipeWidth = 110;
  // Пульсация зазора (включается при счёте >= 10)
  // Открытие (sin > 0): зазор растёт — одинаково на обоих этапах
  static const double _pipeGapAmpOpen = 50; // +px (максимальное открытие)
  // Закрытие (sin < 0): зазор уменьшается — на втором этапе агрессивнее
  static const double _pipeGapAmpClose = 50; // -px при счёте 10–14
  static const double _pipeGapAmpClose2 = 80; // -px при счёте >= 15
  static const double _pipeGapFrequency = 0.5; // циклов в секунду
  // Вертикальное смещение пары столбов (счёт >= 20)
  static const double _pipeVerticalAmp = 70; // px вверх/вниз
  static const double _pipeVerticalFreq = 0.35; // циклов в секунду
  static const double _pipeVerticalChance = 0.45; // вероятность (0.0–1.0)
  // Закрытые столбы, открывающиеся при подлёте (счёт >= 30)
  static const double _pipeOpenRadius = 280; // px от птицы — начало открытия
  static const double _pipeOpenChance = 0.35; // вероятность (0.0–1.0)
  // Горизонтальный отступ хитбокса столба (картинка stripes шире реального препятствия)
  static const double _pipeHitInset = 8;
  // Вертикальный отступ хитбокса столба от края зазора (увеличь чтобы добавить зазор)
  static const double _pipeHitInsetV = 8;
  // Отступ от верхнего и нижнего края экрана (увеличь чтобы границы были жёстче)
  static const double _edgeInset = -100;
  static const double _pipeGap = 210;
  static const double _birdX = 0.22; // bird X as fraction of screen width
  static const double _birdSize = 128; // размер контейнера живой птицы
  static const double _birdFallSize = 90; // размер birdfall (менять здесь)

  // Реальные пропорции bird.png (929×368) — не менять вручную
  static const double _birdImgW = 929;
  static const double _birdImgH = 368;
  // Фактические размеры отрисованной птицы внутри квадратного контейнера
  static const double _birdRealW = _birdSize;
  static const double _birdRealH = _birdSize * _birdImgH / _birdImgW;
  // Вертикальный отступ пустого пространства сверху/снизу (BoxFit.contain)
  static const double _birdOffsetY = (_birdSize - _birdRealH) / 2;
  // Дополнительный отступ хитбокса сверху от края картинки (менять здесь)
  static const double _birdHitInsetTop = 4;

  late double _screenW;
  late double _screenH;

  final _musicPlayers = <AudioPlayer>[];
  StreamSubscription<void>? _musicSub;
  int _musicIndex = 0;
  static const _kZambiaMusic = [GameMusics.zambia1, GameMusics.zambia2];

  double _birdY = 0;
  double _birdVY = 0;
  double _birdAngle = 0;

  final List<_Pipe> _pipes = [];
  int _score = 0;
  int _bestScore = 0;
  static const _kBestScoreKey = 'zambia_best_score';

  Future<void> _loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => _bestScore = prefs.getInt(_kBestScoreKey) ?? 0);
  }

  Future<void> _saveBestScore() async {
    if (_score <= _bestScore) return;
    _bestScore = _score;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kBestScoreKey, _bestScore);
  }

  bool _running = false;
  bool _started = false;
  bool _dead = false;
  bool _awaitingFirstTap = false; // после интро/рестарта — ждём первый тап
  double _hoverT = 0;
  static const double _kHoverAmp = 8.0; // размах покачивания (px)
  static const double _kHoverSpeed = 4.0; // скорость покачивания (рад/с)
  static const double _kHoverMaxTime = 2.0; // сколько ждём тап до падения (сек)
  bool _dying = false;
  bool _introPlaying = false;
  double _birdAngularV = 0;
  double _elapsed = 0;
  double _pipeGapElapsed = 0; // отсчёт с момента счёта >= 10
  bool _pipeGapAnimActive = false;
  static const double _pipeGapFadeIn = 3.0; // секунд на нарастание амплитуды
  double _asyncFadeElapsed = 0; // отсчёт с момента счёта >= 15
  bool _asyncPhaseActive = false;
  static const double _asyncFadeDuration =
      3.0; // секунд на переход в асинхронный режим
  double _currentPipeGap = _pipeGap;
  double _darkness = 0; // текущая прозрачность затемнения (плавно нарастает)

  // ── монетный дроп ─────────────────────────────────────────────────────────
  static const int _kCoinDropAfter = 5;
  static const double _kCoinDropChance = 0.10;
  static const int _kCoinMin = 10;
  static const int _kCoinMax = 50;
  int _lastCoinCheckScore = 0; // последний score при котором проверяли шанс
  bool _coinAnimPlaying = false;
  final GlobalKey _coinOriginKey = GlobalKey(); // ключ для позиции центра монет

  Timer? _timer;
  DateTime? _lastTick;

  // ── Пауза, пока приложение свёрнуто: игровой таймер работал бы и в фоне ──
  bool _loopWasRunning = false;

  @override
  void onAppHidden() {
    _loopWasRunning = _timer?.isActive ?? false;
    _timer?.cancel();
    pausePlayingPlayers([..._musicPlayers]);
  }

  @override
  void onAppShown() {
    if (_loopWasRunning && mounted) {
      _lastTick = DateTime.now(); // без скачка времени после возврата
      _timer = Timer.periodic(const Duration(milliseconds: 16), _tick);
    }
    resumePausedPlayers();
  }

  late final AnimationController _introController;
  late final Animation<double> _introAnim;

  // ── анимация крыльев ──────────────────────────────────────────────────────
  static const List<String> _wingFrames = [
    'assets/images/flag_games/zambia/bird.png',
    'assets/images/flag_games/zambia/bird2.png',
    'assets/images/flag_games/zambia/bird3.png',
    'assets/images/flag_games/zambia/bird4.png',
  ];
  // Полная последовательность: 0→1→2→3→2→1→0
  static const List<int> _wingSequence = [0, 1, 2, 3, 2, 1, 0];
  static const Duration _wingFrameDuration = Duration(milliseconds: 55);

  int _wingFrame = 0;
  int _wingStep = 0;
  Timer? _wingTimer;

  void _playWingFlap() {
    context.read<IAudioCubit>().playSfx(_birdFlySfx[_birdFlyRand.nextInt(3)]);
    _wingTimer?.cancel();
    _wingStep = 0;
    _wingTimer = Timer.periodic(_wingFrameDuration, (t) {
      if (_wingStep >= _wingSequence.length) {
        t.cancel();
        setState(() => _wingFrame = 0);
        return;
      }
      setState(() => _wingFrame = _wingSequence[_wingStep]);
      _wingStep++;
    });
  }

  // ── спрайт птицы ──────────────────────────────────────────────────────────
  Widget _buildBird() {
    if (_dying) {
      return Image.asset(
        'assets/images/flag_games/zambia/birdfall.png',
        width: _birdFallSize,
        height: _birdFallSize,
        fit: BoxFit.contain,
      );
    }
    return Image.asset(
      _wingFrames[_wingFrame],
      width: _birdSize,
      height: _birdSize,
      fit: BoxFit.contain,
    );
  }

  // ── спрайт столба ─────────────────────────────────────────────────────────
  Widget _buildPipe(double height, bool isTop, {double width = _pipeWidth}) {
    final img = Image.asset(
      'assets/images/flag_games/zambia/stripes.png',
      width: width,
      height: height,
      fit: BoxFit.fill,
    );
    return isTop ? Transform.flip(flipY: true, child: img) : img;
  }

  @override
  void initState() {
    super.initState();
    _loadBestScore();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _introAnim = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeInOut,
    );
  }

  bool _audioPreloaded = false;

  Future<void> _initMusicPlayers() async {
    if (_audioPreloaded) return;
    _audioPreloaded = true;
    await FlameAudio.audioCache.loadAll([
      GameMusics.zambia1.file,
      GameMusics.zambia2.file,
      GameSfx.birdFly.file,
      GameSfx.birdFly2.file,
      GameSfx.birdFly3.file,
      GameSfx.birdHurt.file,
    ]);
    for (final track in _kZambiaMusic) {
      final p = AudioPlayer()..audioCache = FlameAudio.audioCache;
      // mixWithOthers: не забираем аудиофокус у звуков эффектов
      await p.setAudioContext(
        AudioContextConfig(
          focus: AudioContextConfigFocus.mixWithOthers,
        ).build(),
      );
      // stop, а не release: release выгружает трек после остановки/окончания,
      // и после смерти resume() на пустом плеере молчит
      await p.setReleaseMode(ReleaseMode.stop);
      await p.setSource(AssetSource(track.file));
      _musicPlayers.add(p);
    }
  }

  void _startIntro() {
    _initMusicPlayers();
    setState(() => _introPlaying = true);
    _introController.forward(from: 0).whenComplete(() {
      if (!mounted) return;
      // Интро закончилось — запускаем игру с финальных позиций
      setState(() {
        _introPlaying = false;
        _birdY = _screenH / 2;
        // Добавляем первый столб сразу за правым краем экрана
        _pipes.add(_Pipe(x: _screenW, gapY: _screenH * 0.5));
      });
      _startGame();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    _screenW = size.width;
    _screenH = size.height;
    _birdY = _screenH / 2;
  }

  void _startGame() {
    _pipes.clear();
    _score = 0; // TODO: убрать перед релизом
    _lastCoinCheckScore = 0;
    _coinAnimPlaying = false;
    _dead = false;
    _dying = false;
    _started = true;
    _stopMusic();
    _musicIndex = 0;
    _playNextMusic();
    _birdY = _screenH / 2;
    _birdVY = 0;
    _birdAngle = 0;
    _birdAngularV = 0;
    _wingFrame = 0;
    _elapsed = 0;
    _darkness = 0;
    _pipeGapElapsed = 0;
    _pipeGapAnimActive = false;
    _asyncFadeElapsed = 0;
    _asyncPhaseActive = false;
    _currentPipeGap = _pipeGap;
    _spawnPipe();
    _running = true;
    // птица парит до первого тапа — без гравитации и движения труб
    _awaitingFirstTap = true;
    _lastTick = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 16), _tick);
  }

  void _jump() {
    if (_dying) return; // во время падения нажатие игнорируется
    if (_dead) {
      setState(_startGame);
      return;
    }
    if (_introPlaying) return; // во время интро нажатие игнорируется
    if (!_started) {
      _startIntro();
      return;
    }
    // первый тап после интро — запускает игру и сразу делает прыжок
    if (_awaitingFirstTap) {
      _awaitingFirstTap = false;
      _hoverT = 0;
    }
    _playWingFlap();
    setState(() {
      _birdVY = _jumpVelocity;
    });
  }

  void _spawnPipe() {
    final rand = Random();

    // Открывающийся столб: только после 30, не совмещается с другими режимами
    if (_score >= 30 && rand.nextDouble() < _pipeOpenChance) {
      _pipes.add(
        _Pipe(
          x: _screenW + _pipeWidth,
          gapY: _screenH / 2, // всегда по центру
          opensOnApproach: true,
        ),
      );
      return;
    }

    final gapY = _screenH * 0.2 + rand.nextDouble() * (_screenH * 0.45);
    final phase = rand.nextDouble() * 2 * pi;
    final movesVertically =
        _score >= 20 && rand.nextDouble() < _pipeVerticalChance;
    final verticalPhase = rand.nextDouble() * 2 * pi;
    _pipes.add(
      _Pipe(
        x: _screenW + _pipeWidth,
        gapY: gapY,
        phase: phase,
        movesVertically: movesVertically,
        verticalPhase: verticalPhase,
      ),
    );
  }

  void _tick(Timer t) {
    if (!mounted) return;

    final now = DateTime.now();
    final dt = (now.difference(_lastTick!).inMicroseconds) / 1e6;
    _lastTick = now;

    if (_dying) {
      setState(() {
        _birdVY += _gravity * dt;
        _birdY += _birdVY * dt;
        _birdAngle = (_birdAngle + _birdAngularV * dt).clamp(-0.1, 3.15);
        if (_birdY > _screenH + _birdSize) {
          _dying = false;
          _dead = true;
          t.cancel();
        }
      });
      return;
    }

    if (!_running) return;

    if (_awaitingFirstTap) {
      // ждём первый тап: птица мягко покачивается на месте; если тапа нет
      // _kHoverMaxTime секунд — игра стартует сама и птица начинает падать
      // (её можно поймать тапом во время падения)
      _hoverT += dt;
      if (_hoverT < _kHoverMaxTime) {
        setState(() {
          _birdY = _screenH / 2 + sin(_hoverT * _kHoverSpeed) * _kHoverAmp;
          _birdVY = 0;
          _birdAngle = 0;
        });
        return;
      }
      _awaitingFirstTap = false;
      _hoverT = 0;
    }

    setState(() {
      _elapsed += dt;

      // плавное затемнение фона
      final darknessTarget = _score < 10
          ? 0.0
          : (((_score - 10) ~/ 5) * 0.07).clamp(0.0, 0.55);
      _darkness += (darknessTarget - _darkness) * (dt * 1.5).clamp(0.0, 1.0);

      // пульсация зазора при счёте >= 10
      if (_score >= 10) {
        if (!_pipeGapAnimActive) {
          _pipeGapAnimActive = true;
          _pipeGapElapsed = 0;
        }
        _pipeGapElapsed += dt;
      }
      // переход в асинхронный режим при счёте >= 15
      if (_score >= 15) {
        if (!_asyncPhaseActive) {
          _asyncPhaseActive = true;
          _asyncFadeElapsed = 0;
        }
        _asyncFadeElapsed += dt;
      }

      // физика птицы
      _birdVY += _gravity * dt;
      _birdY += _birdVY * dt;
      _birdAngle = (_birdVY / 1200).clamp(-0.6, 1.2);

      // двигаем трубы
      final currentSpeed = _pipeSpeedBase + (_score ~/ 5) * _pipeSpeedStep;
      for (final pipe in _pipes) {
        pipe.x -= currentSpeed * dt;
        if (!pipe.scored && pipe.x + _pipeWidth < _screenW * _birdX) {
          pipe.scored = true;
          _score++;
          _checkCoinDrop();
        }
      }

      // спавним новую трубу
      if (_pipes.isEmpty || _pipes.last.x < _screenW * 0.55) {
        _spawnPipe();
      }

      // убираем трубы вышедшие за экран
      _pipes.removeWhere((p) => p.x + _pipeWidth < -10);

      // проверка коллизий
      _checkCollisions();
    });
  }

  void _checkCoinDrop() {
    if (_score <= _kCoinDropAfter) return;
    if (_score <= _lastCoinCheckScore) return;
    _lastCoinCheckScore = _score;

    final rand = Random();
    if (rand.nextDouble() >= _kCoinDropChance) return;
    if (_coinAnimPlaying) return;

    final amount = _kCoinMin + rand.nextInt(_kCoinMax - _kCoinMin + 1);
    _coinAnimPlaying = true;

    if (amount > 15) context.read<IAudioCubit>().playSfx(GameSfx.money);
    context.read<GamePreferencesCubit>().addMoney(amount);

    // Запускаем анимацию после кадра (нужен context рендера)
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
      // Геттер возвращает актуальную позицию птицы на момент каждого спауна монеты
      await layer.addMoneys(
        () => FlagGameViewport.toScreen(context, Offset(
          _screenW * _birdX + _birdRealW / 2,
          _birdY + _birdOffsetY + _birdRealH / 2,
        )),
        amount.clamp(1, 50),
      );
      await Future.delayed(const Duration(milliseconds: 600));
      await layer.hide();
      if (mounted) setState(() => _coinAnimPlaying = false);
    });
  }

  void _checkCollisions() {
    final birdLeft = _screenW * _birdX;
    final birdRight = birdLeft + _birdRealW;
    final birdTop = _birdY + _birdOffsetY + _birdHitInsetTop;
    final birdBottom = birdTop + _birdRealH - _birdHitInsetTop;

    // потолок / пол (с отступом _edgeInset)
    if (birdTop <= _edgeInset || birdBottom >= _screenH - _edgeInset) {
      _die();
      return;
    }

    for (final pipe in _pipes) {
      // Хитбокс столба уже спрайта на _pipeHitInset с каждой стороны
      final pipeLeft = pipe.x + _pipeHitInset;
      final pipeRight = pipe.x + _pipeWidth - _pipeHitInset;

      if (birdRight < pipeLeft || birdLeft > pipeRight) continue;

      final center = _gapCenterFor(pipe);
      final gap = _gapFor(pipe);
      final topPipeBottom = center - gap / 2 - _pipeHitInsetV;
      final botPipeTop = center + gap / 2 + _pipeHitInsetV;

      if (birdTop < topPipeBottom || birdBottom > botPipeTop) {
        _die();
        return;
      }
    }
  }

  void _playNextMusic() {
    if (!mounted || _musicPlayers.isEmpty) return;
    _musicSub?.cancel();
    final idx = _musicIndex % _musicPlayers.length;
    _musicIndex++;
    final player = _musicPlayers[idx];
    // в режиме stop плеер после stop()/окончания уже стоит в начале трека
    player.resume();
    _musicSub = player.onPlayerComplete.listen((_) => _playNextMusic());
  }

  void _stopMusic() {
    _musicSub?.cancel();
    _musicSub = null;
    for (final p in _musicPlayers) {
      p.stop();
    }
  }

  void _die() {
    flagGameVibrate(context, 'Zambia', 'lose');
    flagGameLossAd(context, 'Zambia', isStillLost: () => _dead || _dying);
    _saveBestScore();
    _stopMusic();
    context.read<IAudioCubit>().playSfx(GameSfx.birdHurt);
    _running = false;
    _dying = true;
    _wingTimer?.cancel();
    _wingFrame = 0;
    // небольшой подпрыжок, потом падение с переворотом
    _birdVY = -220;
    _birdAngularV = 3.15 / 0.55; // поворот на 180° за ~0.55 сек
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wingTimer?.cancel();
    _musicSub?.cancel();
    for (final p in _musicPlayers) {
      p.stop();
      p.dispose();
    }
    _musicPlayers.clear();
    FlameAudio.audioCache.clearAll();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _LandscapeWrapper(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _jump,
        child: Stack(
          children: [
            // Фон
            const Positioned.fill(child: ColoredBox(color: Color(0xFF147F55))),

            // Затемнение фона (плавно нарастает)
            if (_darkness > 0)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: _darkness),
                ),
              ),

            // Трубы
            ..._pipes.expand((pipe) => _buildPipeWidget(pipe)),

            // Птица
            if (_introPlaying || !_started)
              // В интро и до старта — анимированная / статичная в точке А
              AnimatedBuilder(
                animation: _introAnim,
                builder: (_, __) {
                  final t = _introPlaying ? _introAnim.value : 0.0;
                  final birdEndX = _screenW * _birdX;
                  final birdEndY = _screenH / 2;
                  final x = _lerpD(
                    _IntroConfig.birdStartX(_screenW),
                    birdEndX,
                    t,
                  );
                  // до интро птица по центру между верхним краем экрана
                  // и верхом столба (на любом экране)
                  final startSize = _IntroConfig.birdStartSize(_screenW);
                  final pillarTop =
                      _IntroConfig.pipeStartGapY(_screenH) + _pipeGap / 2;
                  final birdStartY = pillarTop / 2 - startSize / 2;
                  final y = _lerpD(birdStartY, birdEndY, t);
                  final sz = _lerpD(startSize, _birdSize, t);
                  return Positioned(
                    left: x,
                    top: y,
                    child: Image.asset(
                      'assets/images/flag_games/zambia/bird.png',
                      width: sz,
                      height: sz,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              )
            else
              // Игра идёт — обычная позиция с физикой
              Positioned(
                left: _screenW * _birdX,
                top: _birdY,
                child: Transform.rotate(angle: _birdAngle, child: _buildBird()),
              ),

            // Столб интро
            if (_introPlaying || !_started)
              AnimatedBuilder(
                animation: _introAnim,
                builder: (_, __) {
                  final t = _introPlaying ? _introAnim.value : 0.0;
                  final x = _lerpD(
                    _IntroConfig.pipeStartX(_screenW),
                    _screenW,
                    t,
                  );
                  final gapY = _lerpD(
                    _IntroConfig.pipeStartGapY(_screenH),
                    _screenH * 0.5,
                    t,
                  );
                  final w = _lerpD(
                    _IntroConfig.pipeStartWidth(_screenW),
                    _pipeWidth,
                    t,
                  );
                  final botH = (_screenH - (gapY + _pipeGap / 2)).clamp(
                    0.0,
                    _screenH,
                  );
                  return Positioned(
                    left: x,
                    top: gapY + _pipeGap / 2,
                    child: _buildPipe(botH, false, width: w),
                  );
                },
              ),

            // Хитбоксы (отключи _showHitboxes перед релизом)
            if (_showHitboxes) ...[
              // Хитбокс птицы — красный (вращается вместе с птицей)
              Positioned(
                left: _screenW * _birdX,
                top: _birdY,
                child: Transform.rotate(
                  angle: _birdAngle,
                  child: SizedBox(
                    width: _birdSize,
                    height: _birdSize,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: _birdOffsetY + _birdHitInsetTop,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: _birdRealW,
                          height: _birdRealH - _birdHitInsetTop,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2),
                            color: Colors.red.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Хитбоксы столбов — синие
              ..._pipes.expand((pipe) {
                final center = _gapCenterFor(pipe);
                final gap = _gapFor(pipe);
                final topH = center - gap / 2 - _pipeHitInsetV;
                final botH = _screenH - (center + gap / 2 + _pipeHitInsetV);
                final left = pipe.x + _pipeHitInset;
                final w = _pipeWidth - _pipeHitInset * 2;
                return [
                  Positioned(
                    left: left,
                    top: 0,
                    child: Container(
                      width: w,
                      height: topH.clamp(0, _screenH),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        color: Colors.blue.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  Positioned(
                    left: left,
                    top: center + gap / 2 + _pipeHitInsetV,
                    child: Container(
                      width: w,
                      height: botH.clamp(0, _screenH),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        color: Colors.blue.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ];
              }),
            ],

            // Счёт — появляется вместе с началом интро
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _started || _introPlaying ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: Center(
                  child: FText(
                    '$_score',
                    textStyle: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
            ),

            // Рекорд с кубком — до интро, в левом нижнем углу; с интро уходит
            Positioned(
              left: 16,
              bottom: 12,
              child: AnimatedOpacity(
                opacity: _started || _introPlaying ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/winner_cup.png',
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 6),
                    FText(
                      '$_bestScore',
                      textStyle: const TextStyle(
                        fontSize: 30,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Game Over
            if (_dead)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FText(
                      'game over',
                      textStyle: const TextStyle(fontSize: 58),
                    ),
                    const SizedBox(height: 8),
                    FText(
                      'score: $_score',
                      textStyle: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 16),
                    FText(
                      'tap to restart',
                      textStyle: const TextStyle(fontSize: 28),
                    ),
                  ],
                ),
              ),

            // «Tap to start» — один раз, на первом открытом флаге
            Positioned.fill(
              child: FlagGameTapHint(visible: !_started && !_introPlaying && !_dead),
            ),
            const Positioned(top: 8, left: 8, child: FBackButton()),
          ],
        ),
      ),
    );
  }

  // Текущий центр зазора с учётом вертикального движения
  double _gapCenterFor(_Pipe pipe) {
    if (pipe.opensOnApproach) return _screenH / 2;
    if (!pipe.movesVertically) return pipe.gapY;
    final offset =
        _pipeVerticalAmp *
        sin(_pipeGapElapsed * _pipeVerticalFreq * 2 * pi + pipe.verticalPhase);
    return (pipe.gapY + offset).clamp(
      _pipeGap / 2 + 10,
      _screenH - _pipeGap / 2 - 10,
    );
  }

  double _gapFor(_Pipe pipe) {
    // открывающийся столб: зазор зависит от расстояния до птицы
    if (pipe.opensOnApproach) {
      final birdX = _screenW * _birdX;
      final dist = pipe.x - birdX;
      if (dist > _pipeOpenRadius) return 0;
      if (dist < 0) return _pipeGap;
      // плавное открытие по Curves.easeOut (квадратичное)
      final t = 1 - (dist / _pipeOpenRadius);
      return _pipeGap * (t * (2 - t)); // easeOut
    }
    if (!_pipeGapAnimActive || pipe.movesVertically) return _pipeGap;
    final fadeIn = (_pipeGapElapsed / _pipeGapFadeIn).clamp(0.0, 1.0);
    // плавный переход от синхронного к асинхронному
    final asyncT = _asyncPhaseActive
        ? (_asyncFadeElapsed / _asyncFadeDuration).clamp(0.0, 1.0)
        : 0.0;
    final phase = pipe.phase * asyncT;
    final pulse = sin(_pipeGapElapsed * _pipeGapFrequency * 2 * pi + phase);
    // плавное нарастание закрывающей амплитуды
    final ampClose =
        _pipeGapAmpClose + (_pipeGapAmpClose2 - _pipeGapAmpClose) * asyncT;
    final amp = pulse >= 0 ? _pipeGapAmpOpen : ampClose;
    return _pipeGap + amp * fadeIn * pulse;
  }

  List<Widget> _buildPipeWidget(_Pipe pipe) {
    final center = _gapCenterFor(pipe);
    final gap = _gapFor(pipe);
    final topHeight = center - gap / 2;
    final botHeight = _screenH - (center + gap / 2);

    return [
      Positioned(
        left: pipe.x,
        top: 0,
        child: _buildPipe(topHeight.clamp(0, _screenH), true),
      ),
      Positioned(
        left: pipe.x,
        top: center + gap / 2,
        child: _buildPipe(botHeight.clamp(0, _screenH), false),
      ),
    ];
  }
}

class _Pipe {
  double x;
  final double gapY;
  final double phase;
  final bool movesVertically;
  final double verticalPhase;
  final bool opensOnApproach; // закрыт, открывается при подлёте птицы
  bool scored = false;

  _Pipe({
    required this.x,
    required this.gapY,
    this.phase = 0,
    this.movesVertically = false,
    this.verticalPhase = 0,
    this.opensOnApproach = false,
  });
}
