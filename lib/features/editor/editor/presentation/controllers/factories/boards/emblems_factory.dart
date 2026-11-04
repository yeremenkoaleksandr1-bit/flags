
import 'package:flags/domain/game_objects/emblems/emblem.dart';
import 'package:flags/resources/resources.dart';


base class EmblemsFactory {
  static List<Emblem> create() {
    return Resources.i.emblemsResources.emblems;
  }
}
