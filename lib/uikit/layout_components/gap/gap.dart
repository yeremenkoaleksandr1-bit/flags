import 'package:flutter/material.dart';

import '../../theme/theme.dart' show ThemeIndents;

class Gap extends StatelessWidget {
  const Gap._({
    this.width = 0,
    this.height = 0,
  });

  final double width;
  final double height;

  static Widget custom({double height = 0, double width = 0}) =>
      Gap._(width: width, height: height);

  // Vertical Gaps
  static const v4 = Gap._(height: ThemeIndents.s4);
  static const v8 = Gap._(height: ThemeIndents.s8);
  static const v6 = Gap._(height: ThemeIndents.s6);
  static const v10 = Gap._(height: ThemeIndents.s10);
  static const v12 = Gap._(height: ThemeIndents.s12);
  static const v14 = Gap._(height: ThemeIndents.s14);
  static const v16 = Gap._(height: ThemeIndents.s16);
  static const v18 = Gap._(height: ThemeIndents.s18);
  static const v20 = Gap._(height: ThemeIndents.s20);
  static const v24 = Gap._(height: ThemeIndents.s24);
  static const v30 = Gap._(height: ThemeIndents.s30);
  static const v32 = Gap._(height: ThemeIndents.s32);
  static const v40 = Gap._(height: ThemeIndents.s40);
  static const v48 = Gap._(height: ThemeIndents.s48);

  // Horizontal Gaps
  static const h4 = Gap._(width: ThemeIndents.s4);
  static const h8 = Gap._(width: ThemeIndents.s8);
  static const h6 = Gap._(width: ThemeIndents.s6);
  static const h10 = Gap._(width: ThemeIndents.s10);
  static const h12 = Gap._(width: ThemeIndents.s12);
  static const h14 = Gap._(width: ThemeIndents.s14);
  static const h16 = Gap._(width: ThemeIndents.s16);
  static const h18 = Gap._(width: ThemeIndents.s18);
  static const h20 = Gap._(width: ThemeIndents.s20);
  static const h24 = Gap._(width: ThemeIndents.s24);
  static const h30 = Gap._(width: ThemeIndents.s30);
  static const h32 = Gap._(width: ThemeIndents.s32);
  static const h40 = Gap._(width: ThemeIndents.s40);
  static const h48 = Gap._(width: ThemeIndents.s48);

  @override
  Widget build(BuildContext context) => SizedBox(width: width, height: height);
}
