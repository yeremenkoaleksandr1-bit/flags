import 'package:flags/domain/converters/gameobject_converter.dart';
import 'package:flags/domain/game_objects/base/flippable.dart';

abstract class FlippableObjectConverter<T extends FlippableGameObject>
    extends GameObjectConverter<T> {
  const FlippableObjectConverter();

  @override
  Map<String, dynamic> toJson(T model) {
    return super.toJson(model)
      ..addAll({
        "fv": model.flippedVertical,
        "fh": model.flippedHorizontal,
      });
  }
}
