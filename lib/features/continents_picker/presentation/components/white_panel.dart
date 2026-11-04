import 'package:flags/uikit/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WhitePanel extends StatelessWidget {
  const WhitePanel({
    super.key,
    required this.child,
    this.backgroundColor = ThemePalette.white,
    this.borderColor = const Color(0xFFC3DAF7),
  });

  final Widget child;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: borderColor,
          width: 3.r,
          strokeAlign: -0.98,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: child,
      ),
    );
  }
}
