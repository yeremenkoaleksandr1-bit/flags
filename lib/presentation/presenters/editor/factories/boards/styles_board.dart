import 'dart:ui';

import 'package:armar/armar.dart';
import 'package:flags/domain/editor/styles/bends_style.dart';
import 'package:flags/domain/editor/styles/bicolour_style.dart';
import 'package:flags/domain/editor/styles/border_style.dart';
import 'package:flags/domain/editor/styles/canton_style.dart';
import 'package:flags/domain/editor/styles/chevron_style.dart';
import 'package:flags/domain/editor/styles/clear_style.dart';
import 'package:flags/domain/editor/styles/czech_style.dart';
import 'package:flags/domain/editor/styles/fesses_style.dart';
import 'package:flags/domain/editor/styles/greek_cross_style.dart';
import 'package:flags/domain/editor/styles/pales_style.dart';
import 'package:flags/domain/editor/styles/pall_style.dart';
import 'package:flags/domain/editor/styles/quarterly_stylre.dart';
import 'package:flags/domain/editor/styles/saltire_style.dart';
import 'package:flags/domain/editor/styles/scandinavian_cross_style.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/editor/styles/symmetric_cross_style.dart';

base class StylesBoardFactory {
  static Map<String, FlagStyle> create(Rect rect) => {
        "Clear": ClearStyle(rect: rect),
        "Symmetric cross": SymmetricCrossStyle(rect: rect),
        "Bends": BendsStyle(rect: rect),
        "Bicolour": BicolourStyle(rect: rect),
        "Border": BorderStyle(rect: rect),
        "Canton": CantonStyle(rect: rect),
        "Chevron": ChevronStyle(rect: rect),
        "Czech": CzechStyle(rect: rect),
        "Fesses": FessesStyle(rect: rect),
        "Greek cross": GreekCrossStyle(rect: rect),
        "Pales": PalesStyle(rect: rect),
        "Pall": PallStyle(rect: rect),
        "Quarterly": QuarterlyStyle(rect: rect),
        "Saltire": SaltireStyle(rect: rect),
        "Scandinavian cross": ScandinavianCrossStyle(rect: rect),
      };
}
