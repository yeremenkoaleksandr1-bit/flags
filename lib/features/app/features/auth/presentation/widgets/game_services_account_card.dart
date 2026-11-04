import 'dart:convert';

import 'package:flags/features/app/features/auth/presentation/bloc/game_services_auth_cubit.dart';
import 'package:flags/features/app/features/auth/presentation/bloc/game_services_auth_state.dart';
import 'package:flags/features/app/features/monetization/presentation/bloc/monetization_cubit.dart';
import 'package:flags/features/app/features/monetization/presentation/bloc/monetization_state.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameServicesAccountCard extends StatelessWidget {
  const GameServicesAccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameServicesAuthCubit, GameServicesAuthState>(
      builder: (context, authState) {
        return BlocBuilder<MonetizationCubit, MonetizationState>(
          builder: (context, monetizationState) {
            final authCubit = context.read<GameServicesAuthCubit>();
            final monetizationCubit = context.read<MonetizationCubit>();

            return FCard(
              color: ThemePalette.peach,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FText(
                    'Google Play Games',
                    textStyle: TextStyle(fontSize: 26),
                  ),
                  const SizedBox(height: 8),
                  if (authState.player != null)
                    _SignedInPlayerView(player: authState.player!)
                  else
                    FText(
                      'Connect your Google Play Games profile',
                      textStyle: const TextStyle(fontSize: 18, height: 1),
                    ),
                  if (authState.statusMessage != null) ...[
                    const SizedBox(height: 8),
                    FText(
                      authState.statusMessage!,
                      textStyle: const TextStyle(fontSize: 16, height: 1),
                    ),
                  ],
                  const SizedBox(height: 12),
                  FBlueButton(
                    onPressed: authState.isLoading
                        ? () {}
                        : () {
                            authCubit.signIn();
                          },
                    child: Center(
                      child: FText(
                        authState.isSignedIn ? 'Reconnect' : 'Connect',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FCard(
                    color: ThemePalette.peachCard,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FText(
                          monetizationState.isPremium
                              ? 'No Ads active'
                              : 'No Ads purchase',
                          textStyle: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(height: 4),
                        FText(
                          monetizationState.productPriceLabel,
                          textStyle: const TextStyle(fontSize: 18, height: 1),
                        ),
                        if (monetizationState.statusMessage != null) ...[
                          const SizedBox(height: 8),
                          FText(
                            monetizationState.statusMessage!,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              height: 1,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        if (!monetizationState.isPremium)
                          FYellowButton(
                            onPressed: monetizationState.isPurchasePending
                                ? () {}
                                : () {
                                    monetizationCubit.buyNoAdsSubscription(
                                      context,
                                    );
                                  },
                            child: Center(
                              child: FText(
                                monetizationState.isPurchasePending
                                    ? 'Processing...'
                                    : 'Buy for ${monetizationState.productPriceLabel}',
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        FBlueButton(
                          onPressed: monetizationState.isPurchasePending
                              ? () {}
                              : () {
                                  monetizationCubit.restorePurchases();
                                },
                          child: Center(child: FText('Restore purchases')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SignedInPlayerView extends StatelessWidget {
  const _SignedInPlayerView({required this.player});

  final GameServicesPlayer player;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PlayerAvatar(player: player),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FText(
                player.displayName,
                textStyle: const TextStyle(fontSize: 20),
              ),
              FText(
                player.playerId,
                textStyle: const TextStyle(fontSize: 14, height: 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayerAvatar extends StatelessWidget {
  const _PlayerAvatar({required this.player});

  final GameServicesPlayer player;

  @override
  Widget build(BuildContext context) {
    final image = player.iconImageBase64;

    if (image == null || image.isEmpty) {
      return CircleAvatar(
        radius: 24,
        child: Text(player.displayName.characters.first),
      );
    }

    return CircleAvatar(
      radius: 24,
      foregroundImage: MemoryImage(base64Decode(image)),
    );
  }
}
