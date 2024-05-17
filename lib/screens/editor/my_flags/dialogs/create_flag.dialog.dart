import 'dart:async';

import 'package:flags/domain/editor/create_flag_data.dart';
import 'package:flags/domain/editor/proportions.dart';
import 'package:flags/shared/mixins/form_mixin.dart';
import 'package:flags/ui/dialogs/dialogs.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/buttons/colors/colors.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

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

class _ContentState extends State<_Content> with ReactiveFormHandlerMixin {
  final ValueNotifier<double> proportion = ValueNotifier(1);
  @override
  FormGroup formGroup = FormGroup({
    'name': FormControl<String>(),
  });

  @override
  FutureOr<void> onFormDataHandle(FormGroup form) async {
    await QR.back(
      CreateFlagData(
        name: form.control('name').value,
        proportion: proportion.value,
      ),
    );
  }

  @override
  void dispose() {
    proportion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FText("Create flag"),
        FCard(
          child: ReactiveForm(
            formGroup: formGroup,
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ReactiveTextField(
                        formControlName: 'name',
                      ),
                      Gap.v12,
                      FCard(
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
                                return ValueListenableBuilder(
                                  valueListenable: proportion,
                                  builder: (
                                    BuildContext context,
                                    double value,
                                    Widget? child,
                                  ) {
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
                                        child: child!,
                                      ),
                                    );
                                  },
                                  child: child,
                                );
                              },
                            ),
                          ],
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
                        onPressed: handleFormData,
                        child: Center(
                          child: FText("Confirm"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
