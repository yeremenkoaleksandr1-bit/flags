import 'dart:math';

import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/domain/game_objects/parts/parts.dart';
import 'package:flags/presentation/game/puzzle/entities/colored_part.game_object.dart';
import 'package:flags/presentation/game/puzzle/generators/generator.dart';
import 'package:flags/presentation/game/puzzle/generators/super_easy.dart';
import 'package:flame/extensions.dart';

class PuzzleEasyGenerator extends PuzzleSuperEasyGenerator {
  final int quantityColoredPart;

  PuzzleEasyGenerator({
    this.quantityColoredPart = 1,
    super.quantityEmblem = 4,
    super.quantityParts = 5,
    required super.levels,
  });

  @override
  List<ProcessGameObject> generateParts(
    GameFlag flag,
    Random random,
  ) {
    const maxRandomColorsQuantity = 5;

    final superParts = super.generateParts(flag, random).toList();

    final flagObjects = flag.objects.whereType<PathGameObject>();

    final List<PathGameObject> parts = [];

    for (var i = 0; i < quantityColoredPart; i++) {
      final allColors = [...PuzzlePartsGenerator.allFlagColors];
      final superPart =
          superParts.whereType<PathGameObject>().toList().random(random);

      superParts.remove(superPart);

      final isFlagPart =
          flagObjects.any((e) => e.uniqueName == superPart.uniqueName);

      final List<Color> colors = [];

      if (isFlagPart) {
        colors.add(superPart.color);
      }

      while (colors.length < maxRandomColorsQuantity) {
        final colorInt = allColors.elementAt(
          random.nextInt(allColors.length),
        );

        if (!colors.any(
          (e) =>
              e.value == colorInt ||
              ColorUtils.calculateColorSimilarity(e.value, colorInt) < 40,
        )) {
          final color = Color(colorInt);
          colors.add(color);
          allColors.remove(colorInt);
        }
      }

      colors.shuffle(random);

      parts.add(
        ColoredPart(
          key: superPart.key,
          name: superPart.name,
          uniqueName: superPart.uniqueName,
          path: superPart.path,
          position: superPart.position,
          size: superPart.size,
          scale: superPart.scale,
          rotation: superPart.rotation,
          colors: colors,
          previousMustBePlaced: superPart.previousMustBePlaced,
        ),
      );
    }

    return [...superParts, ...parts];
  }
}

class ColorUtils {
  static double calculateColorSimilarity(int color1, int color2) {
    // Convert RGB to CIELAB
    final lab1 = rgbToLab(color1);
    final lab2 = rgbToLab(color2);

    // Compute Euclidean distance
    return sqrt(
      pow(lab1[0] - lab2[0], 2) +
          pow(lab1[1] - lab2[1], 2) +
          pow(lab1[2] - lab2[2], 2),
    );
  }

  static List<double> rgbToLab(int color) {
    final r = (color >> 16) & 0xFF;
    final g = (color >> 8) & 0xFF;
    final b = color & 0xFF;

    final xyz = rgbToXyz(r, g, b);
    return xyzToLab(xyz[0], xyz[1], xyz[2]);
  }

  static List<double> rgbToXyz(int r, int g, int b) {
    double rgbToXyzChannel(double c) {
      c = c / 255.0;
      if (c > 0.04045) {
        return pow((c + 0.055) / 1.055, 2.4) * 100;
      } else {
        return (c / 12.92) * 100;
      }
    }

    final double x =
        rgbToXyzChannel(0.4124564 * r + 0.3575761 * g + 0.1804375 * b);
    final double y =
        rgbToXyzChannel(0.2126729 * r + 0.7151522 * g + 0.072175 * b);
    final double z =
        rgbToXyzChannel(0.0193339 * r + 0.119192 * g + 0.9503041 * b);
    return [x, y, z];
  }

  static List<double> xyzToLab(double x, double y, double z) {
    const double referenceX = 95.047;
    const double referenceY = 100.0;
    const double referenceZ = 108.883;

    double xyzToLabChannel(double c) {
      if (c > 0.008856) {
        return pow(c, 1 / 3) * 116 - 16;
      } else {
        return c * 903.3;
      }
    }

    final double labL = xyzToLabChannel(x / referenceX);
    final double labA = xyzToLabChannel(y / referenceY);
    final double labB = xyzToLabChannel(z / referenceZ);
    return [labL, labA, labB];
  }
}
