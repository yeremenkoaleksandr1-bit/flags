import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:flags/presentation/presenters/continents_picker/state/continents_picker.state.dart';

abstract interface class IContinentsPickerCubit
    with DynamicStatedCubitStream<ContinentsPickerState> {
  ContinentPickerRouteParams get params;
}

class ContinentsPickerCubitImpl extends StatedCubit<ContinentsPickerState>
    implements IContinentsPickerCubit {
  @override
  final ContinentPickerRouteParams params;

  ContinentsPickerCubitImpl({
    required this.params,
  });

  @override
  Future<void> onInit() async {
    final continents = [
      ContinentType.europe,
      ContinentType.asia,
      ContinentType.africa,
      ContinentType.southAmerica,
      ContinentType.northAmerica,
      ContinentType.oceania,
    ];

    emit(
      SuccessState(
        ContinentsPickerState(
          continents: continents,
        ),
      ),
    );

    super.onInit();
  }
}
