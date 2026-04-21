import 'package:flags/domain/domain.dart';
import 'package:flags/features/app/features/shop/presentation/components/shop_item.view.dart';
import 'package:flags/features/continents_picker/presentation/components/continent.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flutter/material.dart';

class ContinentsSlider extends StatefulWidget {
  const ContinentsSlider({
    super.key,
    required this.gameProcessType,
    required this.continents,
    required this.onPressed,
  });

  final GameProcessType gameProcessType;
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
                    (e) => SizedBox.expand(
                      child: ShopItemView(
                        tag: "continent_${e.key}",
                        builder: (context, isBought) => ScaledGestureDetector(
                          onTap: () => widget.onPressed(e.value),
                          child: ContinentComponent.fromType(
                            e.value,
                            widget.gameProcessType,
                            isBought,
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
