import 'package:armar/armar.dart';
import 'package:flutter/material.dart';

import '../../rx/rx.dart';
import '../mixins/form_state.mixin.dart';

class ArFormFieldSendButton extends StatefulWidget {
  const ArFormFieldSendButton(
    this.formSendButtonState, {
    super.key,
    required this.wrap,
    this.error,
    this.loader,
    this.success,
    required this.child,
  });

  final FormSendButtonStateMixin formSendButtonState;

  final Widget Function(void Function()? onTap, Widget child) wrap;
  final Widget child;

  final Widget? error;
  final Widget? loader;
  final Widget? success;

  @override
  State<ArFormFieldSendButton> createState() => _FormFieldSendButtonState();
}

class _FormFieldSendButtonState extends State<ArFormFieldSendButton> {
  RxValue<bool> get sendButtonActiveState =>
      widget.formSendButtonState.sendButtonActiveState;

  RxGetStatus get sendButtonState => widget.formSendButtonState.sendButtonState;

  void sendFormData() => widget.formSendButtonState.sendFormData();

  @override
  Widget build(BuildContext context) {
    return FastBuilder(
      () {
        final active = sendButtonActiveState.value;

        return widget.wrap(
          active ? sendFormData : null,
          RxStatusView(
            status: sendButtonState,
            error: widget.error,
            loader: widget.loader,
            success: widget.success,
            child: widget.child,
          ),
        );
      },
    );
  }
}
