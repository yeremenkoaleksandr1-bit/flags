import 'package:flags/presentation/game/puzzle/generators/generator.dart';

class PuzzleSuperEasyGenerator extends PuzzlePartsGenerator {
  PuzzleSuperEasyGenerator({
    super.quantityParts = 3,
    super.quantityEmblem = 2,
    super.multiplier = 1,
  });
}
