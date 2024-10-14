import 'dart:ui';

import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/converters/json_converter.dart';
import 'package:flags/domain/converters/objects/native_structs_converter.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/entities/points/points.dart';
import 'package:flags/domain/game_objects/shape/shape_object.dart';

class SPointSerializer implements IJsonConverter<SPoint, List<dynamic>> {
  const SPointSerializer();

  @override
  SPoint fromJson(List<dynamic> j) {
    final List<dynamic> p = j[1];
    return switch (j[0] as String) {
      "close" => SClosePoint(),
      "cubit" => SCubitPoint(p[0], p[1], p[2], p[3], p[4], p[5]),
      "line" => SLinePoint(p[0], p[1]),
      "move" => SMovePoint(p[0], p[1]),
      _ => throw UnimplementedError(),
    };
  }

  @override
  List<dynamic> toJson(SPoint m) {
    final String type = switch (m.runtimeType) {
      const (SClosePoint) => "close",
      const (SCubitPoint) => "cubit",
      const (SLinePoint) => "line",
      const (SMovePoint) => "move",
      _ => throw UnimplementedError(),
    };

    return [type, m.points];
  }
}

class SPaintSerializer implements IJsonConverter<SPaint, Map<String, dynamic>> {
  const SPaintSerializer();

  @override
  SPaint fromJson(Map<String, dynamic> j) {
    return SPaint(
      blendMode: BlendMode.values[j["blendMode"]],
      color: Color(j["color"]),
      invertColors: j["invertColors"],
      isAntiAlias: j["isAntiAlias"],
      strokeCap: StrokeCap.values[j["strokeCap"]],
      strokeJoin: StrokeJoin.values[j["strokeJoin"]],
      strokeMiterLimit: j["strokeMiterLimit"],
      strokeWidth: j["strokeWidth"],
      style: PaintingStyle.values[j["style"]],
    );
  }

  @override
  Map<String, dynamic> toJson(SPaint m) => {
        "blendMode": m.blendMode.index,
        "color": m.color.value,
        "invertColors": m.invertColors,
        "isAntiAlias": m.isAntiAlias,
        "strokeCap": m.strokeCap.index,
        "strokeJoin": m.strokeJoin.index,
        "strokeMiterLimit": m.strokeMiterLimit,
        "strokeWidth": m.strokeWidth,
        "style": m.style.index,
      };
}

class SPathSerializer implements IJsonConverter<SPath, Map<String, dynamic>> {
  const SPathSerializer();

  @override
  SPath fromJson(Map<String, dynamic> j) => SPath(
        rect: const RectSerializer().fromJson(j["rect"]),
        paint: const SPaintSerializer().fromJson(j["paint"]),
        points: [
          ...List.of(j["points"]).map(
            (e) => const SPointSerializer().fromJson(e),
          ),
        ],
      );

  @override
  Map<String, dynamic> toJson(SPath m) => {
        "rect": const RectSerializer().toJson(m.rect),
        "paint": const SPaintSerializer().toJson(m.paint),
        "points": [
          ...m.points.map((e) => const SPointSerializer().toJson(e)),
        ],
      };
}

class FlagStyleSerializer
    implements IJsonConverter<FlagStyle, Map<String, dynamic>> {
  @override
  FlagStyle fromJson(Map<String, dynamic> j) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(FlagStyle m) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
