import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/presentation/game/puzzle/entities/draggable_emblem_part.game_object.dart';

import '../../../../uikit/game_widgets/objects/game_object.dart';

class PuzzleSceneItemsFactory {
  static GameObjectWidget build(
    ProcessGameObject object, {
    required GameObjectWidget Function(DraggableEmblemPart object) onEmblem,
    required GameObjectWidget Function(ProcessGameObject object) onDefault,
  }) {
    if (object is DraggableEmblemPart) {
      return onEmblem(object);
    }

    return onDefault(object);
  }
}
