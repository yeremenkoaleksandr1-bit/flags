import 'dart:async';

import 'package:flutter/material.dart';

/// Куда поворачивается экран — для иконки поворота телефона.
enum RotationHint { toLandscape, toPortrait }

/// Переход через затемнение: чёрный слой поверх всего приложения плавно
/// появляется, под ним выполняется [action] (смена экрана, поворот ориентации),
/// и после паузы [hold] слой плавно исчезает. Скрывает артефакты поворота.
///
/// С [rotation] посередине чёрного экрана показывается иконка телефона,
/// которая плавно поворачивается. Во время смены ориентации иконки на экране нет:
/// весь интерфейс в этот момент разворачивается на 90°, и видимая иконка дёрнулась бы.
abstract final class BlackoutTransition {
  static const Duration fadeDuration = Duration(milliseconds: 250);

  // иконка поворота
  static const Duration iconFadeDuration = Duration(milliseconds: 150);
  static const Duration iconTurnDuration = Duration(milliseconds: 600);
  static const double iconSize = 200;
  static const String _iconAsset = 'assets/images/ui/rotate_phone.png';

  static OverlayEntry? _entry;
  static final ValueNotifier<bool> _visible = ValueNotifier(false);
  static final ValueNotifier<bool> _iconVisible = ValueNotifier(false);
  static final ValueNotifier<double> _iconTurns = ValueNotifier(0);
  static bool _running = false;

  static Future<void> run(
    BuildContext context,
    FutureOr<void> Function() action, {
    Duration hold = const Duration(milliseconds: 450),
    RotationHint? rotation,
  }) async {
    if (_running) return;
    _running = true;
    // против часовой, как на иконке: портрет 0 → альбом −¼ оборота
    final (fromTurns, toTurns) = switch (rotation) {
      RotationHint.toLandscape => (0.0, -0.25),
      RotationHint.toPortrait => (-0.25, 0.0),
      null => (0.0, 0.0),
    };
    final overlay = Overlay.of(context, rootOverlay: true);
    try {
      if (rotation != null) {
        // иконка должна быть готова к моменту появления, а не догружаться
        await precacheImage(const AssetImage(_iconAsset), context);
      }
      _iconTurns.value = fromTurns;
      _iconVisible.value = false;
      _entry ??= OverlayEntry(builder: (_) => const _BlackoutLayer());
      if (!_entry!.mounted) {
        overlay.insert(_entry!);
      }
      // один кадр, чтобы слой появился с нулевой прозрачностью и анимировался
      await WidgetsBinding.instance.endOfFrame;
      _visible.value = true;
      await Future<void>.delayed(fadeDuration);

      Future<void> showIcon() async {
        _iconVisible.value = true;
        await Future<void>.delayed(iconFadeDuration);
        _iconTurns.value = toTurns;
        await Future<void>.delayed(iconTurnDuration);
        _iconVisible.value = false;
        await Future<void>.delayed(iconFadeDuration);
      }

      // Иконка всегда крутится, пока интерфейс в портрете, чтобы «вертикально»
      // совпадало с тем, как держат телефон: при входе — до поворота экрана,
      // при выходе — уже после возврата в портрет.
      if (rotation == RotationHint.toLandscape) await showIcon();

      // не ждём завершения навигации: future push-а завершается только при pop
      unawaited(Future(action));
      await Future<void>.delayed(hold);

      if (rotation == RotationHint.toPortrait) await showIcon();

      _visible.value = false;
      await Future<void>.delayed(fadeDuration);
    } finally {
      _entry?.remove();
      _entry = null;
      _running = false;
    }
  }
}

class _BlackoutLayer extends StatelessWidget {
  const _BlackoutLayer();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: BlackoutTransition._visible,
      builder: (context, visible, _) {
        return AbsorbPointer(
          // пока идёт переход, нажатия не проходят к экранам под слоем
          child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: BlackoutTransition.fadeDuration,
            curve: Curves.easeInOut,
            child: ColoredBox(
              color: Colors.black,
              child: Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: BlackoutTransition._iconVisible,
                  builder: (context, iconVisible, _) => AnimatedOpacity(
                    opacity: iconVisible ? 1 : 0,
                    duration: BlackoutTransition.iconFadeDuration,
                    child: ValueListenableBuilder<double>(
                      valueListenable: BlackoutTransition._iconTurns,
                      builder: (context, turns, _) => AnimatedRotation(
                        turns: turns,
                        duration: BlackoutTransition.iconTurnDuration,
                        curve: Curves.easeInOut,
                        child: Image.asset(
                          BlackoutTransition._iconAsset,
                          width: BlackoutTransition.iconSize,
                          height: BlackoutTransition.iconSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
