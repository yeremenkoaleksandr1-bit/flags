// ignore_for_file: no_logic_in_create_state

import 'dart:math';

import 'package:armar/armar.dart';
import 'package:flags/uikit/assets/components/close.dart';
import 'package:flutter/material.dart';

import '../../../../uikit/assets/components/check_mark.dart';
import '../../../../uikit/components/gestures/scaled_gesture.dart';
import '../../../../uikit/uikit.dart';

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
  final RxValue<bool> _isShown = RxValue(false);

  final RxValue<Offset> _position = RxValue(Offset.zero);
  final RxValue<double> _width = RxValue(0.0);

  @override
  Widget build(BuildContext context) {
    final mq = context.mediaQuery;
    return FastBuilder(
      () {
        final position = _position.value;
        final isShown = _isShown.value;
        final width = max(128.0, _width.value);

        return Positioned(
          left: (position.dx - (width / 2 - _width.value / 2))
              .clamp(0, mq.size.width - width),
          top: (position.dy - 48).clamp(mq.padding.top + 64, double.infinity),
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
