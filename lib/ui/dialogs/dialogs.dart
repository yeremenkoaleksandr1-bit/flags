import 'package:flags/ui/dialogs/base/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

abstract class DialogWidget<T> extends StatelessWidget {
  const DialogWidget({super.key});

  Future<T?> showModal({
    Alignment alignment = Alignment.center,
    RouteSettings? routeSettings,
    bool barrierDismissible = true,
  }) =>
      showDialog<T>(
        context: QR.context!,
        routeSettings: routeSettings,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) => FCustomDialog(
          alignment: alignment,
          dialogContext: context,
          child: build(context),
        ),
      );
}
