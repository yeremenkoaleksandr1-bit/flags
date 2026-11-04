// ignore_for_file: no_logic_in_create_state

import 'dart:math';

import 'package:flags/uikit/assets/components/check_mark.dart';
import 'package:flags/uikit/assets/components/close.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

class EmblemConfirmationWidget extends StatefulWidget {
  const EmblemConfirmationWidget({
    super.key,
    required this.state,
    required this.onConfirm,
    required this.onDecline,
  });

  final VoidCallback onConfirm;
  final VoidCallback onDecline;

  final IEmblemConfirmationController state;

  @override
  State<EmblemConfirmationWidget> createState() => state;
}

abstract interface class IEmblemConfirmationController
    extends State<EmblemConfirmationWidget> {
  void setPosition(Offset position);

  void setWidth(double value);

  void show();

  void hide();
}

class EmblemConfirmationWidgetState extends State<EmblemConfirmationWidget>
    implements IEmblemConfirmationController {
  final ValueNotifier<bool> _isShown = ValueNotifier(false);

  final ValueNotifier<Offset> _position = ValueNotifier(Offset.zero);
  final ValueNotifier<double> _width = ValueNotifier(0.0);

  @override
  void dispose() {
    _isShown.dispose();
    _position.dispose();
    _width.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return MultiValueListenableBuilder(
      valueListenables: [_position, _isShown, _width],
      builder: (
        BuildContext context,
        List<dynamic> values,
        Widget? child,
      ) {
        final Offset position = values[0];
        final bool isShown = values[1];
        final double width = max(128.0, values[2] as double);

        return Positioned(
          left: (position.dx - (width / 2 - width / 2))
              .clamp(0, mq.size.width - width),
          top: position.dy.clamp(
            mq.padding.top + 64,
            double.infinity,
          ),
          width: width,
          height: 38,
          child: IgnorePointer(
            ignoring: !isShown,
            child: AnimatedOpacity(
              opacity: isShown ? 1 : 0,
              duration: const Duration(milliseconds: 100),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaledGestureDetector(
                      onTap: widget.onDecline,
                      child: FCard(
                        color: ThemePalette.red,
                        child: UIClose(),
                      ),
                    ),
                    Gap.h24,
                    ScaledGestureDetector(
                      onTap: widget.onConfirm,
                      child: FCard(
                        color: ThemePalette.green,
                        child: UICheckMark(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void hide() {
    _isShown.value = false;
  }

  @override
  void setPosition(Offset position) {
    _position.value = position;
  }

  @override
  void show() {
    _isShown.value = true;
  }

  @override
  void setWidth(double value) {
    _width.value = value;
  }
}
