import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../uikit.dart';

class FLogoTextView extends StatelessWidget {
  const FLogoTextView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FText(
          "Flags",
          strokeWidth: 12.r,
          textStyle: TextStyle(fontSize: 64.sp, color: ThemePalette.white),
        ),
        FText(
          "Up",
          strokeWidth: 12.r,
          textStyle: TextStyle(
            fontSize: 84.sp,
            color: ThemePalette.yellow,
            height: -0.15,
          ),
        ),
      ],
    );
  }
}
