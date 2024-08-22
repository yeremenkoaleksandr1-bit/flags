import 'package:flags/domain/converters/game_objects/flippable_object_converter.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/resources/resources.dart';
import 'package:flame/components.dart';

class EmblemConverter extends FlippableObjectConverter<EmblemPart> {
  const EmblemConverter();

  @override
  Map<String, dynamic> toJson(EmblemPart model) {
    return super.toJson(model)
      ..addAll({
        'emblem': model.emblem.name,
      });
  }

  @override
  EmblemPart fromJson(Map<String, dynamic> j) {
    final emblem = Resources.i.emblemsResources.emblems.firstWhere(
      (e) => e.name == j['emblem'],
    );
    return EmblemPart(
      key: j['k'],
      name: j['n'],
      uniqueName: j['un'],
      position: Vector2(j['px'], j['py']),
      scale: j['sc'],
      size: Vector2(j['sx'], j['sy']),
      rotation: j['r'],
      emblem: emblem,
      flippedHorizontal: j['fh'],
      flippedVertical: j['fv'],
    );
  }
}
