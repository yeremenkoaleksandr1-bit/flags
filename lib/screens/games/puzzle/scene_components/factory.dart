import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';

import '../../../../uikit/game_widgets/objects/game_object.dart';

class PuzzleSceneItemsFactory {
  static GameObjectWidget build(
    ProcessGameObject object, {
    required GameObjectWidget Function(EmblemPart object) onEmblem,
    required GameObjectWidget Function(ProcessGameObject object) onDefault,
  }) {
    if (object is EmblemPart) {
      return onEmblem(object);
    }

    return onDefault(object);
  }
}
