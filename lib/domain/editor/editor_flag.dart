import 'package:equatable/equatable.dart';
import 'package:flags/domain/editor/styles/clear_style.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class EditorFlagData extends Equatable {
  final String name;
  final double proportion;
  final List<GameObject> objects;
  final FlagStyle backgroundStyle;

  Rect get rect =>
      Vector2(GameFlag.defaultSize.x, GameFlag.defaultSize.y / proportion)
          .toRect();

  EditorFlagData({
    required this.name,
    required this.proportion,
    this.objects = const [],
    FlagStyle? backgroundStyle,
  }) : backgroundStyle = backgroundStyle ??
            ClearStyle(
              rect:
                  Vector2(GameFlag.defaultSize.x, GameFlag.defaultSize.y / proportion)
                      .toRect(),
              colors: [
                Colors.white,
              ],
            );

  EditorFlagData clone() {
    return EditorFlagData(
      name: name,
      proportion: proportion,
      objects: [
        ...objects.map((e) => e.copyWith()),
      ],
      backgroundStyle: backgroundStyle,
    );
  }

  EditorFlagData copyWith({
    String? name,
    double? proportion,
    List<GameObject>? objects,
    FlagStyle? backgroundStyle,
  }) {
    return EditorFlagData(
      name: name ?? this.name,
      proportion: proportion ?? this.proportion,
      objects: objects ?? this.objects,
      backgroundStyle: backgroundStyle ?? this.backgroundStyle,
    );
  }

  @override
  List<Object?> get props => [
        name,
        objects,
        backgroundStyle,
        proportion,
      ];
}
