import 'package:flags/domain/domain.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../presentation/presenters/continents_picker/route_params.dart';
import 'completed_levels_count_stream_view.dart';

class ContinentComponent extends StatefulWidget {
  ContinentComponent._({
    super.key,
    required this.imagePath,
    required this.name,
  });

  late ContinentType type;

  final String name;

  final String imagePath;

  factory ContinentComponent.fromType(ContinentType type) {
    return (switch (type) {
      ContinentType.europe => ContinentComponent._(
          name: "Europe",
          imagePath: 'assets/images/continents/europe.png',
        ),
      ContinentType.asia => ContinentComponent._(
          name: "Asia",
          imagePath: 'assets/images/continents/asia.png',
        ),
      ContinentType.africa => ContinentComponent._(
          name: "Africa",
          imagePath: 'assets/images/continents/africa.png',
        ),
      ContinentType.oceania => ContinentComponent._(
          name: "Oceania",
          imagePath: 'assets/images/continents/oceania.png',
        ),
      ContinentType.northAmerica => ContinentComponent._(
          name: "North America",
          imagePath: 'assets/images/continents/north_america.png',
        ),
      ContinentType.southAmerica => ContinentComponent._(
          name: "South America",
          imagePath: 'assets/images/continents/south_america.png',
        ),
    })
      ..type = type;
  }

  @override
  State<ContinentComponent> createState() => _ContinentComponentState();
}

class _ContinentComponentState extends State<ContinentComponent> {
  final params = QR.params['data']!.value as ContinentPickerRouteParams;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ThemePaddings.content,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              widget.imagePath,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FText(
                  widget.name,
                  textAlign: TextAlign.center,
                  strokeWidth: 12,
                  textStyle: const TextStyle(
                    fontSize: 64,
                    height: 1,
                  ),
                ),
                CompletedLevelsCountStreamBuilder(
                  continent: widget.type,
                  gameMode: params.gameProcessType,
                  builder: (int quantity) {
                    return FText(
                      "$quantity/99",
                      textStyle: const TextStyle(
                        fontSize: 38,
                        height: 1,
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
