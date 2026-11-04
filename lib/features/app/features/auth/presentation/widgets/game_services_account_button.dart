import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flags/features/app/features/auth/presentation/bloc/game_services_auth_cubit.dart';
import 'package:flags/features/app/features/auth/presentation/bloc/game_services_auth_state.dart';
import 'package:flags/navigator/router.gr.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameServicesAccountButton extends StatelessWidget {
  const GameServicesAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameServicesAuthCubit, GameServicesAuthState>(
      builder: (context, state) {
        final player = state.player;

        return GestureDetector(
          onTap: () {
            context.navigateTo(const GameServicesAccountRoute());
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ThemePalette.peach,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: ThemePalette.black.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AccountAvatar(player: player),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FText(
                        player?.displayName ?? 'Guest',
                        textStyle: const TextStyle(fontSize: 16, height: 1),
                      ),
                      FText(
                        player == null ? 'Tap to connect' : 'View profile',
                        textStyle: const TextStyle(fontSize: 12, height: 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AccountAvatar extends StatelessWidget {
  const _AccountAvatar({required this.player});

  final GameServicesPlayer? player;

  @override
  Widget build(BuildContext context) {
    final image = player?.iconImageBase64;

    if (image == null || image.isEmpty) {
      return const CircleAvatar(
        radius: 18,
        backgroundColor: ThemePalette.blue,
        child: Icon(
          Icons.person,
          color: ThemePalette.white,
          size: 18,
        ),
      );
    }

    return CircleAvatar(
      radius: 18,
      foregroundImage: MemoryImage(base64Decode(image)),
    );
  }
}
