import 'dart:ui';

import 'package:flags/domain/converters/json_converter.dart';

class RectSerializer implements IJsonConverter<Rect, Map<String, dynamic>> {
  const RectSerializer();

  @override
  Rect fromJson(Map<String, dynamic> json) => Rect.fromLTWH(
        json["l"],
        json["t"],
        json["w"],
        json["h"],
      );

  @override
  Map<String, dynamic> toJson(Rect model) => {
        "t": model.top,
        "l": model.left,
        "w": model.width,
        "h": model.height,
      };
}

class OffsetSerializer implements IJsonConverter<Offset, List<double>> {
  const OffsetSerializer();

  @override
  Offset fromJson(List<double> j) => Offset(j[0], j[1]);

  @override
  List<double> toJson(Offset m) => [m.dx, m.dy];
}

class SizeSerializer implements IJsonConverter<Size, List<double>> {
  const SizeSerializer();

  @override
  Size fromJson(List<double> j) => Size(j[0], j[1]);

  @override
  List<double> toJson(Size m) => [m.width, m.height];
}
