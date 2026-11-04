import 'package:auto_route/auto_route.dart';
import 'package:flags/features/app/features/auth/presentation/widgets/game_services_account_card.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';

@RoutePage()
class GameServicesAccountScreen extends StatelessWidget {
  const GameServicesAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameSafeArea(
      child: GamePageBuilder(
        endSlideDirection: GamePageSlideDirection.right,
        child: Stack(
          children: [
            Padding(
              padding: ThemePaddings.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: FText(
                      'Account',
                      textStyle: TextStyle(fontSize: 52),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const GameServicesAccountCard(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: const FBackButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
