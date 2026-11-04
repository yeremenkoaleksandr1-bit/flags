import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/navigator/router.gr.dart';
// ignore: unused_import
import 'package:flags/features/flag_games/angola/knife_hit_screen.dart';
// ignore: unused_import
import 'package:flags/features/flag_games/kosovo/kosovo_game_screen.dart';
// ignore: unused_import
import 'package:flags/features/flag_games/japan/japan_knife_hit_screen.dart';
// ignore: unused_import
import 'package:flags/features/flag_games/cambodia/cambodia_game_screen.dart';
import 'package:flags/features/flag_games/israel/israel_game_screen.dart';
import 'package:flags/features/flag_games/flag_game_unlocks.dart';
import 'package:flags/uikit/assets/components/money.dart';
import 'package:flags/ui/blackout_transition.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/components/buttons/colors/green_button.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/features/app/features/vibration/presentation/bloc/vibration_cubit.dart';

void _forceLandscape() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

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
    _forceLandscape();
  }

  @override
  void dispose() {
    // обратно строго вертикально, как во всём приложении (main.dart)
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// [puzzleFlag] — ключ открытия: флаг пазлов (GameFlag.name), сборка которого
/// открывает игру, или ключ покупки из [FlagGameUnlocks.prices];
/// null — игра открыта всегда.
/// [imagePath] empty string = placeholder tile (coming soon).
class FlappyFlagEntry {
  final String name;
  final String imagePath;
  final String? puzzleFlag;
  final bool isPlaceholder;
  final PageRouteInfo? route;

  const FlappyFlagEntry({
    required this.name,
    this.imagePath = '',
    this.puzzleFlag,
    this.isPlaceholder = false,
    this.route,
  });
}

@RoutePage()
class FlappyFlagPickerScreen extends StatefulWidget {
  const FlappyFlagPickerScreen({super.key});

  @override
  State<FlappyFlagPickerScreen> createState() => _FlappyFlagPickerScreenState();
}

class _FlappyFlagPickerScreenState extends State<FlappyFlagPickerScreen>
    with AutoRouteAwareStateMixin<FlappyFlagPickerScreen> {
  // В будущем этот список будет разбит на страницы с возможностью свайпа.
  // Сейчас первые 6 позиций: 1 реальный флаг + 5 заглушек.
  static final List<FlappyFlagEntry> _flags = [
    FlappyFlagEntry(
      name: 'Zambian Bird',
      imagePath: 'assets/images/flag_games/zambia/zambia_flag.png',
      route: const FlappyGameRoute(),
      puzzleFlag: 'Zambia',
    ),
    FlappyFlagEntry(
      name: 'Tanzanian Racer',
      imagePath: 'assets/images/flag_games/tanzania/tanzania_flag.png',
      route: const TrafficGameRoute(),
      puzzleFlag: 'Tanzania',
    ),
    FlappyFlagEntry(
      name: 'Angolan Hit',
      imagePath: 'assets/images/flag_games/angola/angola_flag.png',
      route: const KnifeHitRoute(),
      puzzleFlag: 'Angola',
    ),
    FlappyFlagEntry(
      name: 'Kosovo Defense',
      imagePath: 'assets/images/flag_games/kosovo/kosovo_flag.png',
      route: const KosovoGameRoute(),
      puzzleFlag: 'Kosovo', // в пазлах нет — открывается покупкой
    ),
    FlappyFlagEntry(
      name: 'Sharp Japanese',
      imagePath: 'assets/images/flag_games/japan/japan_flag.png',
      route: const JapanKnifeHitRoute(),
      puzzleFlag: 'Japan',
    ),
    FlappyFlagEntry(
      name: 'Cambodian Builder',
      imagePath: 'assets/images/flag_games/cambodia/cambodia_flag.png',
      route: const CambodiaGameRoute(),
      puzzleFlag: 'Cambodia',
    ),
    FlappyFlagEntry(
      name: 'Israeli Dash',
      imagePath: 'assets/images/flag_games/israel/israel_flag.png',
      route: const IsraelGameRoute(),
      puzzleFlag: 'Israel',
    ),
    FlappyFlagEntry(
      name: 'Kiribati Hunter',
      imagePath: 'assets/images/flag_games/kiribati/kiribati_flag.png',
      route: const KiribatiGameRoute(),
      puzzleFlag: 'Kiribati',
    ),
    const FlappyFlagEntry(name: '', isPlaceholder: true),
  ];

  // открытые игры (флаги, собранные в пазлах); null — ещё загружается
  Set<String>? _unlocked;
  // открытые игры, анимация открытия которых уже показана
  Set<String> _revealed = {};

  @override
  void initState() {
    super.initState();
    _loadUnlocks();
  }

  Future<void> _loadUnlocks() async {
    final unlocked = await FlagGameUnlocks.load();
    final revealed = await FlagGameUnlocks.loadRevealed();
    if (mounted) {
      setState(() {
        _unlocked = unlocked;
        _revealed = revealed;
      });
    }
  }

  void _onLockedTap(FlappyFlagEntry e) {
    final key = e.puzzleFlag!;
    final price = FlagGameUnlocks.prices[key];
    if (price == null) {
      _showLockedInfo(context, key);
      return;
    }
    _showBuyDialog(context, e.name, price, () async {
      context.read<GamePreferencesCubit>().removeMoney(price);
      context.read<IAudioCubit>().playSfx(GameSfx.money);
      await FlagGameUnlocks.unlockPurchased(key);
      if (mounted) setState(() => _unlocked = {...?_unlocked, key});
    });
  }

  bool _isLocked(FlappyFlagEntry e) =>
      e.puzzleFlag != null && !(_unlocked?.contains(e.puzzleFlag) ?? false);

  // выход в портретный режим — под затемнением, чтобы не было видно поворота
  Future<void> _leave() {
    // берём заранее: после pop контекст экрана уже недоступен
    final audio = context.read<IAudioCubit>();
    final router = context.router;
    return BlackoutTransition.run(
      context,
      () {
        router.pop();
        // экран режимов во вложенном навигаторе не узнаёт о закрытии этого
        // экрана, поэтому музыку меню (её ставили на паузу) включаем здесь
        audio.playBgm(GameMusics.main);
      },
      // портрет включается только после закрытия экрана (~250 мс анимации),
      // поэтому держим затемнение дольше, чем при входе
      hold: const Duration(milliseconds: 750),
      rotation: RotationHint.toPortrait,
    );
  }

  @override
  Widget build(BuildContext context) {
    // системный «назад» тоже уходит через затемнение
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave();
      },
      child: _LandscapeWrapper(
        child: GamePageBuilder(
          startSlideDirection: GamePageSlideDirection.right,
          endSlideDirection: GamePageSlideDirection.right,
          onPageFocussed: () async {
            final audio = context.read<IAudioCubit>();
            // вернулись в список флагов — выгружаем все звуки мини-игры
            // (и её музыку), затем играет музыка списка
            await audio.releaseGameAudio();
            await audio.playBgm(GameMusics.flagGamesMenu);
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/ui/background.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // место под кнопку назад (сама кнопка — на верхнем слое)
                    const Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Opacity(
                        opacity: 0,
                        child: IgnorePointer(child: FBackButton()),
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final w = constraints.maxWidth;
                          final h = constraints.maxHeight;
                          // мягкое затухание верхнего края при прокрутке
                          return ShaderMask(
                            blendMode: BlendMode.dstIn,
                            shaderCallback: (rect) => LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: const [Colors.transparent, Colors.black],
                              stops: [0.0, _kTopFadeFrac],
                            ).createShader(rect),
                            child: GridView.builder(
                              padding: EdgeInsets.fromLTRB(
                                w * 0.06,
                                h * _kTopFadeFrac, // в покое первый ряд не попадает в затухание

                                w * 0.03,
                                h * 0.04,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: h * 0.04,
                                    crossAxisSpacing: w * 0.03,
                                    childAspectRatio: 800 / 518,
                                  ),
                              itemCount: _flags.length,
                              itemBuilder: (context, index) {
                                final entry = _flags[index];
                                final locked = _isLocked(entry);
                                // открыт, но анимацию открытия ещё не видели
                                final key = entry.puzzleFlag;
                                final reveal =
                                    !FlagGameUnlocks.unlockAllForTesting &&
                                    !locked &&
                                    _unlocked != null &&
                                    key != null &&
                                    !_revealed.contains(key);
                                return _FlagTile(
                                  entry: entry,
                                  locked: locked,
                                  reveal: reveal,
                                  onRevealed: () {
                                    FlagGameUnlocks.markRevealed(key!);
                                    setState(
                                      () => _revealed = {..._revealed, key},
                                    );
                                  },
                                  onTap: entry.isPlaceholder
                                      ? () => _showComingSoon(context)
                                      : locked
                                      ? () => _onLockedTap(entry)
                                      : entry.route == null
                                      ? null
                                      : () {
                                          // в игре до её старта тихо; там
                                          // включится своя музыка
                                          context
                                              .read<IAudioCubit>()
                                              .pauseBgm();
                                          context.navigateTo(entry.route!);
                                        },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Мягкое затемнение верхнего края: над списком, под заголовком
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).padding.top + _kTopShadeHeight,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: _kTopShadeOpacity),
                          Colors.black.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Заголовок — поверх затемнения
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: IgnorePointer(
                    child: Transform.translate(
                      offset: const Offset(_kTitleOffsetX, _kTitleOffsetY),
                      child: FText(
                        'Flag games',
                        strokeWidth: 8,
                        textStyle: const TextStyle(fontSize: _kTitleFontSize),
                      ),
                    ),
                  ),
                ),
              ),
              // Кнопка назад — самый верхний слой
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  child: FBackButton(onPressed: _leave),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Затемнение верхнего края ─────────────────────────────────────────────────
const double _kTopShadeHeight =
    110.0; // высота затемнения (px, от верха безопасной зоны)
const double _kTopShadeOpacity = 0.45; // насколько тёмный самый верх (0..1)

// ── Заголовок «Flag games» (независимо от таблички) ──────────────────────────
const double _kTitleFontSize = 34.0;
const double _kTitleOffsetX = 0.0; // сдвиг вправо от центра (px)
const double _kTitleOffsetY = 11.0; // отступ вниз от верха безопасной зоны (px)

// высота мягкого затухания сверху списка (доля высоты области списка)
const double _kTopFadeFrac = 0.06;

// ── Пасхалка: «Coming soon...» злится с каждым нажатием ──────────────────────
// Сообщения идут по порядку; после последнего оно и повторяется.
const _kComingSoonLines = [
  'More flag games are coming in future updates.\nStay tuned!',
  'Still coming soon.\nTapping again won\'t make it faster.',
  'You do know this is just a placeholder, right?',
  'Nope. Still nothing here.',
  'Were you expecting a different answer?',
  'Seriously. There is NO game here.',
  'Stop poking me.',
  'I am starting to lose my patience.',
  'Go play an actual flag. There are plenty of them!',
  'Do you enjoy this? Because I don\'t.',
  'That\'s it. I\'m not talking to you anymore.',
  '...',
  '......',
  'FINE. Here is your secret game:\nclosing this window.',
  'Nothing. Will. Happen. JUST KEEP WAITING FOR NEW UPDATES!!!',
];
const _kComingSoonButtons = ['OK', 'OK', 'Sure', 'Fine', 'Whatever', 'Leave'];

// счётчик живёт, пока открыто приложение
int _comingSoonTaps = 0;

// Один раз за всё сохранение в конце цепочки игра сдаётся и платит, чтобы отстали
const String _kComingSoonRewardKey = 'flag_games_coming_soon_rewarded';
const int _kComingSoonReward = 50;
const String _kComingSoonRewardLine =
    'OK, OK, YOU WIN!\nTake $_kComingSoonReward coins and leave me alone.';

// Вибрация на злых сообщениях: с этого сообщения и дальше, всё сильнее
const int _kAngryFromLine = 6; // 'Stop poking me.'
const int _kAngryVibrateMs = 120; // первая злая вибрация
const int _kAngryVibrateStepMs = 40; // прибавка за каждое следующее сообщение
const int _kAngryVibrateMaxMs = 500;

int _comingSoonVibrate(BuildContext context, int line) {
  final tap = _comingSoonTaps;
  final total = _kComingSoonLines.length;
  if (line < _kAngryFromLine) {
    debugPrint(
      '[ComingSoon] tap #$tap, line ${line + 1}/$total: calm, no vibration',
    );
    return 0;
  }
  final ms = math.min(
    _kAngryVibrateMs + (line - _kAngryFromLine) * _kAngryVibrateStepMs,
    _kAngryVibrateMaxMs,
  );
  final vibration = context.read<IVibrationCubit>();
  final muted = vibration.state.muted;
  debugPrint(
    '[ComingSoon] tap #$tap, line ${line + 1}/$total: VIBRATE ${ms}ms'
    '${muted ? ' (skipped: vibration is off in settings)' : ''}',
  );
  vibration.vibrate(milliseconds: ms);
  return ms;
}

// тряска окна на злых сообщениях
const double _kShakeAmplitude = 6.0; // px на первом злом сообщении
const double _kShakeAmplitudeExtra = 8.0; // + к амплитуде на самом злом

/// Трясёт [child] по горизонтали [durationMs] мс с затуханием (0 — без тряски).
class _Shake extends StatefulWidget {
  const _Shake({
    required this.durationMs,
    required this.amplitude,
    required this.child,
  });

  final int durationMs;
  final double amplitude;
  final Widget child;

  @override
  State<_Shake> createState() => _ShakeState();
}

class _ShakeState extends State<_Shake> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: math.max(1, widget.durationMs)),
  );

  @override
  void initState() {
    super.initState();
    if (widget.durationMs > 0) _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      child: widget.child,
      builder: (context, child) {
        final t = _ctrl.value;
        // ~4 колебания за время тряски, амплитуда затухает к концу
        final dx = widget.durationMs == 0
            ? 0.0
            : math.sin(t * math.pi * 8) * widget.amplitude * (1 - t);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
    );
  }
}

Future<void> _showComingSoon(BuildContext context) async {
  final i = math.min(_comingSoonTaps, _kComingSoonLines.length - 1);
  _comingSoonTaps++;
  var line = _kComingSoonLines[i];
  var button =
      _kComingSoonButtons[math.min(i ~/ 3, _kComingSoonButtons.length - 1)];
  var reward = false;
  // тряска окна — вместе с вибрацией и той же длительности
  final shakeMs = _comingSoonVibrate(context, i);
  if (i == _kComingSoonLines.length - 1) {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_kComingSoonRewardKey) ?? false)) {
      await prefs.setBool(_kComingSoonRewardKey, true);
      reward = true;
      line = _kComingSoonRewardLine;
      button = 'Thanks';
    }
    if (!context.mounted) return;
  }
  // чем злее, тем краснее окно
  final anger = i / (_kComingSoonLines.length - 1);
  if (reward) {
    context.read<GamePreferencesCubit>().addMoney(_kComingSoonReward);
    context.read<IAudioCubit>().playSfx(GameSfx.money);
    final center = MediaQuery.of(context).size.center(Offset.zero);
    // монеты летят из центра (из окна) в счётчик, когда окно уже на экране
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
      await layer.addMoneys(() => center, 30);
      await Future<void>.delayed(const Duration(milliseconds: 900));
      await layer.hide();
    });
  }
  await showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    // без безопасной зоны: иначе в альбомной ориентации вырез камеры
    // сдвигает окно от центра экрана
    useSafeArea: false,
    builder: (ctx) => Center(
      child: _Shake(
        durationMs: shakeMs,
        amplitude: _kShakeAmplitude + anger * _kShakeAmplitudeExtra,
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
            decoration: BoxDecoration(
              color: Color.lerp(
                const Color(0xFF1E1E1E),
                const Color(0xFF6E0E0E),
                anger,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FText(
                  line,
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(fontSize: 26),
                ),
                const SizedBox(height: 24),
                FGreenButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: FText(
                    button,
                    textStyle: const TextStyle(fontSize: 26),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// ── Закрытые игры ────────────────────────────────────────────────────────────
const double _kLockedDim = 0.78; // затемнение закрытого флага (0..1)
const double _kLockIconSize = 0.45; // высота замка — доля высоты флага

// Покупка игры за монеты
void _showBuyDialog(
  BuildContext context,
  String gameName,
  int price,
  Future<void> Function() onBuy,
) {
  final money = context.read<GamePreferencesCubit>().state.moneys;
  final canBuy = money >= price;
  showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    useSafeArea: false,
    builder: (ctx) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FText(
                'Unlock $gameName?',
                textAlign: TextAlign.center,
                textStyle: const TextStyle(fontSize: 28),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 44, child: UIMoney()),
                  const SizedBox(width: 10),
                  FText('$price', textStyle: const TextStyle(fontSize: 34)),
                ],
              ),
              if (!canBuy) ...[
                const SizedBox(height: 12),
                FText(
                  'Not enough coins: you need ${price - money} more',
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.redAccent,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (canBuy)
                FGreenButton(
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await onBuy();
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: FText(
                    'Unlock',
                    textStyle: const TextStyle(fontSize: 26),
                  ),
                )
              else
                FGreenButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: FText('OK', textStyle: const TextStyle(fontSize: 26)),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _showLockedInfo(BuildContext context, String flag) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    useSafeArea: false,
    builder: (ctx) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/locked.png', height: 56),
              const SizedBox(height: 16),
              FText(
                'Complete the flag of $flag\nin Puzzles to unlock this game!',
                textAlign: TextAlign.center,
                textStyle: const TextStyle(fontSize: 26),
              ),
              const SizedBox(height: 24),
              FGreenButton(
                onPressed: () => Navigator.of(ctx).pop(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                child: FText('OK', textStyle: const TextStyle(fontSize: 26)),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _FlagTile extends StatelessWidget {
  final FlappyFlagEntry entry;
  final bool locked;
  final bool reveal; // проиграть анимацию открытия, когда плитка станет видна
  final VoidCallback? onRevealed;
  final VoidCallback? onTap;

  const _FlagTile({
    required this.entry,
    this.locked = false,
    this.reveal = false,
    this.onRevealed,
    this.onTap,
  });

  // цена открытия, если игра покупается за монеты
  int? get price => entry.puzzleFlag == null
      ? null
      : FlagGameUnlocks.prices[entry.puzzleFlag];

  @override
  Widget build(BuildContext context) {
    // прогиб при нажатии + звук кнопки и вибрация (как у карточек режимов)
    return ScaledGestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: entry.isPlaceholder
                ? Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF333333),
                        width: 2,
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: FText(
                        'Coming soon...',
                        textStyle: const TextStyle(fontSize: 22),
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(entry.imagePath, fit: BoxFit.cover),
                        if (reveal)
                          _UnlockReveal(
                            key: ValueKey('reveal_${entry.puzzleFlag}'),
                            price: price,
                            onDone: onRevealed,
                          ),
                        // закрытая игра: затемнение + замок по центру
                        if (!reveal)
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: locked ? 1 : 0,
                            child: ColoredBox(
                              color: Colors.black.withValues(
                                alpha: _kLockedDim,
                              ),
                              child: price == null
                                  ? FractionallySizedBox(
                                      heightFactor: _kLockIconSize,
                                      child: Image.asset(
                                        'assets/images/locked.png',
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  // покупаемая игра: замок + цена с иконкой денег
                                  : LayoutBuilder(
                                      builder: (context, c) {
                                        final h = c.maxHeight;
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/locked.png',
                                              height: h * 0.34,
                                            ),
                                            SizedBox(height: h * 0.05),
                                            SizedBox(
                                              height: h * 0.24,
                                              child: FittedBox(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 40,
                                                      child: UIMoney(),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    FText(
                                                      '$price',
                                                      textStyle:
                                                          const TextStyle(
                                                            fontSize: 36,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
          if (!entry.isPlaceholder) ...[
            const SizedBox(height: 4),
            FText(entry.name, textStyle: const TextStyle(fontSize: 16)),
          ] else
            const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Анимация открытия игры ───────────────────────────────────────────────────
const int _kRevealMs = 1400; // вся анимация
const double _kRevealShakeEnd = 0.35; // доля времени на тряску замка
const double _kRevealMinVisible =
    0.8; // какая часть плитки должна быть на экране
const Duration _kRevealDelay = Duration(
  milliseconds: 900,
); // пауза после появления

/// Закрытая плитка, которая при появлении на экране «открывается»: замок
/// трясётся, разлетается на 4 куска, затемнение плавно уходит. Пока плитка
/// не видна (ниже по списку или под переходом), анимация ждёт.
class _UnlockReveal extends StatefulWidget {
  const _UnlockReveal({super.key, this.price, this.onDone});

  final int? price;
  final VoidCallback? onDone;

  @override
  State<_UnlockReveal> createState() => _UnlockRevealState();
}

class _UnlockRevealState extends State<_UnlockReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: _kRevealMs),
  );
  ScrollPosition? _scroll;
  bool _scheduled = false;
  bool _cracked = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      if (!_cracked && _ctrl.value >= _kRevealShakeEnd) {
        _cracked = true;
        context.read<IAudioCubit>().playSfx(GameSfx.gearCrash);
      }
    });
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onDone?.call();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scroll?.removeListener(_check);
    _scroll = Scrollable.maybeOf(context)?.position;
    _scroll?.addListener(_check);
  }

  @override
  void dispose() {
    _scroll?.removeListener(_check);
    _ctrl.dispose();
    super.dispose();
  }

  double _visibleFraction() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return 0;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    final visible = rect.intersect(Offset.zero & MediaQuery.sizeOf(context));
    if (visible.width <= 0 || visible.height <= 0) return 0;
    return (visible.width * visible.height) / (rect.width * rect.height);
  }

  void _check() {
    if (!mounted || _scheduled || _ctrl.isAnimating || _ctrl.isCompleted)
      return;
    if (_visibleFraction() < _kRevealMinVisible) return;
    // небольшая пауза: экран мог только что открыться под затемнением перехода
    _scheduled = true;
    Future<void>.delayed(_kRevealDelay, () {
      if (!mounted) return;
      _scheduled = false;
      if (_visibleFraction() >= _kRevealMinVisible) {
        _ctrl.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.value;
        // затемнение уходит после того, как замок разбился
        final dimT = ((t - _kRevealShakeEnd) / 0.5).clamp(0.0, 1.0);
        final dim = _kLockedDim * (1 - Curves.easeOut.transform(dimT));
        return LayoutBuilder(
          builder: (context, c) {
            final h = c.maxHeight;
            final lockH = h * (widget.price == null ? _kLockIconSize : 0.34);
            final lockW = lockH * 105 / 117;
            return Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: Colors.black.withValues(alpha: dim)),
                if (t < _kRevealShakeEnd)
                  Center(
                    child: Transform.translate(
                      // тряска нарастает к моменту, когда замок разобьётся
                      offset: Offset(
                        math.sin(t * 90) *
                            lockW *
                            0.08 *
                            (t / _kRevealShakeEnd),
                        0,
                      ),
                      child: Transform.rotate(
                        angle: math.sin(t * 70) * 0.12 * (t / _kRevealShakeEnd),
                        child: Image.asset(
                          'assets/images/locked.png',
                          height: lockH,
                        ),
                      ),
                    ),
                  )
                else
                  ..._pieces(t, lockW, lockH, h),
              ],
            );
          },
        );
      },
    );
  }

  // 4 четвертинки замка разлетаются в стороны, вращаются, падают и гаснут
  List<Widget> _pieces(double t, double lockW, double lockH, double tileH) {
    final p = ((t - _kRevealShakeEnd) / (1 - _kRevealShakeEnd)).clamp(0.0, 1.0);
    final sec = p * 0.9;
    const quads = [(-1.0, -1.0), (1.0, -1.0), (-1.0, 1.0), (1.0, 1.0)];
    return [
      for (final (qx, qy) in quads)
        Center(
          child: Opacity(
            opacity: (1 - p).clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(
                qx * lockW * 0.25 + qx * tileH * 0.9 * sec,
                qy * lockH * 0.25 +
                    (-0.6 + qy * 0.2) * tileH * 1.2 * sec +
                    0.5 * tileH * 4.0 * sec * sec,
              ),
              child: Transform.rotate(
                angle: qx * 4.0 * sec,
                child: SizedBox(
                  width: lockW / 2,
                  height: lockH / 2,
                  child: ClipRect(
                    child: OverflowBox(
                      maxWidth: lockW,
                      maxHeight: lockH,
                      alignment: Alignment(qx, qy),
                      child: Image.asset(
                        'assets/images/locked.png',
                        width: lockW,
                        height: lockH,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    ];
  }
}
