import 'package:armar/rx/rx.dart';
import 'package:flutter/material.dart';

import '../armar.dart';


class RxStatusView extends StatefulWidget {
  const RxStatusView({
    super.key,
    required this.status,
    required this.child,
    this.error,
    this.loader,
    this.success,
    this.duration = const Duration(milliseconds: 500),
  });

  final RxGetStatus status;
  final Widget child;

  final Widget? error;
  final Widget? loader;
  final Widget? success;

  final Duration duration;

  @override
  State<RxStatusView> createState() => _RxStatusViewState();
}

class _RxStatusViewState extends State<RxStatusView> {
  bool _isLastWasError = false;

  late Widget child = widget.child;

  @override
  Widget build(BuildContext context) {
    return FastBuilder(() {
      if (widget.status.value.isError && widget.error != null) {
        child = widget.error!;
        _isLastWasError = true;
      } else if (widget.status.value.isSuccess && widget.success != null) {
        child = widget.success!;
        _isLastWasError = false;
      } else if (widget.status.value.isEmpty ||
          (!widget.status.value.isError &&
              _isLastWasError &&
              !widget.status.value.isLoading &&
              widget.success == null)) {
        child = widget.child;
        _isLastWasError = false;
      }

      return AnimatedCrossFade(
        duration: widget.duration,
        firstChild: Center(child: child),
        secondChild: widget.loader ??
            const Center(
              child: CircularProgressIndicator(),
            ),
        alignment: Alignment.center,
        crossFadeState: widget.status.value.isLoading
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
      );
    });
  }
}
