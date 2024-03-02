import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../uikit/layout_components/containers/card.dart';
import '../../uikit/theme/paddings.dart';

abstract class DialogWidget<T> extends StatelessWidget {
  const DialogWidget({super.key});

  Widget buildContainer(BuildContext context, Widget child) {
    return FCard(
      child: build(context),
    );
  }

  Future<T?> showModal({
    Alignment alignment = Alignment.center,
    RouteSettings? routeSettings,
    bool barrierDismissible = true,
  }) =>
      showDialog<T>(
        context: QR.context!,
        routeSettings: routeSettings,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) => Stack(
          children: [
            Padding(
              padding: ThemePaddings.screen,
              child: Align(
                alignment: alignment,
                child: buildContainer(
                  context,
                  build(context),
                ),
              ),
            ),
          ],
        ),
      );
}
