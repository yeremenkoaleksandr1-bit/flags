// ignore_for_file: no_logic_in_create_state, must_be_immutable, join_return_with_assignment, prefer_const_constructors_in_immutables

import 'dart:math';

import 'package:flags/core/extensions/extensions.dart';
import 'package:flags/core/extensions/offset.dart';
import 'package:flags/uikit/assets/components/money.dart';
import 'package:flutter/material.dart';

class MoneyAnimatedView extends StatefulWidget {
  MoneyAnimatedView({
    super.key,
  });

  @override
  State<MoneyAnimatedView> createState() => MoneyAnimatedItemController();
}

class MoneyAnimatedItemController extends State<MoneyAnimatedView>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(controller);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  BezierCurve? _curve;

  late Offset currentPosition = const Offset(-999, -999);

  void playAnimation(
    OVector vector, {
    required void Function(GlobalKey<MoneyAnimatedItemController>) onCompleted,
  }) {
    final random = Random();
    final int inverse = random.nextBool() ? -1 : 1;
    final double distance = random.nextDoubleRange(20, 150);

    final m1 = vector.median.median(vector.p1);
    final m2 = vector.median.median(vector.p2);

    final p1 = vector.createPointFromDirection(m1, distance * inverse);
    final p2 = vector.createPointFromDirection(m2, distance * inverse);

    _curve = BezierCurve(vector.p1, p1, p2, vector.p2);

    currentPosition = _curve!.p1;

    controller.forward(from: 0).whenCompleteOrCancel(() {
      onCompleted(widget.key! as GlobalKey<MoneyAnimatedItemController>);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        if (_curve != null) {
          currentPosition = _curve!.lerp(
            animation.value,
            Curves.easeIn,
          );

          if (animation.value >= 1) {
            currentPosition = const Offset(-999, 999);
          }
        }

        return Transform.translate(
          offset: currentPosition.translate(-14, -14),
          child: child,
        );
      },
      child: SizedBox(
        height: 28,
        width: 28,
        child: UIMoney(),
      ),
    );
  }
}
