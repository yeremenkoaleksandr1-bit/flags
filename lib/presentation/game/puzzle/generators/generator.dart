import 'dart:math';

import 'package:flags/core/extensions/extensions.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/emblems/emblems.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/domain/game_objects/flag/flag_extensions.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/presentation/game/puzzle/entities/scallable_emblem.dart';
import 'package:flags/presentation/game/puzzle/generators/easy.dart';
import 'package:flame/extensions.dart';

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
    GameFlag flag,
    Random random,
  ) async {
    final flagFabrics = flag.fabrics;

    final List<ProcessGameObject> parts = [
      ...flagFabrics.map(
        (e) => e.copyWith(),
      ),
    ];

    final List<String> usedFlags = [flag.name];

    for (var i = 0; i < quantityParts - flagFabrics.length; i++) {
      final randomFlag = levels
          .where((e) => !usedFlags.contains(e.flag.name))
          .toList()
          .random(random)
          .flag;

      final randomPart = randomFlag.fabrics.random(random);

      if (randomPart is PathGameObject) {
        final isSimilarToOriginal = parts.whereType<PathGameObject>().any(
              (e) =>
                  e.path.points.length == randomPart.path.points.length &&
                  e.path.rect.size == randomPart.path.rect.size &&
                  ColorUtils.calculateColorSimilarity(
                        e.color.value,
                        randomPart.color.value,
                      ) <
                      30,
            );
        if (isSimilarToOriginal) {
          randomPart.path.paint.color = Color(allFlagColors.random(random));
        }
      }

      parts.add(
        randomPart.copyWith(
          name: "${randomFlag.name}_${randomPart.uniqueName}",
          uniqueName: "${randomFlag.name}_${randomPart.uniqueName}",
        ),
      );

      usedFlags.add(randomFlag.name);
    }

    return parts;
  }

  Future<List<EmblemPart>> generateEmblem(GameFlag flag, Random random) async {
    final flagEmblems = flag.emblems;

    final List<String> usedFlags = [flag.name];

    final List<EmblemPart> parts = [
      ...flagEmblems.map(
        (e) => e.copyWith(),
      ),
    ];

    for (var i = 0; i < quantityEmblem - flagEmblems.length; i++) {
      final fLevels = levels
          .where(
            (e) =>
                !usedFlags.contains(e.flag.name) && e.flag.emblems.isNotEmpty,
          )
          .toList();

      if (fLevels.isEmpty) {
        break;
      }

      final randomFlag = fLevels.random(random).flag;

      final randomPart = randomFlag.emblems.random(random);

      parts.add(
        randomPart.copyWith(
          name: "${randomFlag.name}_${randomPart.uniqueName}",
          uniqueName: "${randomFlag.name}_${randomPart.uniqueName}",
        ),
      );

      usedFlags.add(randomFlag.name);
    }

    final angles = RotationConstants.assistAngles.toList();
    const scalesLen = 4;

    return [
      ...parts.map(
        (e) {
          final correctIndex = random.nextInt(scalesLen);
          var angle = angles.random(random).remainder(pi * 2);
          if (angle < 0) {
            angle += pi * 2;
          }

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

  static const List<int> allFlagColors = [
    0xffFFFFFF,
    0xff000000,
    //red
    0xffCC0033,
    0xffCD3333,
    0xffCD3333,
    0xffCC0001,
    0xffCD3301,
    0xffFE0000,
    0xffFF3334,
    0xffFF0032,
    0xff9A0034,
    0xff981E1D,
    0xff663234,
    //orange
    0xffFF9801,
    0xffFE6700,
    0xffCD6601,
    //yellow
    0xffFFCD00,
    0xffFDDC05,
    0xffFDF042,
    //green
    0xff229E46,
    0xff019968,
    0xff01694E,
    0xff007934,
    0xff1FB53A,
    0xff009901,
    0xff016600,
    0xff346633,
    0xff3F9A01,
    0xff017E3C,
    //blue
    0xff013797,
    0xff003265,
    0xff01008C,
    0xff6799CC,
    0xff0198CD,
    0xff3367CD,
    0xff0066CB,
    0xff669AFF,
    0xff6ABFE6,
    0xff4A96D0,
    0xff0132CD,
    0xff333D84,
    0xff241E8A,
    0xff171796,
    0xff015EA4,
    0xff0146AE,
  ];
}
