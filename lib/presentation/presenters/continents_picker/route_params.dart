import 'package:flags/domain/domain.dart';

class ContinentPickerRouteParams {
  final GameProcessType gameProcessType;

  ContinentPickerRouteParams({required this.gameProcessType});

  @override
  String toString() {
    return 'ContinentPickerRouteParams{gameProcessType: $gameProcessType}';
  }
}
