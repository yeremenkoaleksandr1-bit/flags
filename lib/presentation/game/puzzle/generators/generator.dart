import 'dart:math';

import 'package:flags/core/extensions/extensions.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/entities/path/path.dart';
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

  List<ProcessGameObject> generate(GameFlag flag, Random random) {
    final parts = generateParts(flag, random);

    final emblems = generateEmblem(flag, random);
    final all = [...parts, ...emblems];

    all.shuffle(random);

    return all;
  }

  List<ProcessGameObject> generateParts(
    GameFlag flag,
    Random random,
  ) {
    final flagFabrics = flag.fabrics;
    final List<ProcessGameObject> parts = [
      ...flagFabrics.map((e) => e.copyWith()),
    ];

    final List<String> usedFlags = [flag.name];
    final availableLevels =
        levels.where((e) => !usedFlags.contains(e.flag.name)).toList();

    for (var i = 0; i < quantityParts - flagFabrics.length; i++) {
      if (availableLevels.isEmpty) {
        break;
      }

      final randomFlag = availableLevels.random(random).flag;
      var randomPart = randomFlag.fabrics.random(random);

      if (randomPart is PathGameObject) {
        PathGameObject part = randomPart;
        if (randomPart is GroupedPathsPart) {
          if (parts.any((element) {
            return element.name == randomPart.name ||
                element.uniqueName == randomPart.uniqueName;
          })) {
            usedFlags.add(randomFlag.name);
            availableLevels.removeWhere((e) => e.flag.name == randomFlag.name);
            i--;
            continue;
          }
        }

        final isSimilarToOriginal = parts.whereType<PathGameObject>().any(
              (e) =>
                  e.path.isSimilarByPoints(part.path) &&
                  validateColor(
                    e.path.color.value,
                    part.path.color.value,
                  ),
            );

        final validColors = [
          ...allFlagColors.where(
            (e) => parts.whereType<PathGameObject>().any(
                  (p) => validateColor(p.path.color.value, e),
                ),
          ),
        ];

        if (isSimilarToOriginal) {
          part = part.copyWith(
            path: part.path.copyWith(
              paint: part.path.paint.copyWith(
                color: Color(
                  validColors.random(random),
                ),
              ),
            ),
          );
        }

        randomPart = part;
      }

      parts.add(
        randomPart.copyWith(
          name: "${randomFlag.name}_${randomPart.uniqueName}",
          uniqueName: "${randomFlag.name}_${randomPart.uniqueName}",
        ),
      );

      usedFlags.add(randomFlag.name);
      availableLevels.removeWhere((e) => e.flag.name == randomFlag.name);
    }

    return parts;
  }

  bool validateColor(int a, int b) {
    return ColorUtils.calculateColorSimilarity(a, b) < 80;
  }

  List<EmblemPart> generateEmblem(GameFlag flag, Random random) {
    final flagEmblems = flag.emblems;

    final List<String> usedFlags = [flag.name];
    final List<EmblemPart> parts = [
      ...flagEmblems.map((e) => e.copyWith()),
    ];

    final availableLevels = levels
        .where(
          (e) => !usedFlags.contains(e.flag.name) && e.flag.emblems.isNotEmpty,
        )
        .toList();

    for (var i = 0; i < quantityEmblem - flagEmblems.length; i++) {
      if (availableLevels.isEmpty) {
        break;
      }

      final randomFlag = availableLevels.random(random).flag;
      final randomPart = randomFlag.emblems.random(random);

      parts.add(
        randomPart.copyWith(
          name: "${randomFlag.name}_${randomPart.uniqueName}",
          uniqueName: "${randomFlag.name}_${randomPart.uniqueName}",
        ),
      );

      usedFlags.add(randomFlag.name);
      availableLevels.removeWhere((e) => e.flag.name == randomFlag.name);
    }

    final angles = RotationConstants.assistAngles.toList();
    const scalesLen = 4;

    return parts.map((e) {
      final correctIndex = random.nextInt(scalesLen);
      var angle = angles.random(random).remainder(pi * 2);
      if (angle < 0) {
        angle += pi * 2;
      }

      final randomIndex = random.nextIntRange(0, scalesLen);
      final scales = generateScales(correctIndex, scalesLen, 0.2);
      final randomScale = scales[randomIndex];
      final scale =
          (randomScale >= 1 ? randomScale : randomScale - 0.2 * randomIndex);

      return ScalableEmblemPart.fromEmblem(
        e.copyWith(rotation: angle, scale: scale),
        scales: scales,
      );
    }).toList();
  }

  List<double> generateScales(int correctIndex, int len, double increment) {
    return List.generate(
      len,
      (index) => (1 + (index - correctIndex) * increment).roundDouble(1),
    );
  }

  static const List<int> allFlagColors = [
    0xffFFFFFF,
    0xff000000,
    // red
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
    // orange
    0xffFF9801,
    0xffFE6700,
    0xffCD6601,
    // yellow
    0xffFFCD00,
    0xffFDDC05,
    0xffFDF042,
    // green
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
    // blue
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

List<double> rgbToHsl(int r, int g, int b) {
  final double rPrime = r / 255.0;
  final double gPrime = g / 255.0;
  final double bPrime = b / 255.0;

  final double cMax = max(rPrime, max(gPrime, bPrime));
  final double cMin = min(rPrime, min(gPrime, bPrime));
  final double delta = cMax - cMin;

  double h = 0.0;
  if (delta != 0) {
    if (cMax == rPrime) {
      h = ((gPrime - bPrime) / delta) % 6;
    } else if (cMax == gPrime) {
      h = ((bPrime - rPrime) / delta) + 2;
    } else {
      h = ((rPrime - gPrime) / delta) + 4;
    }
  }
  h = (h * 60) % 360;
  if (h < 0) {
    h += 360;
  }

  final double l = (cMax + cMin) / 2.0;

  double s = 0.0;
  if (delta != 0) {
    s = delta / (1 - (2 * l - 1).abs());
  }

  return [h, s * 100, l * 100];
}

double hslDistance(List<double> hsl1, List<double> hsl2) {
  final double h1 = hsl1[0];
  final double s1 = hsl1[1];
  final double l1 = hsl1[2];

  final double h2 = hsl2[0];
  final double s2 = hsl2[1];
  final double l2 = hsl2[2];

  final double dh = min((h1 - h2).abs(), 360 - (h1 - h2).abs()) / 180.0;
  final double ds = (s1 - s2).abs() / 100.0;
  final double dl = (l1 - l2).abs() / 100.0;

  return sqrt(dh * dh + ds * ds + dl * dl);
}

bool areColorsSimilar(
    int color1, int color2, double threshold, double brightnessThreshold) {
  final int r1 = (color1 >> 16) & 0xFF;
  final int g1 = (color1 >> 8) & 0xFF;
  final int b1 = color1 & 0xFF;

  final int r2 = (color2 >> 16) & 0xFF;
  final int g2 = (color2 >> 8) & 0xFF;
  final int b2 = color2 & 0xFF;

  final List<double> hsl1 = rgbToHsl(r1, g1, b1);
  final List<double> hsl2 = rgbToHsl(r2, g2, b2);

  final double distance = hslDistance(hsl1, hsl2);

  final double brightnessDifference = (hsl1[2] - hsl2[2]).abs();

  return distance < threshold;
}
