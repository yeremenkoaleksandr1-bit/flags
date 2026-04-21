import 'package:flags/domain/models/app/game_preferences_data.dart';
import 'package:flags/domain/preferences/builders/build_game_preferences.dart';
import 'package:flags/uikit/assets/components/money.dart';
import 'package:flags/uikit/shaders/outline_shader.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalMoneysView extends StatelessWidget {
  const TotalMoneysView({super.key, required this.widgetKey});

  final Key widgetKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: Align(
        alignment: Alignment.topRight,
        child: Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 4.h,
              left: 0,
              right: 0,
              height: 36.h,
              child: const Material(
                color: ThemePalette.white,
                shape: StadiumBorder(),
              ),
            ),
            Positioned(
              top: -8.h,
              left: -8.w,
              height: 50.h,
              child: OutlineShader(child: UIMoney()),
            ),
            Padding(
              padding: EdgeInsets.only(left: 42.w, right: 14.w, top: 3.h),
              child: BuildGamePreferences(
                builder: (BuildContext context, GamePreferencesState state) {
                  return FText(
                    "${state.moneys}",
                    strokeWidth: 4.r,
                    textStyle: TextStyle(fontSize: 28.sp),
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
