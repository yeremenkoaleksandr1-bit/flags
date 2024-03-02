import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../uikit/assets/components/tiled_background.dart';
import '../../../../uikit/components/progress_indicator/linear_progress_indicator.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemePalette.blue,
      body: Stack(
        children: [
          Positioned.fill(child: TiledBackground()),
          Positioned.fill(
            child: Padding(
              padding: ThemePaddings.content,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Center(
                    child: const FLogoTextView()
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .rotate(
                          end: 0.005,
                          begin: -0.005,
                          curve: Curves.linear,
                          duration: const Duration(
                            milliseconds: 2000,
                          ),
                        ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 84),
                    child: Column(
                      children: [
                        Text(
                          "loading",
                          style: TextStyle(
                            color: ThemePalette.white,
                          ),
                        ),
                        FLinearProgressIndicator(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
