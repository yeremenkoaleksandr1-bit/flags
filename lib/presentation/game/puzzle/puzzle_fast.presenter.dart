import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';

abstract interface class IPuzzleFastModePresenter
    implements IPuzzleCommonModePresenter {}

class PuzzleFastModePresenterImpl extends PuzzleCommonModePresenterImpl
    implements IPuzzleFastModePresenter {
  PuzzleFastModePresenterImpl({required super.params});
}
