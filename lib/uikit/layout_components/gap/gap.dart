import 'package:flutter/material.dart';

import '../../theme/theme.dart' show ThemeIndents;

class Gap extends StatelessWidget {
  const Gap._({this.width = 0, this.height = 0});

  final double width;
  final double height;

  static Widget custom({double height = 0, double width = 0}) =>
      Gap._(width: width, height: height);

  // Vertical Gaps
  static Widget get v4 => Gap._(height: ThemeIndents.s4);
  static Widget get v8 => Gap._(height: ThemeIndents.s8);
  static Widget get v6 => Gap._(height: ThemeIndents.s6);
  static Widget get v10 => Gap._(height: ThemeIndents.s10);
  static Widget get v12 => Gap._(height: ThemeIndents.s12);
  static Widget get v14 => Gap._(height: ThemeIndents.s14);
  static Widget get v16 => Gap._(height: ThemeIndents.s16);
  static Widget get v18 => Gap._(height: ThemeIndents.s18);
  static Widget get v20 => Gap._(height: ThemeIndents.s20);
  static Widget get v24 => Gap._(height: ThemeIndents.s24);
  static Widget get v30 => Gap._(height: ThemeIndents.s30);
  static Widget get v32 => Gap._(height: ThemeIndents.s32);
  static Widget get v40 => Gap._(height: ThemeIndents.s40);
  static Widget get v48 => Gap._(height: ThemeIndents.s48);

  // Horizontal Gaps
  static Widget get h4 => Gap._(width: ThemeIndents.s4);
  static Widget get h8 => Gap._(width: ThemeIndents.s8);
  static Widget get h6 => Gap._(width: ThemeIndents.s6);
  static Widget get h10 => Gap._(width: ThemeIndents.s10);
  static Widget get h12 => Gap._(width: ThemeIndents.s12);
  static Widget get h14 => Gap._(width: ThemeIndents.s14);
  static Widget get h16 => Gap._(width: ThemeIndents.s16);
  static Widget get h18 => Gap._(width: ThemeIndents.s18);
  static Widget get h20 => Gap._(width: ThemeIndents.s20);
  static Widget get h24 => Gap._(width: ThemeIndents.s24);
  static Widget get h30 => Gap._(width: ThemeIndents.s30);
  static Widget get h32 => Gap._(width: ThemeIndents.s32);
  static Widget get h40 => Gap._(width: ThemeIndents.s40);
  static Widget get h48 => Gap._(width: ThemeIndents.s48);

  @override
  Widget build(BuildContext context) => SizedBox(width: width, height: height);
}
