import 'package:flags/features/app/features/monetization/presentation/bloc/monetization_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Пауза между проигрышем и рекламой — чтобы игрок увидел, как проиграл.
const Duration kFlagGameAdDelay = Duration(milliseconds: 1000);

/// Сообщает о проигрыше: на каждый N-й проигрыш (см.
/// [MonetizationCubit.flagGameLossesPerAd]) после паузы показывается реклама.
/// Рекламы не будет, если игрок за это время ушёл с экрана или уже начал
/// новую попытку ([isStillLost] вернул false).
void flagGameLossAd(
  BuildContext context,
  String game, {
  required bool Function() isStillLost,
}) {
  final monetization = context.read<MonetizationCubit>();
  debugPrint('[Ads] $game: loss');
  Future<void>.delayed(kFlagGameAdDelay, () {
    if (!context.mounted) {
      debugPrint('[Ads] $game: left the screen, ad skipped');
      return;
    }
    if (!isStillLost()) {
      debugPrint('[Ads] $game: already restarted, ad skipped');
      return;
    }
    monetization.onFlagGameLost();
  });
}
