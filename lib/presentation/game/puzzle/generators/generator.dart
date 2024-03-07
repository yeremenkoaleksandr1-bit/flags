import 'dart:math';

import 'package:flags/core/extensions/extensions.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/game_objects/flag/flag_extensions.dart';
import 'package:flame/extensions.dart';

import '../../../../domain/entities/game/game_levels/game_level.dart';
import '../../../../domain/game_objects/base/process.game_object.dart';
import '../../../../domain/game_objects/emblems/emblems.dart';
import '../../../../domain/game_objects/flag/flag.dart';
import '../entities/scallable_emblem.dart';

class PuzzlePartsGenerator {
  PuzzlePartsGenerator({
    required this.levels,
    required this.quantityParts,
    required this.quantityEmblem,
  });

  final int quantityParts;
  final int quantityEmblem;

  final List<GameLevel> levels;

  Future<List<ProcessGameObject>> generate(GameFlag flag, Random random) async {
    final parts = await generateParts(flag, random);
    final emblems = await generateEmblem(flag, random);

    final all = [...parts, ...emblems];

    all.shuffle(random);

    return all;
  }

  Future<List<ProcessGameObject>> generateParts(
      GameFlag flag, Random random) async {
    final flagFabrics = flag.fabrics;

    List<ProcessGameObject> parts = [...flagFabrics];

    List<String> usedFlags = [flag.name];

    for (var i = 0; i < quantityParts - flagFabrics.length; i++) {
      final randomFlag = levels
          .where((e) => !usedFlags.contains(e.flag.name))
          .toList()
          .random(random)
          .flag;

      final randomPart = randomFlag.fabrics.random(random);

      parts.add(
        randomPart.copyWith(
          name: "${randomFlag.name}_${randomPart.name}",
        ),
      );

      usedFlags.add(randomFlag.name);
    }

    return parts;
  }

  Future<List<EmblemPart>> generateEmblem(GameFlag flag, Random random) async {
    final flagEmblems = flag.emblems;

    List<String> usedFlags = [flag.name];

    List<EmblemPart> parts = [...flagEmblems];

    for (var i = 0; i < quantityEmblem - flagEmblems.length; i++) {
      final fLevels = levels
          .where((e) =>
              !usedFlags.contains(e.flag.name) && e.flag.emblems.isNotEmpty)
          .toList();

      if (fLevels.isEmpty) {
        break;
      }

      final randomFlag = fLevels.random(random).flag;

      final randomPart = randomFlag.emblems.random(random);

      parts.add(randomPart);

      usedFlags.add(randomFlag.name);
    }

    final angles = RotationConstants.assistAngles.toList();
    const scalesLen = 4;

    return [
      ...parts.map(
        (e) {
          final correctIndex = random.nextInt(scalesLen);
          var angle = (angles.random(random)).remainder(pi * 2);
          if (angle < 0) angle += pi * 2;

          final randomIndex = random.nextIntRange(0, scalesLen);

          final scales = generateScales(correctIndex, scalesLen, 0.2);

          final randomScale = scales[randomIndex];

          final scale = (randomScale >= 1
              ? randomScale
              : randomScale - 0.2 * randomIndex);

          return ScalableEmblemPart.fromEmblem(
            e.copyWith(
              rotation: angle,
              scale: scale,
            ),
            scales: scales,
          );
        },
      ),
    ];
  }

  List<double> generateScales(int correctIndex, int len, double inclement) {
    return List.generate(
      len,
      (index) => (1 + (index - correctIndex) * inclement).roundDouble(1),
    );
  }
}
