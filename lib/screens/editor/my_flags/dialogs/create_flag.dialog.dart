import 'package:armar/armar.dart';
import 'package:armar/form_builder/mixins/form_state.mixin.dart';
import 'package:armar/rx/rx.dart';
import 'package:flags/domain/editor/create_flag_data.dart';
import 'package:flags/domain/editor/proportions.dart';
import 'package:flags/ui/dialogs/dialogs.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/buttons/colors/colors.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/form/fields/text_field.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class CreateFlagDialog extends DialogWidget {
  const CreateFlagDialog({
    super.key,
  });

  @override
  Widget buildContainer(BuildContext context, Widget child) {
    return GamePageBuilder(
      startSlideDirection: GamePageSlideDirection.left,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}

class _Content extends StatefulWidget {
  const _Content({super.key});

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> with FormStatePresenterMixin {
  final RxValue<double> proportion = RxValue(1);

  @override
  Future<void> onFormDataSend(Map<String, dynamic> data) async {
    await QR.back(
      CreateFlagData(
        name: data['name'],
        proportion: proportion.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FText("Create flag"),
        FCard(
          child: ArFormBuilder(
            this,
            builder: (ArFormBuilderState state) {
              return Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ArFieldLabel(
                          title: const Text("Enter Flag name"),
                          field: FTextField(
                            fieldKey: 'name',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.min(2),
                              FormBuilderValidators.max(400),
                            ]),
                            placeholder: "Name",
                          ),
                        ),
                        Gap.v12,
                        ArFieldLabel(
                          title: const Text("Select Proportion"),
                          field: FCard(
                            child: GridView.count(
                              crossAxisCount: 4,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                              children: [
                                ...flagProportions.entries.map(
                                  (e) {
                                    final child = Center(
                                      child: AspectRatio(
                                        aspectRatio: e.value,
                                        child: Material(
                                          child: Center(child: Text(e.key)),
                                        ),
                                      ),
                                    );
                                    return FastValueBuilder(
                                      listen: proportion,
                                      builder: (value) {
                                        return ScaledGestureDetector(
                                          onTap: value != e.value
                                              ? () {
                                                  proportion.value = e.value;
                                                }
                                              : null,
                                          child: FCard(
                                            color: value == e.value
                                                ? ThemePalette.yellowButton
                                                : ThemePalette.gray,
                                            child: child,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap.v12,
                  Row(
                    children: [
                      Expanded(
                        child: FRedButton(
                          onPressed: QR.back,
                          child: Center(
                            child: FText("Cancel"),
                          ),
                        ),
                      ),
                      Gap.h12,
                      Expanded(
                        child: FGreenButton(
                          onPressed: sendFormData,
                          child: Center(
                            child: FText("Confirm"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
