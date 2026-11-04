import 'dart:math' as math;

import 'package:flutter/material.dart';

/// «Виртуальный экран» для игр на флагах: масштаб подобран так, чтобы
/// область размера Pixel 10 (на нём всё выверено) была видна целиком, а по
/// длинной стороне экран расширяется до краёв настоящего — без полос.
/// Размеры объектов, расстояния в пикселях, скорости — как на Pixel 10 на
/// любом телефоне; элементы, расставленные долями экрана, могут чуть
/// сместиться по той стороне, где добавилось место.
///
/// Для игры MediaQuery подменён: size = виртуальный экран (не меньше
/// [reference] по обеим сторонам), отступы безопасной зоны нулевые. Координаты внутри игры — в «пикселях Pixel 10»; для внешних слоёв
/// (анимация монет) их переводит [FlagGameViewport.toScreen].
class FlagGameViewport extends StatelessWidget {
  const FlagGameViewport({
    super.key,
    required this.child,
    this.background = Colors.black,
  });

  /// Pixel 10 в горизонтальном режиме, логические пиксели (1080×2424 / 2.625).
  static const Size reference = Size(923.4, 411.4);

  final Widget child;
  final Color background;

  /// Точка из координат игры → в координаты реального экрана.
  static Offset toScreen(BuildContext context, Offset local) {
    final scope = context.getInheritedWidgetOfExactType<_ViewportScope>();
    if (scope == null) return local;
    return scope.origin + local * scope.scale;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return ColoredBox(
      color: background,
      child: LayoutBuilder(
        builder: (context, c) {
          final real = c.biggest;
          // масштаб по меньшей стороне — «зона Pixel 10» видна целиком,
          // объекты того же размера; по длинной стороне виртуальный экран
          // расширяется до краёв настоящего (без полос и обрывов фона)
          final scale = math.min(
            real.width / reference.width,
            real.height / reference.height,
          );
          final virtual = Size(real.width / scale, real.height / scale);
          return FittedBox(
            fit: BoxFit.fill,
            child: SizedBox.fromSize(
              size: virtual,
              child: MediaQuery(
                data: mq.copyWith(
                  size: virtual,
                  padding: EdgeInsets.zero,
                  viewPadding: EdgeInsets.zero,
                  viewInsets: EdgeInsets.zero,
                ),
                child: _ViewportScope(
                  scale: scale,
                  origin: Offset.zero,
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ViewportScope extends InheritedWidget {
  const _ViewportScope({
    required this.scale,
    required this.origin,
    required super.child,
  });

  final double scale;
  final Offset origin;

  @override
  bool updateShouldNotify(_ViewportScope old) =>
      old.scale != scale || old.origin != origin;
}
