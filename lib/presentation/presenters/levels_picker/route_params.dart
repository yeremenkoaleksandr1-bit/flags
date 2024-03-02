import 'package:flags/domain/domain.dart';

class LevelsPickerRouteParams {
  final GameProcessType gameProcessType;
  final ContinentType continentType;

  LevelsPickerRouteParams({
    required this.gameProcessType,
    required this.continentType,
  });
}
