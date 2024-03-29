import 'package:armar/rx/rx.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/uikit/assets/components/money.dart';
import 'package:flags/uikit/shaders/outline_shader.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';

class TotalMoneysView extends StatelessWidget {
  const TotalMoneysView({
    super.key,
    required this.widgetKey,
  });

  final Key widgetKey;

  @override
  Widget build(BuildContext context) {
    final moneyRx = IAppPresenter.I.gameState.data.moneyRx;

    return Padding(
      padding: const Pad(right: 12),
      child: Align(
        alignment: Alignment.topRight,
        child: Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          children: [
            const Positioned(
              top: 4,
              left: 0,
              right: 0,
              height: 36,
              child: Material(
                color: ThemePalette.white,
                shape: StadiumBorder(),
              ),
            ),
            Positioned(
              top: -8,
              left: -8,
              height: 48,
              child: OutlineWidget(
                key: widgetKey,
                child: UIMoney(),
              ),
            ),
            Padding(
              padding: const Pad(left: 42, right: 14, top: 3),
              child: FastValueBuilder(
                listen: moneyRx,
                builder: (int value) {
                  return OutlineWidget(
                    child: FText(
                      "$value",
                      strokeWidth: 4,
                      textStyle: const TextStyle(
                        fontSize: 28,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
