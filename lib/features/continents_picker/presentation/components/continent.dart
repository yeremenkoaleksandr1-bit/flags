import 'package:flags/domain/domain.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'completed_levels_count_stream_view.dart';

class ContinentComponent extends StatefulWidget {
  ContinentComponent._({
    super.key,
    required this.imagePath,
    required this.name,
    required this.isBought,
    required this.gameProcessType,
  });

  final bool isBought;

  late ContinentType type;

  final String name;

  final String imagePath;

  final GameProcessType gameProcessType;

  factory ContinentComponent.fromType(
    ContinentType type,
    GameProcessType gameProcessType,
    bool isBought,
  ) {
    return (switch (type) {
      ContinentType.europe => ContinentComponent._(
        name: "Europe",
        imagePath: 'assets/images/continents/europe.png',
        gameProcessType: gameProcessType,
        isBought: isBought,
      ),
      ContinentType.asia => ContinentComponent._(
        name: "Asia",
        imagePath: 'assets/images/continents/asia.png',
        gameProcessType: gameProcessType,
        isBought: isBought,
      ),
      ContinentType.africa => ContinentComponent._(
        name: "Africa",
        imagePath: 'assets/images/continents/africa.png',
        gameProcessType: gameProcessType,
        isBought: isBought,
      ),
      ContinentType.oceania => ContinentComponent._(
        name: "Oceania",
        imagePath: 'assets/images/continents/oceania.png',
        gameProcessType: gameProcessType,
        isBought: isBought,
      ),
      ContinentType.northAmerica => ContinentComponent._(
        name: "North America",
        imagePath: 'assets/images/continents/north_america.png',
        gameProcessType: gameProcessType,
        isBought: isBought,
      ),
      ContinentType.southAmerica => ContinentComponent._(
        name: "South America",
        imagePath: 'assets/images/continents/south_america.png',
        gameProcessType: gameProcessType,
        isBought: isBought,
      ),
    })..type = type;
  }

  @override
  State<ContinentComponent> createState() => _ContinentComponentState();
}

class _ContinentComponentState extends State<ContinentComponent> {
  @override
  void initState() {
    super.initState();
  }

  late final levelsCount =
      FactoryGameContinent.continents[widget.type]!.levels.length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ThemePaddings.content,
      child: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 400.h),
              child: Image.asset(widget.imagePath),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FText(
                  widget.name,
                  textAlign: TextAlign.center,
                  strokeWidth: 12.r,
                  textStyle: TextStyle(fontSize: 64.sp, height: 1),
                ),
                if (widget.isBought)
                  CompletedLevelsCountStreamBuilder(
                    continent: widget.type,
                    gameMode: widget.gameProcessType,
                    builder: (int quantity) {
                      return FText(
                        "$quantity/$levelsCount",
                        textStyle: TextStyle(fontSize: 38.sp, height: 1),
                      );
                    },
                  ),
                if (!widget.isBought) const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
