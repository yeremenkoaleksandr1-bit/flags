import 'package:flags/domain/models/app/game_preferences_data.dart';
import 'package:flags/domain/preferences/builders/build_game_preferences.dart';
import 'package:flags/uikit/assets/components/money.dart';
import 'package:flags/uikit/shaders/outline_shader.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// где начинается белая плашка — доля ширины иконки денег (118x137 px)
const double _kPillStartUnderIcon = 0.5;

class TotalMoneysView extends StatelessWidget {
  const TotalMoneysView({
    super.key,
    required this.widgetKey,
    this.paddingRight,
    this.pillHeight,
    this.pillTop,
    this.iconHeight,
    this.iconOffsetTop,
    this.iconOffsetLeft,
    this.fontSize,
    this.strokeWidth,
    this.paddingLeft,
    this.paddingRight2,
    this.paddingTop,
  });

  final Key widgetKey;

  // Внешний отступ справа
  final double? paddingRight;
  // Белая таблетка
  final double? pillHeight;
  final double? pillTop;
  // Иконка монеты
  final double? iconHeight;
  final double? iconOffsetTop;
  final double? iconOffsetLeft;
  // Цифра
  final double? fontSize;
  final double? strokeWidth;
  // Внутренние отступы таблетки
  final double? paddingLeft;
  final double? paddingRight2;
  final double? paddingTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: paddingRight ?? 12.w),
      child: Align(
        alignment: Alignment.topRight,
        child: Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: pillTop ?? 4.h,
              // плашка начинается под серединой иконки: левый верх иконки
              // прозрачный, и сквозь него был виден край плашки (лишняя линия)
              left: (iconOffsetLeft ?? -8.w) +
                  (iconHeight ?? 50.h) * 118 / 137 * _kPillStartUnderIcon,
              right: 0,
              height: pillHeight ?? 36.h,
              child: const Material(
                color: ThemePalette.white,
                shape: StadiumBorder(),
              ),
            ),
            Positioned(
              top: iconOffsetTop ?? -8.h,
              left: iconOffsetLeft ?? -8.w,
              height: iconHeight ?? 50.h,
              child: KeyedSubtree(
                key: widgetKey,
                child: OutlineShader(
                  child: UIMoney(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left:   paddingLeft  ?? 42.w,
                right:  paddingRight2 ?? 14.w,
                top:    paddingTop   ?? 3.h,
              ),
              child: BuildGamePreferences(
                builder: (BuildContext context, GamePreferencesState state) {
                  return FText(
                    "${state.moneys}",
                    strokeWidth: strokeWidth ?? 4.r,
                    textStyle: TextStyle(fontSize: fontSize ?? 28.sp),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
