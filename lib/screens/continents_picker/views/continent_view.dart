import 'package:flags/domain/domain.dart';
import 'package:flags/domain/services/levels/levels.service.dart';
import 'package:flags/features/shop/shop_item.view.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:flags/screens/continents_picker/components/continent.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox.square(
          dimension: constraints.maxWidth,
          child: PageView(
            controller: _controller,
            children: [
              ...widget.continents.asMap().entries.map(
                    (e) => Stack(
                      children: [
                        ShopItemView(
                          tag: "continent_${e.key}",
                          child: () => ScaledGestureDetector(
                            onTap: () => widget.onPressed(e.value),
                            child: ContinentComponent.fromType(e.value),
                          ),
                        ),
                        if (IAppPresenter.isDebugMode)
                          Align(
                            alignment: Alignment.topCenter,
                            child: FBlueButton(
                              onPressed: () {
                                final params = QR.params['data']!.value!
                                    as ContinentPickerRouteParams;

                                ILevelsService.I.removeDataOfContinent(
                                  continent: e.value,
                                  gameMode: params.gameProcessType,
                                );
                              },
                              child: FText("reset state"),
                            ),
                          ),
                      ],
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
