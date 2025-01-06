// ignore_for_file: no_logic_in_create_state, avoid_single_cascade_in_expression_statements

import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HeartTries extends StatefulWidget {
  const HeartTries({
    super.key,
    required this.state,
  });

  final HeartTriesState state;

  @override
  State<HeartTries> createState() => state;
}

class HeartTriesState extends State<HeartTries> {
  final int tries;

  late final List<GlobalKey<_HeartState>> _heartsKeys = List.generate(
    tries,
    (index) => GlobalKey<_HeartState>(),
  );

  HeartTriesState({
    required this.tries,
  });

  late int _showsHeart = tries;

  @override
  void initState() {
    super.initState();
  }

  void removeOneHeart() {
    if (isOver()) return;
    _heartsKeys[tries - _showsHeart].currentState!..controller.forward(from: 0);

    _showsHeart--;
  }

  void refresh() async {
    _showsHeart = tries;
    await Future.forEach(_heartsKeys.reversed, (element) async {
      if (element.currentState!.controller.status ==
          AnimationStatus.completed) {
        element.currentState!.controller.reverse(from: 1);
        await Future.delayed(
          const Duration(milliseconds: 80),
        );
      }
    });
  }

  bool isOver() {
    return _showsHeart <= 0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._heartsKeys.map(
            (e) => _Heart(
              key: e,
            ),
          ),
        ],
      ),
    );
  }
}

class _Heart extends StatefulWidget {
  const _Heart({super.key});

  @override
  State<_Heart> createState() => _HeartState();
}

class _HeartState extends State<_Heart> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 150),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sprite = SpriteUIWidget(
      image: Assets.images.heart.image,
    );

    return Stack(
      children: [
        Opacity(
          opacity: 0.4,
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ),
            child: sprite,
          ),
        ),
        sprite.animate(
          controller: controller,
          autoPlay: false,
          effects: [
            const FadeEffect(
              curve: Curves.easeInBack,
              begin: 1,
              end: 0,
            ),
            const MoveEffect(
              curve: Curves.easeInBack,
              begin: Offset.zero,
              end: Offset(0, 68),
            ),
          ],
        )
      ],
    );
  }
}
