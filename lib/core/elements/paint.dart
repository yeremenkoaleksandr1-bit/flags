import 'dart:ui';

import 'package:flutter/material.dart';

class SPaint {
  BlendMode blendMode;
  Color color;
  bool invertColors;
  bool isAntiAlias;
  StrokeCap strokeCap;
  StrokeJoin strokeJoin;
  double strokeMiterLimit;
  double strokeWidth;
  PaintingStyle style;

  SPaint({
    this.blendMode = BlendMode.srcOver,
    this.color = Colors.black,
    this.invertColors = false,
    this.isAntiAlias = true,
    this.strokeCap = StrokeCap.butt,
    this.strokeJoin = StrokeJoin.miter,
    this.strokeMiterLimit = 0,
    this.strokeWidth = 0,
    this.style = PaintingStyle.fill,
  });

  SPaint copyWith({
    BlendMode? blendMode,
    Color? color,
    bool? invertColors,
    bool? isAntiAlias,
    StrokeCap? strokeCap,
    StrokeJoin? strokeJoin,
    double? strokeMiterLimit,
    double? strokeWidth,
    PaintingStyle? style,
  }) {
    return SPaint(
      blendMode: blendMode ?? this.blendMode,
      color: color ?? this.color,
      invertColors: invertColors ?? this.invertColors,
      isAntiAlias: isAntiAlias ?? this.isAntiAlias,
      strokeCap: strokeCap ?? this.strokeCap,
      strokeJoin: strokeJoin ?? this.strokeJoin,
      strokeMiterLimit: strokeMiterLimit ?? this.strokeMiterLimit,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      style: style ?? this.style,
    );
  }

  Paint get flutterPaint => Paint().copyWith(
        blendMode: blendMode,
        color: color,
        invertColors: invertColors,
        isAntiAlias: isAntiAlias,
        strokeCap: strokeCap,
        strokeJoin: strokeJoin,
        strokeMiterLimit: strokeMiterLimit,
        strokeWidth: strokeWidth,
        style: style,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final SPaint typedOther = other as SPaint;
    return typedOther.blendMode == blendMode &&
        typedOther.color == color &&
        typedOther.invertColors == invertColors &&
        typedOther.isAntiAlias == isAntiAlias &&
        typedOther.strokeCap == strokeCap &&
        typedOther.strokeJoin == strokeJoin &&
        typedOther.strokeMiterLimit == strokeMiterLimit &&
        typedOther.strokeWidth == strokeWidth &&
        typedOther.style == style;
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      blendMode.hashCode ^
      color.hashCode ^
      invertColors.hashCode ^
      isAntiAlias.hashCode ^
      strokeCap.hashCode ^
      strokeJoin.hashCode ^
      strokeMiterLimit.hashCode ^
      strokeWidth.hashCode ^
      style.hashCode;

  @override
  String toString() {
    return 'PaintEntity{blendMode: $blendMode, color: $color, invertColors: $invertColors, isAntiAlias: $isAntiAlias, strokeCap: $strokeCap, strokeJoin: $strokeJoin, strokeMiterLimit: $strokeMiterLimit, strokeWidth: $strokeWidth, style: $style}';
  }
}

extension PaintEntityX on Paint {
  SPaint toEntity() {
    return SPaint(
      blendMode: blendMode,
      color: color,
      invertColors: invertColors,
      isAntiAlias: isAntiAlias,
      strokeCap: strokeCap,
      strokeJoin: strokeJoin,
      strokeMiterLimit: strokeMiterLimit,
      strokeWidth: strokeWidth,
      style: style,
    );
  }
}

extension PaintCopy on Paint {
  Paint copyWith({
    BlendMode? blendMode,
    Color? color,
    ColorFilter? colorFilter,
    FilterQuality? filterQuality,
    ImageFilter? imageFilter,
    bool? invertColors,
    bool? isAntiAlias,
    MaskFilter? maskFilter,
    Shader? shader,
    StrokeCap? strokeCap,
    StrokeJoin? strokeJoin,
    double? strokeMiterLimit,
    double? strokeWidth,
    PaintingStyle? style,
  }) {
    var paint = Paint()
      ..blendMode = blendMode ?? this.blendMode
      ..color = color ?? this.color
      ..colorFilter = colorFilter ?? this.colorFilter
      ..filterQuality = filterQuality ?? this.filterQuality
      ..imageFilter = imageFilter ?? this.imageFilter
      ..invertColors = invertColors ?? this.invertColors
      ..isAntiAlias = isAntiAlias ?? this.isAntiAlias
      ..maskFilter = maskFilter ?? this.maskFilter
      ..shader = shader ?? this.shader
      ..strokeCap = strokeCap ?? this.strokeCap
      ..strokeJoin = strokeJoin ?? this.strokeJoin
      ..strokeWidth = strokeWidth ?? this.strokeWidth
      ..style = style ?? this.style;

    return paint;
  }
}
