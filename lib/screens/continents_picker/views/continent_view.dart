import 'package:flags/domain/domain.dart';
import 'package:flags/domain/services/levels/levels.service.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../presentation/presenters/continents_picker/route_params.dart';
import '../../../uikit/text/f_text.dart';
import '../components/continent.dart';

class ContinentsSlider extends StatefulWidget {
  const ContinentsSlider({
    super.key,
    required this.continents,
    required this.onPressed,
  });

  final List<ContinentType> continents;

  final ValueChanged<ContinentType> onPressed;

  @override
  State<ContinentsSlider> createState() => _ContinentsSliderState();
}

class _ContinentsSliderState extends State<ContinentsSlider> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        ...widget.continents.map(
          (e) => Stack(
            children: [
              ScaledGestureDetector(
                onTap: () => widget.onPressed(e),
                child: ContinentComponent.fromType(e),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: FBlueButton(
                  onPressed: () {
                    final params =
                        QR.params['data']!.value as ContinentPickerRouteParams;

                    ILevelsService.I.removeDataOfContinent(
                      continent: e,
                      gameMode: params.gameProcessType,
                    );
                  },
                  child: FText("reset state"),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
