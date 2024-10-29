import 'dart:convert';
import 'dart:ui';

import 'package:flags/domain/converters/background_styles/bends_style.dart';
import 'package:flags/domain/converters/background_styles/pales_style.dart';
import 'package:flags/domain/converters/background_styles/pall_style.dart';
import 'package:flags/domain/converters/background_styles/quarterly_stylre.dart';
import 'package:flags/domain/converters/background_styles/saltire_style.dart';
import 'package:flags/domain/converters/background_styles/scandinavian_cross_style.dart';
import 'package:flags/domain/converters/json_converter.dart';
import 'package:flags/domain/converters/objects/native_structs_converter.dart';
import 'package:flags/domain/editor/styles/style.dart';

import 'bicolour_style.dart';
import 'border_style.dart';
import 'canton_style.dart';
import 'chevron_style.dart';
import 'clear_style.dart';
import 'czech_style.dart';
import 'fesses_style.dart';
import 'greek_cross_style.dart';
import 'symmetric_cross_style.dart';

abstract class FlagStyleSerializer<T extends FlagStyle>
    implements IJsonConverter<T, String> {
  T factory({
    required Rect rect,
    required List<Color> colors,
  });

  @override
  T fromJson(String j) {
    final Map<String, dynamic> jsonMap = jsonDecode(j);

    final Rect rect = const RectSerializer().fromJson(jsonMap['r']);

    final List<Color> colors = (jsonDecode(jsonMap['c']) as List<dynamic>)
        .map((colorValue) => Color(colorValue as int))
        .toList();

    return factory(
      rect: rect,
      colors: colors,
    );
  }

  @override
  String toJson(T m) {
    return jsonEncode(
      {
        'r': const RectSerializer().toJson(m.rect),
        'c': jsonEncode(
          [
            ...m.colors.map((e) => e.value),
          ],
        ),
      },
    );
  }

  static FlagStyleSerializer Function()? createFromName(String typeName) {
    return switch (typeName) {
      "BendsStyle" => BendsStyleSerializer.new,
      "BicolourStyle" => BicolourStyleSerializer.new,
      "BorderStyle" => BorderStyleSerializer.new,
      "CantonStyle" => CantonStyleSerializer.new,
      "ChevronStyle" => ChevronStyleSerializer.new,
      "ClearStyle" => ClearStyleSerializer.new,
      "CzechStyle" => CzechStyleSerializer.new,
      "FessesStyle" => FessesStyleSerializer.new,
      "GreekCrossStyle" => GreekCrossStyleSerializer.new,
      "PalesStyle" => PalesStyleSerializer.new,
      "PallStyle" => PallStyleSerializer.new,
      "QuarterlyStyle" => QuarterlyStyleSerializer.new,
      "SaltireStyle" => SaltireStyleSerializer.new,
      "ScandinavianCrossStyle" => ScandinavianCrossStyleSerializer.new,
      "SymmetricCrossStyle" => SymmetricCrossStyleSerializer.new,
      _ => null,
    };
  }
}
