import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../uikit/layout_components/containers/card.dart';
import '../../uikit/theme/paddings.dart';

abstract class DialogWidget extends StatelessWidget {
  const DialogWidget({super.key});
  Widget buildContainer(BuildContext context, Widget child) {
    return FCard(
      child: build(context),
    );
  }

  Future<T?> showModal<T>({
    Alignment alignment = Alignment.center,
    RouteSettings? routeSettings,
    bool barrierDismissible = true,
    EdgeInsets padding = ThemePaddings.screen,
  }) =>
      showDialog<T>(
        context: QR.context!,
        routeSettings: routeSettings,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) => Padding(
          padding: padding,
          child: Align(
            alignment: alignment,
            child: buildContainer(
              context,
              build(context),
            ),
          ),
        ),
      );
}
