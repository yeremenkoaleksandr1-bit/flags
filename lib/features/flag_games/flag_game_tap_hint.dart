import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Подсказка «Tap to start» — один раз за всё сохранение: на той игре с флагом,
/// которую игрок открыл первой, пока он её не начал. После этого её больше нет
/// нигде — ни в других играх, ни после рестарта, ни после перезапуска.
///
/// [visible] — игра в состоянии «ещё не начата». Как только он стал false,
/// подсказка уходит навсегда, даже если игра снова вернётся в это состояние.
class FlagGameTapHint extends StatefulWidget {
  const FlagGameTapHint({super.key, required this.visible});

  final bool visible;

  static const String _seenKey = 'flag_games_tap_hint_seen';

  // в памяти: подсказку уже отдали какому-то экрану в этой сессии
  static bool _claimed = false;

  @override
  State<FlagGameTapHint> createState() => _FlagGameTapHintState();
}

class _FlagGameTapHintState extends State<FlagGameTapHint>
    with SingleTickerProviderStateMixin {
  bool _show = false; // этому экрану досталась подсказка
  bool _done = false; // игра началась — больше не показываем

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    _claim();
  }

  Future<void> _claim() async {
    if (FlagGameTapHint._claimed) return;
    FlagGameTapHint._claimed = true;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(FlagGameTapHint._seenKey) ?? false) return;
    // отмечаем сразу: подсказка достаётся только первому открытому флагу,
    // даже если из него вышли, не начав игру
    await prefs.setBool(FlagGameTapHint._seenKey, true);
    if (!mounted) return;
    setState(() => _show = true);
    _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant FlagGameTapHint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_show && oldWidget.visible && !widget.visible) {
      _done = true;
      _pulse.stop();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final on = _show && !_done && widget.visible;
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: on ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: Center(
          child: FadeTransition(
            opacity: Tween(begin: 0.45, end: 1.0).animate(_pulse),
            child: FText(
              'Tap to start',
              textStyle: const TextStyle(fontSize: 34),
            ),
          ),
        ),
      ),
    );
  }
}
