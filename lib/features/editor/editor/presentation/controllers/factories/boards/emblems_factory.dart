import 'dart:ui';

import 'package:flags/domain/game_objects/emblems/emblem.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/resources/resources.dart';

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

base class EmblemsFactory {
  static List<Emblem> create() {
    return Resources.i.emblemsResources.emblems;
  }
}
