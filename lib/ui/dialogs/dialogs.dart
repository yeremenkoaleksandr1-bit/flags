import 'package:flutter/material.dart';

import '../../uikit/layout_components/containers/card.dart';
import '../../uikit/theme/paddings.dart';

abstract class DialogWidget extends StatelessWidget {
  const DialogWidget({super.key});

  Widget buildContainer(BuildContext context, Widget child) {
    return FCard(child: build(context));
  }

  Future<T?> showModal<T>(
    BuildContext context, {
    Alignment alignment = Alignment.center,
    RouteSettings? routeSettings,
    bool barrierDismissible = true,
    EdgeInsets? padding,
    bool useRootNavigator = false,
  }) => showDialog<T>(
    context: context,
    routeSettings: routeSettings,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) => Padding(
      padding: padding ?? ThemePaddings.screen,
      child: Align(
        alignment: alignment,
        child: buildContainer(context, build(context)),
      ),
    ),
  );
}
