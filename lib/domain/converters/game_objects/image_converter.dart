import 'package:flags/domain/converters/game_objects/flippable_object_converter.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/resources/resources.dart';
import 'package:flame/components.dart';

class ImageGameObjectConverter
    extends FlippableObjectConverter<ImageGameObject> {
  const ImageGameObjectConverter();

  @override
  Map<String, dynamic> toJson(ImageGameObject model) {
    return super.toJson(model)
      ..addAll({
        'ip': model.imagePath,
      });
  }

  @override
  ImageGameObject fromJson(Map<String, dynamic> j) {
    return ImageGameObject(
      key: j['k'],
      name: j['n'],
      uniqueName: j['un'],
      position: Vector2(j['px'], j['py']),
      scale: j['sc'],
      size: Vector2(j['sx'], j['sy']),
      rotation: j['r'],
      imagePath: j['ip'],
      flippedHorizontal: j['fh'],
      flippedVertical: j['fv'],
    );
  }
}
